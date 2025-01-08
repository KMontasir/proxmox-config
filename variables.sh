#!/bin/bash

# Variables utilisateurs
declare -A PROXMOX_USERS=( 
    ["marcus"]="pveadmin-marcus@pve" 
    ["jeanbatiste"]="pveadmin-jeanbatiste@pve"
    ["philippe"]="pveadmin-philippe@pve"
    ["montasir"]="pveadmin-montasir@pve"
)
PROXMOX_PASSWORD="Azerty/123"
PVE_PASSWORD="Azerty/123"

# Variables fichiers ISO
OPNSENSE_ISO="/var/lib/vz/template/iso/OPNsense-24.7-dvd-amd64.iso"
DEBIAN_ISO="/var/lib/vz/template/iso/debian-12.8.0-amd64-DVD-1.iso"

# Variables Stockage
declare -A STORAGE_CONFIGS=(
    ["local-lvm-thin"]="/dev/sdb"
    ["local-lvm-thin2"]="/dev/sdc"
    #["cloud-init"]="/dev/sdd"
)

# Variables Disque pour les VMs
declare -A DISK_CONFIGS=(
    ["PfSenseTemplate"]="16G"
    ["WebServerTemplate"]="16G"
)
