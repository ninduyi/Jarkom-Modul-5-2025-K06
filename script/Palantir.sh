auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
	address 192.168.0.14
	netmask 255.255.255.252
	gateway 192.168.0.13
	# DNS Resolver otomatis saat interface nyala
	up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# ======= Misi 1.4 ========
#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install apache2 -y

# Buat index.html
echo "Welcome to Palantir" > /var/www/html/index.html

service apache2 start
echo "Konfigurasi Palantir Selesai."

# ======== 2.5 ========
#!/bin/bash

# --- 0. PRE-FLIGHT CHECK: NYALAIN APACHE ---
echo "🔌 Menyalakan Web Server Apache..."
service apache2 restart
# Cek status singkat
if pgrep apache2 > /dev/null; then
    echo "✅ Apache is RUNNING."
else
    echo "❌ Apache GAGAL start! Cek error."
fi

# --- 1. Definisi Subnet ---
NET_MANUSIA="192.168.1.0/24"    # Elendil & Isildur
NET_ELF="192.168.0.128/25"      # Gilgalad & Cirdan

# --- 2. Reset Firewall ---
echo "🧹 Reset aturan firewall..."
iptables -F
iptables -X

# --- 3. PILIH SIMULASI WAKTU (PENTING!) ---
echo "⏳ Set Waktu: 10:00 UTC (Pagi)"
date -u -s "10:00:00"

# --- 4. Pasang Aturan Firewall (Mode UTC) ---
echo "🛡️ Memasang Firewall Ras & Waktu..."

# ==========================================
# ATURAN FAKSI ELF (07:00 - 15:00 UTC)
# ==========================================
# Izin dulu (ACCEPT)
iptables -A INPUT -p tcp --dport 80 -s $NET_ELF -m time --timestart 07:00 --timestop 15:00 --utc -j ACCEPT
# Selain jam itu, TOLAK (REJECT)
iptables -A INPUT -p tcp --dport 80 -s $NET_ELF -j REJECT --reject-with tcp-reset

# ==========================================
# ATURAN FAKSI MANUSIA (17:00 - 23:00 UTC)
# ==========================================
# Izin dulu (ACCEPT)
iptables -A INPUT -p tcp --dport 80 -s $NET_MANUSIA -m time --timestart 17:00 --timestop 23:00 --utc -j ACCEPT
# Selain jam itu, TOLAK (REJECT)
iptables -A INPUT -p tcp --dport 80 -s $NET_MANUSIA -j REJECT --reject-with tcp-reset

# Izinkan akses lain (Admin/Ping)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

echo "✅ Selesai! Waktu server saat ini (UTC): $(date -u)"

#Habis menyerang cek
iptables -L SCAN_BLOCK -n -v

