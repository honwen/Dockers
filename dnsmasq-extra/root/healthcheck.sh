#!/bin/sh

set -e

wait4x -i300ms -t2s dns A 99999.alidns.com --expect-ip 223.5.5.5 --expect-ip 223.6.6.6 -n 127.0.0.1:7900
wait4x -i300ms -t2s dns A public1.114dns.com --expect-ip 114.114.114.114 --expect-ip 114.114.115.115 -n 127.0.0.1:7900
wait4x -i300ms -t2s dns A public2.114dns.com --expect-ip 114.114.114.114 --expect-ip 114.114.115.115 -n 127.0.0.1:7900
wait4x -i300ms -t2s dns A public1.sdns.cn --expect-ip 1.2.4.8 --expect-ip 210.2.4.8 -n 127.0.0.1:7900
wait4x -i300ms -t2s dns A public2.sdns.cn --expect-ip 1.2.4.8 --expect-ip 210.2.4.8 -n 127.0.0.1:7900
wait4x -i300ms -t2s dns A qq.com -n 127.0.0.1:7900
wait4x -i300ms -t2s dns A taobao.com -n 127.0.0.1:7900
wait4x -i300ms -t2s dns A t.cn -n 127.0.0.1:7900
wait4x -i500ms -t2s dns A google.com -n 127.0.0.1:7900
wait4x -i500ms -t2s dns A github.com -n 127.0.0.1:7900
wait4x -i500ms -t2s dns A google.io -n 127.0.0.1:7900

wait4x -i500ms -t2s dns A 123456.alidns.com --expect-ip 223.5.5.5 --expect-ip 223.6.6.6 -n 127.0.0.1:7800
wait4x -i300ms -t2s dns A public1.114dns.com --expect-ip 114.114.114.114 --expect-ip 114.114.115.115 -n 127.0.0.1:7800
wait4x -i300ms -t2s dns A public1.sdns.cn --expect-ip 1.2.4.8 --expect-ip 210.2.4.8 -n 127.0.0.1:7800
wait4x -i300ms -t2s dns A qq.com -n 127.0.0.1:7800
wait4x -i300ms -t2s dns A taobao.com -n 127.0.0.1:7800
wait4x -i300ms -t2s dns A t.cn -n 127.0.0.1:7800

wait4x -i500ms -t2s dns A dns.google.com --expect-ip 8.8.8.8 --expect-ip 8.8.4.4 -n 127.0.0.1:7700
wait4x -i500ms -t2s dns A one.one.one.one --expect-ip 1.1.1.1 --expect-ip 1.0.0.1 -n 127.0.0.1:7700
wait4x -i500ms -t2s dns A dns9.quad9.net --expect-ip 9.9.9.9 --expect-ip 149.112.112.9 -n 127.0.0.1:7700
wait4x -i500ms -t2s dns A dns11.quad9.net --expect-ip 9.9.9.9 --expect-ip 149.112.112.11 -n 127.0.0.1:7700
wait4x -i500ms -t2s dns A google.com -n 127.0.0.1:7700
wait4x -i500ms -t2s dns A github.com -n 127.0.0.1:7700
wait4x -i500ms -t2s dns A google.io -n 127.0.0.1:7700

# doggo www.qq.com @udp://127.0.0.1:7900 --time --timeout=2s | grep -q www.qq.com || exit 1
# doggo www.qq.com @udp://127.0.0.1:7800 --time --timeout=2s | grep -q www.qq.com || exit 1
# doggo www.google.com @udp://127.0.0.1:7700 --time --timeout=2s | grep -q www.google.com || exit 1
# doggo t.cn @udp://127.0.0.1:${PORT} --time --timeout=2s | grep -q t.cn || exit 1
# doggo t.tt @udp://127.0.0.1:${PORT} --time --timeout=2s | grep -q t.tt || exit 1

exit 0
