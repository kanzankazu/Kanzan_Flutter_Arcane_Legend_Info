# Arcane Legend Calculator

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Aplikasi kalkulator untuk game Arcane Legend yang membantu menghitung berbagai statistik dalam permainan.

## 📱 Fitur

- 🎯 Kalkulator statistik karakter
- ⚔️ Perhitungan damage
- 🛡️ Perbandingan item
- ⬆️ Simulasi upgrade
- 📊 Analisis statistik
- 🌙 Tema gelap/terang

## 🚀 Memulai

### Prasyarat

- Flutter SDK (versi terbaru)
- Android Studio / VS Code
- Perangkat emulator atau perangkat fisik
- Git (untuk version control)

### 📥 Instalasi

1. Clone repository ini:
   ```bash
   git clone https://github.com/username/arcane-legend-calculator.git
   cd arcane-legend-calculator
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

### ▶️ Menjalankan Aplikasi

```bash
# Jalankan di perangkat yang tersedia
flutter run

# Atau jalankan dengan opsi release
flutter run --release
```

## 🏗️ Struktur Proyek

```
lib/
├── core/                  # Core functionality
│   ├── constants/        # Konstanta aplikasi
│   ├── theme/            # Tema dan styling
│   └── utils/            # Utility functions
│
├── data/                 # Layer data
│   ├── models/           # Model data
│   └── repositories/     # Repositori data
│
├── domain/               # Business logic
│   ├── entities/         # Entitas bisnis
│   └── usecases/         # Use cases aplikasi
│
├── presentation/         # Layer presentasi
│   ├── pages/            # Halaman aplikasi
│   ├── widgets/          # Komponen UI reusable
│   └── providers/        # State management
│
└── main.dart             # Entry point aplikasi
```

## 🛠️ Pengembangan

### Build APK

```bash
flutter build apk --release
```

### Build App Bundle

```bash
flutter build appbundle
```

### Menjalankan Test

```bash
flutter test
```

## 🚨 Troubleshooting

### Jika `flutter pub get` Gagal

Jika Anda mendapatkan error seperti:
```
Failed to start the Dart CLI isolate. Could not resolve DartDev snapshot or kernel.
```

Ikuti langkah-langkah berikut:

1. **Periksa versi Flutter**
   ```bash
   flutter doctor -v
   ```

2. **Bersihkan cache Flutter**
   ```bash
   flutter clean
   ```

3. **Perbarui Flutter**
   ```bash
   flutter upgrade
   ```

4. **Dapatkan ulang dependencies**
   ```bash
   flutter pub get
   ```

5. **Periksa koneksi internet**
   Pastikan koneksi internet stabil dan tidak ada pemblokiran akses ke pub.dev

6. **Periksa file pubspec.yaml**
   Pastikan format file pubspec.yaml valid dan tidak ada kesalahan sintaks

## 🤝 Kontribusi

Kontribusi sangat diterima! Berikut cara berkontribusi:

1. Fork repository ini
2. Buat branch fitur baru (`git checkout -b fitur/namafitur`)
3. Commit perubahan (`git commit -m 'Menambahkan fitur baru'`)
4. Push ke branch (`git push origin fitur/namafitur`)
5. Buat Pull Request

## 📜 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE).

---

Dibuat dengan ❤️ oleh [Nama Anda]
