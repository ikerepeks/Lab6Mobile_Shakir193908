import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object based on fb user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anon method
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in email & pass
  Future signInWithEmailAndPassword(String email, String pw) async {
    try {
      AuthResult result =
          await _auth.signInWithEmailAndPassword(email: email, password: pw);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email & pass
  Future registerWithEmailAndPassword(String email, String pw) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pw);
      FirebaseUser user = result.user;

      // create doc for the user using uid
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'new crew member', 100);

      // return user info in string
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
