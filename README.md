# Digital Time Capsule

Aplikasi mobile yang memungkinkan pengguna untuk membuat, menyimpan, dan membuka kapsul waktu digital dengan pesan untuk masa depan.

## 📱 Deskripsi Aplikasi

**Digital Time Capsule** adalah aplikasi Flutter yang memberikan pengalaman unik untuk menyimpan pesan, kenangan, atau dokumen penting dalam "kapsul waktu digital". Pengguna dapat membuat kapsul waktu dengan konten pribadi dan menentukan kapan kapsul tersebut dapat dibuka kembali di masa depan.

### Fitur Utama
- **Registrasi dan Login**: Sistem autentikasi untuk keamanan akun pengguna
- **Buat Kapsul Waktu**: Pengguna dapat membuat kapsul waktu baru dengan pesan dan tanggal pembukaan
- **Kelola Kapsul**: Edit dan mengelola kapsul waktu yang telah dibuat
- **Buka Kapsul**: Membuka kapsul waktu sesuai waktu yang telah ditentukan
- **Penyimpanan Lokal**: Data disimpan secara aman menggunakan Hive

## 👥 Anggota Kelompok

| Nama | NIM |
|------|-----|
| Muhammad Irsyad Mustaqim | 1237050050 |
| Hafizultan Fanzaulid | 1237050097 |

## 🏫 Institusi

- **Universitas**: [UIN Sunan Gunung Djati Bandung](https://uinsgd.ac.id/)
- **Jurusan**: [Informatika](http://if.uinsgd.ac.id/)

## 📊 Repository

- **GitHub Repository**: [https://github.com/hafanza/digital_time_capsule](https://github.com/hafanza/digital_time_capsule)

## 🛠️ Teknologi yang Digunakan

- **Framework**: Flutter
- **Bahasa Pemrograman**: Dart
- **Database Lokal**: Hive
- **Internationalization**: intl
- **Custom Font**: VT323

## 📋 Persyaratan Sistem

- Dart SDK: ^3.10.4
- Flutter SDK
- Android SDK (untuk build Android)
- Xcode (untuk build iOS)

## 🚀 Cara Menjalankan Aplikasi

### Prerequisites
Pastikan Anda telah menginstall:
- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)

### Langkah-langkah

1. **Clone Repository**
```bash
git clone https://github.com/hafanza/digital_time_capsule.git
cd digital_time_capsule
```

2. **Dapatkan Dependencies**
```bash
flutter pub get
```

3. **Jalankan Aplikasi**
```bash
flutter run
```

## 📦 Dependencies Utama

- **hive** (^2.2.3): Database lokal yang cepat dan efisien
- **hive_flutter** (^1.1.0): Integrasi Hive dengan Flutter
- **intl** (^0.19.0): Untuk formatting tanggal dan waktu
- **cupertino_icons** (^1.0.8): Icon library iOS

## 📁 Struktur Proyek

```
lib/
├── splash_screen.dart          # Layar splash/loading awal
├── login_screen.dart           # Layar login
├── register_screen.dart        # Layar registrasi
├── home_screen.dart            # Layar utama
├── create_capsule_screen.dart  # Layar pembuatan kapsul waktu
├── edit_capsule_screen.dart    # Layar pengeditan kapsul waktu
├── open_capsule_screen.dart    # Layar pembukaan kapsul waktu
└── main.dart                   # Entry point aplikasi
```

## 📖 Dokumentasi Lebih Lanjut

Untuk informasi lebih lanjut tentang Flutter, kunjungi:
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Online Documentation](https://docs.flutter.dev/)

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik UIN Sunan Gunung Djati Bandung.

---

**Dibuat dengan ❤️ oleh Tim Digital Time Capsule**
