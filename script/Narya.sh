auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.0.43
    netmask 255.255.255.248
    gateway 192.168.0.41
    up echo "nameserver 192.168.122.1" > /etc/resolv.conf


# ======= Misi 1.4 ========
#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

# Config Options (Forwarder)
cat > /etc/bind/named.conf.options <<EOF
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; 8.8.8.8; };
    allow-query { any; };
    dnssec-validation no;
    auth-nxdomain no;
    listen-on-v6 { any; };
};
EOF

# Config Zones
cat > /etc/bind/named.conf.local <<EOF
zone "k06.com" { type master; file "/etc/bind/jarkom/db.k06"; };
zone "0.168.192.in-addr.arpa" { type master; file "/etc/bind/jarkom/db.192"; };
EOF

# Create DB Files
mkdir -p /etc/bind/jarkom

# Forward Zone
cat > /etc/bind/jarkom/db.k06 <<EOF
; BIND data file for k06.com
\$TTL    604800
@       IN      SOA     k06.com. root.k06.com. (
                        2023101001 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL
@       IN      NS      k06.com.
@       IN      A       192.168.0.43
www     IN      CNAME   k06.com.
palantir IN     A       192.168.0.14
ironhills IN    A       192.168.0.22
EOF

# Reverse Zone
cat > /etc/bind/jarkom/db.192 <<EOF
; BIND reverse data file
\$TTL    604800
@       IN      SOA     k06.com. root.k06.com. (
                        2023101001 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL
@       IN      NS      k06.com.
43      IN      PTR     k06.com.
14      IN      PTR     palantir.k06.com.
22      IN      PTR     ironhills.k06.com.
EOF

service bind9 restart
echo "Konfigurasi Narya Selesai."

# ======== 2.3 ========
#!/bin/bash
echo "🛡️  Mengaktifkan Firewall DNS Narya..."

# 1. Reset ulang
iptables -F
iptables -X

# 2. Izinkan Loopback & Koneksi sendiri
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 3. KHUSUS VILYA (Boleh Masuk)
iptables -A INPUT -s 192.168.0.42 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -s 192.168.0.42 -p tcp --dport 53 -j ACCEPT

# 4. BLOKIR SISANYA (Pakai REJECT biar jelas gagalnya)
iptables -A INPUT -p udp --dport 53 -j REJECT --reject-with icmp-port-unreachable
iptables -A INPUT -p tcp --dport 53 -j REJECT --reject-with tcp-reset

echo "✅ Selesai. Coba tes nc dari Palantir sekarang."
echo "   Harusnya: Connection refused"

