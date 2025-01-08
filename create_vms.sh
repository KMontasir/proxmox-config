#!/bin/bash

# Fonction pour créer les VMs avec configuration matérielle complète
create_vms() {

    # Création des groupes de ressources
    echo "Création des groupes de ressources..."
    for pool in Pare-Feu zone-relais zone-exposee service-interne template; do
        pveum pool add $pool
    done

    # Création de la VM Firewall Template
    VM_NAME="PfSenseTemplate"
    DISK_SIZE=${DISK_CONFIGS["$VM_NAME"]}
    STORAGE_NAME="local-lvm-thin"  # Choisir le stockage pour cette VM
    echo "Création du volume LVM pour $VM_NAME avec taille $DISK_SIZE..."
    lvcreate --thinpool $STORAGE_NAME/thinpool --virtualsize $DISK_SIZE -n vm-9999-disk-0

    echo "Création de la VM Firewall..."
    qm create 9999 \
        --name "Firewall" \
        --memory 2048 \
        --cores 2 \
        --net0 "virtio,bridge=vmbr0" \
        --net1 "virtio,bridge=vmbr1" \
        --cdrom $OPNSENSE_ISO \
        --boot c \
        --bootdisk scsi0 \
        --scsi0 $STORAGE_NAME:vm-9999-disk-0 \
        --pool Pare-Feu

    # Création de la VM serveur Web Template
    VM_NAME="WebServerTemplate"
    DISK_SIZE=${DISK_CONFIGS["$VM_NAME"]}
    STORAGE_NAME="local-lvm-thin"  # Choisir le stockage pour cette VM
    echo "Création du volume LVM pour $VM_NAME avec taille $DISK_SIZE..."
    lvcreate --thinpool $STORAGE_NAME/thinpool --virtualsize $DISK_SIZE -n vm-9001-disk-0

    echo "Création du serveur web template..."
    qm create 9001 \
        --name "WebServerTemplate" \
        --memory 2048 \
        --cores 2 \
        --net0 "virtio,bridge=vmbr1,tag=20" \
        --cdrom $DEBIAN_ISO \
        --boot c \
        --bootdisk scsi0 \
        --scsi0 $STORAGE_NAME:vm-9001-disk-0 \
        --pool template
}
