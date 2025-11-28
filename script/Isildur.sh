auto eth0
iface eth0 inet dhcp

# ======= 2.5 ========
#jg" 
# Hapus IP lama (jika ada)
ip addr flush dev eth0

# Pasang IP Manual
ip addr add 192.168.1.10/24 dev eth0
ip route add default via 192.168.1.1

# Pasang DNS
echo "nameserver 192.168.0.43" > /etc/resolv.conf

# Tes Koneksi
ping -c 2 192.168.0.43