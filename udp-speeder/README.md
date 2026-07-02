### Source
- https://github.com/chenhw2/Dockers/tree/udp-speeder
  
### Thanks
- https://github.com/wangyu-/UDPspeeder
  
### Usage
```
$ docker pull chenhw2/udp-speeder

$ docker run -d \
    -e "ARGS=-s -l 0.0.0.0:6666 -r 8.8.8.8:53" \
    -p 6666:6666/udp \
    chenhw2/udp-speeder

$ docker run -d \
    -e "ARGS=-c -l 0.0.0.0:5353 -r [udp-speeder_server]:6666" \
    -p 5353:5353/udp \
    chenhw2/udp-speeder
```
=================================================================================
### Help
```
$ docker run --rm chenhw2/udp-speeder --help

Usage:	docker build [OPTIONS] PATH | URL | -

Build an image from a Dockerfile

Options:
      --add-host list           Add a custom host-to-IP mapping (host:ip)
      --build-arg list          Set build-time variables
      --cache-from strings      Images to consider as cache sources
      --cgroup-parent string    Optional parent cgroup for the container
      --compress                Compress the build context using gzip
      --cpu-period int          Limit the CPU CFS (Completely Fair Scheduler) period
      --cpu-quota int           Limit the CPU CFS (Completely Fair Scheduler) quota
  -c, --cpu-shares int          CPU shares (relative weight)
      --cpuset-cpus string      CPUs in which to allow execution (0-3, 0,1)
      --cpuset-mems string      MEMs in which to allow execution (0-3, 0,1)
      --disable-content-trust   Skip image verification (default true)
  -f, --file string             Name of the Dockerfile (Default is 'PATH/Dockerfile')
      --force-rm                Always remove intermediate containers
      --iidfile string          Write the image ID to the file
      --isolation string        Container isolation technology
      --label list              Set metadata for an image
  -m, --memory bytes            Memory limit
      --memory-swap bytes       Swap limit equal to memory plus swap: '-1' to enable unlimited swap
      --network string          Set the networking mode for the RUN instructions during build (default "default")
      --no-cache                Do not use cache when building the image
      --pull                    Always attempt to pull a newer version of the image
  -q, --quiet                   Suppress the build output and print image ID on success
      --rm                      Remove intermediate containers after a successful build (default true)
      --security-opt strings    Security options
      --shm-size bytes          Size of /dev/shm
  -t, --tag list                Name and optionally a tag in the 'name:tag' format (default )
      --target string           Set the target build stage to build.
      --ulimit ulimit           Ulimit options (default [])
```

