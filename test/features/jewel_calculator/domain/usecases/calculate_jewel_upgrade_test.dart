import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/domain/entities/jewel_level.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/domain/repositories/jewel_repository.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/domain/usecases/calculate_jewel_upgrade.dart';

class MockJewelRepository extends Mock implements JewelRepository {}

void main() {
  late CalculateJewelUpgrade usecase;
  late MockJewelRepository mockJewelRepository;

  setUp(() {
    mockJewelRepository = MockJewelRepository();
    usecase = CalculateJewelUpgrade(mockJewelRepository);
  });

  const tCracked = JewelLevel(
    name: 'Cracked',
    requiredPrevious: 0,
    totalCracked: 1,
    combineTimeMinutes: 0,
    totalTimeMinutes: 0,
    basePriceMultiplier: 1.0,
    combineCostMultiplier: 1.0,
    combineCostGold: 0,
  );

  const tDamaged = JewelLevel(
    name: 'Damaged',
    requiredPrevious: 3,
    totalCracked: 3,
    combineTimeMinutes: 30,
    totalTimeMinutes: 30,
    basePriceMultiplier: 1.5,
    combineCostMultiplier: 1.1,
    combineCostGold: 50,
  );
  
  const tWeak = JewelLevel(
    name: 'Weak',
    requiredPrevious: 3,
    totalCracked: 9,
    combineTimeMinutes: 60,
    totalTimeMinutes: 90,
    basePriceMultiplier: 2.0,
    combineCostMultiplier: 1.2,
    combineCostGold: 100,
  );

  final tLevels = [tCracked, tDamaged, tWeak];

  test('should calculate cost correctly from Damaged to Weak', () async {
    when(() => mockJewelRepository.getJewelLevels()).thenAnswer((_) async => tLevels);

    final result = await usecase(
      startLevel: tDamaged,
      targetLevel: tWeak,
      pricePerStartJewel: 1000,
    );

    expect(result.totalJewelsNeeded, 3.0);
    expect(result.totalCostGold, 100);
    expect(result.totalTimeMinutes, 60);
  });
}
