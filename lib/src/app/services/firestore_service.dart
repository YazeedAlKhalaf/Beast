import 'dart:async';

import 'package:beast/src/app/constants/strings.dart';
import 'package:beast/src/app/models/chat.dart';
import 'package:beast/src/app/models/message.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirestoreService {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection(USERS_COLLECTION_NAME);
  final CollectionReference _messagesCollectionReference =
      Firestore.instance.collection(MESSAGES_COLLECTION_NAME);
  final CollectionReference _chatsCollectionReference =
      Firestore.instance.collection(CHATS_COLLECTION_NAME);

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.uid).setData(
            user.toJson(),
          );
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
      return _userListFromSnapshot(snapshot, currentUser);
    });
  }

  Future<List<String>> getFriendsIds(User currentUser) async {
    List<String> friendsIds = [];
    DocumentSnapshot userDocSnap =
        await _usersCollectionReference.document(currentUser.uid).get();
    userDocSnap.data['friends'].forEach((friendId) {
      friendsIds.add(friendId);
    });

    return friendsIds;
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

  Future changeFriendsList({
    @required User currentUser,
    @required User friendToAdd,
  }) async {
    List<String> friends = [];
    await _usersCollectionReference.document(currentUser.uid).get().then((doc) {
      doc.data['friends'].forEach((friendId) {
        friends.add(friendId);
      });
    });

    if (!friends.contains(friendToAdd.uid)) {
      addToFriendsList(
        currentUser: currentUser,
        friendToAdd: friendToAdd,
      );
    } else {
      removeFromFriendsList(
        currentUser: currentUser,
        friendToRemove: friendToAdd,
      );
    }
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
    List<String> mediaUrls,
    @required String messageType,
  }) async {
    try {
      if (!(await checkIfChatIsCreated(sender: sender, receiver: receiver))) {
        await createChat(
          sender: sender,
          receiver: receiver,
        );
        print('created chat');
      }

      Message _message;
      var messagesMap;

      _message = Message(
        receiverId: receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: messageType,
        mediaUrls: messageType == TEXT_MESSAGE_TYPE ? [] : mediaUrls,
      );

      messagesMap = [
        _message.toJson(),
      ];

      await _chatsCollectionReference
          .document('${sender.uid}')
          .collection('${sender.uid}')
          .document('${receiver.uid}')
          .updateData(
        {
          'messages': FieldValue.arrayUnion(messagesMap),
        },
      );
      await _chatsCollectionReference
          .document('${receiver.uid}')
          .collection('${receiver.uid}')
          .document('${sender.uid}')
          .updateData(
        {
          'messages': FieldValue.arrayUnion(messagesMap),
        },
      );
    } catch (e) {
      return e;
    }
  }

  Future<List<Message>> getMessagesList({
    @required User sender,
    @required User receiver,
  }) async {
    List<Message> messages = [];

    QuerySnapshot qs = await _messagesCollectionReference
        .document(sender.uid)
        .collection(receiver.uid)
        .getDocuments();

    qs.documents.forEach((doc) {
      Message m = Message.fromJson(doc.data);
      messages.add(m);
    });

    return messages;
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

  Future createChat({
    @required User sender,
    @required User receiver,
  }) async {
    try {
      if (await checkIfChatIsCreated(
        sender: sender,
        receiver: receiver,
      )) {
        return 'You already have a chat created with this person';
      }

      Chat chat = Chat(
        sender: sender,
        receiver: receiver,
        messages: [],
        timestamp: Timestamp.now(),
      );

      var chatMap = chat.toJson();

      await _chatsCollectionReference
          .document('${sender.uid}')
          .collection('${sender.uid}')
          .document('${receiver.uid}')
          .setData(
            chatMap,
          );

      await _chatsCollectionReference
          .document('${receiver.uid}')
          .collection('${receiver.uid}')
          .document('${sender.uid}')
          .setData(
            chatMap,
          );
    } catch (e) {
      return e;
    }
  }

  Future<bool> checkIfChatIsCreated({
    @required User sender,
    @required User receiver,
  }) async {
    try {
      DocumentSnapshot documentSnapshot = await _chatsCollectionReference
          .document('${sender.uid}')
          .collection('${sender.uid}')
          .document('${receiver.uid}')
          .get();

      if (documentSnapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('cc' + e);
      return e;
    }
  }

  Stream<DocumentSnapshot> chatStream({
    @required User sender,
    @required User receiver,
  }) {
    return _chatsCollectionReference
        .document('${sender.uid}')
        .collection('${sender.uid}')
        .document('${receiver.uid}')
        .get()
        .asStream();
  }

  Stream<QuerySnapshot> chatsStream({
    @required User sender,
  }) {
    return _chatsCollectionReference
        .document('${sender.uid}')
        .collection('${sender.uid}')
        .orderBy(TIMESTAMP_FIELD_NAME, descending: false)
        .snapshots();
  }

  Future updateUserData({
    @required User currentUser,
    @required User currentUserWithNewData,
  }) async {
    var userMap = currentUserWithNewData.toJson();

    await _usersCollectionReference.document(currentUser.uid).updateData(
          userMap,
        );
  }

  // Future<List<User>> getFriendsList({
  //   @required User user,
  // }) async {
  //   List<User> friendsList;

  //   await _usersCollectionReference.document(user.uid).get();
  // }
}
