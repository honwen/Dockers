#!/bin/sh
# build.base.sh — build chenhw2/alpine:base and chenhw2/debian:base
#
# Usage:
#   ./build.base.sh                    # build both in parallel
#   ./build.base.sh --push             # build both in parallel, then push in parallel
#   ./build.base.sh --no-cache         # build without cache
#   ./build.base.sh --no-cache --push  # combine both
cd "$(dirname "$0")"

DO_PUSH=0
NO_CACHE=""
while [ $# -gt 0 ]; do
	case "$1" in
	--push) DO_PUSH=1 ;;
	--no-cache) NO_CACHE="--no-cache" ;;
	-h | --help)
		echo "Usage: $0 [--push] [--no-cache]"
		exit 0
		;;
	*)
		echo "Unknown option: $1" >&2
		echo "Usage: $0 [--push] [--no-cache]" >&2
		exit 2
		;;
	esac
	shift
done

# tag|context
IMAGES='
alpine:base|alpine_HKT/base
debian:base|debian_HKT/base
'

LOGDIR=$(mktemp -d /tmp/build.base.XXXXXX)

build_one() {
	line=$1
	tag=${line%%|*}
	ctx=${line#*|}
	# shellcheck disable=SC2086
	docker build $NO_CACHE -t "chenhw2/$tag" "$ctx" >"$LOGDIR/build.$tag.log" 2>&1
}

# --- parallel build -------------------------------------------------------
pids=""
for line in $IMAGES; do
	tag=${line%%|*}
	build_one "$line" &
	pids="$pids $!:$tag"
	echo "[..] build  chenhw2/$tag started"
done

fail=0
for entry in $pids; do
	pid=${entry%%:*}
	tag=${entry#*:}
	if wait "$pid"; then
		echo "[OK]   build  chenhw2/$tag"
	else
		echo "[FAIL] build  chenhw2/$tag — log: $LOGDIR/build.$tag.log" >&2
		fail=1
	fi
done

if [ "$fail" -ne 0 ]; then
	echo "some builds failed, skipping push; logs kept in $LOGDIR" >&2
	exit 1
fi

# --- parallel push --------------------------------------------------------
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
