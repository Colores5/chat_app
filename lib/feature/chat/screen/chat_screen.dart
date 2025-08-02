import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/core.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  final String reciverEmail;
  final String reciverID;

  ChatScreen({
    super.key,
    required this.reciverEmail,
    required this.reciverID,
  });

  final TextEditingController _messageController = TextEditingController();

  final ChatRepository _chatRepository = getIt<ChatRepository>();
  final AuthRepository _authRepository = getIt<AuthRepository>();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatRepository.sendMessage(reciverID, _messageController.text);
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(reciverEmail),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _chatRepository.getMessages(
                reciverID,
                _authRepository.getCurrentUser()!.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Ошибка');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs
                      .map(
                        (doc) => Column(
                          crossAxisAlignment:
                              (doc.data()
                                      as Map<String, dynamic>)['senderID'] ==
                                  _authRepository.getCurrentUser()!.uid
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    (doc.data()
                                            as Map<
                                              String,
                                              dynamic
                                            >)['senderID'] ==
                                        _authRepository.getCurrentUser()!.uid
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              child: Text(
                                (doc.data() as Map<String, dynamic>)['message'],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: StyledTextField(
                    textEditingController: _messageController,
                    hintText: 'Напиши сообщение',
                    obsecureText: false,
                  ),
                ),
                GestureDetector(
                  onTap: () => sendMessage(),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.green,
                    ),
                    margin: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
