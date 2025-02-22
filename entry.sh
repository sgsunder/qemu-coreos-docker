#!/usr/bin/env bash
set -Eeuo pipefail

APP="CoreOS"
SUPPORT="https://github.com/sgsunder/qemu-coreos-docker"

# Configure CoreOS speific arguments ========================================
BOOT=""  # Unset BOOT argument, use CoreOS at /boot.qcow2
GPU="N"
DISK_TYPE="scsi"
VGA="virtio"
DISPLAY="disabled"
TPM="N"
SMM="N"
USER_PORTS="2375"  # Pass through Docker API port
ARGUMENTS="-fw_cfg name=opt/com.coreos/config,file=/etc/coreos.ign ${ARGUMENTS:-}"
# ===========================================================================

cd /run

. reset.sh      # Initialize system
. install.sh    # Get bootdisk
. disk.sh       # Initialize disks
. display.sh    # Initialize graphics
. network.sh    # Initialize network
. boot.sh       # Configure boot
. proc.sh       # Initialize processor
. config.sh     # Configure arguments

trap - ERR

version=$(qemu-system-x86_64 --version | head -n 1 | cut -d '(' -f 1 | awk '{ print $NF }')
info "Booting image${BOOT_DESC} using QEMU v$version..."

exec qemu-system-x86_64 ${ARGS:+ $ARGS}