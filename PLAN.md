# Rencana Pengembangan & Penerapan Fitur (Implementation Plan)
## SIMPRO Mobile App â€” Offline-First & Backend Integration
> Dokumen arsitektur dan panduan penerapan teknis integrasi penuh aplikasi mobile Flutter **SIMPRO (CV Arthamas Graha)** dengan backend web **Laravel 12**, dilengkapi arsitektur **Offline-First**, **SQLite Local Caching**, dan **Persistent Authentication**.

---

## 1. Latar Belakang & Tujuan

Aplikasi SIMPRO Mobile dirancang untuk kebutuhan manajemen operasional proyek konstruksi di lapangan. Karakteristik pekerjaan konstruksi (seperti pembangunan jembatan, gedung, dan perumahan) sering berada pada lokasi dengan koneksi internet yang tidak stabil (*unreliable network*) atau bahkan tanpa sinyal (*blind spot*).

### Tujuan Utama:
1. **Persistent Authentication:** Sesi pengguna tersimpan aman di perangkat lokal sehingga tidak perlu login berulang kali setiap aplikasi dibuka.
2. **Offline-First Architecture:** Pengguna tetap dapat membaca data proyek, material, alat berat, dan laporan keuangan tanpa koneksi internet melalui basis data lokal SQLite.
3. **Antrean Sinkronisasi Otomatis (*Sync Queue*):** Pengguna dapat menginput laporan progres fisik atau survei lokasi saat offline. Data tersimpan di antrean lokal dan otomatis diunggah ke backend Laravel begitu internet terhubung kembali.
4. **Full Backend Integration:** Menggantikan lapisan data simulasi (*mock data*) dengan integrasi RESTful API Laravel Sanctum.

---

## 2. Arsitektur Aliran Data (Offline-First Clean Architecture)

Sistem mengadopsi pola **Clean Architecture** yang memisahkan tanggung jawab antara *Presentation*, *Domain*, dan *Data*:

```
+-----------------------------------------------------------------+
|                        PRESENTATION LAYER                       |
|   (UI Pages, Widgets, BLoC / Cubit State Management)            |
+-----------------------------------------------------------------+
                                |
                                v
+-----------------------------------------------------------------+
|                          DOMAIN LAYER                           |
|   (Entities, Use Cases, Repository Interfaces)                  |
+-----------------------------------------------------------------+
                                |
                                v
+-----------------------------------------------------------------+
|                           DATA LAYER                            |
|                       (Repository Impl)                         |
|                                                                 |
|         Strategi: Cache-First with Network Revalidation         |
|        -------------------------------------------------        |
|        1. Baca data instan dari SQLite (0 ms latency)           |
|        2. Di latar belakang, request data baru ke Laravel API   |
|        3. Simpan data baru ke SQLite & segarkan tampilan UI     |
+-----------------------------------------------------------------+
               /                                   \
              v                                     v
+---------------------------+         +---------------------------+
|    LOCAL DATA SOURCE      |         |    REMOTE DATA SOURCE     |
|  - SQLite (sqflite)       |         |  - Dio / HTTP Client      |
|  - Secure Token Storage   |         |  - Laravel Sanctum Token  |
|  - Offline Sync Queue     |         |  - Multipart File Upload  |
+---------------------------+         +---------------------------+
```

---

## 3. Rencana Fitur & Tahapan Penerapan (Fase Kerja)

### Fase 1: Persistent Authentication & Session Gatekeeper
- **Penyimpanan Token Aman:** Menggunakan `flutter_secure_storage` untuk menyimpan Access Token (Sanctum Bearer Token) dan data profil pengguna terenkripsi.
- **Splash / Auth Gatekeeper di `main.dart`:**
  - Saat aplikasi dibuka, sistem memeriksa keberadaan token valid di storage lokal.
  - Jika token ditemukan: Langsung arahkan ke `DashboardPage`.
  - Jika token kosong / kedaluwarsa: Arahkan ke `AuthenticationPage`.
- **Auto-Logout saat 401 Unauthorized:** Interceptor otomatis menghapus token lokal dan mengembalikan pengguna ke halaman login jika sesi di server telah dicabut.

---

### Fase 2: Pengaturan REST API Client (Backend Connection)
- **Dio Client & Base URL Dinamis:**
  - `http://10.0.2.2:8000/api/v1` untuk Android Emulator.
  - `http://<IP-LAN>:8000/api/v1` untuk Pengujian di HP Fisik melalui Wi-Fi.
  - `https://simpro.arthamasgraha.com/api/v1` untuk Server Produksi.
