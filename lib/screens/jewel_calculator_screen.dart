import 'package:flutter/material.dart';
import '../domain/entities/jewel_level.dart';
import '../utils/calculations.dart';
import 'level_comparison_screen.dart';

class JewelCalculatorScreen extends StatefulWidget {
  const JewelCalculatorScreen({super.key});

  @override
  State<JewelCalculatorScreen> createState() => _JewelCalculatorScreenState();
}

class _JewelCalculatorScreenState extends State<JewelCalculatorScreen> {
  String? _selectedLevel;
  double _basePrice = 1000;
  Map<String, dynamic> _jewelInfo = {};
  final TextEditingController _basePriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _basePriceController.text = _basePrice.toString();
    _basePriceController.addListener(_updateBasePrice);
  }

  @override
  void dispose() {
    _basePriceController.dispose();
    super.dispose();
  }

  void _updateBasePrice() {
    final value = double.tryParse(_basePriceController.text) ?? 0;
    if (value != _basePrice) {
      setState(() {
        _basePrice = value;
        if (_selectedLevel != null) {
          _jewelInfo = JewelCalculations.getJewelInfo(
            _selectedLevel!,
            basePrice: _basePrice,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final levels = JewelLevel.getJewelLevels();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Jewel'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cek Statistik & Harga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedLevel,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Level Jewel',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Pilih Level'),
                        ),
                        ...levels.map((level) {
                          return DropdownMenuItem(
                            value: level.name,
                            child: Text(level.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedLevel = value;
                          if (value != null) {
                            _jewelInfo = JewelCalculations.getJewelInfo(
                              value,
                              basePrice: _basePrice,
                            );
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _basePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Harga Dasar (Cracked)',
                        border: OutlineInputBorder(),
                        prefixText: 'Gold: ',
                        suffixText: ' gold',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _updateBasePrice();
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedLevel != null && _jewelInfo.isNotEmpty) ..._buildJewelInfo(),
            const SizedBox(height: 24),
            if (_selectedLevel != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelComparisonScreen(
                        initialLevel: _selectedLevel!,
                        basePrice: _basePrice,
                      ),
                    ),
                  );
                },
                child: const Text('Bandingkan dengan Level Lain'),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildJewelInfo() {
    return [
      const SizedBox(height: 16),
      Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              _buildInfoRow('Total Cracked Dibutuhkan:', '${_jewelInfo['totalCracked']}'),
              _buildInfoRow('Waktu Combine:', '${_jewelInfo['combineTime']}'),
              _buildInfoRow('Total Waktu:', '${_jewelInfo['totalTime']}'),
              if (_jewelInfo.containsKey('sellPrice')) ...[
                const Divider(),
                _buildInfoRow(
                  'Harga Jual:',
                  JewelLevel.formatCurrency(_jewelInfo['sellPrice']),
                  isImportant: true,
                ),
                _buildInfoRow(
                  'Biaya Material (Cracked):',
                  JewelLevel.formatCurrency((_basePrice * _jewelInfo['totalCracked']).round()),
                ),
                _buildInfoRow(
                  'Biaya Combine:',
                  JewelLevel.formatCurrency(_jewelInfo['combineCost']),
                ),
                _buildInfoRow(
                  'Total Biaya Produksi:',
                  JewelLevel.formatCurrency(((_basePrice * _jewelInfo['totalCracked']) + _jewelInfo['combineCost']).round()),
                ),
                const Divider(),
                _buildInfoRow(
                  'Keuntungan Bersih:',
                  JewelLevel.formatCurrency(
                    (_jewelInfo['sellPrice'] - (_basePrice * _jewelInfo['totalCracked']) - _jewelInfo['combineCost']).round(),
                  ),
                  isImportant: true,
                  textColor: (_jewelInfo['sellPrice'] - (_basePrice * _jewelInfo['totalCracked']) - _jewelInfo['combineCost']) >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildInfoRow(String label, String value, {bool isImportant = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              color: textColor ?? (isImportant ? Theme.of(context).primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }
}
