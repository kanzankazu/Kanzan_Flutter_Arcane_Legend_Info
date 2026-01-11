import '../domain/entities/jewel_level.dart';

class JewelCalculations {
  // Calculate total combine cost to reach a specific level
  static int calculateCombineCost(JewelLevel targetLevel) {
    if (targetLevel.name == 'Cracked') {
      return 0;
    }

    final levels = JewelLevel.getJewelLevels();
    final levelMap = {for (var level in levels) level.name: level};

    // Base cases
    if (targetLevel.name == 'Damaged') {
      return targetLevel.combineCostGold; // 50
    } else if (targetLevel.name == 'Weak') {
      // 3x Damaged combine + 1x Weak combine
      return (3 * levelMap['Damaged']!.combineCostGold) +
          targetLevel.combineCostGold; // 3*50 + 100 = 250
    } else if (targetLevel.name == 'Standard') {
      // 3x Weak combine + 1x Standard combine
      final weakCombine = calculateCombineCost(levelMap['Weak']!);
      return (3 * weakCombine) + targetLevel.combineCostGold; // 3*250 + 200 = 950
    }

    // Recursive calculation for higher levels
    final levelIndex = levels.indexWhere((level) => level.name == targetLevel.name);
    if (levelIndex > 0) {
      final prevLevel = levels[levelIndex - 1];
      return (3 * calculateCombineCost(prevLevel)) + targetLevel.combineCostGold;
    }

    return 0; // Fallback
  }

  // Calculate sell price for a jewel level
  static int calculateSellPrice(double basePrice, JewelLevel level) {
    return (basePrice * level.totalCracked * level.basePriceMultiplier).round();
  }

  // Get jewel information including calculations
  static Map<String, dynamic> getJewelInfo(String levelName, {double? basePrice}) {
    try {
      final level = JewelLevel.getLevelByName(levelName)!;
      final result = {
        'level': level.name,
        'totalCracked': level.totalCracked,
        'combineTime': JewelLevel.formatTime(level.combineTimeMinutes),
        'totalTime': JewelLevel.formatTime(level.totalTimeMinutes),
      };

      if (basePrice != null && basePrice > 0) {
        result.addAll({
          'sellPrice': calculateSellPrice(basePrice, level),
          'combineCost': calculateCombineCost(level),
          'basePrice': basePrice,
        });
      }

      return result;
    } catch (e) {
      return {};
    }
  }

  // Get level index for comparison
  static int getLevelIndex(String levelName) {
    final levels = JewelLevel.getJewelLevels();
    final levelNames = levels.map((level) => level.name.toLowerCase()).toList();
    return levelNames.indexOf(levelName.toLowerCase());
  }

  // Calculate Elixir break-even point
  static Map<String, dynamic> calculateElixirBreakEven({
    required double elixirPrice,
    required double crackedPrice,
    int durationMinutes = 30,
    int crackedPerMinute = 1,
  }) {
    final totalCrackedDuringElixir = crackedPerMinute * durationMinutes;
    final totalValue = totalCrackedDuringElixir * crackedPrice;
    final breakEvenQuantity = crackedPrice > 0 ? (elixirPrice / crackedPrice).ceil() : 0;
    final breakEvenMinutes = crackedPerMinute > 0 ? breakEvenQuantity / crackedPerMinute : 0.0;
    
    final profit = totalValue - elixirPrice;
    final isEfficient = breakEvenMinutes <= durationMinutes;

    return {
      'elixirPrice': elixirPrice,
      'crackedPrice': crackedPrice,
      'durationMinutes': durationMinutes,
      'totalCracked': totalCrackedDuringElixir,
      'totalValue': totalValue,
      'breakEvenQuantity': breakEvenQuantity,
      'breakEvenMinutes': breakEvenMinutes,
      'profit': profit,
      'isEfficient': isEfficient,
      'extraProfit': isEfficient ? (durationMinutes - breakEvenMinutes) * crackedPerMinute * crackedPrice : 0.0,
      'formattedElixirPrice': JewelLevel.formatCurrency(elixirPrice.round()),
      'formattedCrackedPrice': JewelLevel.formatCurrency(crackedPrice.round()),
      'formattedProfit': JewelLevel.formatCurrency(profit.round().abs()) + (profit >= 0 ? '' : ' (Rugi)'),
    };
  }

  // Calculate detailed price range from one level to another
  static Map<String, dynamic> calculatePriceRange(
    String startLevelName,
    String endLevelName,
    double basePrice, {
    double? marketPrice,
  }) {
    try {
      // Validate that levels are different
      if (startLevelName.toLowerCase() == endLevelName.toLowerCase()) {
        return {'error': 'Level awal dan level akhir tidak boleh sama'};
      }

      final startLevel = JewelLevel.getLevelByName(startLevelName)!;
      final endLevel = JewelLevel.getLevelByName(endLevelName)!;

      // Base production cost analysis
      final startSellPrice = calculateSellPrice(basePrice, startLevel);
      final endSellPrice = calculateSellPrice(basePrice, endLevel);
      
      // Material cost for the end level based on start level price
      final materialCost = (endLevel.totalCracked / startLevel.totalCracked) * startSellPrice;
      final totalCombineCost = calculateCombineCost(endLevel) - ( (endLevel.totalCracked / startLevel.totalCracked) * calculateCombineCost(startLevel));
      final totalProductionCost = materialCost + totalCombineCost;

      // Estimated market price if no market price is provided
      final estimatedPrice = (basePrice * endLevel.totalCracked * endLevel.basePriceMultiplier);
      final activePrice = marketPrice ?? estimatedPrice;

      final profit = activePrice - totalProductionCost;
      final profitPercentage = (profit / totalProductionCost) * 100;

      // Feasibility analysis
      String suggestion = "";
      if (profit > 0) {
        if (profitPercentage > 30) {
          suggestion = "💎 Profit tinggi, sangat kompetitif!";
        } else if (profitPercentage > 10) {
          suggestion = "💰 Profit cukup baik.";
        } else {
          suggestion = "🆗 Profit tipis, pertimbangkan harga.";
        }
      } else {
        suggestion = "❌ Tidak menguntungkan! Rugi ${JewelLevel.formatCurrency(profit.abs().round())}";
      }

      return {
        'startLevel': startLevel.name,
        'endLevel': endLevel.name,
        'materialCost': materialCost,
        'combineCost': totalCombineCost,
        'totalProductionCost': totalProductionCost,
        'estimatedPrice': estimatedPrice,
        'marketPrice': marketPrice,
        'profit': profit,
        'profitPercentage': profitPercentage.toStringAsFixed(1),
        'suggestion': suggestion,
        'minPriceFor10Percent': totalProductionCost * 1.1,
        'formattedStartPrice': JewelLevel.formatCurrency(startSellPrice),
        'formattedEndPrice': JewelLevel.formatCurrency(activePrice.round()),
        'formattedProfit': JewelLevel.formatCurrency(profit.round()),
        'formattedMinPrice': JewelLevel.formatCurrency((totalProductionCost * 1.1).round()),
      };
    } catch (e) {
      return {'error': 'Terjadi kesalahan dalam perhitungan'};
    }
  }
}
