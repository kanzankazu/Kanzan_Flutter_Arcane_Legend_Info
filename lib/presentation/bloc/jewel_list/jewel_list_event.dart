import 'package:equatable/equatable.dart';

abstract class JewelListEvent extends Equatable {
  const JewelListEvent();

  @override
  List<Object> get props => [];
}

class LoadJewelLevels extends JewelListEvent {
  const LoadJewelLevels();
}

class SearchJewelLevels extends JewelListEvent {
  final String query;

  const SearchJewelLevels(this.query);

  @override
  List<Object> get props => [query];
}
