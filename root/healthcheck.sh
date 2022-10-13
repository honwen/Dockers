#!/bin/sh

doggo www.qq.com @udp://127.0.0.1:7900 --time --timeout=2 | grep -q www.qq.com || exit 1
doggo www.qq.com @udp://127.0.0.1:7800 --time --timeout=2 | grep -q www.qq.com || exit 1
doggo www.google.com @udp://127.0.0.1:7700 --time --timeout=2 | grep -q www.google.com || exit 1
doggo t.cn @udp://127.0.0.1:${PORT} --time --timeout=2 | grep -q t.cn || exit 1
doggo t.tt @udp://127.0.0.1:${PORT} --time --timeout=2 | grep -q t.tt || exit 1

exit 0
