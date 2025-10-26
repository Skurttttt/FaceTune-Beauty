import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_mvvm/viewmodels/auth/register_view_model.dart';
import 'package:firebase_auth_mvvm/utils/validators.dart';
import 'package:firebase_auth_mvvm/ui/widgets/password_text_field.dart';
import 'package:firebase_auth_mvvm/ui/widgets/primary_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => RegisterViewModel(), child: const _RegisterView());
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  @override
  void dispose() { _email.dispose(); _password.dispose(); _name.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Display Name'), validator: (v) => Validators.nonEmpty(v, field: 'Display Name')),
                const SizedBox(height: 12),
                TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: Validators.email),
                const SizedBox(height: 12),
                PasswordTextField(controller: _password, visible: vm.passwordVisible, onToggle: vm.togglePasswordVisibility, validator: Validators.password),
                const SizedBox(height: 20),
                if (vm.error != null) Text(vm.error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                Row(children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back to login')),
                  const Spacer(),
                ]),
                const SizedBox(height: 8),
                PrimaryButton(label: 'Create Account', icon: Icons.person_add_alt_1, loading: vm.isLoading, onPressed: () async {
                  if (!(_form.currentState?.validate() ?? false)) return;
                  final ok = await vm.register(email: _email.text.trim(), password: _password.text, displayName: _name.text.trim());
                  if (ok && mounted) Navigator.pushReplacementNamed(context, '/home');
                }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
