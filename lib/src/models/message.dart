import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderId;
  String receiverId;
  String type;
  String message;
  Timestamp timestamp;
  List<String> mediaUrls;

  Message({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.timestamp,
    this.mediaUrls,
  });

  Message.fromJson(Map<String, dynamic> map) {
    List<String> mediaFromMap = [];

    List<String> choose() {
      map['mediaUrls'].forEach((v) {
        mediaFromMap.add(v.toString());
        print(v);
      });
      return mediaFromMap;
    }

    this.senderId = map['senderId'];
    this.receiverId = map['receiverId'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
    this.mediaUrls = choose();
  }

  Map toJson() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['receiverId'] = this.receiverId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['mediaUrls'] = this.mediaUrls;
    return map;
  }
}
