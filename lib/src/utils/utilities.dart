import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Utils {
  String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0].toUpperCase();
    String lastNameInitial = nameSplit[1][0].toUpperCase();
    return firstNameInitial + lastNameInitial;
  }

  Future<File> pickImage({
    ImageSource source,
  }) async {
    File selectedImage = await ImagePicker.pickImage(
      source: source,
      imageQuality: 50,
    );
    return selectedImage;
  }
}
