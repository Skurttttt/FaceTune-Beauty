import 'package:flutter/foundation.dart';
import '../../core/di/injector.dart';
import '../../data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repo = getIt<AuthRepository>();
  bool _isLoading = false; bool get isLoading => _isLoading;
  bool _passwordVisible = false; bool get passwordVisible => _passwordVisible;
  String? error;

  void togglePasswordVisibility() { _passwordVisible = !_passwordVisible; notifyListeners(); }

  Future<bool> login(String email, String password) async {
    try { _set(true); await _repo.signInWithEmailPassword(email: email, password: password); error = null; return true; }
    catch (e) { error = e.toString(); return false; }
    finally { _set(false); }
  }

  Future<bool> loginWithGoogle() async {
    try { _set(true); final u = await _repo.signInWithGoogle(); error = u == null ? 'Sign in aborted' : null; return u != null; }
    catch (e) { error = e.toString(); return false; }
    finally { _set(false); }
  }

  void _set(bool v) { _isLoading = v; notifyListeners(); }
}
