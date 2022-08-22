import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final store = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String messageText;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  final TextEditingController textEditingController = TextEditingController();

  Future<void> getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 202, 202),
      appBar: AppBar(
        leading: null,
        elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 12, 12, 12),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              margin: EdgeInsets.all(height * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: width * 0.8,
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.multiline,
                      controller: textEditingController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(190),
                              borderSide: const BorderSide()),
                          hintText: 'Type your message here',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(190))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      textEditingController.text.trim();
                      textEditingController.text.replaceAll(' ', ' ');
                      if (textEditingController.text.isNotEmpty) {
                        store.collection('chat').add({
                          'text': textEditingController.text,
                          'sender': loggedInUser.email,
                        });
                      } else {
                        print('Enter something');
                      }

                      textEditingController.clear();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(child: Icon(Icons.send)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatefulWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            store.collection('chat').snapshots(includeMetadataChanges: false),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot<Object?>> messages = snapshot.data!.docs;
          List<MessageBubble> messageLists = [];

          for (var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];
            final currentUser = loggedInUser.email;

            final widget = MessageBubble(
                isMe: currentUser == messageSender,
                messageText: messageText,
                messageSender: messageSender);
            messageLists.add(widget);
          }
          // return Expanded(
          //     child: ListView.builder(
          //         itemCount: snapshot.data!.docChanges.length,
          //         itemBuilder: ((context, index) {
          //           DocumentSnapshot text = snapshot.data!.docs[index];
          //           return ;
          //         })));
          return Expanded(
            child: ListView(
                reverse: true,
                padding: const EdgeInsets.all(10),
                children: messageLists),
          );
        }));
  }
}

class MessageBubble extends StatelessWidget {
  final String messageText, messageSender;
  final bool isMe;
  const MessageBubble(
      {Key? key,
      required this.isMe,
      required this.messageText,
      required this.messageSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            messageSender,
            textAlign: TextAlign.end,
            style: const TextStyle(
                fontSize: 12, color: Color.fromARGB(255, 121, 119, 119)),
          ),
          Material(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            color: isMe ? Colors.black : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                messageText,
                textScaleFactor: 1,
                style: TextStyle(color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
