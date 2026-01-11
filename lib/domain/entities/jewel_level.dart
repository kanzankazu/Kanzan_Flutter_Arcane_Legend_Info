import 'package:equatable/equatable.dart';

class JewelLevel extends Equatable {
  final String name;
  final int requiredPrevious;
  final int totalCracked;
  final int combineTimeMinutes;
  final int totalTimeMinutes;
  final double basePriceMultiplier;
  final double combineCostMultiplier;
  final int combineCostGold;

  const JewelLevel({
    required this.name,
    required this.requiredPrevious,
    required this.totalCracked,
    required this.combineTimeMinutes,
    required this.totalTimeMinutes,
    this.basePriceMultiplier = 1.0,
    this.combineCostMultiplier = 1.0,
    this.combineCostGold = 0,
  });

  @override
  List<Object> get props => [
        name,
        requiredPrevious,
        totalCracked,
        combineTimeMinutes,
        totalTimeMinutes,
        basePriceMultiplier,
        combineCostMultiplier,
        combineCostGold,
      ];

  /// Factory method to create a list of all jewel levels
  static List<JewelLevel> getJewelLevels() {
    return [
      const JewelLevel(
        name: 'Cracked',
        requiredPrevious: 0,
        totalCracked: 1,
        combineTimeMinutes: 0,
        totalTimeMinutes: 0,
        basePriceMultiplier: 1.0,
        combineCostMultiplier: 1.0,
        combineCostGold: 0,
      ),
      const JewelLevel(
        name: 'Damaged',
        requiredPrevious: 3,
        totalCracked: 3,
        combineTimeMinutes: 30,
        totalTimeMinutes: 30,
        basePriceMultiplier: 1.5,
        combineCostMultiplier: 1.1,
        combineCostGold: 50,
      ),
      const JewelLevel(
        name: 'Weak',
        requiredPrevious: 3,
        totalCracked: 9,
        combineTimeMinutes: 60,
        totalTimeMinutes: 90,
        basePriceMultiplier: 2.0,
        combineCostMultiplier: 1.2,
        combineCostGold: 100,
      ),
      const JewelLevel(
        name: 'Standard',
        requiredPrevious: 3,
        totalCracked: 27,
        combineTimeMinutes: 120,
        totalTimeMinutes: 210,
        basePriceMultiplier: 3.0,
        combineCostMultiplier: 1.3,
        combineCostGold: 200,
      ),
      const JewelLevel(
        name: 'Fortified',
        requiredPrevious: 3,
        totalCracked: 81,
        combineTimeMinutes: 240,
        totalTimeMinutes: 450,
        basePriceMultiplier: 4.5,
        combineCostMultiplier: 1.4,
        combineCostGold: 500,
      ),
      const JewelLevel(
        name: 'Excellent',
        requiredPrevious: 3,
        totalCracked: 243,
        combineTimeMinutes: 360,
        totalTimeMinutes: 810,
        basePriceMultiplier: 6.5,
        combineCostMultiplier: 1.5,
        combineCostGold: 1000,
      ),
      const JewelLevel(
        name: 'Superb',
        requiredPrevious: 3,
        totalCracked: 729,
        combineTimeMinutes: 720,
        totalTimeMinutes: 1530,
        basePriceMultiplier: 9.5,
        combineCostMultiplier: 1.6,
        combineCostGold: 2000,
      ),
      const JewelLevel(
        name: 'Noble',
        requiredPrevious: 3,
        totalCracked: 2187,
        combineTimeMinutes: 960,
        totalTimeMinutes: 2490,
        basePriceMultiplier: 14.0,
        combineCostMultiplier: 1.7,
        combineCostGold: 5000,
      ),
      const JewelLevel(
        name: 'Exquisite',
        requiredPrevious: 3,
        totalCracked: 6561,
        combineTimeMinutes: 1200,
        totalTimeMinutes: 3690,
        basePriceMultiplier: 20.0,
        combineCostMultiplier: 1.8,
        combineCostGold: 10000,
      ),
      const JewelLevel(
        name: 'Precise',
        requiredPrevious: 3,
        totalCracked: 19683,
        combineTimeMinutes: 1440,
        totalTimeMinutes: 5130,
        basePriceMultiplier: 28.0,
        combineCostMultiplier: 1.9,
        combineCostGold: 20000,
      ),
      const JewelLevel(
        name: 'Flawless',
        requiredPrevious: 3,
        totalCracked: 59049,
        combineTimeMinutes: 1440,
        totalTimeMinutes: 6570,
        basePriceMultiplier: 40.0,
        combineCostMultiplier: 2.0,
        combineCostGold: 50000,
      ),
    ];
  }

  /// Get jewel level by name
  static JewelLevel? getLevelByName(String name) {
    return getJewelLevels().firstWhere(
      (level) => level.name.toLowerCase() == name.toLowerCase(),
      orElse: () => throw Exception('Jewel level not found'),
    );
  }

  /// Get index of the jewel level
  static int getLevelIndex(String name) {
    final levels = getJewelLevels();
    return levels.indexWhere(
      (level) => level.name.toLowerCase() == name.toLowerCase(),
    );
  }

  /// Format time in minutes to a readable string
  static String formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (hours > 0 && mins > 0) {
      return '$hours jam $mins menit';
    } else if (hours > 0) {
      return '$hours jam';
    } else {
      return '$mins menit';
    }
  }

  /// Format currency to a readable string
  static String formatCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )} gold';
  }
}
