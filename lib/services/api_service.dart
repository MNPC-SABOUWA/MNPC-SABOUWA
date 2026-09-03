import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';
import 'storage_service.dart';

class ApiService {
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await StorageService.getToken();

    final response = await http.post(
      Uri.parse(
        "${AppConstants.apiBaseUrl}$endpoint",
      ),
      headers: {
        "Content-Type": "application/json",
        if (token != null)
          "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  static Future<dynamic> get(
    String endpoint,
  ) async {
    final token = await StorageService.getToken();

    final response = await http.get(
      Uri.parse(
        "${AppConstants.apiBaseUrl}$endpoint",
      ),
      headers: {
        "Content-Type": "application/json",
        if (token != null)
          "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(response);
  }

  static dynamic _handleResponse(
    http.Response response,
  ) {
    dynamic data;

    try {
      data = jsonDecode(response.body);
    } catch (_) {
      data = {
        "detail": response.body,
      };
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return data;
    }

    String message = "Une erreur est survenue.";

    if (data is Map<String, dynamic>) {
      final detail = data["detail"];

      if (detail is String) {
        message = detail;
      } else if (detail is List) {
        message = detail
            .map(
              (item) {
                if (item is Map &&
                    item["msg"] != null) {
                  return item["msg"].toString();
                }

                return item.toString();
              },
            )
            .join("\n");
      }
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message,
    );
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  const ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() {
    return "ApiException($statusCode): $message";
  }
}