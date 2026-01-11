import 'package:arcane_legend_calculator/domain/entities/jewel_level.dart';

abstract class JewelRepository {
  /// Get all jewel levels
  List<JewelLevel> getJewelLevels();

  /// Get jewel level by name
  JewelLevel? getJewelLevelByName(String name);

  /// Calculate combine cost for a jewel level
  int calculateCombineCost(JewelLevel level);

  /// Calculate sell price for a jewel level based on base price
  int calculateSellPrice(double basePrice, JewelLevel level);

  /// Get jewel info by name
  Map<String, dynamic>? getJewelInfo(String levelName, {double? basePrice});

  /// Get level index by name
  int getLevelIndex(String levelName);

  /// Calculate price conversion between two jewel levels
  Map<String, dynamic> calculatePriceConversion({
    required String startLevel,
    required double startPrice,
    required String endLevel,
    double? targetPrice,
  });

  /// Calculate break even for Jewel Elixir
  Map<String, dynamic> calculateElixirBreakEven({
    required double elixirPrice,
    required double crackedPrice,
    int elixirDurationMinutes = 30,
    int crackedPerMinute = 1,
  });
}
