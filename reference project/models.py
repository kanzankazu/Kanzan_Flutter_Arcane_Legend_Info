"""
Modul untuk model data Jewel Arcane Legend
"""
from dataclasses import dataclass
from typing import List

@dataclass
class JewelLevel:
    """Kelas untuk merepresentasikan level jewel"""
    name: str
    required_previous: int
    total_cracked: int
    combine_time_minutes: int
    total_time_minutes: int
    base_price_multiplier: float = 1.0  # Default multiplier untuk harga jual
    combine_cost_multiplier: float = 1.0  # Multiplier untuk biaya combine
    combine_cost_gold: int = 0  # Biaya combine dalam gold

def get_jewel_levels() -> List[JewelLevel]:
    """Mengembalikan daftar semua level jewel yang tersedia"""
    levels = [
        ("Cracked", 0, 1, 0, 0, 1.0, 1.0, 0),
        ("Damaged", 3, 3, 30, 30, 1.5, 1.1, 50),
        ("Weak", 3, 9, 60, 90, 2.0, 1.2, 100),
        ("Standard", 3, 27, 120, 210, 3.0, 1.3, 200),
        ("Fortified", 3, 81, 240, 450, 4.5, 1.4, 500),
        ("Excellent", 3, 243, 360, 810, 6.5, 1.5, 1000),
        ("Superb", 3, 729, 720, 1530, 9.5, 1.6, 2000),
        ("Noble", 3, 2187, 960, 2490, 14.0, 1.7, 5000),
        ("Exquisite", 3, 6561, 1200, 3690, 20.0, 1.8, 10000),
        ("Precise", 3, 19683, 1440, 5130, 28.0, 1.9, 20000),
        ("Flawless", 3, 59049, 1440, 6570, 40.0, 2.0, 50000),
    ]

    return [JewelLevel(*level) for level in levels]
