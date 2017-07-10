### Docker
- https://hub.docker.com/r/chenhw2/alpine

### base

A minimal, busybox-like container based on [Alpine Linux](http://alpinelinux.org/),
that contains [apk](http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management)
package manager to ease installation of extra packages and help you build
smaller development containers.

This is possible thanks to the work from [uggedal](https://github.com/uggedal)
on packaging Alpine Linux for Docker.

This project is now build on top of official [Alpine Linux](https://hub.docker.com/_/alpine/)
image, only including some convenience packages and scripts on top.

### Included packages

To get you started, a set of packages have been integrated:

- curl
- wget
- ca-certificates

### Time Zone
Hong Kong Time Offset: UTC/GMT +8