- **Auth Interceptor:** Menyuntikkan header `Authorization: Bearer <token>` dan `Accept: application/json` secara otomatis pada setiap request HTTP.
- **Pendaftaran Rute Backend (`routes/api.php`):**
  - Mengaktifkan rute API di backend Laravel 12 melalui perintah `php artisan install:api`.
  - Mendaftarkan endpoint auth, dashboard, projects, materials, equipments, surveys, progress, dan finance.

---

### Fase 3: SQLite Local Caching (Database Lokal HP)
- **Pustaka Utama:** `sqflite` dan `path_provider`.
- **Tabel Basis Data Lokal:**
  1. `cached_projects`: Menyimpan daftar proyek, nilai kontrak, RAB, progres, dan kelengkapan berkas.
  2. `cached_materials`: Menyimpan katalog material, stok gudang, harga satuan, dan tarif sewa.
  3. `cached_equipments`: Menyimpan daftar alat berat, kondisi fisik, dan tarif harian.
  4. `cached_surveys`: Menyimpan data survei lapangan, luas lahan (Ha), elevasi (mdpl), dan kontur.
  5. `cached_finance`: Menyimpan ringkasan arus kas dan mutasi transaksi proyek.
- **Kebijakan Cache:**
  - *Read:* Ambil data dari SQLite saat halaman dibuka agar tampilan langsung muncul tanpa hambatan sinyal.
  - *Sync:* Ketika internet tersedia, perbarui tabel SQLite dengan respons terbaru dari backend.

---

### Fase 4: Offline Sync Queue (Antrean Kirim Laporan)
- **Tabel `offline_sync_queue`:**
  - Kolom: `id`, `endpoint`, `http_method`, `payload_json`, `attachment_paths`, `status`, `created_at`.
- **Alur Kerja Pengiriman Offline:**
  1. Pengawas mengisi form laporan progres / survei lokasi di lapangan tanpa sinyal.
  2. Klik tombol "Simpan" -> Aplikasi mencatat laporan ke antrean `offline_sync_queue` dan menampilkan status *"Tersimpan Lokal (Menunggu Sinyal)"*.
  3. Layanan latar belakang (`ConnectivityListener`) memantau status jaringan menggunakan `connectivity_plus`.
  4. Begitu sinyal internet kembali aktif, sistem memproses antrean satu per satu secara berurutan (*FIFO*) ke server backend Laravel.

---

### Fase 5: Peningkatan UI/UX untuk Penggunaan Lapangan
- **Pull-to-Refresh (`RefreshIndicator`):** Memungkinkan staf menarik layar ke bawah pada halaman daftar untuk sinkronisasi paksa dengan server.
- **Banner Status Sinyal (`OfflineBanner`):** Indikator halus di bagian atas layar yang memberitahu bahwa aplikasi sedang berada dalam *Mode Offline*.
- **Image Picker & Kompresi Foto:** Fitur kamera langsung dan kompresi otomatis foto lapangan (JPG kualitas 80%, maks. 1 MB) agar pengunggahan hemat kuota dan cepat.

---

## 4. Panduan Langkah Penerapan Detail (Implementation Guide)

### Langkah 1: Penambahan Dependensi di `pubspec.yaml`
```yaml
dependencies:
  flutter:
    sdk: flutter

  # Jaringan & HTTP
  dio: ^5.7.0
  connectivity_plus: ^6.1.0

  # Penyimpanan Sesi & Enkripsi
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.3.3

  # Basis Data Lokal SQLite
  sqflite: ^2.4.1
  path: ^1.9.0
  path_provider: ^2.1.5

  # Utilitas Media Lapangan
  image_picker: ^1.1.2
```

---

### Langkah 2: Pembuatan Helper Database SQLite Lokal
Lokasi file: `lib/core/database/database_helper.dart`
- Inisialisasi SQLite singleton.
- Pembuatan tabel lokal: `projects`, `materials`, `equipments`, `site_surveys`, dan `sync_queue`.
- Fungsi CRUD dasar (insert batch, query all, update, delete cache).

---

