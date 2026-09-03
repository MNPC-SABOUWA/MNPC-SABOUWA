import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mnpc_sabouwa/services/api_service.dart';

import '../auth/models/user_model.dart';
import 'storage_service.dart';

class AuthService {
  Future<UserModel?> login(
    String email,
    String password,
  ) async {
    final response = await ApiService.post(
      "/auth/login",
      {
        "email": email.trim().toLowerCase(),
        "password": password,
      },
    );

    debugPrint(
      "REPONSE LOGIN : $response",
    );

    if (response is! Map<String, dynamic>) {
      return null;
    }

    if (response["access_token"] == null ||
        response["refresh_token"] == null ||
        response["user"] == null) {
      return null;
    }

    await _saveSession(response);

    return UserModel.fromJson(
      Map<String, dynamic>.from(
        response["user"] as Map,
      ),
    );
  }

  Future<bool> register(
    Map<String, dynamic> data,
  ) async {
    final response = await ApiService.post(
      "/auth/register",
      data,
    );

    debugPrint(
      "REPONSE REGISTER : $response",
    );

    if (response is! Map<String, dynamic>) {
      return false;
    }

    return response["user"] != null;
  }

  Future<UserModel?> verifyEmail(
    String email,
    String code,
  ) async {
    final response = await ApiService.post(
      "/auth/verify-email",
      {
        "email": email.trim().toLowerCase(),
        "code": code.trim(),
      },
    );

    debugPrint(
      "========== REPONSE VERIFY EMAIL ==========",
    );

    debugPrint(
      response.toString(),
    );

    debugPrint(
      "==========================================",
    );

    if (response is! Map<String, dynamic>) {
      return null;
    }

    /*
      Le serveur doit retourner :

      {
        access_token:"",
        refresh_token:"",
        user:{}
      }

    */

    if (response["access_token"] == null) {
      return null;
    }

    if (response["refresh_token"] == null) {
      return null;
    }

    if (response["user"] == null) {
      return null;
    }

    await _saveSession(
      response,
    );

    return UserModel.fromJson(
      Map<String, dynamic>.from(
        response["user"] as Map,
      ),
    );
  }

  Future<void> _saveSession(
    Map<String, dynamic> response,
  ) async {
    await StorageService.saveToken(
      response["access_token"].toString(),
    );

    await StorageService.saveRefreshToken(
      response["refresh_token"].toString(),
    );

    final user = UserModel.fromJson(
      Map<String, dynamic>.from(
        response["user"] as Map,
      ),
    );

    await StorageService.saveUser(
      jsonEncode(
        user.toJson(),
      ),
    );
  }

  Future<void> logout() async {
    await StorageService.logout();
  }
}
