import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String uid;
  String name;
  String time;
  String body;

  Message(this.uid, this.name, this.time, this.body);

  Message parseMessage(Map<String, dynamic> data) {
    Message message = Message(data['uid'], data['name'], data['time'], data['body']);
    return message;
  }

  void sendMessage() async {
    CollectionReference _chatReference = FirebaseFirestore.instance.collection('messenger');
    if (body.isNotEmpty && body != '')
      await _chatReference.add({'name': name, 'uid': uid, 'body': body, 'time': time});
  }
}
