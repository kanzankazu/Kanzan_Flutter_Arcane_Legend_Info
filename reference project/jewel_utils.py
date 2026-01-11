"""
Modul utilitas untuk perhitungan dan operasi terkait jewel
"""

def get_jewel_info(jewel_level):
    """
    Mengambil informasi jewel berdasarkan level
    
    Args:
        jewel_level (JewelLevel): Objek level jewel
        
    Returns:
        dict: Informasi jewel dalam bentuk dictionary
    """
    return {
        'name': jewel_level.name,
        'total_cracked': jewel_level.total_cracked,
        'combine_time_minutes': jewel_level.combine_time_minutes,
        'total_time_minutes': jewel_level.total_time_minutes,
        'base_price_multiplier': jewel_level.base_price_multiplier,
        'combine_cost_multiplier': jewel_level.combine_cost_multiplier,
        'combine_cost_gold': jewel_level.combine_cost_gold
    }

def display_price_calculation(start_level, end_level, base_price):
    """
    Menampilkan perhitungan harga jewel dari level awal ke level tujuan
    
    Args:
        start_level (JewelLevel): Level awal
        end_level (JewelLevel): Level tujuan
        base_price (float): Harga dasar per cracked jewel
    """
    print(f"\n=== Perhitungan Harga Jewel ===")
    print(f"Dari: {start_level.name}")
    print(f"Ke: {end_level.name}")
    print(f"Harga per {start_level.name} Jewel: {base_price:,.0f} gold")
    
    # Hitung total jewel yang dibutuhkan untuk upgrade
    # required_previous menunjukkan berapa banyak jewel level sebelumnya yang dibutuhkan
    # untuk membuat 1 jewel level saat ini
    jewel_needed = 1  # Jumlah jewel tujuan yang ingin dibuat
    current_level = end_level
    
    # Hitung total cracked jewel yang dibutuhkan
    # Mulai dari level tujuan dan turun ke level start_level + 1
    total_cracked = 0
    
    while current_level.name != start_level.name:
        jewel_needed *= current_level.required_previous
        total_cracked += jewel_needed
        
        # Cari level sebelumnya
        prev_level = None
        for level in get_jewel_levels():
            if level.name == current_level.name:
                break
            prev_level = level
        
        if not prev_level:
            break
            
        current_level = prev_level
    
    # Hitung total biaya
    total_cost = base_price * total_cracked
    
    print(f"\nTotal {start_level.name} Jewel dibutuhkan: {total_cracked:,}")
    print(f"Total Biaya: {total_cost:,.0f} gold")
    
    # Hitung perkiraan waktu
    time_difference = end_level.total_time_minutes - start_level.total_time_minutes
    hours = time_difference // 60
    minutes = time_difference % 60
    print(f"\nPerkiraan Waktu Tambahan: {hours} jam {minutes} menit")

from arcane_legend.models import get_jewel_levels

def select_jewel_level(prompt):
    """
    Meminta pengguna untuk memilih level jewel
    
    Args:
        prompt (str): Pesan yang akan ditampilkan ke pengguna
        
    Returns:
        JewelLevel: Objek level jewel yang dipilih atau None jika dibatalkan
    """
    jewel_levels = get_jewel_levels()
    
    print("\nDaftar Level Jewel:")
    for i, level in enumerate(jewel_levels, 1):
        print(f"{i}. {level.name}")
    
    while True:
        try:
            choice = input(f"\n{prompt} (1-{len(jewel_levels)}, atau 0 untuk batal): ").strip()
            
            if choice == '0':
                print("Operasi dibatalkan.")
                return None
                
            choice_idx = int(choice) - 1
            if 0 <= choice_idx < len(jewel_levels):
                return jewel_levels[choice_idx]
            else:
                print(f"Pilihan tidak valid. Silakan pilih angka antara 1-{len(jewel_levels)}.")
        except ValueError:
            print("Masukan tidak valid. Harap masukkan angka.")
