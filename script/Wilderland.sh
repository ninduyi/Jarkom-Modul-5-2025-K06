auto lo
iface lo inet loopback

# Ke Moria
auto eth0
iface eth0 inet static
	address 192.168.0.26
	netmask 255.255.255.252
	gateway 192.168.0.25
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Ke Client Durin (A11)
auto eth1
iface eth1 inet static
	address 192.168.0.65
	netmask 255.255.255.192

# Ke Client Khamul (A10)
auto eth2
iface eth2 inet static
	address 192.168.0.33
	netmask 255.255.255.248

# ======= Misi 1.4 ========
#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p

apt-get update && apt-get install isc-dhcp-relay -y

echo 'SERVERS="192.168.0.42"' > /etc/default/isc-dhcp-relay
echo 'INTERFACES="eth0 eth1 eth2"' >> /etc/default/isc-dhcp-relay

service isc-dhcp-relay restart
echo "Konfigurasi Wirderland Selesai."



# ======== 3 ========
#!/bin/bash

# IP & Subnet Khamul
IP_TARGET="192.168.0.34"
SUBNET_TARGET="192.168.0.32/29"

echo "⛔ MENGISOLASI KHAMUL (HARD RESET)..."

# 1. HAPUS SEMUA ATURAN (FLUSH TOTAL)
# Ini memastikan tidak ada aturan 'ACCEPT' tersisa
iptables -F
iptables -X
iptables -Z

# 2. SET POLICY DEFAULT (Agar lebih ketat)
# Kita biarkan ACCEPT dulu biar router tidak terkunci, tapi kita filter manual
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 3. BLOKIR KHAMUL (POSISI PALING ATAS - INSERT)

# A. Blokir Trafik Melintas (Internet/Luar)
# Blokir spesifik IP 34 dan seluruh Subnet A10 jaga-jaga
iptables -I FORWARD 1 -s $IP_TARGET -j DROP
iptables -I FORWARD 2 -d $IP_TARGET -j DROP
iptables -I FORWARD 3 -s $SUBNET_TARGET -j DROP

# B. Blokir Akses ke Router Sendiri (Ping Gateway)
iptables -I INPUT 1 -s $IP_TARGET -j DROP
iptables -I INPUT 2 -s $SUBNET_TARGET -j DROP

# C. Blokir Router Menghubungi Khamul
iptables -I OUTPUT 1 -d $IP_TARGET -j DROP

echo "✅ Aturan Terpasang."
echo "   Khamul ($IP_TARGET) sekarang terisolasi."