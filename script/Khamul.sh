auto eth0
iface eth0 inet dhcp

# ======= 3? ========
# 1. Bersihkan IP lama
ip addr flush dev eth0

# 2. Pasang IP Manual
ip addr add 192.168.0.34/29 dev eth0

# 3. Pasang Gateway (Arah ke Wirderland)
ip route add default via 192.168.0.33

# 4. Pasang DNS
echo "nameserver 192.168.0.43" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf