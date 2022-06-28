#!/bin/sh

doggo www.qq.com @udp://127.0.0.1:7800 --time --timeout=2 || exit 1
doggo www.google.com @udp://127.0.0.1:7700 --time --timeout=2 || exit 1
doggo t.cn @udp://127.0.0.1:${PORT} --time --timeout=2 || exit 1
doggo t.tt @udp://127.0.0.1:${PORT} --time --timeout=2 || exit 1

exit 0
