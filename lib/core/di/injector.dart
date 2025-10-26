import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/firebase_auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository(
        auth: getIt<FirebaseAuth>(),
        db: getIt<FirebaseFirestore>(),
      ));
}
