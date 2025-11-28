auto lo
iface lo inet loopback

# Ke Osgiliath (A1)
auto eth0
iface eth0 inet static
	address 192.168.0.2
	netmask 255.255.255.252
	gateway 192.168.0.1
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Ke Client Isildur (A4)
auto eth1
iface eth1 inet static
	address 192.168.1.1
	netmask 255.255.255.0

# Ke Pelargir (A2)
auto eth2
iface eth2 inet static
	address 192.168.0.5
	netmask 255.255.255.252

# Routing ke Bawah
up ip route add 192.168.0.8/30 via 192.168.0.6
up ip route add 192.168.0.12/30 via 192.168.0.6
up ip route add 192.168.0.128/25 via 192.168.0.6


apt-get install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay
SERVERS="192.168.0.42" 
INTERFACES="eth0 eth1"

