# Docker - Manual development

## Docker - Requirements

Please check [INSTALL.md - Docker - Requirements](INSTALL.md#docker---requirements).

## Debian minimal installation

We first create a Debian 12 minimal installation so that we can install required packages.

```
docker build \
  --build-arg RESCATUX_BUILDER_UID=$(id -u) \
  --build-arg RESCATUX_BUILDER_GID=$(id -g) \
  --tag live-build-manual-builder . \
  -f manual-builder.Dockerfile
```
## Some developing

Develop whatever you want inside of the docker

```
docker run \
  -it \
  --env RESCATUX_BUILDER_UID=$(id -u) \
  --env RESCATUX_BUILDER_GID=$(id -g) \
  -v /dev:/dev \
  -v $(pwd):/live-build-repo:ro \
  -v $(pwd)/live-build-release:/live-build-release:rw \
  live-build-manual-builder:latest
```

## Save your current work
So you need to save your current work so that when you reboot your machine you don't lose your current work inside of the docker image.

- Exit from your docker.

- Identify your docker container id.

```
rescatuxs@adrianpc2020:~$ docker ps -a
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS                      PORTS     NAMES
266d2332828a   live-build-manual-builder:latest   "bash"                   5 minutes ago    Exited (0) 3 minutes ago              sleepy_pascal
164e04ac8430   live-build-manual-builder:latest   "-v /home/rescatuxs/…"   6 minutes ago    Created                               loving_snyder
7bc628fc3fb2   6704c2737d6d                      "-v /home/rescatuxs/…"   8 minutes ago    Created                               angry_jang
c027082f37df   6704c2737d6d                      "-v /home/rescatuxs/…"   13 minutes ago   Created                               dreamy_goodall
7bd0f3fc4440   6704c2737d6d                      "bash"                   16 minutes ago   Exited (0) 14 minutes ago             modest_khorana
d28f50a47eff   hello-world                       "/hello"                 36 minutes ago   Exited (0) 36 minutes ago             gifted_sutherland
```

- Commit your recent changes into it:

```
rescatuxs@adrianpc2020:~$ docker commit 266d2332828a live-build-manual-builder:latest
sha256:bf28c6efaa1595dfde6571a7e257c80c03fa3276fcb698d827f67541e6cbc504
```
## Some more developing

```
docker run \
  -it \
  --env RESCATUX_BUILDER_UID=$(id -u) \
  --env RESCATUX_BUILDER_GID=$(id -g) \
  -v /dev:/dev \
  -v $(pwd):/live-build-repo:ro \
  -v $(pwd)/live-build-release:/live-build-release:rw \
  live-build-manual-builder:latest
```

**Do not run** `docker build` again because you will lose your changes.

## Actual manual build

```
dpkg-buildpackage -us -uc && cp ../* /live-build-release/
```
