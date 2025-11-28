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


# ======= Misi 1.4 ========
# Aktifkan IP Forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p

# Script Auto-SNAT
cat > /root/fix_nat.sh <<EOF
#!/bin/sh
sleep 15
IP=\$(ip addr show eth0 | grep "inet " | awk '{print \$2}' | cut -d/ -f1)
iptables -t nat -F POSTROUTING
if [ ! -z "\$IP" ]; then
    iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o eth0 -j SNAT --to-source \$IP
fi
echo "nameserver 192.168.122.1" > /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
EOF

chmod +x /root/fix_nat.sh

# Pasang di Interface agar permanen
if ! grep -q "post-up /root/fix_nat.sh" /etc/network/interfaces; then
    sed -i '/iface eth0 inet dhcp/a \    post-up /root/fix_nat.sh &' /etc/network/interfaces
fi

# Jalankan sekarang
/root/fix_nat.sh &
echo "Konfigurasi Osgiliath Selesai."


# ======= 2.6 ========
#!/bin/bash

echo "🛡️ Mengaktifkan Proteksi Port Scan (Limit 15 port / 20 detik)..."

# 1. Buat Chain Khusus Hukuman
# Hapus jika sudah ada biar bersih
iptables -F SCAN_BLOCK 2>/dev/null
iptables -X SCAN_BLOCK 2>/dev/null
iptables -N SCAN_BLOCK

# --- Isi Chain Hukuman ---
# a. Catat Log (Sesuai Soal)
iptables -A SCAN_BLOCK -j LOG --log-prefix "PORT_SCAN_DETECTED " --log-level 4
# b. Masukkan IP ke daftar 'BANNED_LIST'
iptables -A SCAN_BLOCK -m recent --set --name BANNED_LIST --rsource
# c. Drop paketnya
iptables -A SCAN_BLOCK -j DROP

# 2. Pasang Aturan di INPUT (Gunakan Insert -I agar ditaruh paling ATAS)

# [PRIORITAS 1] Cek Penjara
# Jika IP ini sudah ada di 'BANNED_LIST', tolak SEMUA akses selama 20 detik
iptables -I INPUT 1 -m recent --name BANNED_LIST --update --seconds 20 -j DROP

# [PRIORITAS 2] Deteksi Scan
# Jika IP melakukan koneksi baru (NEW) ke port TCP manapun...
# Cek apakah sudah > 15 kali dalam 20 detik? Jika YA -> Lempar ke Hukuman
iptables -I INPUT 2 -p tcp -m state --state NEW -m recent --update --seconds 20 --hitcount 15 --name SCANNERS --rsource -j SCAN_BLOCK

# [PRIORITAS 3] Pendaftaran
# Daftarkan setiap koneksi TCP baru ke list 'SCANNERS'
iptables -I INPUT 3 -p tcp -m state --state NEW -m recent --set --name SCANNERS --rsource

echo "✅ Anti-Portscan Terpasang di Urutan Teratas!"


# =========== 2.7 ============
#!/bin/bash

echo "⏳ 1. Mengatur Waktu ke HARI SABTU (Agar akses dibuka)..."
# Set ke Sabtu, 29 Nov 2025
date -s "2025-11-29 10:00:00"

echo "🛡️ 2. Memasang Limitasi Koneksi (Max 3 per IP)..."

# Hapus aturan limit lama jika ada (biar gak numpuk)
iptables -D INPUT -p tcp --syn --dport 80 -m connlimit --connlimit-above 3 -j REJECT 2>/dev/null

# Pasang aturan di URUTAN PERTAMA (-I INPUT 1)
# Artinya: Jika satu IP membuka koneksi ke-4, langsung tolak!
iptables -I INPUT 1 -p tcp --syn --dport 80 -m connlimit --connlimit-above 3 -j REJECT --reject-with tcp-reset

echo "✅ Limitasi Aktif: Max 3 Koneksi/IP."
echo "   Cek aturan: iptables -L INPUT -n -v | grep connlimit"

# CEK DI ISILDUR
ab -n 100 -c 10 http://ironhills.k06.com/
# Jalankan 10 curl sekaligus
for i in {1..10}; do curl -I http://ironhills.k06.com & done


