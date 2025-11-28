auto lo
iface lo inet loopback

# Ke Minastir
auto eth0
iface eth0 inet static
	address 192.168.0.6
	netmask 255.255.255.252
	gateway 192.168.0.5
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Ke AnduinBanks (A3)
auto eth1
iface eth1 inet static
	address 192.168.0.9
	netmask 255.255.255.252

# Ke Web Server Palantir (A5)
auto eth2
iface eth2 inet static
	address 192.168.0.13
	netmask 255.255.255.252

# Routing ke Bawah (AnduinBanks & Client Cirdan)
up ip route add 192.168.0.128/25 via 192.168.0.10