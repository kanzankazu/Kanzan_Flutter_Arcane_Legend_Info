import 'package:flutter/material.dart';
import 'jewel_calculator_screen.dart';
import 'elixir_calculator_screen.dart';
import 'jewel_statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arcane Legend Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardItem(
              context,
              title: 'Cek Jewel',
              icon: Icons.search,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JewelCalculatorScreen()),
              ),
            ),
            _buildDashboardItem(
              context,
              title: 'Kalkulator Elixir',
              icon: Icons.bolt,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ElixirCalculatorScreen()),
              ),
            ),
            _buildDashboardItem(
              context,
              title: 'Tabel Statistik',
              icon: Icons.table_chart,
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JewelStatisticsScreen()),
              ),
            ),
            _buildDashboardItem(
              context,
              title: 'Market Info',
              icon: Icons.shop,
              color: Colors.purple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Market Info akan segera hadir!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
