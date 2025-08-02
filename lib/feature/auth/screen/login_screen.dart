import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/core.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();

  void login(BuildContext context) async {
    final authRepository = getIt<AuthRepository>();

    try {
      await authRepository.signIn(
        _emailTextEditingController.text,
        _passwordtextEditingController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.message,
            size: 64,
          ),
          SizedBox(
            height: 64,
          ),
          Text('Добро пожаловать в простейший мессенджер'),
          StyledTextField(
            obsecureText: false,
            hintText: 'Email',
            textEditingController: _emailTextEditingController,
          ),
          StyledTextField(
            obsecureText: true,
            hintText: 'Пароль',
            textEditingController: _passwordtextEditingController,
          ),
          SizedBox(
            height: 32,
          ),
          StyledElevatedButton(
            onTap: () => login(context),
            text: 'Войти',
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Нет Аккаунта? '),
              GestureDetector(
                onTap: () => AutoRouter.of(context).push(RegisterRoute()),
                child: Text(
                  'Зарегестрируйся!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
