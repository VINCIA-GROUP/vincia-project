import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vincia_app/modules/login/service/login_service.dart';

class LoginPage extends StatelessWidget {
  final LoginService loginService = Modular.get<LoginService>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Image(
              image: AssetImage("assets/images/logo-img.png"),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buttonLogin(context, "Log in", () => loginService.login()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonLogin(BuildContext context, String text, Function() onPressed) {
    final TextStyle textButtonStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimary);
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Theme.of(context).colorScheme.primary);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 45,
          minWidth: 100,
        ),
        child: ElevatedButton(
            style: buttonStyle,
            onPressed: onPressed,
            child: Text(
              text,
              style: textButtonStyle,
            )),
      ),
    );
  }
}
