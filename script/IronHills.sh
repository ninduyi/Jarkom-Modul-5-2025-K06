auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
	address 192.168.0.22
	netmask 255.255.255.252
	gateway 192.168.0.21
	# DNS Resolver otomatis saat interface nyala
	up echo "nameserver 192.168.122.1" > /etc/resolv.conf

# ======= Misi 1.4 ========
#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update && apt-get install apache2 -y

# Buat index.html
echo "Welcome to IronHills" > /var/www/html/index.html

service apache2 start
echo "Konfigurasi IronHills Selesai."

# ======== 2.4 ========
#!/bin/bash

# --- 1. Definisi Subnet Faksi ---
NET_MANUSIA="192.168.1.0/24"    # Elendil & Isildur (A4)
NET_DURIN="192.168.0.64/26"     # Durin (A11)
NET_KHAMUL="192.168.0.32/29"    # Khamul (A10)

# --- 2. Bersihkan Aturan Lama (Agar tidak menumpuk) ---
echo "🧹 Membersihkan aturan waktu lama..."
while iptables -D INPUT -p tcp --dport 80 -m time --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT --reject-with tcp-reset 2>/dev/null; do :; done

# --- 3. Atur Waktu ke RABU (Simulasi Blokir) ---
echo "⏳ Mengatur waktu server ke RABU (26 Nov 2025)..."
date -s "2025-11-26 10:00:00"

# --- 4. Pasang Aturan Firewall (REJECT di Hari Kerja) ---
echo "🛡️ Memasang Firewall Waktu..."

# Gunakan -I INPUT 1 agar aturan ini ditaruh paling ATAS (Prioritas Utama)
iptables -I INPUT 1 -p tcp --dport 80 -s $NET_MANUSIA -m time --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT --reject-with tcp-reset
iptables -I INPUT 1 -p tcp --dport 80 -s $NET_DURIN -m time --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT --reject-with tcp-reset
iptables -I INPUT 1 -p tcp --dport 80 -s $NET_KHAMUL -m time --weekdays Mon,Tue,Wed,Thu,Fri -j REJECT --reject-with tcp-reset

echo "✅ Selesai! IronHills sekarang menolak akses (Karena hari ini diset Rabu)."