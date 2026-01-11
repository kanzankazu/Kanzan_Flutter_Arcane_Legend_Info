import 'package:flutter/material.dart';
import '../utils/calculations.dart';
import '../domain/entities/jewel_level.dart';

class ElixirCalculatorScreen extends StatefulWidget {
  const ElixirCalculatorScreen({super.key});

  @override
  State<ElixirCalculatorScreen> createState() => _ElixirCalculatorScreenState();
}

class _ElixirCalculatorScreenState extends State<ElixirCalculatorScreen> {
  final _elixirPriceController = TextEditingController(text: '1000');
  final _crackedPriceController = TextEditingController(text: '100');
  final _durationController = TextEditingController(text: '30');
  final _rateController = TextEditingController(text: '5');

  Map<String, dynamic>? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    final elixirPrice = double.tryParse(_elixirPriceController.text) ?? 0;
    final crackedPrice = double.tryParse(_crackedPriceController.text) ?? 0;
    final duration = int.tryParse(_durationController.text) ?? 30;
    final rate = int.tryParse(_rateController.text) ?? 1;

    setState(() {
      _result = JewelCalculations.calculateElixirBreakEven(
        elixirPrice: elixirPrice,
        crackedPrice: crackedPrice,
        durationMinutes: duration,
        crackedPerMinute: rate,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Jewel Elixir'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInput('Harga Jewel Elixir', _elixirPriceController, 'gold'),
                    _buildInput('Harga per Cracked Jewel', _crackedPriceController, 'gold'),
                    _buildInput('Durasi Elixir', _durationController, 'menit'),
                    _buildInput('Rate (Cracked / menit)', _rateController, 'buah'),
                  ],
                ),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 16),
              Card(
                color: _result!['profit'] >= 0 
                  ? Theme.of(context).colorScheme.tertiaryContainer 
                  : Theme.of(context).colorScheme.errorContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: (_result!['profit'] >= 0 ? Colors.green : Colors.red).withOpacity(0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        _result!['profit'] >= 0 ? '✅ Menguntungkan!' : '❌ Tidak Menguntungkan!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _result!['profit'] >= 0 
                            ? Theme.of(context).colorScheme.onTertiaryContainer 
                            : Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      const Divider(),
                      _buildResultRow(
                        'Total Cracked Didapat', 
                        '${_result!['totalCracked']} buah',
                        textColor: _result!['profit'] >= 0 
                          ? Theme.of(context).colorScheme.onTertiaryContainer 
                          : Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      _buildResultRow(
                        'Total Nilai', 
                        JewelLevel.formatCurrency(_result!['totalValue'].round()),
                        textColor: _result!['profit'] >= 0 
                          ? Theme.of(context).colorScheme.onTertiaryContainer 
                          : Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      _buildResultRow(
                        'Keuntungan', 
                        _result!['formattedProfit'],
                        textColor: _result!['profit'] >= 0 
                          ? Theme.of(context).colorScheme.onTertiaryContainer 
                          : Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const Divider(),
                      _buildResultRow(
                        'Minimal Cracked (Break Even)', 
                        '${_result!['breakEvenQuantity']} buah',
                        textColor: _result!['profit'] >= 0 
                          ? Theme.of(context).colorScheme.onTertiaryContainer 
                          : Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      _buildResultRow(
                        'Waktu Balik Modal', 
                        '${_result!['breakEvenMinutes'].toStringAsFixed(1)} menit',
                        textColor: _result!['profit'] >= 0 
                          ? Theme.of(context).colorScheme.onTertiaryContainer 
                          : Theme.of(context).colorScheme.onErrorContainer,
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

  Widget _buildInput(String label, TextEditingController controller, String suffix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          suffixText: suffix,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        onChanged: (_) => _calculate(),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: textColor)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
