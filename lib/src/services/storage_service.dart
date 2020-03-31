import 'dart:io';
import 'package:beast/src/locator.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageService {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  StorageReference _storageReference;

  Future<String> uploadMediaToStorage({
    @required User sender,
    @required User receiver,
    @required List<File> media,
  }) async {
    try {
      _storageReference = FirebaseStorage.instance.ref().child(
            'messages_media/media/sender_${sender.uid}_receiver_${receiver.uid}/${DateTime.now().millisecondsSinceEpoch}_sender${sender.uid}_receiver${receiver.uid}',
          );

      StorageUploadTask _storageUploadTask = _storageReference.putFile(
        media[0],
      );

      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future uploadMedia({
    @required User sender,
    @required User receiver,
    @required List<File> media,
    @required String messageType,
  }) async {
    String url = await uploadMediaToStorage(
      sender: sender,
      receiver: receiver,
      media: media,
    );

    await _firestoreService.addMessageToDb(
      sender: sender,
      receiver: receiver,
      text: '',
      mediaUrls: [
        url,
      ],
      messageType: messageType,
    );
  }
}
