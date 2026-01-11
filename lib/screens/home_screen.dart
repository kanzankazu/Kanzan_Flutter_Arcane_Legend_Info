import 'package:flutter/material.dart';
import 'jewel_calculator_screen.dart';
import 'elixir_calculator_screen.dart';
import 'jewel_statistics_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arcane Legend Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Keluar',
            onPressed: () {
              // Untuk mobile kita bisa keluar aplikasi, untuk web kita kembalikan ke splash atau sekedar info
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesi Berakhir. Silakan tutup tab browser Anda.')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                    title: 'Market Itemku',
                    icon: Icons.shopping_basket,
                    color: Colors.pink,
                    onTap: () => _launchURL('https://www.itemku.com/g/arcane-legends/semua'),
                  ),
                  _buildDashboardItem(
                    context,
                    title: 'Web Resmi',
                    icon: Icons.language,
                    color: Colors.red,
                    onTap: () => _launchURL('https://www.arcanelegendsgame.com/'),
                  ),
                  _buildDashboardItem(
                    context,
                    title: 'Main Game',
                    icon: Icons.play_arrow,
                    color: Colors.indigo,
                    onTap: () => _launchURL('https://account.spacetimestudios.com/arcanelegends/'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDashboardItem(
                context,
                title: 'Market Info (Coming Soon)',
                icon: Icons.info_outline,
                color: Colors.grey,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur Market Info akan segera hadir!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Could not launch $urlString');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
