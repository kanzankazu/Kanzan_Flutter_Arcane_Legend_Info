import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:arcane_legend_calculator/domain/entities/jewel_level.dart';
import 'package:arcane_legend_calculator/domain/repositories/jewel_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'jewel_list_event.dart';
part 'jewel_list_state.dart';

@injectable
class JewelListBloc extends Bloc<JewelListEvent, JewelListState> {
  final JewelRepository _jewelRepository;

  JewelListBloc(this._jewelRepository) : super(const JewelListState()) {
    on<LoadJewelLevels>(_onLoadJewelLevels);
    on<SearchJewelLevels>(_onSearchJewelLevels);
  }

  Future<void> _onLoadJewelLevels(
    LoadJewelLevels event,
    Emitter<JewelListState> emit,
  ) async {
    emit(state.copyWith(status: JewelListStatus.loading));

    try {
      final levels = _jewelRepository.getJewelLevels();
      
      emit(
        state.copyWith(
          status: JewelListStatus.success,
          levels: levels,
          filteredLevels: _filterLevels(levels, state.searchQuery),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: JewelListStatus.failure,
          errorMessage: 'Gagal memuat daftar level jewel: $e',
        ),
      );
    }
  }

  Future<void> _onSearchJewelLevels(
    SearchJewelLevels event,
    Emitter<JewelListState> emit,
  ) async {
    final filteredLevels = _filterLevels(state.levels, event.query);
    
    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredLevels: filteredLevels,
      ),
    );
  }

  List<JewelLevel> _filterLevels(List<JewelLevel> levels, String query) {
    if (query.isEmpty) return levels;
    
    return levels
        .where(
          (level) =>
              level.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
