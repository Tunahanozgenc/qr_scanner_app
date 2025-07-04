import 'dart:ffi'; // Bu kullanılmıyor, silebilirsin
import 'package:flutter/material.dart';
import 'main_page.dart'; // Ana sayfa (MainPage) için import

// Uygulama açılış (splash) ekranı
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sayfanın arka planı sarı
      body: Container(
        color: const Color(0xFFFDB623),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Ortala
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              // QR ikon görseli
              Image.asset(
                'assets/qr.png', // asset klasöründen görsel
                width: 130,
                height: 130,
              ),

              const SizedBox(height: 100),

              // Alt kart: metin ve buton içeriyor
              Container(
                height: 200,
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A), // Siyah arka planlı kart
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Başlık metni
                    const Text(
                      'Hadi Başlayalım',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Açıklama metni
                    const Text(
                      'QR kodlarını ücretsiz tarayın, hayatınızı bizimle kolaylaştırın!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // "Başla" butonu
                    ElevatedButton(
                      onPressed: () {
                        // Ana sayfaya geçiş yapılır, splash ekranı silinir
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => MainPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFF4A261), // Buton rengi
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            ' Başla!   ',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
