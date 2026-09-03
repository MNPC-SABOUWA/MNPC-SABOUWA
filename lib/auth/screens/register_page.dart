import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  final service = AuthService();

  bool loading = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    final first = firstName.text.trim();
    final last = lastName.text.trim();
    final mail = email.text.trim().toLowerCase();
    final tel = phone.text.trim();
    final pass = password.text;

    if (first.length < 2) {
      _showMessage('Veuillez saisir votre prénom.');
      return;
    }

    if (last.length < 2) {
      _showMessage('Veuillez saisir votre nom.');
      return;
    }

    if (!_isValidEmail(mail)) {
      _showMessage('Veuillez saisir une adresse e-mail valide.');
      return;
    }

    if (tel.length < 6) {
      _showMessage('Veuillez saisir un numéro de téléphone valide.');
      return;
    }

    if (pass.length < 8) {
      _showMessage(
        'Le mot de passe doit contenir au moins 8 caractères.',
      );
      return;
    }

    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final result = await service.register({
        'first_name': first,
        'last_name': last,
        'email': mail,
        'phone': tel,
        'password': pass,
      });

      if (!mounted) {
        return;
      }

      if (result) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.verifyEmail,
          arguments: mail,
        );
      } else {
        _showMessage(
          'La création du compte n’a pas abouti.',
        );
      }
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Erreur ${e.statusCode} : ${e.message}',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Impossible de contacter le serveur.\n$e',
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  bool _isValidEmail(String value) {
    final regex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    return regex.hasMatch(value);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  InputDecoration _decoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              const Icon(
                Icons.person_add_alt_1,
                size: 60,
              ),
              const SizedBox(height: 15),
              const Text(
                'Créer votre compte MNPC SABOUWA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: firstName,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  'Prénom',
                  Icons.person_outline,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastName,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  'Nom',
                  Icons.badge_outlined,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: _decoration(
                  'Email',
                  Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: _decoration(
                  'Téléphone',
                  Icons.phone_outlined,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: obscurePassword,
                decoration: _decoration(
                  'Mot de passe',
                  Icons.lock_outline,
                ).copyWith(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Le mot de passe doit contenir au moins 8 caractères.',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : _register,
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Créer mon compte',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: loading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: const Text(
                  'J’ai déjà un compte',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
