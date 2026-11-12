import 'enums.dart';


class User {
  final int id;
  final String email;
  final UserRole role;
  final String name;
  final String? phone;    
  final String? mcNumber;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.name,
    this.phone,
    this.mcNumber,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      role: UserRole.fromValue(map['role']),
      name: map['name'],
      phone: map['phone'],
      mcNumber: map['mc_number'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'role': role.value,
      'name': name,
      'phone': phone,
      'mc_number': mcNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
