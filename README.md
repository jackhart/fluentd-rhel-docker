# RHEL Fluentd Docker Images

Fluentd Docker image for RockyLinux and RHEL.  If you don't need to use these base images, use the [official fluentd docker images](https://hub.docker.com/r/fluent/fluentd/).

## Basic Usage

Images are stored in [Docker Hub](https://hub.docker.com/r/jackhrt/fluentd-docker).


### Pull

```bash
docker pull jackhrt/fluentd-docker:v4.4.2-ubi8
```

### Build from source

```bash
TAG_LATEST=true OS=ubi8 docker buildx bake
```

## Examples

### Adding plugins

An example of creating a custom image with plugins is included: `Dockerfile.mqtt`.
```bash
docker buildx bake fluentd-mqtt
```

### Deployment

An example docker compose file for the fluentd service is included.

```bash
docker compose up
```

### Multi-Platform Builds

#### Initial Setup

The following command installs the QEMU emulators for the platforms you want to build.  This only needs to be done once.  This command was taken from the [`tonistiigi/binfmt`](https://github.com/tonistiigi/binfmt)

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

#### Build and Run

Multi-platform builds require overriding the platforms field in `docker-bake.hcl`.  We cannot build multiple platforms at once with bake due to [this issue](https://github.com/docker/buildx/issues/1522).  Change that parameter to `linux/arm6` and run the bake command again.

```bash
TAG_LATEST=true docker buildx bake --set *.platform=linux/arm64
```

Now you can run an emulated `linux/arm6` image with the same docker compose command.

```bash
docker compose up
```

## Version Updates

TODO - finish GitHub actions work.
TODO - add images to hub.
