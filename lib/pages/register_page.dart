import 'package:flutter/material.dart';
import 'package:login_validation_bloc/bloc/provider.dart';
import 'package:login_validation_bloc/providers/auth_provider.dart';
import 'package:login_validation_bloc/utils/show_alert.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          _RegisterForm(),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: 180.0)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 20.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                EmailInput(bloc: bloc),
                SizedBox(height: 10.0),
                PasswordInput(bloc: bloc),
                SizedBox(height: 10.0),
                ButtonSubmitRegister(bloc: bloc),
                SizedBox(height: 5.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Divider(color: Colors.grey),
                ),
                Text(
                  'O registrate con',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SocialNetworkIcons(logo: 'assets/google-logo.png'),
                    SocialNetworkIcons(logo: 'assets/facebook-logo.png'),
                    SocialNetworkIcons(logo: 'assets/twitter-logo.png'),
                  ],
                )
              ],
            ),
          ),
          TextButton(
            child: Text(
              '??Ya tienes cuenta?, inicia sesi??n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}

class SocialNetworkIcons extends StatelessWidget {
  final logo;

  SocialNetworkIcons({this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.0,
      height: 50.0,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.black12,
      ),
      child: Image(
        image: AssetImage(logo),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final LoginBloc bloc;

  EmailInput({this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.email_outlined, color: Colors.deepPurple),
              hintText: 'ejemplo@correo.com',
              labelText: 'Email',
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  final LoginBloc bloc;

  PasswordInput({this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.vpn_key_outlined, color: Colors.deepPurple),
              labelText: 'Password',
              errorText: snapshot.error,
              suffixIcon: IconButton(
                icon: Icon(Icons.remove_red_eye),
                onPressed: () {
                  print('Hola wey');
                },
              ),
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }
}

class ButtonSubmitRegister extends StatelessWidget {
  final LoginBloc bloc;

  ButtonSubmitRegister({this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.deepPurple,
          textColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
            child: Text('Entrar'),
          ),
          onPressed: snapshot.hasData ? () => _register(context, bloc) : null,
        );
      },
    );
  }

  _register(BuildContext context, LoginBloc bloc) async {
    final authProvider = new AuthProvider();
    final data = await authProvider.signUpUser(bloc.email, bloc.password);
    if (data['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showAlertMessage(context, data['message']);
    }
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final backGradient = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ],
        ),
      ),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: [
        backGradient,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, right: -30.0, child: circle),
        Positioned(bottom: -50.0, right: -10.0, child: circle),
        Positioned(bottom: 120.0, right: 30.0, child: circle),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(height: 10.0, width: double.infinity),
              Text(
                'Jorge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
