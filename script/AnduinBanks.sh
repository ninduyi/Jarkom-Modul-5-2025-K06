auto lo
iface lo inet loopback

# Ke Pelargir (A3)
auto eth0
iface eth0 inet static
	address 192.168.0.10
	netmask 255.255.255.252
	gateway 192.168.0.9
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Ke Client Cirdan (A6)
auto eth1
iface eth1 inet static
	address 192.168.0.129
	netmask 255.255.255.128


