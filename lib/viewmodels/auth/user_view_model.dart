import 'package:flutter/foundation.dart';
import '../../core/di/injector.dart';
import '../../data/models/app_user.dart';
import '../../data/repositories/auth_repository.dart';

class UserViewModel extends ChangeNotifier {
  final AuthRepository _repo = getIt<AuthRepository>();
  AppUser? _user;
  AppUser? get user => _user;

  void bindAuthState() {
    _repo.authStateChanges().listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  Future<void> signOut() => _repo.signOut();
}
