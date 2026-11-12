import 'package:flutter/material.dart';

import '../data/account_store.dart';
import '../models/saved_account.dart';
import 'home_screen.dart';
import 'role_selection_screen.dart';

enum _AccountAction { logout, remove }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _store = AccountStore.instance;

  void _openHome(SavedAccount account) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(account: account)),
    );
  }

  Future<void> _onAccountTap(SavedAccount account) async {
    if (account.isLoggedIn) {
      _openHome(account);
      return;
    }

    final password = await _askPassword(account);
    if (password == null) return;

    if (_store.login(account.user.id, password)) {
      _openHome(account);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parola incorecta')),
      );
    }
  }

  Future<String?> _askPassword(SavedAccount account) {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(account.user.email),
        content: TextField(
          controller: controller,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Parola'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Anuleaza'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('Conecteaza'),
          ),
        ],
      ),
    );
  }

  Future<void> _onAction(SavedAccount account, _AccountAction action) async {
    switch (action) {
      case _AccountAction.logout:
        setState(() => _store.logout(account.user.id));
      case _AccountAction.remove:
        final confirmed = await _confirmRemove(account);
        if (confirmed == true) {
          setState(() => _store.remove(account.user.id));
        }
    }
  }

  Future<bool?> _confirmRemove(SavedAccount account) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Stergi contul de pe dispozitiv?'),
        content: Text(
          '${account.user.email} nu va mai aparea in lista. '
          'Contul nu se sterge, doar trebuie adaugat din nou.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Anuleaza'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sterge'),
          ),
        ],
      ),
    );
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accounts = _store.accounts;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.local_shipping,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              const Text(
                'Alege un cont',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: accounts.isEmpty
                    ? const Center(child: Text('Niciun cont salvat'))
                    : ListView(
                        children: [
                          for (final account in accounts)
                            _AccountTile(
                              account: account,
                              onTap: () => _onAccountTap(account),
                              onAction: (action) => _onAction(account, action),
                            ),
                        ],
                      ),
              ),
              OutlinedButton.icon(
                onPressed: _openRegister,
                icon: const Icon(Icons.person_add),
                label: const Text('Creeaza cont nou'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({
    required this.account,
    required this.onTap,
    required this.onAction,
  });

  final SavedAccount account;
  final VoidCallback onTap;
  final ValueChanged<_AccountAction> onAction;

  @override
  Widget build(BuildContext context) {
    final user = account.user;

    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(user.name[0])),
        title: Text(user.name),
        subtitle: Text('${user.email}\n${user.role.label}'),
        isThreeLine: true,
        onTap: onTap,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatusDot(isLoggedIn: account.isLoggedIn),
            PopupMenuButton<_AccountAction>(
              onSelected: onAction,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: _AccountAction.logout,
                  enabled: account.isLoggedIn,
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Iesi din cont'),
                    subtitle: Text('Contul ramane in lista'),
                  ),
                ),
                const PopupMenuItem(
                  value: _AccountAction.remove,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Sterge de pe dispozitiv'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isLoggedIn ? 'Conectat' : 'Necesita parola',
      child: Icon(
        isLoggedIn ? Icons.check_circle : Icons.lock_outline,
        size: 20,
        color: isLoggedIn ? Colors.green : Colors.grey,
      ),
    );
  }
}
