import 'package:beast/src/app/constants/strings.dart';
import 'package:beast/src/app/models/message.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  User sender;
  User receiver;
  List<Message> messages;
  Timestamp timestamp;

  Chat({
    this.sender,
    this.receiver,
    this.messages,
    this.timestamp,
  });

  static List<Message> convertMapToMessage(Map<String, dynamic> map) {
    List<Message> messagesList = [];

    for (var message in map['messages']) {
      Message _message = Message.fromJson(message);
      messagesList.add(_message);
    }

    return messagesList;
  }

  static User convertMapToUser(Map<String, dynamic> map, String userMapName) {
    User user = User.fromJson(map[userMapName]);
    return user;
  }

  Chat.fromJson(Map<String, dynamic> map) {
    this.sender = convertMapToUser(map, 'sender');
    this.receiver = convertMapToUser(map, 'receiver');
    this.messages = convertMapToMessage(map);
    this.timestamp = map[TIMESTAMP_FIELD_NAME];
  }

  static Map convertUserToMap(User user) {
    Map userMap = user.toJson();
    return userMap;
  }

  static List<Map> convertMessagesToMap(List<Message> messages) {
    List<Map> messagesMap = [];
    messages.forEach((Message message) {
      Map _messageMap = message.toJson();
      messagesMap.add(_messageMap);
    });

    return messagesMap;
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': convertUserToMap(sender),
      'receiver': convertUserToMap(receiver),
      'messages': convertMessagesToMap(messages),
      TIMESTAMP_FIELD_NAME: timestamp,
    };
  }
}
