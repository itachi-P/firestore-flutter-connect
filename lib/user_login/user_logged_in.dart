class UserLoggedIn {
//  String _loggedInUserId = null;
//
//  String userLoggedIn(AuthResult result) {
//    if (result != null) {
//      _loggedInUserId = result.user.uid;
//    }
//    return _loggedInUserId;
//  }

  bool _loggedIn = false;

  bool userLoggedIn() {
    return _loggedIn;
  }
}
