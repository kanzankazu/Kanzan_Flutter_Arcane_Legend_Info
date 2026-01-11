import 'package:flutter/material.dart';
import '../domain/entities/jewel_level.dart';

class JewelStatisticsScreen extends StatelessWidget {
  const JewelStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = JewelLevel.getJewelLevels();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabel Statistik Jewel'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 16.0,
                  headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.surface),
                  columns: const [
                    DataColumn(label: Text('Level', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Butuh', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Total Cracked', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Waktu', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Total Waktu', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Multiplier', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: levels.map((level) {
                    return DataRow(cells: [
                      DataCell(Text(level.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB8860B)))),
                      DataCell(Text(level.requiredPrevious > 0 ? '${level.requiredPrevious}' : '-')),
                      DataCell(Text(level.totalCracked.toString().replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]}.',
                          ))),
                      DataCell(Text('${level.combineTimeMinutes}m')),
                      DataCell(Text(JewelLevel.formatTime(level.totalTimeMinutes))),
                      DataCell(Text('${level.basePriceMultiplier}x')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
