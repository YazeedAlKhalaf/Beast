import 'dart:async';
import 'package:beast/src/constants/strings.dart';
import 'package:beast/src/models/message.dart';
import 'package:beast/src/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection(USERS_COLLECTION_NAME);
  final CollectionReference _messagesCollectionReference =
      Firestore.instance.collection(MESSAGES_COLLECTION_NAME);

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.uid).setData(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(FirebaseUser user) async {
    try {
      var userData = await _usersCollectionReference.document(user.uid).get();
      return User.fromJson(userData.data);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getAllUsers(User currentUser) async {
    try {
      List<User> userList = List<User>();

      QuerySnapshot querySnapshot =
          await _usersCollectionReference.getDocuments();

      for (var i = 0; i < querySnapshot.documents.length; i++) {
        if (querySnapshot.documents[i].documentID != currentUser.uid) {
          userList.add(User.fromJson(querySnapshot.documents[i].data));
        }
      }

      return userList;
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  List<User> _userListFromSnapshot(QuerySnapshot snapshot, User currentUser) {
    return snapshot.documents.map((doc) {
      if (doc.data[UID_FIELD_NAME] == currentUser.uid) {
        return null;
      } else {
        return User.fromJson(doc.data);
      }
    });
  }

  Stream<List<User>> fetchAllUsers(User currentUser) {
    return _usersCollectionReference.snapshots().map((snapshot) {
      _userListFromSnapshot(snapshot, currentUser);
    });
  }

  Future<List<User>> getFriends(List<String> friendsIds) async {
    List<User> freinds = [];
    for (String friendId in friendsIds) {
      DocumentSnapshot friendDocumentSnapshot =
          await _usersCollectionReference.document(friendId).get();
      User friend = User.fromJson(friendDocumentSnapshot.data);
      freinds.add(friend);
    }
    return freinds;
  }

  Future addToFriendsList({
    @required User currentUser,
    @required User friendToAdd,
  }) async {
    List<String> friendsToAdd = <String>[
      friendToAdd.uid,
    ];
    await _usersCollectionReference.document(currentUser.uid).updateData({
      FRIENDS_FIELD_NAME: FieldValue.arrayUnion(friendsToAdd),
    });
  }

  Future removeFromFriendsList({
    @required User currentUser,
    @required User friendToRemove,
  }) async {
    List<String> friendsToRemove = <String>[
      friendToRemove.uid,
    ];
    await _usersCollectionReference.document(currentUser.uid).updateData({
      FRIENDS_FIELD_NAME: FieldValue.arrayRemove(friendsToRemove),
    });
  }

  Future addMessageToDb({
    @required User sender,
    @required User receiver,
    @required String text,
  }) async {
    Message _message = Message(
      receiverId: receiver.uid,
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: TEXT_MESSAGE_TYPE,
    );

    var messageMap = _message.toJson();

    await _messagesCollectionReference
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(messageMap);

    await _messagesCollectionReference
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(messageMap);
  }

  Stream<QuerySnapshot> messagesStream({
    @required User sender,
    @required User receiver,
  }) {
    return _messagesCollectionReference
        .document(sender.uid)
        .collection(receiver.uid)
        .orderBy(TIMESTAMP_FIELD_NAME, descending: true)
        .snapshots();
  }

  Future setImageMessage({
    @required String url,
    @required User sender,
    @required User receiver,
  }) async {
    Message _message = Message.imageMessage(
      receiverId: receiver.uid,
      senderId: sender.uid,
      message: "",
      timestamp: Timestamp.now(),
      photoUrl: url,
      type: IMAGE_MESSAGE_TYPE,
    );

    var messageMap = _message.toImageJson();

    await _messagesCollectionReference
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(messageMap);

    await _messagesCollectionReference
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(messageMap);
  }
}
