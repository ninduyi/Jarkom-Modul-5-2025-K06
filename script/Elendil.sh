auto eth0
iface eth0 inet dhcp

# ======= 2.6 ========
nmap -p 1-100 192.168.0.14

ping -c 2 192.168.0.14
curl -I http://palantir.k06.com