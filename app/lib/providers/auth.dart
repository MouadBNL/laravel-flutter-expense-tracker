import 'package:app/models/Category.dart';
import 'package:app/services/Api.dart';
import 'package:flutter/widgets.dart';

class AuthProvider extends ChangeNotifier {
  late ApiService apiService;
  bool isAuthenticated = false;
  String token = '';

  AuthProvider() {
    apiService = ApiService();
    init();
  }

  Future init() async {
    // categories = await apiService.fetchCategories();
    // notifyListeners();
  }

  Future<String> register(String name, String email, String password,
      String passwordConfirm, String deviceName) async {
    String tokenRes = await apiService.register(
        name, email, password, passwordConfirm, deviceName);

    token = tokenRes;
    isAuthenticated = true;
    notifyListeners();
    return token;
  }
}
