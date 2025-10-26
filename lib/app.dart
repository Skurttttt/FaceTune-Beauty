import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth/user_view_model.dart';
import 'ui/pages/login_page.dart';
import 'ui/pages/register_page.dart';
import 'ui/pages/forgot_password_page.dart';
import 'ui/pages/home_page.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()..bindAuthState()),
      ],
      child: MaterialApp(
        title: 'Auth MVVM',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
        initialRoute: '/',
        routes: {
          '/': (_) => const _RootGate(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/forgot': (_) => const ForgotPasswordPage(),
          '/home': (_) => const HomePage(),
        },
      ),
    );
  }
}

class _RootGate extends StatelessWidget {
  const _RootGate();
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserViewModel>().user;
    return user == null ? const LoginPage() : const HomePage();
  }
}
