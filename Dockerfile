FROM busybox:latest AS image-downloader

ARG COREOS_VERSION="41.20250130.3.0"
RUN wget -O /coreos.qcow2.xz \
  "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/${COREOS_VERSION}/x86_64/fedora-coreos-${COREOS_VERSION}-qemu.x86_64.qcow2.xz"
RUN unxz /coreos.qcow2.xz


FROM quay.io/coreos/butane:release AS ignition-builder
COPY --chmod=644 ./coreos.butane.yaml /coreos.bu
RUN /usr/local/bin/butane --strict -o /coreos.ign /coreos.bu


FROM qemux/qemu-docker:latest
COPY --from=image-downloader --chmod=644 /coreos.qcow2 /boot.qcow2
COPY --from=ignition-builder --chmod=644 /coreos.ign /etc/coreos.ign
COPY --chmod=755 ./entry.sh /run/entry.sh

ARG SOURCE_COMMIT
ARG BUILD_DATE
LABEL maintainer="Shyam Sunder" \
    org.opencontainers.image.title="ghcr.io/sgsunder/qemu-coreos-docker" \
    org.opencontainers.image.url="https://github.com/sgsunder/qemu-coreos-docker" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.source="https://github.com/sgsunder/qemu-coreos-docker" \
    org.opencontainers.image.revision="${SOURCE_COMMIT}" \
    org.opencontainers.image.licenses="MIT"
