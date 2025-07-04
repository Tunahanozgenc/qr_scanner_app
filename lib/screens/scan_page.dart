import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../database/qr_database.dart';

// QR kod tarayıcı ekranı
class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR'); // QRView için anahtar
  QRViewController? controller; // Kamerayı ve taramayı yöneten kontrolcü
  String? qrText; // Tarama sonucu QR kod metni

  // Sayfa yok edilirken controller'ı da dispose et
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Hot reload gibi durumlarda Android'de kamerayı durdurup tekrar başlat
  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  // Metin bir URL mi diye kontrol eder
  bool _isURL(String text) {
    final uri = Uri.tryParse(text);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  // URL’yi cihazın tarayıcısında açar
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  // QRView oluşturulduğunda çağrılır, taranan veriyi dinler
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    // Kameradan gelen QR kodları sürekli dinlenir
    controller.scannedDataStream.listen((scanData) async {
      final code = scanData.code;

      // Yeni bir QR kod tarandığında (öncekinden farklıysa)
      if (code != null && code != qrText) {
        setState(() {
          qrText = code;
        });

        // Veritabanındaki tüm kodları al
        final allCodes = await QRDatabase.instance.getAllCodes();
        final codes = allCodes.map((e) => e.code).toList();

        // Kod veritabanında yoksa ekle
        if (!codes.contains(code)) {
          await QRDatabase.instance.insertCode(code);
        }

        // Kamerayı durdur (aynı kod tekrar tekrar taranmasın diye)
        controller.pauseCamera();
      }
    });
  }

  // Tekrar tarama işlemi başlatır
  void _restartScan() {
    setState(() {
      qrText = null;
    });
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Kamera ekranı (QR tarayıcı)
        Expanded(
          flex: 4,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: const Color(0xFFF4A261),
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250,
            ),
          ),
        ),

        // Tarama sonucu kutusu
        Expanded(
          flex: 1,
          child: Center(
            child: qrText == null
                ? const Text('Kodu Tara')
                : GestureDetector(
              onTap: _isURL(qrText!) ? () => _launchURL(qrText!) : null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF4A261), width: 2),
                ),
                child: Text(
                  qrText!,
                  style: TextStyle(
                    color: _isURL(qrText!) ? Colors.blue : Colors.black,
                    decoration: _isURL(qrText!) ? TextDecoration.underline : null,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),

        // Alt kısımda butonlar (flaş ve tekrar tara)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flaş butonu
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF4A261),
                  side: const BorderSide(color: Color(0xFFF4A261), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () async {
                  await controller?.toggleFlash(); // Flaş durumunu değiştir
                  setState(() {});
                },
                icon: const Icon(Icons.flash_on),
                label: FutureBuilder<bool?>(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data == true) {
                      return const Text('Flaş Açık');
                    } else {
                      return const Text('Flaş Kapalı');
                    }
                  },
                ),
              ),

              const SizedBox(width: 16),

              // "Tekrar Tara" butonu (sadece tarama yapılmışsa görünür)
              if (qrText != null)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF4A261),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _restartScan,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Tekrar Tara',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
