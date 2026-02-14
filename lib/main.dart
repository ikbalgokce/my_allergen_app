import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Giriş ekranını buradan çağırıyoruz

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İlaç Takip Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        // Arka plan rengini burada şeffaf yapıyoruz ki ekranlardaki gradientler görünsün
        scaffoldBackgroundColor: Colors.transparent,
      ),
      // Uygulama başladığında ilk açılacak ekran:
      home: const LoginScreen(), 
    );
  }
}