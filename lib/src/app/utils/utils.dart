import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:beast/src/app/constants/config.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

@lazySingleton
class Utils {
  final FlutterVideoCompress _videoCompress = FlutterVideoCompress();

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
      maxHeight: 500,
      maxWidth: 500,
    );
    return selectedImage;
  }

  Future<File> pickVideo({
    ImageSource source,
  }) async {
    File selectedVideo = await ImagePicker.pickVideo(
      source: source,
    );
    print('selected a video');

    MediaInfo videoInfo = await _videoCompress.getMediaInfo(selectedVideo.path);
    print('got video info');

    if (videoInfo.filesize < 68157440) {
      print('no compressing');
      return selectedVideo;
    } else {
      var compressedVideo = await _videoCompress.compressVideo(
        selectedVideo.path,
        quality: VideoQuality.MediumQuality,
        includeAudio: true,
      );
      print('compressing');

      MediaInfo compressedVideoInfo =
          await _videoCompress.getMediaInfo(compressedVideo.path);

      if (compressedVideoInfo.filesize < 68157440) {
        return File(compressedVideo.path);
      } else {
        return null;
      }
    }
  }

  crop({
    File imageFile,
  }) async {
    if (imageFile == null) return null;

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop',
        toolbarColor: Config.blackColor,
        toolbarWidgetColor: Config.whiteColor,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
        aspectRatioPickerButtonHidden: true,
        aspectRatioLockEnabled: true,
      ),
    );

    print(croppedFile.path);

    return croppedFile;
  }
}
