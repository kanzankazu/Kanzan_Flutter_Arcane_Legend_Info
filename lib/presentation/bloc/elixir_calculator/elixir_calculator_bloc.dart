import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:arcane_legend_calculator/domain/repositories/jewel_repository.dart';
import 'package:injectable/injectable.dart';

part 'elixir_calculator_event.dart';
part 'elixir_calculator_state.dart';

@injectable
class ElixirCalculatorBloc
    extends Bloc<ElixirCalculatorEvent, ElixirCalculatorState> {
  final JewelRepository _jewelRepository;

  ElixirCalculatorBloc(this._jewelRepository)
      : super(const ElixirCalculatorState()) {
    on<CalculateElixirBreakEven>(_onCalculateElixirBreakEven);
    on<UpdateElixirPrice>(_onUpdateElixirPrice);
    on<UpdateCrackedPrice>(_onUpdateCrackedPrice);
    on<UpdateElixirDuration>(_onUpdateElixirDuration);
    on<UpdateCrackedPerMinute>(_onUpdateCrackedPerMinute);
    on<ResetElixirCalculator>(_onResetCalculator);
  }

  Future<void> _onCalculateElixirBreakEven(
    CalculateElixirBreakEven event,
    Emitter<ElixirCalculatorState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: ElixirCalculatorStatus.loading));

    try {
      final result = _jewelRepository.calculateElixirBreakEven(
        elixirPrice: event.elixirPrice,
        crackedPrice: event.crackedPrice,
        elixirDurationMinutes: event.elixirDurationMinutes,
        crackedPerMinute: event.crackedPerMinute,
      );

      emit(
        state.copyWith(
          status: ElixirCalculatorStatus.success,
          result: result,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ElixirCalculatorStatus.failure,
          errorMessage: 'Gagal menghitung break even: $e',
        ),
      );
    }
  }

  void _onUpdateElixirPrice(
    UpdateElixirPrice event,
    Emitter<ElixirCalculatorState> emit,
  ) {
    emit(state.copyWith(elixirPrice: event.price));
  }

  void _onUpdateCrackedPrice(
    UpdateCrackedPrice event,
    Emitter<ElixirCalculatorState> emit,
  ) {
    emit(state.copyWith(crackedPrice: event.price));
  }

  void _onUpdateElixirDuration(
    UpdateElixirDuration event,
    Emitter<ElixirCalculatorState> emit,
  ) {
    emit(state.copyWith(elixirDuration: event.duration));
  }

  void _onUpdateCrackedPerMinute(
    UpdateCrackedPerMinute event,
    Emitter<ElixirCalculatorState> emit,
  ) {
    emit(state.copyWith(crackedPerMinute: event.value));
  }

  void _onResetCalculator(
    ResetElixirCalculator event,
    Emitter<ElixirCalculatorState> emit,
  ) {
    emit(const ElixirCalculatorState());
  }
}
