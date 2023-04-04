# syntax=docker/dockerfile:1
FROM rockylinux:8.7 as builder

ARG MAJOR_VERSION=4
ARG MINOR_VERSION=4
ARG PATCH_VERSION=2

USER root

COPY --from=rockylinux:8.7-minimal / /minimal/

RUN dnf update -y --nodocs --releasever 8 --installroot /minimal/ && \
    dnf upgrade -y --nodocs --releasever 8 --installroot /minimal/

COPY ./td*.repo /minimal/etc/yum.repos.d/
RUN rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent && \
    dnf install td-agent-${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}-*.el8 libxcrypt -y \
        --nodocs --releasever 8 --installroot /minimal/ && \
    dnf clean all --installroot /minimal/ && \
    adduser -M -u 77 td-agent

 USER td-agent

FROM rockylinux:8.7-minimal as rockylinux

USER root

COPY --from=builder /minimal/ /

# Copy Linux user/group files
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Copy td-agent.conf
COPY ./td-agent.conf /etc/td-agent/td-agent.conf

HEALTHCHECK --interval=10s --timeout=1m CMD curl -I http://localhost:24220/api/plugins.json

USER td-agent

ENV DEFAULT_CONF="/etc/td-agent/td-agent.conf"

CMD td-agent --config "${DEFAULT_CONF}"

FROM redhat/ubi8-micro as ubi8

USER root

COPY --from=builder /minimal/bin/ /bin/
COPY --from=builder /minimal/lib64/ /lib64/
COPY --from=builder /minimal/usr/ /usr/
COPY --from=builder /minimal/var/log/td-agent/ /var/log/td-agent/
COPY --from=builder /minimal/etc/td-agent/ /etc/td-agent/
COPY --from=builder /minimal/opt/td-agent/ /opt/td-agent/

# Copy Linux user/group files
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

# Copy td-agent.conf
COPY ./td-agent.conf /etc/td-agent/td-agent.conf

HEALTHCHECK --interval=10s --timeout=1m CMD curl -I http://localhost:24220/api/plugins.json

USER td-agent

ENV DEFAULT_CONF="/etc/td-agent/td-agent.conf"

CMD td-agent --config "${DEFAULT_CONF}"
