import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/app_user.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fa.FirebaseAuth auth;
  final FirebaseFirestore db;

  FirebaseAuthRepository({
    required this.auth,
    required this.db,
  });

  AppUser? _mapUser(fa.User? u) {
    if (u == null) return null;
    return AppUser(
      uid: u.uid,
      email: u.email,
      displayName: u.displayName,
      photoUrl: u.photoURL,
      createdAt: u.metadata.creationTime,
    );
  }

  @override
  Stream<AppUser?> authStateChanges() => auth.authStateChanges().map(_mapUser);

  @override
  Future<AppUser?> getCurrentUser() async => _mapUser(auth.currentUser);

  @override
  Future<AppUser?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final cred = await auth.signInWithEmailAndPassword(email: email, password: password);
    final user = _mapUser(cred.user);
    if (user != null) await ensureUserProfile(user);
    return user;
  }

  @override
  Future<AppUser> registerWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
    if (displayName != null && displayName.isNotEmpty) {
      await cred.user?.updateDisplayName(displayName);
    }
    final user = _mapUser(cred.user)!;
    await ensureUserProfile(user);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    if (kIsWeb) {
      // Web: open Google popup
      final provider = fa.GoogleAuthProvider();
      final cred = await auth.signInWithPopup(provider);
      final user = _mapUser(cred.user);
      if (user != null) await ensureUserProfile(user);
      return user;
    } else {
      // Android/iOS/desktop: use Firebase Auth provider (no google_sign_in plugin)
      final provider = fa.GoogleAuthProvider();
      final cred = await auth.signInWithProvider(provider);
      final user = _mapUser(cred.user);
      if (user != null) await ensureUserProfile(user);
      return user;
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> ensureUserProfile(AppUser user) async {
    final ref = db.collection('users').doc(user.uid);
    await db.runTransaction((tr) async {
      final snap = await tr.get(ref);
      if (!snap.exists) {
        tr.set(ref, user.toMap());
      } else {
        tr.update(ref, {
          'email': user.email,
          'displayName': user.displayName,
          'photoUrl': user.photoUrl,
        });
      }
    });
  }
}
