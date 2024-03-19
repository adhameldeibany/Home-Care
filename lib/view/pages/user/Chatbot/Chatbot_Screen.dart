import 'package:flutter/material.dart';
import 'package:graduation_project/code/resource/color_mananger.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<String> messages = [];

  TextEditingController messageController = TextEditingController();

  void sendMessage(String message) {
    setState(() {
      messages.add('User: $message');
    });
    String response = getChatbotResponse(message);
    receiveMessage(response);
  }

  String getChatbotResponse(String message) {
    // TODO: Implement your own chatbot logic here
    // You can use if-else statements, switch-case, or any other approach
    // to process user messages and generate responses
    if (message.toLowerCase().contains('hello')) {
      return 'Hi there!';
    } else if (message.toLowerCase().contains('how are you')) {
      return "I'm doing well, thank you!";
    } else if (message.toLowerCase().contains('bye')) {
      return 'Goodbye!';
    } else if (message.toLowerCase().contains('what is your name')) {
      return "I'm Adham Eldeibany";
    }

      else {
      return 'I didn\'t understand that. Can you please rephrase?';
    }

  }

  void receiveMessage(String message) {
    setState(() {
      messages.add('Bot: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkorange,
        centerTitle: true,
        title: Text('Chatbot'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bot2.png'),
            fit: BoxFit.cover,
            colorFilter:
            ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index],
                        style: TextStyle(fontSize: 20, color: darkorange, fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: darkorange),
                            borderRadius: BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30),),
                        )
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = messageController.text;
                      messageController.clear();
                      sendMessage(message);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
