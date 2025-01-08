#!/bin/bash

# Charger les autres fichiers
source ./variables.sh
source ./setup_storage.sh
source ./setup_openvswitch.sh
source ./setup_users.sh
source ./create_vms.sh

# Fonction principale
main() {
    echo "Début de la configuration..."
    create_lvm
    setup_appliance
    setup_users
    create_vms
    echo "Configuration terminée avec succès !"
}

# Appel de la fonction principale
main
