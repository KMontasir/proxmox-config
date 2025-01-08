#!/bin/bash

# Fonction pour installer et configurer OpenSSH, Open vSwitch
setup_appliance() {
    # Installer et configurer OpenSSH
    echo "Installation et configuration d'OpenSSH'..."
    apt install openssh-server -y
	sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config
	sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#AuthorizedKeysFile .*/AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
	systemctl restart sshd
    echo "OpenSSH configuré avec succès."

    # Installer et configurer Open vSwitch
    echo "Installation et configuration d'Open vSwitch..."
    apt install -y openvswitch-switch
    cat <<EOF >> /etc/network/interfaces
auto $NETWORK_INTERFACE
iface $NETWORK_INTERFACE inet manual
    ovs_type OVSPort
    ovs_bridge vmbr1

auto vmbr1
iface vmbr1 inet manual
    ovs_type OVSBridge
    ovs_ports vlan10 vlan20 $NETWORK_INTERFACE_VLAN10

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
