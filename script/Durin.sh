auto eth0
iface eth0 inet dhcp

# ======== 2.4 ========
#!/bin/bash

# --- 1. Fix Koneksi (Jaga-jaga DHCP mati) ---
echo "🔧 Memperbaiki IP & DNS Durin..."
ip addr flush dev eth0
ip addr add 192.168.0.66/26 dev eth0
ip route add default via 192.168.0.65
echo "nameserver 192.168.0.43" > /etc/resolv.conf

# --- 2. Tes Akses ke IronHills ---
echo "🚀 Mencoba akses ke http://ironhills.k06.com ..."
echo "------------------------------------------------"
curl -I http://ironhills.k06.com
echo "------------------------------------------------"

# --- 3. Analisis Hasil ---
echo "📋 ANALISIS HASIL:"
echo "👉 Jika muncul 'Connection refused' -> BERHASIL (Terblokir sesuai soal)."
echo "👉 Jika muncul '200 OK' -> GAGAL (Tidak terblokir)."
echo "👉 Jika muncul 'Could not resolve host' -> MASALAH DNS (Cek Narya)."


