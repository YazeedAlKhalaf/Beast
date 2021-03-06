import 'dart:io';

import 'package:beast/src/app/generated/locator/locator.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/app/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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

  Future uploadProfilePhotoToStorage({
    @required User currentUser,
    @required File profilePhoto,
  }) async {
    try {
      _storageReference = FirebaseStorage.instance.ref().child(
            'profile_photos/${currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}',
          );

      StorageUploadTask _storageUploadTask = _storageReference.putFile(
        profilePhoto,
      );

      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future uploadProfilePhoto({
    @required User currentUser,
    @required File profilePhoto,
  }) async {
    String url = await uploadProfilePhotoToStorage(
      currentUser: currentUser,
      profilePhoto: profilePhoto,
    );

    return url;
  }
}
