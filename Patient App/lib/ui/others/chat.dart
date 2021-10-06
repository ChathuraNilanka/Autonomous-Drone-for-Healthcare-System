import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/chat_model.dart';
import 'package:emedic/models/user.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/themes.dart';
import 'package:emedic/utils/widgets/app_scaffold.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Repository _repository = Repository();
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        page: DrawerPages.chat,
        child: Container(
          color: backgroundColor,
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildChat(),
              ),
              Container(
                padding: EdgeInsets.only(right: 15, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: _textEditingController,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Type your message",
                            ),
                            textInputAction: TextInputAction.send,
                            onEditingComplete: () => _addNewMessage(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _addNewMessage(),
                      enableFeedback: true,
                      icon: Icon(Icons.send),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _addNewMessage() {
    if (_textEditingController.text.isEmpty) return;
    ChatModel chat = ChatModel(
        userId: User().id,
        text: _textEditingController.text,
        createdAt: DateTime.now(),
        send: true);
    _repository.addMessage(chat);
    _textEditingController.text = "";
  }

  Widget _buildChat() {
    return StreamBuilder(
      stream: _repository.getMessage(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoadingWidget();
        if (snapshot.hasError) return Container();
        return _buildList(snapshot.data.documents);
      },
    );
  }

  Widget _buildList(List<DocumentSnapshot> documents) {
    return ListView.builder(
      reverse: true,
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index) {
        DocumentSnapshot snapshot = documents[index];
        ChatModel _chat = ChatModel.fromMap(snapshot.data);
        return ChatItem(
          message: _chat,
        );
      },
    );
  }
}

class ChatItem extends StatelessWidget {
  final ChatModel message;

  const ChatItem({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;


    var padding = EdgeInsets.fromLTRB(3, 5, screenWidth / 8, 5);
    var mainAxisAlignment = MainAxisAlignment.start;
    var alignment = Alignment.topLeft;
    var primary = Theme.of(context).primaryColor;
    var borderRadius = BorderRadius.only(
      topRight: Radius.circular(15),
      bottomRight: Radius.circular(15),
      bottomLeft: Radius.circular(15),
    );

    if (message.send) {
      padding = EdgeInsets.fromLTRB(screenWidth / 8, 5, 3, 5);
      primary = Colors.white;
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      );
      mainAxisAlignment = MainAxisAlignment.end;
      alignment = Alignment.topRight;
    }
    final messageText =message.text;
    final messageDate =  DateFormat("yyyy-MM-dd HH:mm").format(message.createdAt);

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          Expanded(
            child: Container(
              width: screenWidth * 0.85,
              alignment: alignment,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
              ),
              child: Card(
                color: primary,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        messageDate,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: screenWidth / 35, color: Colors.black54),
                      ),
                      Text(
                        messageText,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: screenWidth / 25, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