### Langkah 3: Pembuatan Token Storage Service
Lokasi file: `lib/core/storage/token_storage.dart`
- Menyediakan fungsi:
  - `saveToken(String token)`
  - `getToken(): Future<String?>`
  - `saveUser(Map<String, dynamic> user)`
  - `getUser(): Future<Map<String, dynamic>?>`
  - `clearSession(): Future<void>`

---

### Langkah 4: Pembuatan Dio API Client & Interceptor
Lokasi file: `lib/core/network/api_client.dart`
- Konfigurasi `BaseOptions` (Connect timeout: 15 detik, Receive timeout: 15 detik).
- Interceptor untuk:
  - Menambahkan header `Authorization: Bearer <token>`.
  - Logging request & response di mode debug.
  - Mendeteksi error status `401 Unauthorized` untuk memicu auto-logout.

---

### Langkah 5: Modifikasi Repository (Cache-First Logic)
Contoh pada `lib/features/projects/data/repositories/project_repository_impl.dart`:
```dart
Future<List<ProjectEntity>> getProjects() async {
  // 1. Ambil data lokal terlebih dahulu (Instan)
  final localData = await localDataSource.getCachedProjects();

  // 2. Jika ada koneksi internet, perbarui dari backend Laravel
  if (await networkInfo.isConnected) {
    try {
      final remoteData = await remoteDataSource.getProjects();
      await localDataSource.cacheProjects(remoteData);
      return remoteData;
    } catch (_) {
      // Jika server bermasalah, tetap kembalikan data lokal
      return localData;
    }
  }

  // 3. Jika offline, kembalikan data cache lokal
  return localData;
}
```

---

### Langkah 6: Pembaruan `main.dart` untuk Session Gatekeeper
Modifikasi inisialisasi awal pada `lib/main.dart`:
- Mengecek status login sebelum memanggil `runApp()`:
  - Jika token tersedia -> `initialRoute = DashboardPage.routeName`
  - Jika token kosong -> `initialRoute = AuthenticationPage.routeName`

---

## 5. Pemetaan Endpoint Backend Laravel (API Reference)

| Modul | Endpoint | HTTP Method | Keterangan |
|---|---|---|---|
| **Otentikasi** | `/api/v1/login` | POST | Login username & password -> kembalikan Sanctum Token |
| | `/api/v1/logout` | POST | Mencabut token sesi aktif |
| | `/api/v1/user` | GET | Mendapatkan profil pengguna aktif & hak akses |
| **Dashboard** | `/api/v1/dashboard` | GET | Metrik total RAB, realisasi biaya, proyek aktif, & log |
| **Proyek** | `/api/v1/projects` | GET | Daftar proyek konstruksi & kelengkapan berkas |
| | `/api/v1/projects/{id}` | GET | Detail rincian proyek, anggaran, dan milestone |
| **Material** | `/api/v1/materials` | GET | Katalog material, stok minimum, & tarif sewa |
| | `/api/v1/material-requests` | POST | Kirim batch pengajuan material (POS keranjang) |
| **Alat Berat** | `/api/v1/equipments` | GET | Inventaris alat berat, status lokasi, & sewa harian |
| **Survei** | `/api/v1/site-surveys` | GET | Daftar laporan survei lokasi lapangan |
| | `/api/v1/site-surveys` | POST | Input laporan survei (luas Ha, elevasi, kontur, foto) |
| **Progres** | `/api/v1/progress` | POST | Input capaian persentase pengerjaan & foto progres |

---

## 6. Skenario Pengujian & Jaminan Mutu (*Quality Assurance*)

1. **Uji Sesi Berulang (Persistent Auth):**
   - Login berhasil -> Tutup paksa aplikasi (*kill process*) -> Buka kembali aplikasi.
   - *Ekspektasi:* Aplikasi langsung menampilkan Dashboard tanpa meminta login ulang.
2. **Uji Baca Offline (*Airplane Mode*):**
   - Muat data saat online -> Aktifkan Mode Pesawat (tanpa internet) -> Buka daftar proyek & material.
   - *Ekspektasi:* Semua data lama tetap muncul normal dari cache SQLite lokal.
3. **Uji Transisi Sinkronisasi Antrean (*Sync Queue*):**
   - Buat laporan survei baru saat Mode Pesawat aktif -> Data berstatus "Menunggu Sinyal".
   - Matikan Mode Pesawat (koneksi internet kembali aktif).
   - *Ekspektasi:* Data otomatis terunggah ke backend Laravel dan status berubah menjadi tersinkronisasi.
