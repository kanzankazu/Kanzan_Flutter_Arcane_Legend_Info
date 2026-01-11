# 💎 Arcane Legend Jewel Calculator

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Status](https://img.shields.io/badge/Status-Beta-orange.svg)]()
[![Theme](https://img.shields.io/badge/Theme-Dark_Fantasy-gold.svg)]()

Aplikasi kalkulator finansial komprehensif untuk game **Arcane Legends** yang membantu pemain menghitung profitabilitas pembuatan jewel, efisiensi elixir, dan perbandingan harga antar level dengan akurasi tinggi.

## 🛡️ Identitas Visual & Branding
Aplikasi ini dirancang dengan estetika premium yang terinspirasi langsung dari antarmuka game Arcane Legends:
- **Tipografi Fantasi**: Menggunakan fon `MedievalSharp` untuk elemen branding dan `Almendra` untuk data teks.
- **Palet Warna Emas & Indigo**: Dominasi warna **Gold (#B8860B)** dan **Deep Indigo** di atas latar belakang gelap untuk kesan MMORPG yang otentik.
- **Dark Mode Optimized**: Kontras tinggi yang nyaman di mata untuk penggunaan durasi lama.

## 📱 Fitur Utama

### 📊 Dashboard Interaktif
- Layout grid 3-kolom yang modern dan responsif.
- Akses cepat ke semua modul kalkulasi.
- Shortcut ke link komunitas eksternal (Market Itemku, Web Resmi).

### 🔍 Informasi Jewel (Cek Statistik)
- Detail lengkap setiap level jewel (Cracked hingga Flawless).
- **Update Harga Real-time**: Kalkulasi otomatis saat Anda mengubah harga dasar.
- **Analisis Keuntungan Bersih**: Break-down biaya material, biaya combine, dan profit nyata secara mendetail.

### ⚔️ Bandingkan Level
- Eksperimen harga pasar dan harga dasar secara fleksibel.
- **Analisis Kelayakan**: Memberikan saran objektif apakah proses pembuatan jewel layak dilakukan atau tidak.
- Indikator visual profit/rugi yang dinamis.

### ⚡ Kalkulator Elixir
- Hitung *Break Even Point* (BEP) penggunaan Jewel Elixir.
- Analisis efisiensi berdasarkan durasi dan rate farming Anda.

### 📏 Tabel Statistik Responsif
- Data teknis lengkap semua level jewel dalam satu tampilan.
- Layout tabel yang pas dengan lebar layar (*match parent*).

## 🚀 Persyaratan Sistem & Build (Spesifik)
Aplikasi ini menggunakan spesifikasi build terbaru untuk mendukung library modern:
- **Flutter SDK**: Versi terbaru (~3.27+)
- **Android Gradle Plugin (AGP)**: 8.9.1
- **Gradle Wrapper**: 8.11.1
- **Kotlin**: 2.1.0
- **Android SDK**: CompileSdk 35 / MinSdk 21

## 🏗️ Struktur Proyek (Actual)

```text
lib/
├── domain/
│   ├── entities/        # Definisi data JewelLevel (Basis Perhitungan)
│   └── repositories/    # Manajemen data jewel
├── screens/             # UI Pages (Home, Calculator, Comparison, etc.)
├── utils/               # Logika perhitungan (calculations.dart)
└── main.dart            # Konfigurasi Tema & Entry Point
```

## 📥 Instalasi & Jalankan

1. **Dapatkan Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Jalankan Aplikasi (Web)**:
   ```bash
   flutter run -d chrome
   ```

3. **Jalankan Aplikasi (Android)**:
   ```bash
   adb devices  # Pastikan HP terdeteksi
   flutter run
   ```

## 🚨 Troubleshooting Build Android
Jika build gagal karena versi Gradle/AGP:
1. Jalankan `flutter clean`.
2. Pastikan `android/settings.gradle.kts` menggunakan AGP 8.9.1.
3. Pastikan `gradle-wrapper.properties` menggunakan versi 8.11.1.

---
Dibuat dengan ❤️ untuk komunitas Arcane Legends oleh **Kanzan**
