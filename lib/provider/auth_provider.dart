import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token => _token;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('http://192.168.8.42:3000/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['access_token'];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    _token = null;
    notifyListeners();
  }

  void changeIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners();
  }
}
