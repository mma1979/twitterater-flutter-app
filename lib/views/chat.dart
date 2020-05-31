import 'dart:convert';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:string_validator/string_validator.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageEditingController = new TextEditingController();
  String url = 'XXXXXXXXX'; // API
  bool isLoading = false;
  final List<MessageTile> _messages = <MessageTile>[];
  bool _validate = false;

  void _handleSubmitted(String text) async {
    setState(() {
      isLoading = true;
    });

    if (text.trim().isNotEmpty) {
      messageEditingController.clear();
      MessageTile message = new MessageTile(
        message: text.trim(),
        sendByMe: true,
      );

      setState(() {
        _messages.insert(0, message);
      });

      var response = await http.get(url + text.trim()).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          messageEditingController.clear();
          MessageTile botReply = new MessageTile(
            message: 'Timeout. Check your internet connection',
            sendByMe: false,
          );

          setState(() {
            _messages.insert(0, botReply);
            isLoading = false;
          });
          return null;
        },
      );
      final jsonBody = json.decode(response.body);

      MessageTile botReply = new MessageTile(
        message: jsonBody['msg'],
        sendByMe: false,
      );

      setState(() {
        _messages.insert(0, botReply);
        isLoading = false;
      });
    } else {
      messageEditingController.clear();
      MessageTile botReply = new MessageTile(
        message: 'Username is incorrect',
        sendByMe: false,
      );

      setState(() {
        _messages.insert(0, botReply);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          title: new Text("Twitterater"),
                          content: new SelectableText(
                            'Twitterater is a bot that helps you to analyze any Twitter account by showing the percentage of how much positive or negative tweets on there using just the username.\n\nThe percentage is based on many factors for example: sharp phrases, violence, racism or self-harm.\n\nTwitterater analysis process completely dependence on AI (artificial intelligence) without any human intervention.\n\nContact us : petereroshdy@gmail.com\n\nversion: v1.0',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'Close',
                                style: TextStyle(color: Colors.pink),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ));
              },
              icon: Icon(
                Icons.info,
                color: Colors.pink,
              ),
            ),
          ],
          title: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/spy-bot.png',
                width: 25.0,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                'Twitterater',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          iconTheme: IconThemeData(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: false,
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, index) => _messages[index],
                  itemCount: _messages.length,
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        controller: messageEditingController,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            hintText: "What is the username ?",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      (isLoading == true)
                          ? CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () {
                                _handleSubmitted(messageEditingController.text);
                              },
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.circular(40)),
                                  padding: EdgeInsets.all(12),
                                  child: Image.asset(
                                    "assets/images/send.png",
                                    height: 25,
                                    width: 25,
                                  )),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({
    @required this.message,
    @required this.sendByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: sendByMe ? Colors.pink : Colors.grey[200],
        ),
        child: GestureDetector(
          onTap: () {
            ClipboardManager.copyToClipBoard(message).then((result) {
              final snackBar = SnackBar(
                content: Text('Copied to Clipboard'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            });
          },
          child: Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: sendByMe ? Colors.white : Colors.black,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
              )),
        ),
      ),
    );
  }
}
