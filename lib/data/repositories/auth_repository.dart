import '../models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> getCurrentUser();

  Future<AppUser?> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<AppUser> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<AppUser?> signInWithGoogle();

  Future<void> signOut();

  /// Ensure Firestore profile exists/updated at /users/{uid}.
  Future<void> ensureUserProfile(AppUser user);
}
