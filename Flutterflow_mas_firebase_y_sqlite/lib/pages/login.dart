  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';
  import '../functions/login/login_controller.dart';

  class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    final _userCtrl = TextEditingController();
    final _passCtrl = TextEditingController();
    bool _loading = false;
    String? _error;

    Future<void> _login() async {
      setState(() {
        _loading = true;
        _error = null;
      });

      final ok = await loginUser(
        context,
        usuario: _userCtrl.text,
        contrasenia: _passCtrl.text,
      );

      if (!mounted) return;

      setState(() => _loading = false);

      if (ok) {
        context.go('/home');
      } else {
        setState(() => _error = 'Usuario o contraseña incorrectos');
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 24),
                ),
                TextField(
                  controller: _userCtrl,
                  decoration: const InputDecoration(labelText: 'Usuario'),
                ),
                TextField(
                  controller: _passCtrl,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Entrar'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
