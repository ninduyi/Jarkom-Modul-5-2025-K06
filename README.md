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

![](assets/1.4.png)
Pada perintah ping ironhills.k06.com, terlihat output (192.168.0.22). Kemudian, pada perintah ping palantir.k06.com, terlihat output (192.168.0.14). Hal ini membuktikan bahwa konfigurasi Bind9 di Narya berfungsi dengan benar. Isildur berhasil bertanya ke Narya mengenai IP dari domain k06.com, dan Narya berhasil menjawab dengan IP yang tepat sesuai konfigurasi Zone File (db.k06).

# Misi 2
![](assets/2.2-toVilya.png)

![](assets/2.3-.png)

![](assets/2-3_gagal.png)

![](assets/2.4.png)

![](assets/2.5_elfCirdan.png)

![](assets/2.5_manusiaIsildur.png)

![](assets/2.6-terblokir.png)

![](assets/2.6-log.png)

![](assets/2.7.png)

![](assets/2.8.png)

# Misi 3

Blokir semua lalu lintas masuk dan keluar dari Khamul.

![](assets/3-ping.png)

![](assets/3-drop.png)
