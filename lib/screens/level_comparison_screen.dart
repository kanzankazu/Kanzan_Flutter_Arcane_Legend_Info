import 'package:flutter/material.dart';
import '../domain/entities/jewel_level.dart';
import '../utils/calculations.dart';

class LevelComparisonScreen extends StatefulWidget {
  final String initialLevel;
  final double basePrice;

  const LevelComparisonScreen({
    super.key,
    required this.initialLevel,
    required this.basePrice,
  });

  @override
  State<LevelComparisonScreen> createState() => _LevelComparisonScreenState();
}

class _LevelComparisonScreenState extends State<LevelComparisonScreen> {
  late String _startLevel;
  late String _endLevel;
  Map<String, dynamic> _comparisonResult = {};
  final TextEditingController _marketPriceController = TextEditingController();

  @override
  void dispose() {
    _marketPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startLevel = widget.initialLevel;
    _endLevel = JewelLevel.getJewelLevels()
        .firstWhere(
          (level) => level.name != _startLevel,
          orElse: () => JewelLevel.getJewelLevels().first,
        )
        .name;
    _marketPriceController.addListener(_calculateComparison);
    _calculateComparison();
  }

  void _calculateComparison() {
    final marketPrice = double.tryParse(_marketPriceController.text);
    setState(() {
      _comparisonResult = JewelCalculations.calculatePriceRange(
        _startLevel,
        _endLevel,
        widget.basePrice,
        marketPrice: marketPrice,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final levels = JewelLevel.getJewelLevels();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bandingkan Level'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Bandingkan Harga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _startLevel,
                            decoration: const InputDecoration(
                              labelText: 'Dari Level',
                              border: OutlineInputBorder(),
                            ),
                            items: levels
                                .map((level) => DropdownMenuItem(
                                      value: level.name,
                                      child: Text(level.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _startLevel = value;
                                  if (_endLevel == value) {
                                    _endLevel = levels
                                        .firstWhere(
                                          (level) => level.name != value,
                                          orElse: () => levels.first,
                                        )
                                        .name;
                                  }
                                  _calculateComparison();
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _endLevel,
                            decoration: const InputDecoration(
                              labelText: 'Ke Level',
                              border: OutlineInputBorder(),
                            ),
                            items: levels
                                .where((level) => level.name != _startLevel)
                                .map((level) => DropdownMenuItem(
                                      value: level.name,
                                      child: Text(level.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _endLevel = value;
                                  _calculateComparison();
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_comparisonResult.containsKey('error'))
              Card(
                elevation: 4,
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _comparisonResult['error'],
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_comparisonResult.isNotEmpty && !_comparisonResult.containsKey('error')) ...[
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Analisis Keuntungan Mendalam',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _marketPriceController,
                        decoration: const InputDecoration(
                          labelText: 'Harga Pasar (Opsional)',
                          hintText: 'Masukkan harga pasar saat ini',
                          border: OutlineInputBorder(),
                          suffixText: 'gold',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const Divider(height: 32),
                      _buildComparisonRow('Biaya Bahan Baku:', JewelLevel.formatCurrency((_comparisonResult['materialCost'] as double).round())),
                      _buildComparisonRow('Biaya Combine Tambahan:', JewelLevel.formatCurrency((_comparisonResult['combineCost'] as double).round())),
                      _buildComparisonRow('Total Biaya Produksi:', JewelLevel.formatCurrency((_comparisonResult['totalProductionCost'] as double).round()), isImportant: true),
                      const Divider(),
                      _buildComparisonRow('Keuntungan:', _comparisonResult['formattedProfit'], isProfit: true),
                      _buildComparisonRow('Persentase Keuntungan:', '${_comparisonResult['profitPercentage']}%', isProfit: true),
                      const Divider(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Saran & Analisis Kelayakan:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(_comparisonResult['suggestion'], style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            Text('Saran harga jual minimal (Profit 10%): ${_comparisonResult['formattedMinPrice']}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value, {bool isProfit = false, bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontWeight: (isProfit || isImportant) ? FontWeight.bold : FontWeight.normal))),
          Text(
            value,
            style: TextStyle(
              fontWeight: (isProfit || isImportant) ? FontWeight.bold : FontWeight.normal,
              color: isProfit ? Colors.green : (isImportant ? Theme.of(context).primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }
}
