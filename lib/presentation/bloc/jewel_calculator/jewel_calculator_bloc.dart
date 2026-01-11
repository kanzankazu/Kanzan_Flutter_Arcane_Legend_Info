import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:arcane_legend_calculator/domain/entities/jewel_level.dart';
import 'package:arcane_legend_calculator/domain/repositories/jewel_repository.dart';
import 'package:injectable/injectable.dart';

part 'jewel_calculator_event.dart';
part 'jewel_calculator_state.dart';

@injectable
class JewelCalculatorBloc
    extends Bloc<JewelCalculatorEvent, JewelCalculatorState> {
  final JewelRepository _jewelRepository;

  JewelCalculatorBloc(this._jewelRepository)
      : super(const JewelCalculatorState()) {
    on<CalculatePriceConversion>(_onCalculatePriceConversion);
    on<ResetCalculator>(_onResetCalculator);
    on<UpdateStartLevel>(_onUpdateStartLevel);
    on<UpdateEndLevel>(_onUpdateEndLevel);
    on<UpdateStartPrice>(_onUpdateStartPrice);
    on<UpdateTargetPrice>(_onUpdateTargetPrice);

    // Load initial jewel levels
    _loadJewelLevels();
  }

  Future<void> _loadJewelLevels() async {
    try {
      final levels = _jewelRepository.getJewelLevels();
      emit(state.copyWith(
        jewelLevels: levels,
        startLevel: levels.first.name,
        endLevel: levels.length > 1 ? levels[1].name : '',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: JewelCalculatorStatus.failure,
        errorMessage: 'Gagal memuat daftar level jewel',
      ));
    }
  }

  Future<void> _onCalculatePriceConversion(
    CalculatePriceConversion event,
    Emitter<JewelCalculatorState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: JewelCalculatorStatus.loading));

    try {
      final result = _jewelRepository.calculatePriceConversion(
        startLevel: event.startLevel,
        startPrice: event.startPrice,
        endLevel: event.endLevel,
        targetPrice: event.targetPrice,
      );

      emit(
        state.copyWith(
          status: JewelCalculatorStatus.success,
          result: result,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: JewelCalculatorStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetCalculator(
    ResetCalculator event,
    Emitter<JewelCalculatorState> emit,
  ) {
    emit(const JewelCalculatorState(
      status: JewelCalculatorStatus.initial,
      startLevel: 'Cracked',
      endLevel: 'Damaged',
      startPrice: '',
      targetPrice: '',
      jewelLevels: [],
    ));
    
    // Reload jewel levels
    _loadJewelLevels();
  }

  void _onUpdateStartLevel(
    UpdateStartLevel event,
    Emitter<JewelCalculatorState> emit,
  ) {
    emit(state.copyWith(startLevel: event.level));
  }

  void _onUpdateEndLevel(
    UpdateEndLevel event,
    Emitter<JewelCalculatorState> emit,
  ) {
    emit(state.copyWith(endLevel: event.level));
  }

  void _onUpdateStartPrice(
    UpdateStartPrice event,
    Emitter<JewelCalculatorState> emit,
  ) {
    emit(state.copyWith(startPrice: event.price));
  }

  void _onUpdateTargetPrice(
    UpdateTargetPrice event,
    Emitter<JewelCalculatorState> emit,
  ) {
    emit(state.copyWith(targetPrice: event.price));
  }
}
