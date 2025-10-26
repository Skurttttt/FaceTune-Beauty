import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_mvvm/viewmodels/auth/forgot_password_view_model.dart';
import 'package:firebase_auth_mvvm/utils/validators.dart';
import 'package:firebase_auth_mvvm/ui/widgets/primary_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel(), child: const _ForgotView());
  }
}

class _ForgotView extends StatefulWidget {
  const _ForgotView();

  @override
  State<_ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<_ForgotView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() { _email.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: Validators.email),
                const SizedBox(height: 16),
                if (vm.error != null) Text(vm.error!, style: const TextStyle(color: Colors.red)),
                if (vm.info != null) Text(vm.info!, style: const TextStyle(color: Colors.green)),
                const SizedBox(height: 12),
                PrimaryButton(label: 'Send Reset Email', icon: Icons.email, loading: vm.isSending, onPressed: () async {
                  if (!(_form.currentState?.validate() ?? false)) return;
                  await vm.sendReset(_email.text.trim());
                }),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
