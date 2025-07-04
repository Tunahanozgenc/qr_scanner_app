import 'package:flutter/material.dart';
import 'history_page.dart';
import 'scan_page.dart';
import 'settings_page.dart';

// Uygulamanın ana sayfası — bottom navigation bar ile üç sayfa arasında geçiş sağlar
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Seçili olan sayfanın index'i — başlangıçta ScanPage gösterilir
  int _selectedIndex = 1;

  // Gösterilecek sayfa widget'ları listesi
  final List<Widget> _pages = [
    HistoryPage(),            // 0. index
    ScanPage(),               // 1. index
    SettingsPage(),     // 2. index
  ];

  // Alt menüdeki butonlara tıklanınca çağrılır, sayfa geçişini sağlar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner App'), // Sayfanın üst başlığı
      ),
      body: _pages[_selectedIndex], // Seçilen sayfa burada gösterilir
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Şu an hangi sayfa seçili
        onTap: _onItemTapped,         // Tıklanınca yeni index seçilecek
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',        // Geçmiş sayfası
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',           // QR tarayıcı sayfası
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',       // Ayarlar sayfası
          ),
        ],
      ),
    );
  }
}
