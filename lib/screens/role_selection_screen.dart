import 'package:flutter/material.dart';

import '../models/enums.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole; // null = nimic ales inca

  void _continue() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ai ales: ${_selectedRole!.label}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creeaza cont')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cine esti?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Cate un card pentru fiecare rol din enum
            for (final role in UserRole.values)
              _RoleCard(
                title: role.label,
                description: _roleDescription(role),
                icon: _roleIcon(role),
                isSelected: role == _selectedRole,
                onTap: () => setState(() => _selectedRole = role),
              ),

            const Spacer(),

            FilledButton(
              onPressed: _selectedRole == null ? null : _continue,
              child: const Text('Continua'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Icon(icon, size: 36, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: isSelected ? Icon(Icons.check_circle, color: color) : null,
        onTap: onTap,
      ),
    );
  }
}

String _roleDescription(UserRole role) => switch (role) {
      UserRole.customer => 'Postez comenzi de transport',
      UserRole.carrier => 'Am camioane si soferi, aplic la comenzi',
      UserRole.ownerOperator => 'Sunt sofer cu propriul camion',
    };

IconData _roleIcon(UserRole role) => switch (role) {
      UserRole.customer => Icons.inventory_2,
      UserRole.carrier => Icons.local_shipping,
      UserRole.ownerOperator => Icons.person_pin,
    };
