#!/bin/bash

# Variables utilisateurs
declare -A PROXMOX_USERS=( 
    ["user1"]="pveadmin-user1@pve" 
    ["user2"]="pveadmin-user2@pve"
    ["user3"]="pveadmin-user3@pve"
    ["user4"]="pveadmin-user4@pve"
)
PROXMOX_PASSWORD=""
PVE_PASSWORD=""

# Variables fichiers ISO
OPNSENSE_ISO=""
DEBIAN_ISO=""

# Variables Stockage
declare -A STORAGE_CONFIGS=(
    ["local-lvm-template"]="/dev/sdb"
    ["local-lvm-vm"]="/dev/sdc"
)

# Variables Disque pour les VMs
declare -A DISK_CONFIGS=(
    ["OpnsenseTemplate"]="16G"
    ["WebServerTemplate"]="16G"
)

# Variable Interface physique bridged sur VLAN10
NETWORK_INTERFACE="eno2"
