# RHEL Fluentd Docker Images

Fluentd Docker image for RockyLinux and RHEL.  If you don't need to use these base images, use the [official fluentd docker images](https://hub.docker.com/r/fluent/fluentd/).

## Usage

Images are stored in [Docker Hub](TODO).

TODO - add images to hub

### Pull

```bash
docker pull jackhrt/fluentd-docker:v4.4.2-ubi8
```

### Build from source

```bash
TAG_LATEST=true OS=ubi8 docker buildx bake .
```

## Examples

### Adding plugins

TODO - example of adding plugins to image

### Deployment

Example docker compose file for the fluentd service is at `examples/docker-compose.yml`.

```bash
cd examples
docker compose up
```

### Multi-Platform Builds

TODO - example of creating builder for arm builds and testing (with Vagrant?)

## Version Updates

TODO - finish GitHub actions work.