import 'package:arcane_legend_calculator/domain/entities/jewel_level.dart';
import 'package:arcane_legend_calculator/domain/repositories/jewel_repository.dart';

class JewelRepositoryImpl implements JewelRepository {
  @override
  List<JewelLevel> getJewelLevels() {
    return JewelLevel.getJewelLevels();
  }

  @override
  JewelLevel? getJewelLevelByName(String name) {
    try {
      return JewelLevel.getLevelByName(name);
    } catch (e) {
      return null;
    }
  }

  @override
  int calculateCombineCost(JewelLevel level) {
    if (level.name == "Cracked") {
      return 0;
    }

    final levels = getJewelLevels();
    final levelMap = {for (var l in levels) l.name: l};

    if (level.name == "Damaged") {
      return level.combineCostGold; // 50
    } else if (level.name == "Weak") {
      // 3x Damaged combine + 1x Weak combine
      return (3 * levelMap["Damaged"]!.combineCostGold) +
          level.combineCostGold; // 3*50 + 100 = 250
    } else if (level.name == "Standard") {
      // 3x Weak combine + 1x Standard combine
      final weakCombine = (3 * levelMap["Damaged"]!.combineCostGold) +
          levelMap["Weak"]!.combineCostGold;
      return (3 * weakCombine) + level.combineCostGold; // 3*250 + 200 = 950
    } else {
      // For higher levels, use recursive calculation
      final prevLevel = levels[levels.indexOf(level) - 1];
      return (3 * calculateCombineCost(prevLevel)) + level.combineCostGold;
    }
  }

  @override
  int calculateSellPrice(double basePrice, JewelLevel level) {
    return (basePrice * level.totalCracked * level.basePriceMultiplier).round();
  }

  @override
  Map<String, dynamic>? getJewelInfo(String levelName, {double? basePrice}) {
    try {
      final level = JewelLevel.getLevelByName(levelName);
      final result = {
        'name': level.name,
        'totalCracked': level.totalCracked,
        'combineTime': JewelLevel.formatTime(level.combineTimeMinutes),
        'totalTime': JewelLevel.formatTime(level.totalTimeMinutes),
        'basePriceMultiplier': level.basePriceMultiplier,
        'combineCostGold': level.combineCostGold,
      };

      if (basePrice != null && basePrice > 0) {
        result['sellPrice'] = calculateSellPrice(basePrice, level);
        result['combineCost'] = calculateCombineCost(level);
        result['basePrice'] = basePrice;
      }

      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  int getLevelIndex(String levelName) {
    return JewelLevel.getLevelIndex(levelName);
  }

  @override
  Map<String, dynamic> calculatePriceConversion({
    required String startLevel,
    required double startPrice,
    required String endLevel,
    double? targetPrice,
  }) {
    try {
      final start = getJewelLevelByName(startLevel);
      final end = getJewelLevelByName(endLevel);

      if (start == null || end == null) {
        throw Exception('Level tidak ditemukan');
      }

      final startInfo = getJewelInfo(startLevel, basePrice: startPrice);
      final endInfo = getJewelInfo(endLevel, basePrice: startPrice);

      if (startInfo == null || endInfo == null) {
        throw Exception('Gagal mendapatkan info level');
      }

      final startIdx = getLevelIndex(startLevel);
      final endIdx = getLevelIndex(endLevel);

      if (startIdx == -1 || endIdx == -1) {
        throw Exception('Gagal mendapatkan index level');
      }

      if (startIdx >= endIdx) {
        throw Exception('Level awal harus lebih rendah dari level akhir');
      }

      // Hitung harga per cracked jewel
      final basePricePerCracked = startPrice / startInfo['totalCracked'];

      // Hitung total biaya produksi
      double totalCost = 0;
      final levels = getJewelLevels();
      
      // Hitung biaya untuk setiap level dari start hingga end-1
      for (int i = startIdx; i < endIdx; i++) {
        final currentLevel = levels[i];
        final nextLevel = levels[i + 1];
        
        // Hitung berapa banyak current level yang dibutuhkan untuk 1 next level
        final needed = nextLevel.totalCracked / currentLevel.totalCracked;
        
        // Hitung biaya combine untuk next level
        final combineCost = calculateCombineCost(nextLevel) - 
                           (i > 0 ? calculateCombineCost(levels[i]) : 0);
        
        totalCost += (basePricePerCracked * nextLevel.totalCracked) + combineCost;
      }

      // Hitung harga jual estimasi
      final estimatedSellPrice = calculateSellPrice(basePricePerCracked, end);
      
      // Hitung keuntungan
      final profit = (targetPrice ?? estimatedSellPrice) - totalCost;
      final profitPercentage = (profit / totalCost) * 100;

      return {
        'startLevel': startLevel,
        'endLevel': endLevel,
        'basePricePerCracked': basePricePerCracked,
        'totalCost': totalCost,
        'estimatedSellPrice': estimatedSellPrice,
        'targetPrice': targetPrice,
        'profit': profit,
        'profitPercentage': profitPercentage,
        'isProfitable': profit > 0,
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Map<String, dynamic> calculateElixirBreakEven({
    required double elixirPrice,
    required double crackedPrice,
    int elixirDurationMinutes = 30,
    int crackedPerMinute = 1,
  }) {
    // Hitung berapa Cracked Jewel yang bisa didapat selama elixir aktif
    final totalCrackedDuringElixir = crackedPerMinute * elixirDurationMinutes;

    // Hitung total nilai Cracked Jewel yang didapat
    final totalValue = totalCrackedDuringElixir * crackedPrice;

    // Hitung berapa Cracked Jewel yang harus didapat untuk break even
    final breakEvenCracked = (elixirPrice / crackedPrice).ceil();
    final breakEvenTime = (breakEvenCracked / crackedPerMinute).ceil();

    // Hitung efisiensi (persentase waktu yang digunakan untuk profit)
    final efficiency = breakEvenTime < elixirDurationMinutes
        ? ((elixirDurationMinutes - breakEvenTime) / elixirDurationMinutes) * 100
        : 0;

    return {
      'elixirPrice': elixirPrice,
      'crackedPrice': crackedPrice,
      'elixirDurationMinutes': elixirDurationMinutes,
      'crackedPerMinute': crackedPerMinute,
      'totalCrackedDuringElixir': totalCrackedDuringElixir,
      'totalValue': totalValue,
      'breakEvenCracked': breakEvenCracked,
      'breakEvenTime': breakEvenTime,
      'efficiency': efficiency,
      'isProfitable': totalValue > elixirPrice,
      'profit': totalValue - elixirPrice,
    };
  }
}
