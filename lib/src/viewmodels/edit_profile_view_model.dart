import 'dart:io';

import 'package:beast/src/constants/config.dart';
import 'package:beast/src/models/user.dart';
import 'package:beast/src/ui/shared/ui_helpers.dart';
import 'package:beast/src/ui/widgets/busy_button.dart';
import 'package:beast/src/ui/widgets/cached_image.dart';
import 'package:beast/src/ui/widgets/custom_app_bar.dart';
import 'package:beast/src/ui/widgets/user_circle.dart';
import 'package:beast/src/viewmodels/base_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileViewModel extends BaseModel {
  initStateFunc({
    @required BuildContext contextFromFunc,
  }) {
    getVariables(
      contextFromFunc: contextFromFunc,
    );
  }

  final _formKey = GlobalKey<FormState>();

  File _newProfilePhoto;
  String _newFullName = '';
  String _newEmail = '';

  BuildContext context;

  getVariables({
    BuildContext contextFromFunc,
  }) {
    context = contextFromFunc;
    notifyListeners();
  }

  customAppBar() {
    return CustomAppBar(
      title: Text(
        'Edit your profile',
      ),
    );
  }

  _displayProfileImage() {
    // No new profile image
    if (_newProfilePhoto == null) {
      if (currentUser.profilePhoto == null) {
        return null;
      } else {
        // User profile image exists
        return CachedImage(
          url: currentUser.profilePhoto,
        );
      }
    } else {
      // New profile image
      return Image.file(
        _newProfilePhoto,
        width: screenWidth(context) * 0.3,
        height: screenWidth(context) * 0.3,
      );
    }
  }

  pickImage({
    @required ImageSource source,
  }) async {
    File selectedImage = await utils.pickImage(
      source: source,
    );

    if (selectedImage != null) {
      setBusy(true);

      _newProfilePhoto = selectedImage;
      notifyListeners();

      setBusy(false);
    } else {
      dialogService.showDialog(
        title: 'Something went wrong!',
        description: 'Please try again later!',
      );
    }
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setBusy(true);

      // Update user in database
      String _newProfilePhotoUrl = '';

      if (_newProfilePhoto == null) {
        _newProfilePhotoUrl = currentUser.profilePhoto;
        notifyListeners();
      } else {
        _newProfilePhotoUrl = await storageService.uploadProfilePhoto(
          currentUser: currentUser,
          profilePhoto: _newProfilePhoto,
        );
      }

      User currentUserWithNewData = User(
        uid: currentUser.uid,
        email: _newEmail,
        fullName: _newFullName,
        profilePhoto: _newProfilePhotoUrl,
        username: currentUser.username,
        friends: currentUser.friends,
      );

      await firestoreService.updateUserData(
        currentUser: currentUser,
        currentUserWithNewData: currentUserWithNewData,
      );
      await authenticationService.rePopulateCurrentUser();
      popCurrentContext();
    } else {
      await dialogService.showDialog(
        title: 'Something went wrong!',
        description: 'Please try again later!',
      );
      setBusy(false);
    }
  }

  buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      await pickImage(
                        source: ImageSource.gallery,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        UserCircle(
                          height: screenWidth(context) * 0.3,
                          width: screenWidth(context) * 0.3,
                          text: userInitials,
                          textSize: screenWidth(context) * 0.1,
                          image: _displayProfileImage(),
                        ),
                        Opacity(
                          opacity: 0.4,
                          child: Container(
                            height: screenWidth(context) * 0.4,
                            width: screenWidth(context) * 0.4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Config.blackColor,
                            ),
                          ),
                        ),
                        Text(
                          'Change Profile\nPicture',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Config.whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue: currentUser.fullName,
                    onSaved: (value) {
                      _newFullName = value;
                      notifyListeners();
                    },
                    style: TextStyle(
                      color: Config.whiteColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Config.whiteColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          screenWidth(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenWidth(context) * 0.05,
                  ),
                  TextFormField(
                    initialValue: currentUser.email,
                    onSaved: (value) {
                      _newEmail = value;
                      notifyListeners();
                    },
                    style: TextStyle(
                      color: Config.whiteColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Config.whiteColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          screenWidth(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenWidth(context) * 0.1,
                  ),
                  BusyButton(
                    busy: busy,
                    title: 'Save Profile',
                    onPressed: () async {
                      setBusy(true);
                      await _submit();
                      setBusy(false);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
