import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => MessageProvider(),
        )
      ],
      child: MaterialApp(
        home: ListScreen(),
      ),
    );
  }
}

class ListScreen extends StatelessWidget {

  Widget build(BuildContext context) {
   var messageProvider = Provider.of<MessageProvider>(context);
    messageProvider.updateStream();
    return Scaffold(
      appBar: AppBar(title: Text('ProviderList')),
      body: StreamBuilder(
        stream: messageProvider.stream,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Waiting');
          }

          if (snapshot.hasError) {
            return Text('Error !!');
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, i) => ListTile(
              title: Text(snapshot.data[i].msgData),
            ),
          );
        },
      ),
      floatingActionButton: FloatingBtn(),
    );
  }
}
int i =0;
class FloatingBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var inputMsg = Provider.of<MessageProvider>(context, listen: false);
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        i++;
        inputMsg.addMessage(Message('Message$i'));
      },
    );
  }
}


class Message with ChangeNotifier {
  final String id = DateTime.now().toString();
  final String msgData;

  Message(this.msgData);
}

class MessageProvider with ChangeNotifier {
  List<Message> _messages = [
    Message('msgData'),
    Message('msgData'),
    Message('NewMessage'),
  ];

  List<Message> get messages {
    return [..._messages];
  }

  StreamController<List<Message>> streamController = StreamController();
  Stream<List<Message>> get stream => streamController.stream;


  void updateStream() {
    this.streamController.sink.add([..._messages]);
  }

  addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }
  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
  
}

