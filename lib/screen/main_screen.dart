import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';
import '../service/main_screen_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // final int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    const HomeScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainScreenProvider>();

    return Scaffold(
      body: _listWidget[mainProvider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mainProvider.currentIndex,
        selectedItemColor: const Color(0xFF00C853),
        onTap: (index) {
          context.read<MainScreenProvider>().setIndex(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
