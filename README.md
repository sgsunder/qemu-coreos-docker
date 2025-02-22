qemu-coreos-docker
====

This Docker container spins up an instance of Fedora CoreOS using QEMU/KVM, then exposes Docker port 2375 from the VM. This can be used to provide an isolated Docker environment for CI/CD pipelines.

Based on: https://github.com/qemus/qemu-docker

### Docker Compose Example

```yaml
name: coreos_in_docker
volumes:
  docker_storage:
services:
  qemu:
    image: ghcr.io/sgsunder/qemu-coreos-docker:latest
    devices:
      - /dev/kvm
      - /dev/net/tun
    volumes:
      - type: volume
        source: qemu-storage
        target: /storage
    cap_add:
      - NET_ADMIN
    ports:
      - 2375:2375  # Exposes Docker port
    restart: always
    stop_grace_period: 2m
```

### Environment Variables

- `DISK_SIZE` - Size of /var/lib/docker directory
- `RAM_SIZE` - Amount of RAM allocated to the VM
- `CPU_CORES` - Amount of CPU cores allocated

### Other Documentation
- https://github.com/qemus/qemu-docker
- https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-qemu/
- https://docs.fedoraproject.org/en-US/fedora-coreos/producing-ign/
