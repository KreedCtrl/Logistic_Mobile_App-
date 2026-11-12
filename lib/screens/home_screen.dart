import 'package:flutter/material.dart';

import '../data/account_store.dart';
import '../models/saved_account.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.account});

  final SavedAccount account;

  void _backToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _logout(BuildContext context) {
    AccountStore.instance.logout(account.user.id);
    _backToLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = account.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        actions: [
          IconButton(
            tooltip: 'Schimba contul',
            icon: const Icon(Icons.switch_account),
            onPressed: () => _backToLogin(context),
          ),
          IconButton(
            tooltip: 'Iesi din cont',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Salut, ${user.name}!\nRol: ${user.role.label}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
