import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../database/qr_database.dart';
import '../core/models/qr_code_model.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<QRCode>> _qrCodesFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _qrCodesFuture = QRDatabase.instance.getAllCodes();
  }

  Future<void> _deleteCode(int id) async {
    await QRDatabase.instance.deleteCode(id);
    setState(() {
      _loadHistory();
    });
  }

  bool _isURL(String text) {
    final uri = Uri.tryParse(text);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QRCode>>(
      future: _qrCodesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final qrCodes = snapshot.data ?? [];

        if (qrCodes.isEmpty) {
          return const Center(
            child: Text('No QR codes scanned yet.'),
          );
        }

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
                  Expanded(
                    child: InkWell(
                      onTap: _isURL(qr.code) ? () => _launchURL(qr.code) : null,
                      child: Text(
                        qr.code,
                        style: TextStyle(
                          fontSize: 16,
                          color: _isURL(qr.code) ? Colors.blue : Colors.black87,
                          decoration:
                          _isURL(qr.code) ? TextDecoration.underline : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCode(qr.id!),
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