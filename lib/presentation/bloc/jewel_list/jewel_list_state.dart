import 'package:arcane_legend_calculator/domain/entities/jewel_level.dart';
import 'package:equatable/equatable.dart';

enum JewelListStatus { initial, loading, success, failure }

class JewelListState extends Equatable {
  final JewelListStatus status;
  final List<JewelLevel> levels;
  final List<JewelLevel> filteredLevels;
  final String searchQuery;
  final String? errorMessage;

  const JewelListState({
    this.status = JewelListStatus.initial,
    this.levels = const [],
    this.filteredLevels = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  JewelListState copyWith({
    JewelListStatus? status,
    List<JewelLevel>? levels,
    List<JewelLevel>? filteredLevels,
    String? searchQuery,
    String? errorMessage,
  }) {
    return JewelListState(
      status: status ?? this.status,
      levels: levels ?? this.levels,
      filteredLevels: filteredLevels ?? this.filteredLevels,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        levels,
        filteredLevels,
        searchQuery,
        errorMessage,
      ];
}
