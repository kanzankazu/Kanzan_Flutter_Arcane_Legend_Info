import 'package:equatable/equatable.dart';

enum ElixirCalculatorStatus { initial, loading, success, failure }

class ElixirCalculatorState extends Equatable {
  final ElixirCalculatorStatus status;
  final String? errorMessage;
  final String elixirPrice;
  final String crackedPrice;
  final String elixirDuration;
  final String crackedPerMinute;
  final Map<String, dynamic>? result;

  const ElixirCalculatorState({
    this.status = ElixirCalculatorStatus.initial,
    this.errorMessage,
    this.elixirPrice = '',
    this.crackedPrice = '',
    this.elixirDuration = '30',
    this.crackedPerMinute = '1',
    this.result,
  });

  bool get isFormValid =>
      elixirPrice.isNotEmpty &&
      double.tryParse(elixirPrice) != null &&
      double.tryParse(elixirPrice)! > 0 &&
      crackedPrice.isNotEmpty &&
      double.tryParse(crackedPrice) != null &&
      double.tryParse(crackedPrice)! > 0 &&
      elixirDuration.isNotEmpty &&
      int.tryParse(elixirDuration) != null &&
      int.tryParse(elixirDuration)! > 0 &&
      crackedPerMinute.isNotEmpty &&
      int.tryParse(crackedPerMinute) != null &&
      int.tryParse(crackedPerMinute)! > 0;

  double? get parsedElixirPrice => double.tryParse(elixirPrice);
  double? get parsedCrackedPrice => double.tryParse(crackedPrice);
  int? get parsedElixirDuration => int.tryParse(elixirDuration);
  int? get parsedCrackedPerMinute => int.tryParse(crackedPerMinute);

  ElixirCalculatorState copyWith({
    ElixirCalculatorStatus? status,
    String? errorMessage,
    String? elixirPrice,
    String? crackedPrice,
    String? elixirDuration,
    String? crackedPerMinute,
    Map<String, dynamic>? result,
  }) {
    return ElixirCalculatorState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      elixirPrice: elixirPrice ?? this.elixirPrice,
      crackedPrice: crackedPrice ?? this.crackedPrice,
      elixirDuration: elixirDuration ?? this.elixirDuration,
      crackedPerMinute: crackedPerMinute ?? this.crackedPerMinute,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        elixirPrice,
        crackedPrice,
        elixirDuration,
        crackedPerMinute,
        result,
      ];
}
