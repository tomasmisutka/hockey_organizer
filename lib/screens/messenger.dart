import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/models/message.dart';

import '../app_localization.dart';

class Messenger extends StatefulWidget {
  final User firebaseUser;

  Messenger(this.firebaseUser);

  @override
  _MessengerState createState() => _MessengerState();
}

class _MessengerState extends State<Messenger> {
  User get firebaseUser => widget.firebaseUser;
  TextEditingController _messageController;
  FocusNode _messageNode;
  ScrollController _scrollController;

  @override
  void initState() {
    _messageController = TextEditingController();
    _messageNode = FocusNode();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _messageNode?.dispose();
    _messageController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 20,
      iconTheme: IconThemeData(
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
      ),
      title: Text(
        'Messenger',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
      ),
    );
  }

  Future<void> _scrollToEnd() async {
    if (_scrollController.hasClients) {
      await _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    }
  }

  bool _isMe(var message) => message['uid'] == firebaseUser.uid;

  Widget messages(BuildContext context, AppLocalizations appLocalizations) {
    Query _messagesReference =
        FirebaseFirestore.instance.collection('messenger').orderBy('time', descending: false);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: _messagesReference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
            QuerySnapshot messages = snapshot.data;

            return ListView(
              controller: _scrollController,
              children: messages.docs.map((message) {
                return Row(
                  mainAxisAlignment:
                      _isMe(message) ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment:
                          _isMe(message) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(message['time'], style: TextStyle(color: Colors.black, fontSize: 11)),
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color:
                                _isMe(message) ? Theme.of(context).primaryColor : Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Visibility(
                                child: Text(message['name'],
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                visible: _isMe(message) ? false : true,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                message['body'],
                                style: TextStyle(
                                  color: _isMe(message) ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) => DateFormat('dd.MM.yyyy kk:mm').format(dateTime);

  Widget chatInputMessage(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            focusNode: _messageNode,
            style: TextStyle(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: appLocalizations.translate('enter_message'),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
              ),
              labelText: appLocalizations.translate('message'),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Message messageToSend = Message(firebaseUser.uid, firebaseUser.displayName,
                _formatDate(DateTime.now()), _messageController.text.trim());
            messageToSend.sendMessage();
            _messageNode.unfocus();
            _messageController.clear();
          },
          child: Container(
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            child: Icon(Icons.send, color: Colors.white),
            padding: EdgeInsets.all(8),
          ),
        )
      ],
    );
  }

  Widget chat(BuildContext context, AppLocalizations appLocalizations) {
    return GestureDetector(
      onTap: () => _messageNode.unfocus(),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            messages(context, appLocalizations),
            chatInputMessage(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: appBar(context),
      body: chat(context, appLocalizations),
    );
  }
}
