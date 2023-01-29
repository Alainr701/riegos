import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          // ignore: unnecessary_null_comparison
          file != null) {
        // registering user in auth with email and password
        // UserCredential cred = await _auth.createUserWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );

        // String photoUrl =
        //     await StorageMethods().uploadImageToStorage('profilePics', file, false);

        // model.User _user = model.User(
        //   username: username,
        //   uid: cred.user!.uid,
        //   photoUrl: photoUrl,
        //   email: email,
        //   bio: bio,
        //   followers: [],
        //   following: [],
        // );

        // adding user in our database
        // await _firestore
        //     .collection("users")
        //     .doc(cred.user!.uid)
        //     .set(_user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    bool isSignedIn = false;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        isSignedIn = true;
      }
    } catch (err) {
      return isSignedIn;
    }
    return isSignedIn;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
