# Praktikum Komunikasi Data dan Jaringan Komputer Modul 5 - K06

## Anggota Kelompok
| NRP | Nama |
|---|---|
| 5027241006 | Nabilah Anindya Paramesti |
| 5027241041 | Raya Ahmad Syarif |

---



# Misi 1

## Topologi 
![](assets/topologi_mod5.png)

## Subnet
![](assets/subnet_mod5.png)

![](assets/rute.png)

## Tree VLSM
![](assets//tree-vlsm_mod5.png)

## Pembagian IP - VLSM
Berikut adalah pembagian IP Address menggunakan metode VLSM (Variable Length Subnet Mask):  

![](assets/ip.png)

Berikut di bawah ini adalah hasil pengujian konektivitas dan akses layanan dari node Client Isildur menuju Web Server Palantir dan IronHills. Pengujian ini membuktikan bahwa konfigurasi Routing, DNS, dan Web Server telah berjalan dengan sukses. 
**Misi 1.4**  
![](assets/1.4.png)
Pada perintah ping ironhills.k06.com, terlihat output (192.168.0.22). Kemudian, pada perintah ping palantir.k06.com, terlihat output (192.168.0.14). Hal ini membuktikan bahwa konfigurasi Bind9 di Narya berfungsi dengan benar. Isildur berhasil bertanya ke Narya mengenai IP dari domain k06.com, dan Narya berhasil menjawab dengan IP yang tepat sesuai konfigurasi Zone File (db.k06).

# Misi 2
**Misi 2.2**  
![](assets/2.2-toVilya.png)  
Gambar di atas menunjukkan bukti keberhasilan mekanisme pengamanan pada node Vilya, di mana pengujian ping dari client Isildur menuju IP 192.168.0.42 menghasilkan status 100% packet loss. Kegagalan respons ini bukan disebabkan oleh gangguan konektivitas jaringan, melainkan akibat penerapan aturan firewall iptables yang secara spesifik membuang (DROP) setiap paket ICMP Echo Request yang masuk dari pihak luar. Dengan demikian, konfigurasi ini telah berhasil memenuhi syarat keamanan untuk melindungi data vital server dari upaya pemindaian (scanning), menjadikan Vilya tidak terdeteksi oleh perangkat lain namun tetap dapat menjalankan fungsinya sebagai DHCP Server secara normal.  

**Misi 2.3**  
![](assets/2.3-.png)  
Gambar di atas memperlihatkan pengujian konektivitas menggunakan netcat (nc) dari node Vilya menuju Narya (192.168.0.43) pada port DNS (53/UDP). Output Connection to ... succeeded! membuktikan bahwa firewall di Narya menerima paket dari Vilya. Hal ini memverifikasi bahwa aturan iptables -A INPUT -s 192.168.0.42 ... -j ACCEPT telah berfungsi dengan benar, memberikan hak akses eksklusif kepada Vilya untuk menggunakan layanan DNS.

![](assets/2-3_gagal.png)  
Sedangkan dari Palantir, tidak adanya respon sukses (koneksi menggantung/timeout) membuktikan bahwa aturan iptables -A INPUT -p udp --dport 53 -j DROP berhasil memblokir akses dari node selain Vilya, sesuai dengan skenario pengamanan yang diminta.

**Misi 2.4**  
![](assets/2.4.png)  
Client Durin berhasil mengakses Web Server IronHills pada hari Sabtu (Akhir Pekan), lalu gagal pada percobaan lain (kemungkinan saat waktu diset ke hari kerja), membuktikan aturan blokir waktu di IronHills berfungsi.

**Misi 2.5**  
![](assets/2.5_elfCirdan.png)  
Client Cirdan berhasil mengakses Palantir pada request pertama, namun request kedua langsung gagal (Connection refused), membuktikan bahwa Firewall Anti-DDoS (limit 5 req/detik) bekerja dengan memblokir request berlebih.
![](assets/2.5_manusiaIsildur.png)
Isildur berhasil mendapatkan respon HTTP/1.1 200 OK saat mengakses palantir.k06.com, membuktikan DNS Narya dan Web Server Palantir berjalan normal dan dapat diakses oleh client Faksi Manusia.

**Misi 2.6**  
![](assets/2.6-terblokir.png)
Gambar ini membuktikan bahwa meskipun akses ICMP (Ping) mungkin diblokir oleh firewall atau kebijakan jaringan (terlihat dari packet loss), Layanan Web (Port 80) tetap berfungsi normal dan terbuka (terlihat dari hasil Nmap). Ini memvalidasi bahwa konfigurasi Web Server di Palantir sudah berjalan dan bisa dijangkau oleh client.
![](assets/2.6-log.png)
Misi 2.6 (Logging Paket Dropped). Ini menunjukkan bahwa mekanisme audit keamanan berjalan: paket ilegal tidak hanya diblokir, tetapi juga direkam jejaknya untuk keperluan analisis admin.

**Misi 2.7**  
![](assets/2.7.png)
Konfigurasi iptables menggunakan modul recent telah berhasil. Server mengizinkan 5 request pertama dalam satu detik, dan secara otomatis memblokir (DROP) sisa request yang melebihi batas tersebut untuk mencegah serangan DDoS.

**Misi 2.8**  
![](assets/2.8.png)
Pengujian menggunakan netcat (nc) dilakukan untuk memastikan port 80 (HTTP) pada node target dalam keadaan terbuka (LISTEN) dan dapat dijangkau dari jaringan server. Output succeeded! menandakan layanan Web Server berjalan normal.

# Misi 3

Blokir semua lalu lintas masuk dan keluar dari Khamul.

![](assets/3-ping.png)

![](assets/3-drop.png)
