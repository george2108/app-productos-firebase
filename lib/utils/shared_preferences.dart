import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new SharedPreferencesUser();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...

*/

class SharedPreferencesUser {
  static final SharedPreferencesUser _instancia =
      new SharedPreferencesUser._internal();

  factory SharedPreferencesUser() {
    return _instancia;
  }

  SharedPreferencesUser._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }
}
