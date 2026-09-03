import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';

class VerificationEmailPage extends StatefulWidget {
  const VerificationEmailPage({
    super.key,
  });

  @override
  State<VerificationEmailPage> createState() => _VerificationEmailPageState();
}

class _VerificationEmailPageState extends State<VerificationEmailPage> {
  final email = TextEditingController();
  final code = TextEditingController();

  final service = AuthService();

  bool loading = false;
  bool _emailInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_emailInitialized) {
      return;
    }

    _emailInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is String && arguments.trim().isNotEmpty) {
      email.text = arguments.trim().toLowerCase();
    }
  }

  @override
  void dispose() {
    email.dispose();
    code.dispose();

    super.dispose();
  }

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();

    final mail = email.text.trim().toLowerCase();
    final verificationCode = code.text.trim();

    if (mail.isEmpty) {
      _showMessage(
        'Veuillez saisir votre email.',
      );
      return;
    }

    if (!_isValidEmail(mail)) {
      _showMessage(
        'Veuillez saisir une adresse e-mail valide.',
      );
      return;
    }

    if (verificationCode.length != 6 ||
        !RegExp(r'^\d{6}$').hasMatch(verificationCode)) {
      _showMessage(
        'Le code doit contenir exactement 6 chiffres.',
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
      final user = await service.verifyEmail(
        mail,
        verificationCode,
      );

      if (!mounted) {
        return;
      }

      if (user != null) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.dashboard,
        );
      } else {
        _showMessage(
          'Code ou email incorrect.',
        );
      }
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Erreur serveur ${e.statusCode} : ${e.message}',
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Erreur : $e',
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
          duration: const Duration(
            seconds: 4,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vérification Email',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: Color(0xFFB00020),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Vérifiez votre adresse email',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Entrez le code reçu à l'adresse email utilisée lors de la création du compte.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: code,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!loading) {
                    _verify();
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Code reçu',
                  prefixIcon: Icon(
                    Icons.password_outlined,
                  ),
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: loading ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB00020),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'VALIDER',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
