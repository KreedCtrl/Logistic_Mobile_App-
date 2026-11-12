import '../models/enums.dart';
import '../models/saved_account.dart';
import '../models/user.dart';

class AccountStore {
  AccountStore._();
  static final AccountStore instance = AccountStore._();

  final List<SavedAccount> _accounts = [
    SavedAccount(
      user: User(
        id: 1,
        email: 'customer@test.com',
        role: UserRole.customer,
        name: 'Fresh Foods SRL',
        createdAt: DateTime(2026, 11, 1),
      ),
      isLoggedIn: true,
    ),
    SavedAccount(
      user: User(
        id: 2,
        email: 'carrier@test.com',
        role: UserRole.carrier,
        name: 'Fast Trans SRL',
        mcNumber: 'MC123456',
        createdAt: DateTime(2026, 11, 2),
      ),
    ),
    SavedAccount(
      user: User(
        id: 3,
        email: 'owner@test.com',
        role: UserRole.ownerOperator,
        name: 'Ion Popescu',
        mcNumber: 'MC654321',
        createdAt: DateTime(2026, 11, 3),
      ),
    ),
  ];

  List<SavedAccount> get accounts => List.unmodifiable(_accounts);

  SavedAccount _find(int userId) =>
      _accounts.firstWhere((a) => a.user.id == userId);

  bool login(int userId, String password) {
    if (password.isEmpty) return false;
    _find(userId).isLoggedIn = true;
    return true;
  }

  void logout(int userId) {
    _find(userId).isLoggedIn = false;
  }

  void remove(int userId) {
    _accounts.removeWhere((a) => a.user.id == userId);
  }
}
