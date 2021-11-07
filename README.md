# cygwin-container
Run cygwin on container (works on Linux!)

![screenshot](https://github.com/BonyChops/cygwin-container/raw/main/screenshot.png "screenshot")

# Setup
More details, check out [here](https://qiita.com/advent-calendar/2021/nnct) (not yet available).
You have to create iso image that works cygwin.  

## Before you begin
You have to install these on your **host** machine

- VirtualBox
- Docker

## Build
```
docker build -t cygwin --build-arg .
```

## Run
```
docker run --rm -d --privileged=true --device /dev/vboxdrv:/dev/vboxdrv -p 2525:22 --name cygwin-container cygwin-image
```

### With VNC
```
docker run --rm -d --privileged=true --device /dev/vboxdrv:/dev/vboxdrv -p 2525:22 -p 3389:3389 --name cygwin-container cygwin-image
```
