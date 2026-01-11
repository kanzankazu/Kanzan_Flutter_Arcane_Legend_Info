import 'package:arcane_legend_calculator/domain/entities/jewel_level.dart';
import 'package:equatable/equatable.dart';

enum JewelCalculatorStatus { initial, loading, success, failure }

class JewelCalculatorState extends Equatable {
  final JewelCalculatorStatus status;
  final String? errorMessage;
  final String startLevel;
  final String endLevel;
  final String startPrice;
  final String targetPrice;
  final Map<String, dynamic>? result;
  final List<JewelLevel> jewelLevels;

  const JewelCalculatorState({
    this.status = JewelCalculatorStatus.initial,
    this.errorMessage,
    this.startLevel = 'Cracked',
    this.endLevel = 'Damaged',
    this.startPrice = '',
    this.targetPrice = '',
    this.result,
    this.jewelLevels = const [],
  });

  bool get isFormValid => startLevel.isNotEmpty && 
                         endLevel.isNotEmpty && 
                         startPrice.isNotEmpty &&
                         double.tryParse(startPrice) != null &&
                         (targetPrice.isEmpty || double.tryParse(targetPrice) != null);

  double? get parsedStartPrice => double.tryParse(startPrice);
  double? get parsedTargetPrice => targetPrice.isNotEmpty ? double.tryParse(targetPrice) : null;

  JewelCalculatorState copyWith({
    JewelCalculatorStatus? status,
    String? errorMessage,
    String? startLevel,
    String? endLevel,
    String? startPrice,
    String? targetPrice,
    Map<String, dynamic>? result,
    List<JewelLevel>? jewelLevels,
  }) {
    return JewelCalculatorState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      startLevel: startLevel ?? this.startLevel,
      endLevel: endLevel ?? this.endLevel,
      startPrice: startPrice ?? this.startPrice,
      targetPrice: targetPrice ?? this.targetPrice,
      result: result ?? this.result,
      jewelLevels: jewelLevels ?? this.jewelLevels,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        startLevel,
        endLevel,
        startPrice,
        targetPrice,
        result,
        jewelLevels,
      ];
}
