#!/bin/bash

# Fonction pour créer les VMs avec configuration matérielle complète
create_vms() {

    # Récupérer dynamiquement le stockage cloud-init
    CLOUD_INIT_STORAGE=""
    for storage_name in "${!STORAGE_CONFIGS[@]}"; do
        if [[ "$storage_name" == "cloud-init" ]]; then
            CLOUD_INIT_STORAGE="$storage_name"
            break
        fi
    done

    if [[ -z "$CLOUD_INIT_STORAGE" ]]; then
        echo "Erreur : le stockage 'cloud-init' n'est pas défini dans STORAGE_CONFIGS."
        exit 1
    fi

    # Création des groupes de ressources
    echo "Création des groupes de ressources..."
    for pool in pare-Feu zone-relais zone-exposee service-interne template labo; do
        pveum pool add "$pool"
    done

    # Création de la VM Firewall Template
    VM_NAME="PfSenseTemplate"
    DISK_SIZE=${DISK_CONFIGS["$VM_NAME"]}
    echo "Création du volume LVM pour $VM_NAME avec taille $DISK_SIZE sur $CLOUD_INIT_STORAGE..."
    lvcreate --thinpool "$CLOUD_INIT_STORAGE/thinpool" --virtualsize "$DISK_SIZE" -n vm-9999-disk-0

    echo "Création de la VM Firewall..."
    qm create 9999 \
        --name "FirewallTemplate" \
        --memory 2048 \
        --cores 2 \
        --net0 "virtio,bridge=vmbr0" \
        --net1 "virtio,bridge=vmbr1" \
        --cdrom "$OPNSENSE_ISO" \
        --boot c \
        --bootdisk scsi0 \
        --scsi0 "$CLOUD_INIT_STORAGE:vm-9999-disk-0" \
        --pool template

    # Création de la VM serveur Web Template
    VM_NAME="WebServerTemplate"
    DISK_SIZE=${DISK_CONFIGS["$VM_NAME"]}
    echo "Création du volume LVM pour $VM_NAME avec taille $DISK_SIZE sur $CLOUD_INIT_STORAGE..."
    lvcreate --thinpool "$CLOUD_INIT_STORAGE/thinpool" --virtualsize "$DISK_SIZE" -n vm-9001-disk-0

    echo "Création du serveur web template..."
    qm create 9989 \
        --name "WebServerTemplate" \
        --memory 2048 \
        --cores 2 \
        --net0 "virtio,bridge=vmbr1,tag=20" \
        --cdrom "$DEBIAN_ISO" \
        --boot c \
        --bootdisk scsi0 \
        --scsi0 "$CLOUD_INIT_STORAGE:vm-9001-disk-0" \
        --pool template
}
