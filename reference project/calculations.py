"""
Modul untuk perhitungan terkait Jewel Arcane Legend
"""
from typing import Dict, Optional
from .models import JewelLevel, get_jewel_levels

def format_time(minutes: int) -> str:
    """Mengkonversi menit ke format jam dan menit."""
    hours = minutes // 60
    mins = minutes % 60

    if hours > 0 and mins > 0:
        return f"{hours} jam {mins} menit"
    elif hours > 0:
        return f"{hours} jam"
    else:
        return f"{mins} menit"

def format_currency(amount: int) -> str:
    """Format angka menjadi format mata uang."""
    return f"{amount:,} gold"

def calculate_combine_cost(level: JewelLevel) -> int:
    """
    Menghitung total biaya combine dari Cracked ke level tertentu
    dengan perhitungan yang lebih sederhana dan akurat.
    """
    if level.name == "Cracked":
        return 0
        
    # Dapatkan semua level jewel
    levels = get_jewel_levels()
    
    # Buat mapping nama level ke objek level
    level_map = {lvl.name: lvl for lvl in levels}
    
    # Hitung biaya combine untuk setiap level yang diperlukan
    if level.name == "Damaged":
        return level.combine_cost_gold  # 50
    elif level.name == "Weak":
        # 3x Damaged combine + 1x Weak combine
        return (3 * level_map["Damaged"].combine_cost_gold) + level.combine_cost_gold  # 3*50 + 100 = 250
    elif level.name == "Standard":
        # 3x Weak combine + 1x Standard combine
        weak_combine = (3 * level_map["Damaged"].combine_cost_gold) + level_map["Weak"].combine_cost_gold
        return (3 * weak_combine) + level.combine_cost_gold  # 3*250 + 200 = 950
    elif level.name == "Fortified":
        # 3x Standard combine + 1x Fortified combine
        std_combine = calculate_combine_cost(level_map["Standard"])
        return (3 * std_combine) + level.combine_cost_gold
    elif level.name == "Excellent":
        # 3x Fortified combine + 1x Excellent combine
        fort_combine = calculate_combine_cost(level_map["Fortified"])
        return (3 * fort_combine) + level.combine_cost_gold
    elif level.name == "Superb":
        # 3x Excellent combine + 1x Superb combine
        exc_combine = calculate_combine_cost(level_map["Excellent"])
        return (3 * exc_combine) + level.combine_cost_gold
    elif level.name == "Noble":
        # 3x Superb combine + 1x Noble combine
        sup_combine = calculate_combine_cost(level_map["Superb"])
        return (3 * sup_combine) + level.combine_cost_gold
    elif level.name == "Exquisite":
        # 3x Noble combine + 1x Exquisite combine
        nob_combine = calculate_combine_cost(level_map["Noble"])
        return (3 * nob_combine) + level.combine_cost_gold
    
    return 0  # Fallback

def calculate_sell_price(base_price: float, level: JewelLevel) -> int:
    """Menghitung harga jual yang wajar untuk level tertentu."""
    return int(base_price * level.total_cracked * level.base_price_multiplier)

def get_jewel_info(level_name: str, base_price: Optional[float] = None) -> Dict:
    """Mendapatkan informasi detail tentang level jewel tertentu."""
    levels = get_jewel_levels()
    for level in levels:
        if level.name.lower() == level_name.lower():
            result = {
                'level': level.name,
                'total_cracked': level.total_cracked,
                'combine_time': format_time(level.combine_time_minutes),
                'total_time': format_time(level.total_time_minutes),
            }

            if base_price is not None and base_price > 0:
                result.update({
                    'sell_price': calculate_sell_price(base_price, level),
                    'combine_cost': calculate_combine_cost(level),
                    'base_price': base_price
                })
            return result
    return {}

def get_level_index(level_name: str) -> int:
    """Mendapatkan index level untuk perbandingan."""
    levels = [level.name.lower() for level in get_jewel_levels()]
    try:
        return levels.index(level_name.lower())
    except ValueError:
        return -1

def display_price_calculation(start_level: str, end_level: str, base_price: float):
    """Menampilkan perhitungan harga dari level awal ke level akhir."""
    start_info = get_jewel_info(start_level, base_price)
    end_info = get_jewel_info(end_level, base_price)

    if not start_info or not end_info:
        print("Level tidak ditemukan! Pastikan penulisan sudah benar.")
        return

    start_idx = get_level_index(start_level)
    end_idx = get_level_index(end_level)

    if start_idx == -1 or end_idx == -1:
        print("Terjadi kesalahan dalam memproses level.")
        return

    if start_idx >= end_idx:
        print("Error: Level awal harus lebih tinggi dari level akhir!")
        return

    print(f"\n=== Perhitungan Harga dari {start_info['level']} ke {end_info['level']} ===")
    print(f"Harga dasar Cracked Jewel: {format_currency(base_price)}")

    # Hitung total cracked dan biaya untuk setiap level di antara start dan end
    total_cracked = 0
    total_cost = 0

    levels = get_jewel_levels()
    for i in range(start_idx, end_idx):
        level = levels[i]
        next_level = levels[i + 1]

        # Hitung kebutuhan untuk naik 1 level
        needed = next_level.total_cracked / level.total_cracked
        cost = calculate_combine_cost(next_level) - calculate_combine_cost(level)

        total_cracked += needed
        total_cost += cost

        print(f"\n{level.name} -> {next_level.name}:")
        print(f"- Butuh {needed:,.1f} {level.name} Jewel")
        print(f"- Biaya: {format_currency(int(cost))}")

    print(f"\n=== Total Perhitungan ===")
    print(f"Total {start_info['level']} Jewel dibutuhkan: {total_cracked:,.1f}")
    print(f"Total Biaya: {format_currency(int(total_cost))}")
    print(f"Harga Jual {end_info['level']}: {format_currency(end_info['sell_price'])}")

    # Hitung keuntungan
    profit = end_info['sell_price'] - total_cost
    profit_percentage = (profit / total_cost) * 100 if total_cost > 0 else 0

    print(f"\nPerkiraan Keuntungan:")
    print(f"- Keuntungan Kotor: {format_currency(int(profit))}")
    print(f"- Persentase Keuntungan: {profit_percentage:,.1f}%")
