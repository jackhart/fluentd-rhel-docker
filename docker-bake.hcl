variable NO_CACHE {default = false}
variable TAG_LATEST {default = false}
variable MAJOR_VERSION {default = 4}
variable MINOR_VERSION {default = 4}
variable PATCH_VERSION {default = 2}
variable OS {default = "rockylinux"}

target "fluentd" {
    context = "."
    target = OS
    args = {
        MAJOR_VERSION = MAJOR_VERSION,
        MINOR_VERSION = MINOR_VERSION,
        PATCH_VERSION = PATCH_VERSION,
    }
    no-cache = NO_CACHE
    tags = [
    equal(true,TAG_LATEST) ?  "jackhrt/fluentd-docker:latest-${OS}": "",
        "jackhrt/fluentd-docker:v${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-${OS}"
    ]
}