import 'package:flutter/foundation.dart';
import '../../core/di/injector.dart';
import '../../data/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repo = getIt<AuthRepository>();
  bool _isLoading = false; bool get isLoading => _isLoading;
  bool _passwordVisible = false; bool get passwordVisible => _passwordVisible;
  String? error;

  void togglePasswordVisibility() { _passwordVisible = !_passwordVisible; notifyListeners(); }

  Future<bool> register({required String email, required String password, String? displayName}) async {
    try { _set(true); await _repo.registerWithEmailPassword(email: email, password: password, displayName: displayName); error = null; return true; }
    catch (e) { error = e.toString(); return false; }
    finally { _set(false); }
  }

  void _set(bool v) { _isLoading = v; notifyListeners(); }
}
