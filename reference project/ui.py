"""
Modul untuk UI dan interaksi pengguna Jewel Arcane Legend
"""
from typing import Optional
from .models import get_jewel_levels
from .calculations import get_jewel_info, display_price_calculation

def display_jewel_table():
    """Menampilkan tabel informasi level jewel."""
    levels = get_jewel_levels()

    # Header tabel
    print(f"{'Level':<12} | {'Butuh':^6} | {'Total':^10} | {'Waktu':^16} | {'Total Waktu':^16}")
    print("-" * 75)

    # Isi tabel
    for level in levels:
        print(f"{level.name:<12} | {level.required_previous if level.required_previous > 0 else '-':^6} | "
              f"{level.total_cracked:^10,} | {format_time(level.combine_time_minutes):^16} | "
              f"{format_time(level.total_time_minutes):^16}")

def select_jewel_level(prompt: str) -> Optional[str]:
    """Menampilkan daftar level dan meminta input pengguna."""
    levels = get_jewel_levels()

    while True:
        print("\nDaftar Level Jewel:")
        for i, level in enumerate(levels, 1):
            print(f"{i}. {level.name}", end="\t")
            if i % 4 == 0:  # 4 kolom per baris
                print()

        print(f"\n{prompt} (1-{len(levels)} atau nama level):")
        user_input = input("> ").strip()

        # Coba konversi ke angka
        if user_input.isdigit():
            level_num = int(user_input)
            if 1 <= level_num <= len(levels):
                return levels[level_num - 1].name
            print(f"Masukkan angka antara 1-{len(levels)}")
        else:
            # Cari berdasarkan nama (case insensitive)
            for level in levels:
                if level.name.lower() == user_input.lower():
                    return level.name
            print("Level tidak ditemukan. Silakan coba lagi.")

def show_jewel_info():
    """Menampilkan informasi level jewel yang dipilih."""
    level_name = select_jewel_level("Pilih level yang ingin dilihat informasinya")
    if level_name:
        info = get_jewel_info(level_name)
        print(f"\n=== Informasi {info['level']} ===")
        print(f"- Total Cracked dibutuhkan: {info['total_cracked']:,}")
        print(f"- Waktu Combine: {info['combine_time']}")
        print(f"- Akumulasi Waktu Total: {info['total_time']}")

def show_conversion_calculation():
    """Menampilkan perhitungan konversi antar level jewel."""
    try:
        # Pilih level awal
        start_level = select_jewel_level("Pilih level awal")
        if not start_level:
            return

        print(f"\nMasukkan harga 1 {start_level} Jewel (gold):")
        start_price = float(input("> ").strip())

        # Pilih level tujuan
        end_level = select_jewel_level("Pilih level tujuan")
        if not end_level:
            return

        # Hitung harga cracked jewel ekuivalen
        start_info = get_jewel_info(start_level)
        if not start_info:
            print("Level awal tidak valid!")
            return

        # Hitung harga dasar per cracked jewel
        base_price = start_price / start_info['total_cracked']

        # Tampilkan perhitungan
        display_price_calculation(start_level, end_level, base_price)

    except ValueError:
        print("Input tidak valid. Pastikan format angka yang dimasukkan benar.")

# Import format_time dari calculations untuk menghindari circular import
from .calculations import format_time
