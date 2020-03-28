import 'dart:io';
import 'package:beast/src/locator.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageService {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  StorageReference _storageReference;

  Future<String> uploadImageToStorage({
    @required User sender,
    @required User receiver,
    @required File image,
  }) async {
    try {
      _storageReference = FirebaseStorage.instance.ref().child(
          'images/${DateTime.now().millisecondsSinceEpoch}_sender${sender.uid}_receiver${receiver.uid}');

      StorageUploadTask _storageUploadTask = _storageReference.putFile(image);

      var url =
          await (await _storageUploadTask.onComplete).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future uploadImage({
    @required User sender,
    @required User receiver,
    @required File image,
  }) async {
    String url = await uploadImageToStorage(
      sender: sender,
      receiver: receiver,
      image: image,
    );

    await _firestoreService.setImageMessage(
      url: url,
      receiver: receiver,
      sender: sender,
    );
  }
}
