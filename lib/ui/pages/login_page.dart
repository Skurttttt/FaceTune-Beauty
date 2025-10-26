import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_mvvm/viewmodels/auth/login_view_model.dart';
import 'package:firebase_auth_mvvm/utils/validators.dart';
import 'package:firebase_auth_mvvm/ui/widgets/password_text_field.dart';
import 'package:firebase_auth_mvvm/ui/widgets/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => LoginViewModel(), child: const _LoginView());
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: Validators.email),
                const SizedBox(height: 12),
                PasswordTextField(controller: _password, visible: vm.passwordVisible, onToggle: vm.togglePasswordVisibility, validator: Validators.password),
                const SizedBox(height: 20),
                if (vm.error != null) Text(vm.error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                Row(children: [
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot'), child: const Text('Forgot Password?')),
                  const Spacer(),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Create account')),
                ]),
                const SizedBox(height: 8),
                PrimaryButton(label: 'Login', icon: Icons.login, loading: vm.isLoading, onPressed: () async {
                  if (!(_form.currentState?.validate() ?? false)) return;
                  final ok = await vm.login(_email.text.trim(), _password.text);
                  if (ok && mounted) Navigator.pushReplacementNamed(context, '/home');
                }),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.g_mobiledata),
                  label: vm.isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Continue with Google'),
                  onPressed: vm.isLoading ? null : () async {
                    final ok = await vm.loginWithGoogle();
                    if (ok && mounted) Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
