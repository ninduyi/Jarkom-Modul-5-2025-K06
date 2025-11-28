auto eth0
iface eth0 inet static
	address 192.168.0.42
	netmask 255.255.255.248
	gateway 192.168.0.41
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# ======= Misi 1.4 ========
# Setup DNS Resolver sementara
echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Install Paket
apt-get update
apt-get install isc-dhcp-server -y

# Config Interface
sed -i 's/INTERFACESv4=""/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server

# Config DHCP Pool
cat > /etc/dhcp/dhcpd.conf <<EOF
option domain-name "k06.com";
option domain-name-servers 192.168.0.43, 8.8.8.8;
default-lease-time 600; max-lease-time 7200;

subnet 192.168.0.40 netmask 255.255.255.248 {}

# A4 (Isildur, Elendil)
subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.10 192.168.1.200;
    option routers 192.168.1.1;
    option broadcast-address 192.168.1.255;
}

# A6 (Cirdan, Gilgalad)
subnet 192.168.0.128 netmask 255.255.255.128 {
    range 192.168.0.130 192.168.0.200;
    option routers 192.168.0.129;
    option broadcast-address 192.168.0.255;
}

# A10 (Khamul)
subnet 192.168.0.32 netmask 255.255.255.248 {
    range 192.168.0.34 192.168.0.38;
    option routers 192.168.0.33;
    option broadcast-address 192.168.0.39;
}

# A11 (Durin)
subnet 192.168.0.64 netmask 255.255.255.192 {
    range 192.168.0.66 192.168.0.100;
    option routers 192.168.0.65;
    option broadcast-address 192.168.0.127;
}
EOF

service isc-dhcp-server restart
echo "Konfigurasi Vilya Selesai."

# ======== 2.2 ========
# Tambahkan ini di Vilya
up iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
up iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
