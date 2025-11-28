auto lo
iface lo inet loopback

# Ke Osgiliath
auto eth0
iface eth0 inet static
	address 192.168.0.18
	netmask 255.255.255.252
	gateway 192.168.0.17
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Ke Web Server IronHills (A8)
auto eth1
iface eth1 inet static
	address 192.168.0.21
	netmask 255.255.255.252

# Ke Wirderland (A9)
auto eth2
iface eth2 inet static
	address 192.168.0.25
	netmask 255.255.255.252

# Routing ke Bawah (Wirderland & Clients)
up ip route add 192.168.0.32/29 via 192.168.0.26
up ip route add 192.168.0.64/26 via 192.168.0.26