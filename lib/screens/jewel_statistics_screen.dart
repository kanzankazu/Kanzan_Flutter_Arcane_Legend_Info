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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Level')),
              DataColumn(label: Text('Butuh (Prev)')),
              DataColumn(label: Text('Total Cracked')),
              DataColumn(label: Text('Waktu (Min)')),
              DataColumn(label: Text('Total Waktu')),
              DataColumn(label: Text('Multiplier')),
            ],
            rows: levels.map((level) {
              return DataRow(cells: [
                DataCell(Text(level.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(level.requiredPrevious > 0 ? '${level.requiredPrevious}' : '-')),
                DataCell(Text(level.totalCracked.toString().replaceAllMapped(
                      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                      (Match m) => '${m[1]}.',
                    ))),
                DataCell(Text('${level.combineTimeMinutes}')),
                DataCell(Text(JewelLevel.formatTime(level.totalTimeMinutes))),
                DataCell(Text('${level.basePriceMultiplier}x')),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
