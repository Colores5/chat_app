import 'package:chat_app/core/router/router.dart';
import 'package:chat_app/core/themes/themes.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.config(),
      theme: lightMode,
    );
  }
}
