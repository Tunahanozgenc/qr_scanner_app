import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool notifications = true;

  void _shareApp() {
    Share.share('Check out this awesome QR Scanner App! Download it now!');
  }

  void _sendFeedback() {
    // Burada mail göndermek veya başka işlem yapabilirsin
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: darkMode,
              onChanged: (bool value) {
                setState(() {
                  darkMode = value;
                });
                // Tema değiştirme işlemini buraya ekleyebilirsin
              },
            ),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: notifications,
              onChanged: (bool value) {
                setState(() {
                  notifications = value;
                });
                // Bildirim ayarlarını buraya ekleyebilirsin
              },
            ),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'QR Scanner App',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 QR Scanner App',
              );
            },
          ),

          const SizedBox(height: 32),

          // Paylaşma butonu
          GestureDetector(
            onTap: _shareApp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFF4A261), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.share, color: Color(0xFFF4A261)),
                  SizedBox(width: 16),
                  Text(
                    'Share App',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          // Geri Bildirim gönderme bölümü
          GestureDetector(
            onTap: _sendFeedback,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFF4A261), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.feedback, color: Color(0xFFF4A261)),
                  SizedBox(width: 16),
                  Text(
                    'Send Feedback',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
