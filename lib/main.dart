import 'package:flutter/material.dart';
import 'package:qr_scanner_app/screens/splash_page.dart'; // Splash ekranını import et

// Uygulamanın giriş noktası
void main() {
  runApp(const MyApp()); // MyApp widget'ını çalıştır
}

// Uygulamanın temel widget'ı (root widget)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner App', // Uygulamanın başlığı (task switcher vb. yerlerde görünür)

      // Uygulamanın tema ayarları
      theme: ThemeData(
        primaryColor: const Color(0xFF2A2A2A), // Ana renk (koyu gri/siyah tonları)
        scaffoldBackgroundColor: Colors.white, // Sayfa arka plan rengi
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2A2A), // AppBar arka plan rengi
          foregroundColor: Colors.white,       // AppBar üzerindeki yazı ve ikon renkleri
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF2A2A2A), // Alt navigation bar arka plan rengi
          selectedItemColor: Color(0xFFF4A261),  // Seçili menü öğesi rengi (turuncu ton)
          unselectedItemColor: Colors.grey,       // Seçili olmayan öğeler gri renkte
        ),
      ),

      home: SplashPage(), // Uygulama açıldığında gösterilecek ilk sayfa

      debugShowCheckedModeBanner: false, // Sağ üstteki "debug" etiketi kaldırılır
    );
  }
}
