import 'package:flutter/foundation.dart';

import '../models/organization_model.dart';
import '../../services/api_service.dart';

class OrganizationProvider extends ChangeNotifier {
  List<OrganizationModel> units = [];

  bool loading = false;
  String? error;

  Future<void> loadUnits() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/organization/');

      if (response is List) {
        units = response
            .whereType<Map<String, dynamic>>()
            .map(OrganizationModel.fromJson)
            .toList();
      }
    } catch (e) {
      error = 'Impossible de charger l’organisation.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
