class UserProfile {
  //General user data
  String uid, firstName, lastName, email, profilePictureURL;
  List interests;

  UserProfile({this.email, this.uid, this.profilePictureURL, this.firstName, this.lastName, this.interests});

  UserProfile.fromMap(Map<String, dynamic> mapData) {
    if (mapData == null || mapData.isEmpty) return;

    //General user Data
    if (mapData.containsKey('user_uid')) uid = mapData['user_uid'].toString();
    if (mapData.containsKey('user_first_name')) firstName = mapData['user_first_name'].toString();
    if (mapData.containsKey('user_last_name')) lastName = mapData['user_last_name'].toString();
    if (mapData.containsKey('user_email')) email = mapData['user_email'].toString();
    if (mapData.containsKey('user_profile_picture_url')) profilePictureURL = mapData['user_profile_picture_url'].toString();

    if (mapData.containsKey('user_interests')) interests = mapData['user_interests'];
  }

  //Returns all the data in map
  Map<String, dynamic> toMap() {
    //UserProfile Data
    Map<String, dynamic> mapData = <String, dynamic>{};

    if (uid != null && uid != '') mapData['user_uid'] = uid;

    if (firstName != null && firstName != '') mapData['user_first_name'] = firstName;
    if (lastName != null && lastName != '') mapData['user_last_name'] = lastName;
    if (email != null && email != '') mapData['user_email'] = email;
    if (profilePictureURL != null && profilePictureURL != '') mapData['user_profile_picture_url'] = profilePictureURL;
    if (interests != null) mapData['user_interests'] = interests;

    return mapData;
  }

  ///Returns if the UserProfile is registered
  bool isRegistered() {
    if (uid != null && uid != '' && email != null && email != '') {
      return true;
    } else {
      return false;
    }
  }

  ///Returns if the UserProfile is initialized with data
  bool isLoggedIn() {
    if (uid != null && uid != '' && email != null && email != '') {
      return true;
    } else {
      return false;
    }
  }
}
