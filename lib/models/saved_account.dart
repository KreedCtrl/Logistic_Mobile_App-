import 'user.dart';

class SavedAccount {
  final User user;
  bool isLoggedIn;

  SavedAccount({required this.user, this.isLoggedIn = false});
}
