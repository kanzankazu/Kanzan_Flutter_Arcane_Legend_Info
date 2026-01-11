#!/usr/bin/env python3
"""
Kalkulator Jewel Arcane Legend

Program ini membantu menghitung berbagai aspek terkait jewel dalam game Arcane Legend,
termasuk perhitungan harga, konversi level, dan informasi statistik.
"""
from arcane_legend.ui import display_jewel_table
from arcane_legend.calculations import calculate_combine_cost
from arcane_legend.jewel_utils import (
    get_jewel_info,
    display_price_calculation,
    select_jewel_level,
    get_jewel_levels
)
import math

def main():
    """Fungsi utama untuk menjalankan kalkulator jewel."""
    print("=== Kalkulator Jewel Arcane Legend ===\n")

    while True:
        print("\nPilih opsi:")
        print("1. Cari informasi level jewel")
        print("2. Tampilkan tabel statistik jewel")
        print("3. Hitung konversi harga antar level")
        print("4. Hitung break even Jewel Elixir")
        print("5. Keluar")

        choice = input("> ").strip()
        if choice == '1':
            level_name = select_jewel_level("Pilih level yang ingin dilihat informasinya")
            if level_name:
                info = get_jewel_info(level_name)
                print(f"\n=== Informasi {info['name']} ===")
                print(f"- Cracked dibutuhkan: {info['total_cracked']:,}")
                print(f"- Waktu Combine: {info['combine_time_minutes']} menit")
                print(f"- Akumulasi Waktu Total: {info['total_time_minutes']} menit")
                print(f"- Base Price Multiplier: {info['base_price_multiplier']}x")
                print(f"- Biaya Combine: {info['combine_cost_gold']:,} gold")
        elif choice == '2':
            display_jewel_table()
        elif choice == '3':
            try:
                # Pilih level awal
                start_level = select_jewel_level("Pilih level sumber")
                if not start_level:
                    continue

                # Minta harga level sumber
                try:
                    print(f"\nMasukkan harga 1 {start_level.name} Jewel (gold):")
                    start_price = float(input("> ").strip())
                    if start_price <= 0:
                        print("Harga harus lebih dari 0!")
                        continue
                except ValueError:
                    print("Input harga tidak valid!")
                    continue

                # Pilih level tujuan
                end_level = select_jewel_level("Pilih level tujuan")
                if not end_level:
                    continue

                # Dapatkan info level
                start_info = get_jewel_info(start_level)
                end_info = get_jewel_info(end_level)

                # Hitung harga per cracked jewel (dengan mempertimbangkan base_price_multiplier)
                base_price_per_cracked = start_price / start_info['total_cracked']

                # Hitung biaya bahan baku
                material_cost = base_price_per_cracked * end_info['total_cracked']

                # Hitung biaya combine menggunakan fungsi yang sudah ada
                combine_cost = calculate_combine_cost(end_level)
                
                # Total biaya produksi (bahan baku + biaya combine)
                total_production_cost = material_cost + combine_cost

                # Hitung harga estimasi di level tujuan
                estimated_price = base_price_per_cracked * end_info['total_cracked'] * end_info['base_price_multiplier']

                # Hitung keuntungan
                profit = estimated_price - total_production_cost
                profit_percentage = (profit / total_production_cost) * 100 if total_production_cost > 0 else 0

                # Tampilkan hasil konversi
                print(f"\n=== Hasil Konversi Harga ===")
                print(f"1 {start_level.name} = {start_info['total_cracked']:,} Cracked (x{start_info['base_price_multiplier']:.1f} multiplier)")
                print(f"1 {end_level.name} = {end_info['total_cracked']:,} Cracked (x{end_info['base_price_multiplier']:.1f} multiplier)")
                print(f"\nHarga dasar per Cracked Jewel: {base_price_per_cracked:,.2f} gold")
                print(f"Perkiraan harga 1 {end_level.name}: {estimated_price:,.0f} gold")

                # Minta input harga target (opsional)
                try:
                    target_price_input = input(f"\nMasukkan harga pasaran terendah {end_level.name} (biarkan kosong untuk lewati): ").strip()
                    if target_price_input:
                        target_price = float(target_price_input)
                        # Hitung keuntungan jika dijual dengan harga target
                        profit = target_price - total_production_cost
                        profit_percentage = (profit / total_production_cost) * 100 if total_production_cost > 0 else 0

                        print(f"\n=== Analisis Harga Jual ===")
                        print(f"Harga pasaran terendah: {target_price:,.0f} gold")
                        print(f"Biaya produksi: {total_production_cost:,.0f} gold")
                        print(f"Keuntungan: {profit:,.0f} gold ({profit_percentage:+.1f}%)")

                        # Analisis kelayakan harga
                        if profit > 0:
                            print("\n✅ Layak dijual!")
                            if profit_percentage > 30:
                                print("💎 Profit tinggi, harga sangat kompetitif")
                            elif profit_percentage > 10:
                                print("💰 Profit cukup baik")
                            else:
                                print("🆗 Profit tipis, pertimbangkan untuk menaikkan harga")

                            # Perbandingan dengan estimasi harga
                            if target_price > estimated_price * 1.1:
                                print("⚠️ Harga di atas rata-rata pasar, mungkin sulit terjual")
                            elif target_price < estimated_price * 0.9:
                                print("💡 Harga di bawah rata-rata, kemungkinan cepat laku")
                            else:
                                print("📊 Harga sesuai dengan estimasi pasar")
                        else:
                            print("\n❌ Tidak menguntungkan!")
                            print(f"Anda akan rugi {abs(profit):,.0f} gold")

                            # Saran harga minimal
                            min_price = total_production_cost * 1.1  # Minimal 10% profit
                            print(f"\nSaran harga minimal untuk untung 10%: {min_price:,.0f} gold")
                except ValueError:
                    print("Input harga tidak valid, lewati analisis harga target")

                if combine_cost > 0:
                    print(f"\n=== Biaya Produksi ===")
                    print(f"Biaya bahan baku: {base_price_per_cracked * end_info['total_cracked']:,.0f} gold")
                    print(f"Biaya combine: {combine_cost:,.0f} gold")
                    print(f"Total biaya produksi: {total_production_cost:,.0f} gold")

                    print(f"\n=== Analisis Keuntungan ===")
                    print(f"Perkiraan keuntungan: {profit:,.0f} gold")
                    print(f"Persentase keuntungan: {profit_percentage:,.1f}%")

                    if profit > 0:
                        print("\n✅ Menguntungkan!")
                    else:
                        print("\n❌ Tidak menguntungkan!")

            except Exception as e:
                print(f"Terjadi kesalahan: {e}")
        elif choice == '4':
            try:
                # Dapatkan level Cracked
                cracked_level = None
                for level in get_jewel_levels():
                    if level.name == "Cracked":
                        cracked_level = level
                        break

                if not cracked_level:
                    print("Level Cracked tidak ditemukan!")
                    continue

                # Minta harga Jewel Elixir
                try:
                    print("\nMasukkan harga Jewel Elixir (gold):")
                    elixir_price = float(input("> ").strip())
                    if elixir_price <= 0:
                        print("Harga harus lebih dari 0!")
                        continue
                except ValueError:
                    print("Input harga tidak valid!")
                    continue

                # Minta harga per Cracked Jewel
                try:
                    print("\nMasukkan harga 1 Cracked Jewel (gold):")
                    cracked_price = float(input("> ").strip())
                    if cracked_price <= 0:
                        print("Harga harus lebih dari 0!")
                        continue
                except ValueError:
                    print("Input harga tidak valid!")
                    continue

                # Asumsi durasi elixir 30 menit (bisa disesuaikan)
                ELIXIR_DURATION_MINUTES = 30

                # Hitung berapa Cracked Jewel yang bisa didapat selama elixir aktif
                # Asumsi: 1 Cracked Jewel per menit (bisa disesuaikan)
                cracked_per_minute = 1
                total_cracked_during_elixir = cracked_per_minute * ELIXIR_DURATION_MINUTES

                # Hitung total nilai Cracked Jewel yang didapat
                total_value = total_cracked_during_elixir * cracked_price

                # Hitung berapa Cracked Jewel yang harus didapat untuk break even
                if cracked_price > 0:
                    break_even_quantity = elixir_price / cracked_price
                else:
                    break_even_quantity = float('inf')

                # Tampilkan hasil
                print("\n=== Perhitungan Break Even Jewel Elixir ===")
                print(f"Harga Jewel Elixir: {elixir_price:,.0f} gold")
                print(f"Harga per Cracked Jewel: {cracked_price:,.0f} gold")
                print(f"\nPerkiraan hasil selama {ELIXIR_DURATION_MINUTES} menit (asumsi {cracked_per_minute} Cracked/menit):")
                print(f"- Total Cracked Jewel didapat: {total_cracked_during_elixir:,}")
                print(f"- Total nilai: {total_value:,.0f} gold")

                # Hitung break even point
                break_even_minutes = break_even_quantity / cracked_per_minute
                break_even_per_hour = break_even_quantity / (ELIXIR_DURATION_MINUTES / 60)

                print(f"\n=== Break Even Point ===")
                print(f"Minimal Cracked Jewel untuk balik modal: {math.ceil(break_even_quantity):,} buah")
                print(f"Waktu yang dibutuhkan: {break_even_minutes:.1f} menit")
                print(f"Atau setara dengan: {break_even_per_hour:,.0f} Cracked/jam")

                # Hitung efisiensi waktu
                if break_even_minutes <= ELIXIR_DURATION_MINUTES:
                    remaining_minutes = ELIXIR_DURATION_MINUTES - break_even_minutes
                    extra_cracked = (ELIXIR_DURATION_MINUTES - break_even_minutes) * cracked_per_minute
                    extra_profit = extra_cracked * cracked_price
                    print(f"\n✅ Efisien! Balik modal dalam {break_even_minutes:.1f} menit")
                    print(f"Sisa waktu: {remaining_minutes:.1f} menit untuk profit tambahan")
                    print(f"Perkiraan keuntungan bersih: {extra_profit:,.0f} gold")
                else:
                    print("\n❌ Tidak efisien! Waktu elixir tidak cukup untuk balik modal")
                    print(f"Perlu tambahan waktu: {break_even_minutes - ELIXIR_DURATION_MINUTES:.1f} menit")

                # Tampilkan perbandingan
                if total_value >= elixir_price:
                    print("\n✅ Menguntungkan!")
                    print(f"Keuntungan: {total_value - elixir_price:,.0f} gold")
                else:
                    print("\n❌ Tidak menguntungkan!")
                    print(f"Rugi: {elixir_price - total_value:,.0f} gold")

                print(f"\nUntuk break even, Anda perlu mendapatkan minimal {math.ceil(break_even_quantity):,} Cracked Jewel")
                print(f"atau {math.ceil(break_even_quantity / ELIXIR_DURATION_MINUTES * 60):,} per jam")

            except Exception as e:
                print(f"Terjadi kesalahan: {e}")
                continue

        elif choice == '5':
            print("\nTerima kasih telah menggunakan Kalkulator Jewel Arcane Legend!")
            break
        else:
            print("Pilihan tidak valid. Silakan pilih 1-5.")


if __name__ == "__main__":
    main()
