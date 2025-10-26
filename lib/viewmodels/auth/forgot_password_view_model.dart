import 'package:flutter/foundation.dart';
import '../../core/di/injector.dart';
import '../../data/repositories/auth_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository _repo = getIt<AuthRepository>();
  bool _isSending = false; bool get isSending => _isSending;
  String? error; String? info;

  Future<bool> sendReset(String email) async {
    try { _set(true); await _repo.sendPasswordResetEmail(email: email); error = null; info = 'Password reset email sent. Check your inbox.'; return true; }
    catch (e) { info = null; error = e.toString(); return false; }
    finally { _set(false); }
  }

  void _set(bool v) { _isSending = v; notifyListeners(); }
}
