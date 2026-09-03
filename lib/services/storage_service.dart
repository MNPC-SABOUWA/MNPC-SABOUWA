import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/app_constants.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // =========================
  // ACCESS TOKEN
  // =========================

  static Future<void> saveToken(
    String token,
  ) async {
    await _storage.write(
      key: AppConstants.tokenKey,
      value: token,
    );
  }

  static Future<String?> getToken() async {
    return await _storage.read(
      key: AppConstants.tokenKey,
    );
  }

  static Future<void> removeToken() async {
    await _storage.delete(
      key: AppConstants.tokenKey,
    );
  }

  // =========================
  // REFRESH TOKEN
  // =========================

  static Future<void> saveRefreshToken(
    String token,
  ) async {
    await _storage.write(
      key: AppConstants.refreshTokenKey,
      value: token,
    );
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: AppConstants.refreshTokenKey,
    );
  }

  static Future<void> removeRefreshToken() async {
    await _storage.delete(
      key: AppConstants.refreshTokenKey,
    );
  }

  // =========================
  // UTILISATEUR
  // =========================

  static Future<void> saveUser(
    String userJson,
  ) async {
    await _storage.write(
      key: AppConstants.userKey,
      value: userJson,
    );
  }

  static Future<String?> getUser() async {
    return await _storage.read(
      key: AppConstants.userKey,
    );
  }

  static Future<void> removeUser() async {
    await _storage.delete(
      key: AppConstants.userKey,
    );
  }

  // =========================
  // DECONNEXION
  // =========================

  static Future<void> logout() async {
    await _storage.delete(
      key: AppConstants.tokenKey,
    );

    await _storage.delete(
      key: AppConstants.refreshTokenKey,
    );

    await _storage.delete(
      key: AppConstants.userKey,
    );
  }

  // =========================
  // EFFACEMENT COMPLET
  // =========================

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
