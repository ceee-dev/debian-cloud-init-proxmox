#!/bin/bash
# Original Author: Casper Pedersen (github.com/casperghst42)
# License: GPL2

wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2
virt-customize -a debian-12-generic-amd64.qcow2 --install qemu-guest-agent --install resolvconf --install systemd-resolved --update --run-command 'mkdir -p /etc/network/interfaces.d' --run-command 'echo "auto ens18" >> /etc/network/interfaces.d/ens18' --run-command 'echo "iface ens18 inet manual" >> /etc/network/interfaces.d/ens18'

qm create 1000 --name "debian12-cloudinit-template" --memory 2048 --net0 virtio,bridge=vmbr1
qm importdisk 1000 debian-12-generic-amd64.qcow2 local-lvm -format qcow2

qm set 1000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-1000-disk-0
qm resize 1000 scsi0 100G

qm set 1000 --ide2 local-lvm:cloudinit
qm set 1000 --boot c --bootdisk scsi0
qm set 1000 --serial0 socket --vga serial0
