import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../database/qr_database.dart';
import '../core/models/qr_code_model.dart';

// QR geçmişini gösteren sayfa
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // QR kodlarını listeleyecek future
  late Future<List<QRCode>> _qrCodesFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory(); // Sayfa açılır açılmaz geçmişi yükle
  }

  // Veritabanından tüm QR kodlarını çek
  void _loadHistory() {
    _qrCodesFuture = QRDatabase.instance.getAllCodes();
  }

  // ID'si verilen QR kodunu veritabanından sil ve listeyi güncelle
  Future<void> _deleteCode(int id) async {
    await QRDatabase.instance.deleteCode(id);
    setState(() {
      _loadHistory(); // Silme sonrası verileri yeniden yükle
    });
  }

  // Verilen metin bir URL mi kontrol et
  bool _isURL(String text) {
    final uri = Uri.tryParse(text);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  // URL'yi tarayıcıda açmaya çalış
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        // Başarısız olursa kullanıcıya bilgi ver
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QRCode>>(
      future: _qrCodesFuture,
      builder: (context, snapshot) {
        // Veriler yükleniyorsa yükleniyor animasyonu göster
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Hata varsa göster
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));//hata kodu
        }

        // Veriler geldiyse listeye dönüştür
        final qrCodes = snapshot.data ?? [];

        // Liste boşsa mesaj göster
        if (qrCodes.isEmpty) {
          return const Center(
            child: Text('Henüz QR kodu taranmadı.'),
          );
        }

        // Liste doluysa ListView ile göster
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: qrCodes.length,
          itemBuilder: (context, index) {
            final qr = qrCodes[index];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(color: const Color(0xFFF4A261), width: 1.5),
              ),
              child: Row(
                children: [
                  // QR metni göster (eğer URL ise tıklanabilir)
                  Expanded(
                    child: InkWell(
                      onTap: _isURL(qr.code) ? () => _launchURL(qr.code) : null,
                      child: Text(
                        qr.code,
                        style: TextStyle(
                          fontSize: 16,
                          color: _isURL(qr.code) ? Colors.blue : Colors.black87,
                          decoration: _isURL(qr.code)
                              ? TextDecoration.underline
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis, // Taşarsa üç nokta ile kısalt
                      ),
                    ),
                  ),
                  // Silme butonu
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCode(qr.id!), // id null olamaz çünkü veritabanından geldi
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
