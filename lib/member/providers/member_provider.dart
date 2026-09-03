import 'package:flutter/foundation.dart';

import '../models/member_model.dart';
import '../../services/api_service.dart';

class MemberProvider extends ChangeNotifier {
  MemberModel? member;

  bool loading = false;
  String? error;

  Future<void> loadMember(String memberId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final response = await ApiService.get('/members/$memberId');

      if (response is Map<String, dynamic>) {
        member = MemberModel.fromJson(response);
      }
    } catch (e) {
      error = 'Impossible de charger le profil membre.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
