import 'package:flutter/material.dart';

import 'screens/login_screen.dart';

void main() {
  runApp(const LogisticsApp());
}

// Radacina aplicatiei: tema + primul ecran.
class LogisticsApp extends StatelessWidget {
  const LogisticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logistics App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const LoginScreen(),
    );
  }
}
