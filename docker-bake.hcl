variable TAG_LATEST {default = false}
variable MAJOR_VERSION {default = 4}
variable MINOR_VERSION {default = 4}
variable PATCH_VERSION {default = 2}
variable OS {default = "rockylinux"}


group "default" {
  targets = ["fluentd"]
}

target "fluentd" {
    context = "."
    target = OS
    args = {
        MAJOR_VERSION = MAJOR_VERSION,
        MINOR_VERSION = MINOR_VERSION,
        PATCH_VERSION = PATCH_VERSION,
    }
    platforms = ["linux/amd64"]  # FIXME "linux/arm64"  -- https://github.com/docker/buildx/issues/1522
    tags = [
    equal(true,TAG_LATEST) ?  "jackhrt/fluentd-docker:latest-${OS}": "",
        "jackhrt/fluentd-docker:v${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-${OS}"
    ]
}

target "fluentd-mqtt" {
    context = "."
    contexts = {fluentd-base = "target:fluentd"}
    dockerfile = "Dockerfile.mqtt"
    platforms = ["linux/amd64"]  # FIXME "linux/arm64" -- https://github.com/docker/buildx/issues/1522
    tags = [
    equal(true,TAG_LATEST) ?  "jackhrt/fluentd-mqtt-docker:latest-${OS}": "",
        "jackhrt/fluentd-mqtt-docker:v${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-${OS}"
    ]
}

# for debugging
target builder {
    inherits = ["fluentd"]
    tags = ["builder"]
    target = "builder"
}

# FIXME - can't use the bake file in action b/c of issue cited above
target "docker-metadata-action" {}

target "fluentd-prod" {
    inherits = ["fluentd", "docker-metadata-action"]
}