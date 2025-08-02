import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/core.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _chatRepository = getIt<ChatRepository>();
  final _auth = getIt<AuthRepository>();

  void logout() {
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Главная страница'),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Выйти из аккаунта'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _chatRepository.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Ошибка');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                children: [const CircularProgressIndicator()],
              ),
            );
          }
          return ListView(
            children: snapshot.data!
                .where(
                  (userData) =>
                      userData['email'] != _auth.getCurrentUser()!.email,
                )
                .map(
                  (userData) => UserTile(
                    text: userData['email'],
                    onTap: () {
                      AutoRouter.of(
                        context,
                      ).push(
                        ChatRoute(
                          reciverEmail: userData['email'],
                          reciverID: userData['uid'],
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
