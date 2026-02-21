import 'package:flutter/material.dart';

import 'allergen_profile_screen.dart';
import 'home_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String userEmail;

  const MainScreen({
    super.key,
    required this.userId,
    this.userName = 'Kullanıcı',
    this.userEmail = '',
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(
        userId: widget.userId,
        userName: widget.userName,
        userEmail: widget.userEmail,
      ),
      AllergenProfileScreen(userId: widget.userId),
      NotificationsScreen(userId: widget.userId),
      SettingsScreen(userId: widget.userId),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Alerjen'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Bildirimler'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}
