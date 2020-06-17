class User {
  String uid;
  String fullName; // real name
  String username; // nickname
  String email;
  String profilePhoto;
  List<String> friends = List<String>();

  User({
    this.uid,
    this.fullName,
    this.username,
    this.email,
    this.profilePhoto,
    this.friends,
  });

  User.fromJson(Map<String, dynamic> data) {
    List<String> friendsFromMap = [];

    List<String> choose() {
      data['friends'].forEach((v) {
        friendsFromMap.add(v);
        // print(v);
      });
      return friendsFromMap;
    }

    this.uid = data['uid'];
    this.fullName = data['fullName'];
    this.username = data['username'];
    this.email = data['email'];
    this.profilePhoto = data['profilePhoto'];
    this.friends = choose();
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'email': email,
      'profilePhoto': profilePhoto,
      'friends': friends,
    };
  }
}
