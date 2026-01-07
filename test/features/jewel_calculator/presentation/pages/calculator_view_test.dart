import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/domain/entities/jewel_level.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/presentation/bloc/jewel_calculator_bloc.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/presentation/bloc/jewel_calculator_event.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/presentation/bloc/jewel_calculator_state.dart';
import 'package:arcane_legend_calculator/features/jewel_calculator/presentation/pages/calculator_view.dart';

class MockJewelCalculatorBloc extends MockBloc<JewelCalculatorEvent, JewelCalculatorState>
    implements JewelCalculatorBloc {}

void main() {
  late MockJewelCalculatorBloc mockBloc;

  setUp(() {
    mockBloc = MockJewelCalculatorBloc();
  });

  const tLevel = JewelLevel(
    name: 'Cracked',
    requiredPrevious: 0,
    totalCracked: 1,
    combineTimeMinutes: 0,
    totalTimeMinutes: 0,
    basePriceMultiplier: 1.0,
    combineCostMultiplier: 1.0,
    combineCostGold: 0,
  );

  testWidgets('CalculatorView shows input fields', (tester) async {
    when(() => mockBloc.state).thenReturn(const JewelLevelsLoaded([tLevel]));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<JewelCalculatorBloc>.value(
            value: mockBloc,
            child: const CalculatorView(),
          ),
        ),
      ),
    );

    expect(find.text('Start Level'), findsOneWidget);
    expect(find.text('Target Level'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Calculate'), findsOneWidget);
  });
}
