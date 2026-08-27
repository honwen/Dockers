#!/bin/sh
# build.proxy.sh — rebuild the chenhw2/* proxy images built in the last 3 months
# (extracted from shell history; paths adapted to the post-reorg layout where
#  each former branch is now a subdirectory under master)
#
# Usage:
#   ./build.proxy.sh                    # build all in parallel
#   ./build.proxy.sh --push             # ...then push successfully built images in parallel
#   ./build.proxy.sh --no-cache         # build without using build cache
#   ./build.proxy.sh --retry N          # retry failed builds N times (default 2), sequentially
#
# Note: the Dockerfiles resolve latest-release URLs via api.github.com
# (unauthenticated: 60 req/h per IP, plus burst limits), so --no-cache
# parallel builds can hit the rate limit — the retry rounds recover from that.
cd "$(dirname "$0")"

DO_PUSH=0
NO_CACHE=""
RETRY=2
RETRY_DELAY=30
while [ $# -gt 0 ]; do
	case "$1" in
	--push) DO_PUSH=1 ;;
	--no-cache) NO_CACHE="--no-cache" ;;
	--retry)
		RETRY=$2
		shift
		;;
	-h | --help)
		echo "Usage: $0 [--push] [--no-cache] [--retry N]"
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		echo "Usage: $0 [--push] [--no-cache] [--retry N]" >&2
		exit 2
		;;
	esac
	shift
done

# tag|context|dockerfile (dockerfile empty = <context>/Dockerfile)
IMAGES='
gitea|caddy-gitea|
ss-obfs|ss-obfs|
sing-box|sing-box|
sing-box:plus|sing-box|Dockerfile.plus
sing-box:geoX|sing-box|Dockerfile.geoX
sing-box:rc|sing-box|Dockerfile.rc
xray|xray|
xray:pro|xray|Dockerfile.pro
xray:rc|xray|Dockerfile.rc
warp2socks|warp2socks|
ssvpn|ssvpn|
dnsproxy|dnsproxy|
'

LOGDIR=$(mktemp -d /tmp/build.proxy.XXXXXX)

# pre-flight: GitHub API rate limit (unauthenticated: 60 req/h/IP; /rate_limit itself is free)
core_rl=$(curl -skS --max-time 10 https://api.github.com/rate_limit 2>/dev/null | sed -n '/"core"/,/}/p')
remaining=$(echo "$core_rl" | sed -n 's/.*"remaining": *\([0-9]*\).*/\1/p')
reset_at=$(echo "$core_rl" | sed -n 's/.*"reset": *\([0-9]*\).*/\1/p')
if [ -n "$remaining" ] && [ "$remaining" -lt 12 ]; then
	reset_in=$(((reset_at - $(date +%s)) / 60))
	echo "WARN: GitHub API rate limit low ($remaining/60 remaining, resets in ~${reset_in}min) — builds may fail on URL resolution" >&2
fi

# build_one <tag|ctx|df> — foreground, appends to log
build_one() {
	line=$1
	tag=${line%%|*}
	rest=${line#*|}
	ctx=${rest%%|*}
	df=${rest#*|}
	# shellcheck disable=SC2086
	if [ -n "$df" ]; then
		docker build $NO_CACHE -t "chenhw2/$tag" -f "$ctx/$df" "$ctx" >>"$LOGDIR/build.$tag.log" 2>&1
	else
		docker build $NO_CACHE -t "chenhw2/$tag" "$ctx" >>"$LOGDIR/build.$tag.log" 2>&1
	fi
}

# --- round 1: all builds in parallel -------------------------------------
pids=""
for line in $IMAGES; do
	tag=${line%%|*}
	build_one "$line" &
	pids="$pids $!:$tag"
	echo "[..] build  chenhw2/$tag started"
done

failed=""
for entry in $pids; do
	pid=${entry%%:*}
	tag=${entry#*:}
	if wait "$pid"; then
		echo "[OK]   build  chenhw2/$tag"
	else
		echo "[FAIL] build  chenhw2/$tag — log: $LOGDIR/build.$tag.log" >&2
		for line in $IMAGES; do
			case "$line" in "$tag|"*) failed="$failed $line" ;; esac
		done
	fi
done

# --- retry rounds: failed builds only, sequentially (avoids API bursts) --
attempt=0
while [ -n "$failed" ] && [ "$attempt" -lt "$RETRY" ]; do
	attempt=$((attempt + 1))
	echo "--- retry round $attempt/$RETRY (sequential, ${RETRY_DELAY}s apart) ---"
	still_failed=""
	for line in $failed; do
		tag=${line%%|*}
		echo "[..] retry  chenhw2/$tag"
		if build_one "$line"; then
			echo "[OK]   retry  chenhw2/$tag"
		else
			echo "[FAIL] retry  chenhw2/$tag — log: $LOGDIR/build.$tag.log" >&2
			still_failed="$still_failed $line"
		fi
		sleep "$RETRY_DELAY"
	done
	failed=$still_failed
done

if [ -n "$failed" ]; then
	echo "some builds failed after $RETRY retries, skipping push; logs kept in $LOGDIR" >&2
	exit 1
fi

# --- push: all successfully built images in parallel ----------------------
fail=0
if [ "$DO_PUSH" -eq 1 ]; then
	echo "--- pushing images in parallel ---"
	push_pids=""
	for line in $IMAGES; do
		tag=${line%%|*}
		docker push "chenhw2/$tag" >"$LOGDIR/push.$tag.log" 2>&1 &
		push_pids="$push_pids $!:$tag"
		echo "[..] push   chenhw2/$tag started"
	done

	for entry in $push_pids; do
		pid=${entry%%:*}
		tag=${entry#*:}
		if wait "$pid"; then
			echo "[OK]   push   chenhw2/$tag"
		else
			echo "[FAIL] push   chenhw2/$tag — log: $LOGDIR/push.$tag.log" >&2
			fail=1
		fi
	done
fi

if [ "$fail" -eq 0 ]; then
	rm -rf "$LOGDIR"
	echo "all done"
else
	echo "some pushes failed, logs kept in $LOGDIR" >&2
	exit 1
fi
