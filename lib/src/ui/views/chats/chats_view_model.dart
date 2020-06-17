import 'package:beast/src/app/generated/router/router.gr.dart';
import 'package:beast/src/app/models/user.dart';
import 'package:beast/src/ui/global/custom_base_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatsViewModel extends CustomBaseViewModel {
  Stream<QuerySnapshot> chatsStream() {
    return firestoreService.chatsStream(
      sender: currentUser,
    );
  }

  navigateToChatView({
    User receiver,
  }) {
    navigationService.navigateTo(
      Routes.chatViewRoute,
      arguments: ChatViewArguments(
        receiver: receiver,
      ),
    );
  }

  navigateToProfileView() {
    navigationService.navigateTo(Routes.profileViewRoute);
  }
}
