#!/bin/bash

# Fonction pour installer et configurer Open vSwitch
setup_openvswitch() {
    echo "Installation et configuration d'Open vSwitch..."
    apt install -y openvswitch-switch
    cat <<EOF >> /etc/network/interfaces
auto vmbr1
iface vmbr1 inet manual
    ovs_type OVSBridge
    ovs_ports vlan10 vlan20

auto vlan10
iface vlan10 inet manual
    ovs_type OVSIntPort
    ovs_bridge vmbr1
    ovs_options tag=10

auto vlan20
iface vlan20 inet manual
    ovs_type OVSIntPort
    ovs_bridge vmbr1
    ovs_options tag=20
EOF
    systemctl restart networking
    echo "Open vSwitch configuré avec succès."
}
