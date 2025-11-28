auto lo
iface lo inet loopback

# Ke Internet (NAT)
auto eth0
iface eth0 inet dhcp
    # Aktifkan NAT & DNS Resolver otomatis saat nyala
    up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.168.0.0/16
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Ke Rivendell (A12) - BAWAH
auto eth1
iface eth1 inet static
	address 192.168.0.29
	netmask 255.255.255.252

# Ke Moria (A7) - KIRI
auto eth2
iface eth2 inet static
	address 192.168.0.17
	netmask 255.255.255.252

# Ke Minastir (A1) - KANAN
auto eth3
iface eth3 inet static
	address 192.168.0.1
	netmask 255.255.255.252

# --- Routing Static ---
# Rute Jalur Kanan (Via Minastir)
up ip route add 192.168.0.4/30 via 192.168.0.2
up ip route add 192.168.0.8/30 via 192.168.0.2
up ip route add 192.168.0.12/30 via 192.168.0.2
up ip route add 192.168.1.0/24 via 192.168.0.2
up ip route add 192.168.0.128/25 via 192.168.0.2

# Rute Jalur Kiri (Via Moria)
up ip route add 192.168.0.20/30 via 192.168.0.18
up ip route add 192.168.0.24/30 via 192.168.0.18
up ip route add 192.168.0.32/29 via 192.168.0.18
up ip route add 192.168.0.64/26 via 192.168.0.18

# Rute Jalur Bawah (Via Rivendell)
up ip route add 192.168.0.40/29 via 192.168.0.30


nano /etc/sysctl.conf
net.ipv4.ip_forward=1