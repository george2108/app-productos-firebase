import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:login_validation_bloc/utils/shared_preferences.dart';

class AuthProvider {
  final _firebaseToken = 'AIzaSyDk7RPRYxDI96FSUh8p_-z1SYoD3dkoxr0';
  final _prefs = new SharedPreferencesUser();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(authData),
    );
    Map<String, dynamic> data = json.decode(response.body);
    print(data);
    if (data.containsKey('idToken')) {
      _prefs.token = data['idToken'];
      return {'ok': true, 'token': data['idToken']};
    } else {
      return {'ok': false, 'message': data['error']['message']};
    }
  }

  Future<Map<String, dynamic>> signUpUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(authData),
    );
    Map<String, dynamic> data = json.decode(response.body);
    print(data);
    if (data.containsKey('idToken')) {
      _prefs.token = data['idToken'];
      return {'ok': true, 'token': data['idToken']};
    } else {
      return {'ok': false, 'message': data['error']['message']};
    }
  }
}
