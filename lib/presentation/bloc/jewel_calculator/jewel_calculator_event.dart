import 'package:equatable/equatable.dart';

abstract class JewelCalculatorEvent extends Equatable {
  const JewelCalculatorEvent();

  @override
  List<Object> get props => [];
}

class CalculatePriceConversion extends JewelCalculatorEvent {
  final String startLevel;
  final double startPrice;
  final String endLevel;
  final double? targetPrice;

  const CalculatePriceConversion({
    required this.startLevel,
    required this.startPrice,
    required this.endLevel,
    this.targetPrice,
  });

  @override
  List<Object> get props => [startLevel, startPrice, endLevel];
}

class ResetCalculator extends JewelCalculatorEvent {
  const ResetCalculator();
}

class UpdateStartLevel extends JewelCalculatorEvent {
  final String level;

  const UpdateStartLevel(this.level);

  @override
  List<Object> get props => [level];
}

class UpdateEndLevel extends JewelCalculatorEvent {
  final String level;

  const UpdateEndLevel(this.level);

  @override
  List<Object> get props => [level];
}

class UpdateStartPrice extends JewelCalculatorEvent {
  final String price;

  const UpdateStartPrice(this.price);

  @override
  List<Object> get props => [price];
}

class UpdateTargetPrice extends JewelCalculatorEvent {
  final String price;

  const UpdateTargetPrice(this.price);

  @override
  List<Object> get props => [price];
}
