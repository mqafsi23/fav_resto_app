import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/notification_helper.dart';
import '../service/preferences_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Consumer<PreferencesHelper>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Tema Gelap'),
                subtitle: const Text('Nyalakan untuk menggunakan dark mode'),
                value: provider.isDarkTheme,
                onChanged: (value) {
                  provider.enableDarkTheme(value);
                },
              ),
              const Divider(),
              SwitchListTile(
                title: const Text('Pengingat Makan Siang'),
                subtitle: const Text('Ingatkan saya restoran acak setiap jam 11:00 AM'),
                value: provider.isDailyReminderActive,
                onChanged: (value) {
                  provider.enableDailyReminder(value);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications_active, color: Colors.orange),
                title: const Text('Tes Notifikasi (Only on Android development stage)'),
                onTap: () async {
                  await NotificationHelper().showNotification();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}