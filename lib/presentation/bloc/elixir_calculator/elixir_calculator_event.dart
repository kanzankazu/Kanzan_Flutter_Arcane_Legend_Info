import 'package:equatable/equatable.dart';

abstract class ElixirCalculatorEvent extends Equatable {
  const ElixirCalculatorEvent();

  @override
  List<Object> get props => [];
}

class CalculateElixirBreakEven extends ElixirCalculatorEvent {
  final double elixirPrice;
  final double crackedPrice;
  final int elixirDurationMinutes;
  final int crackedPerMinute;

  const CalculateElixirBreakEven({
    required this.elixirPrice,
    required this.crackedPrice,
    this.elixirDurationMinutes = 30,
    this.crackedPerMinute = 1,
  });

  @override
  List<Object> get props => [
        elixirPrice,
        crackedPrice,
        elixirDurationMinutes,
        crackedPerMinute,
      ];
}

class UpdateElixirPrice extends ElixirCalculatorEvent {
  final String price;

  const UpdateElixirPrice(this.price);

  @override
  List<Object> get props => [price];
}

class UpdateCrackedPrice extends ElixirCalculatorEvent {
  final String price;

  const UpdateCrackedPrice(this.price);

  @override
  List<Object> get props => [price];
}

class UpdateElixirDuration extends ElixirCalculatorEvent {
  final String duration;

  const UpdateElixirDuration(this.duration);

  @override
  List<Object> get props => [duration];
}

class UpdateCrackedPerMinute extends ElixirCalculatorEvent {
  final String value;

  const UpdateCrackedPerMinute(this.value);

  @override
  List<Object> get props => [value];
}

class ResetElixirCalculator extends ElixirCalculatorEvent {
  const ResetElixirCalculator();
}
