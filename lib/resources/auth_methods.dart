import 'dart:typed_data';
import 'package:book_n_eat_senior_project/models/user.dart' as model;
import 'package:book_n_eat_senior_project/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMedthods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firetore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firetore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  // sign up user
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String confirmPassword,
      required String firstName,
      required String lastName,
      required Uint8List file,
      String role = "customer"}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty) {
        if (password == confirmPassword) {
          // register user
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          print(cred.user!.uid);

          String photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
          // add user to database

          model.User user = model.User(
              uid: cred.user!.uid,
              email: email,
              firstName: firstName,
              lastName: lastName,
              role: role,
              photoUrl: photoUrl);

          await _firetore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());

          res = "success";
        } else {
          print("password is not match");
        }
      } else {
        print("fill every box");
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted.';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        res = 'worong-password';
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
