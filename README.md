# 📕 Bookquet Mobile 💐
![Build status](https://build.appcenter.ms/v0.1/apps/17748249-cdc9-48b7-9df3-2a52844a0cda/branches/main/badge)

\~ Di setiap buku, terdapat karangan kata-kata berbunga \~

> "If you don’t like to read, you haven’t found the right book." – **J.K. Rowling**

> Proyek ini dibuat untuk memenuhi tugas Proyek Akhir Semester (PAS) pada mata kuliah Pemrograman Berbasis Platform (CSGE602022) yang diselenggarakan oleh Fakultas Ilmu Komputer, Universitas Indonesia Tahun Ajaran 2023/2024 Semester Gasal.

## Tautan Aplikasi
Aplikasi Bookquet Mobile dapat diunduh [disini](https://install.appcenter.ms/orgs/PBP12/apps/Bookquet-mobile/distribution_groups/public).

## 👥 Anggota Kelompok
Kami dari kelompok D-12 yang beranggotakan:
| Nama | NPM | Github | 
| -- | -- | -- |
| Akmal Ramadhan | 2206081534 | Akmal76 |
| Carissa Aida Zahra | 2206082543 | carissadzr
| Edbert Halim | 2206813795 | edbert2397 |
| Farah Aura Rosadi | 2206824773 | FarahAuraR
| William | 2206083432 | sunsetheus |

## 📜 Cerita Aplikasi

Dalam rangka diselenggarakannya Kongres Bahasa Indonesia XII pada bulan Oktober 2023, kelompok D-12 dengan bangga mepersembahkan **Bookquet** - sebuah aplikasi inovatif yang menghadirkan literasi ke dalam pengalaman baru. Lebih dari sekadar perpustakaan pribadi, Bookquet memanjakan pengguna melalui pengalaman yang tak terlupakan dengan fitur penyimpanan buku yang akan dibaca nanti. Selain itu, pengguna dapat memberikan ulasan mengenai buku yang sudah dibaca. Nantinya, aplikasi ini bukan hanya tempat untuk literasi, tetapi juga sebagai sarana untuk mendorong generasi muda Indonesia untuk menjelajahi kekayaan kata-kata. Mari menjelajah dunia literasi bersama Bookquet 💐.

## 📚 Daftar Modul
Berikut ini adalah daftar modul yang akan kami implementasikan beserta pengembang dari setiap modul.
 
| Modul | Penjelasan | Pengembang |
| -- | -- | -- |
| **Authentication** | Pengguna aplikasi dapat melakukan *register*, *login*, dan *logout* akun (dengan mekanisme proses registrasi akan di-*redirect* ke *web service* Django secara *asynchronus*). Akun *user* yang sudah terdaftar di Django bisa melakukan *login* melalui aplikasi Bookquet Mobile di Flutter | Carissa |
| **User Dashboard** | Menampilkan informasi pribadi pengguna yang sedang *login* (informasi *user* dari pembuatan akun). Pengguna juga dapat mengedit data pribadinya. | Farah |.
| **Homepage** | Menampilkan halaman utama berupa daftar buku. Pengguna disambut dengan *hero block* dan daftar buku di bawahnya. Setiap buku ditampilkan menggunakan *card* yang memberikan informasi berupa judul, genre, *author*, dan tahun terbit. Pengguna bisa menggunakan fitur *filter* dan *search* untuk mencari buku berdasarkan genre, judul, atau *author*. Pengguna juga bisa menambahkan *feedback* terhadap aplikasi yang digunakan pada tombol `Berikan Feedback`. | Akmal |
| **Book Preview, Rate & Review**| Menampilkan informasi suatu buku, seperti sinopsis, pengarang, judul buku, *rating* buku, genre, dan gambar sampul buku. Pengguna dapat memberikan ulasan (komentar) dan *rating* (bintang dengan rentang 1-5). Jika *user* sudah pernah melakukan *rating*, *rating* terbaru akan memperbarui *rating* lama yang diberikan sebelumba. Pada halaman ini, pengguna dapat melihat komentar beragam *user* (ditampilkan terbatas). | William |
| **Read Later** | Pengguna dapat menambahkan suatu buku ke dalam daftar *read later* dengan tiga buah pilihan prioritas yaitu *low*, *medium*, dan *high*. Dalam halaman tampilan *read later*, terdapat empat tombol yaitu *all*, *low*, *medium*, dan *high*. Jika tombol tersebut ditekan, halaman akan menampilkan buku yang memiliki prioritas yang dipilih (jika *priority* yang dipilih adalah *all*, akan menampilkan semua buku pada *read later*). Pengguna dapat menghapus sebuah buku dari *read later*. Pengguna juga dapat meningkatkan prioritas dari suatu buku yang telah dimasukkan ke dalam daftar *read later*.  | Edbert |

## 🕵️ *Role* atau Peran Pengguna 
#### 🔓 User yang Sudah Terautentikasi
Menggunakan fitur aplikasi secara menyeluruh. Fitur yang disedaiakan yaitu:
- Melakukan pencarian dan *filter* berdasarkan judul, *author*, atau genre.
- Membuka halaman *profile* yang berisi data-data *user* terkait dan dapat mengeditnya.
- Memberikan *review* dan *rating* ke buku yang dipilih.
- Menambah dan menghapus buku pada daftar baca nanti (*read later*).

## *Dataset* yang Digunakan
*Dataset* yang kami gunakan bersumber dari [Kaggle - GoodReads Best Books](https://www.kaggle.com/datasets/thedevastator/comprehensive-overview-of-52478-goodreads-best-b/data). Alasan pemilihan *dataset* ini dikarenakan tersedianya informasi lengkap buku seperti deskripsi singkat, genre, gambar sampul, dan lain-lain. Kami akan mengambil sebanyak 100 buku dari *dataset* tersebut.

## Alur Pengintegrasian dengan Web Service untuk Terhubung dengan Aplikasi Web yang Sudah dibuat saat Proyek Tengah Semester
1. Menambahkan depedensi `http` dengan menjalankan perintah `flutter pub add http` pada terminal proyek agar dapat digunakan untuk bertukar HTTP Request.
2. Membuat model yang sesuai dengan respons JSON dari *web service*, kami menggunakan QuickType untuk membantu pembuatan model-model *app* kami (tercantum pada direktori models).
3. Untuk menyesuaikan *return* yang dibutuhkan *app* yang dibuat, kami memodifikasi beberapa *views code web service* kami (proyek PTS Django).
4. Data yang didapat kemudian diolah atau dipetakan ke dalam suatu struktur data, baik `Map` maupun `List`. Kemudian, data yang sudah dikonversi ke aplimasi ditampilkan melalui `FutureBuilder`.

## Tautan Berita Acara
Tautan berita acara kelompok D12 dapat diakses [disini](https://docs.google.com/spreadsheets/d/172pyc2X2Ib8fZ6M8gB--YL7NuA5O4M92OxUJ01vpUAc/edit?usp=sharing).
