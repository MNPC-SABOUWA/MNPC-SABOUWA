import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? user;

  bool loading = false;

  String? errorMessage;

  Future<bool> login(
    String email,
    String password,
  ) async {
    if (loading) {
      return false;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = await _service.login(
        email.trim().toLowerCase(),
        password,
      );

      return user != null;
    } on ApiException catch (e) {
      user = null;
      errorMessage = e.message;
      return false;
    } catch (e) {
      user = null;
      errorMessage = 'Une erreur est survenue lors de la connexion.';
      debugPrint('Erreur connexion : $e');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    Map<String, dynamic> data,
  ) async {
    if (loading) {
      return false;
    }

    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.register(data);
      return result;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = 'Une erreur est survenue lors de l’inscription.';
      debugPrint('Erreur inscription : $e');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();

    user = null;
    errorMessage = null;

    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}