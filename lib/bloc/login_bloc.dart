import 'dart:async';

import 'package:login_validation_bloc/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<String> get emailStream =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // obtener el valor de los streams para usar los datos
  String get email => _emailController.valueOrNull;
  String get password => _passwordController.valueOrNull;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }
}
