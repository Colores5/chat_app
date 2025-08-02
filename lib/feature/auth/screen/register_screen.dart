import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/core.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordtextEditingController =
      TextEditingController();

  Future<void> register(BuildContext context) async {
    final _auth = getIt<AuthRepository>();

    if (_confirmPasswordtextEditingController.text ==
        _passwordtextEditingController.text) {
      try {
        _auth.signUp(
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Пароли не совпадают'),
        ),
      );
    }
  }

  RegisterScreen({
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
          Text('Регистрация'),
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
          StyledTextField(
            obsecureText: true,
            hintText: 'Повторите пароль',
            textEditingController: _confirmPasswordtextEditingController,
          ),
          SizedBox(
            height: 32,
          ),
          StyledElevatedButton(
            onTap: () => register(context),
            text: 'Зарегестироваться',
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Уже есть аккаунт? '),
              GestureDetector(
                onTap: () => AutoRouter.of(context).pop(),
                child: Text(
                  'Войди!',
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
