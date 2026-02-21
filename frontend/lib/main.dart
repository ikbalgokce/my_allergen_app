import 'package:flutter/material.dart';

import 'screens/login_page.dart';

void main() {
  runApp(const MyAllergenApp());
}

class MyAllergenApp extends StatelessWidget {
  const MyAllergenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Allergen',
      home: const LoginPage(),
    );
  }
}
