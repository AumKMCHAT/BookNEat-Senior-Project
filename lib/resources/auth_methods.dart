import 'dart:io';
import 'dart:typed_data';
import 'package:book_n_eat_senior_project/models/user.dart' as model_user;
import 'package:book_n_eat_senior_project/models/restuarant.dart'
    as model_restaurant;
import 'package:book_n_eat_senior_project/resources/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AuthMedthods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model_user.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model_user.User.fromSnap(snap);
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

          model_user.User user = model_user.User(
              userId: cred.user!.uid,
              email: email,
              firstName: firstName,
              lastName: lastName,
              role: role,
              photoUrl: photoUrl);

          await _firestore
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

  Future<String> signUpRestaurant(
      {required String name,
      required String category,
      required Position position,
      required String timeAvialable,
      required List<File> files,
      required String telephone,
      required bool status,
      String role = "restaurant"}) async {
    String res = "Some error occurred";
    List<String> photoUrls = [];

    // current user foreignkey
    final User? user = _auth.currentUser;
    // final currentUserUid = user!.uid;
    const currentUserUid = "U6aUNtE3w0gp5OUDbThPoWTTIfu2";
    print(currentUserUid);

    var collection = _firestore.collection('users');
    collection
        .doc(currentUserUid) // <-- Doc ID where data should be updated.
        .update({'role': role}) // <-- Updated data
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));

    try {
      files.forEach((element) async {
        String photoUrl =
            await StorageMethods().uploadFile('restaurantPics', element, false);
        print(photoUrl);
        photoUrls.add(photoUrl);
      });

      print('photoUrls: $photoUrls');
      double lat = position.latitude;
      double long = position.longitude;
      GeoPoint geoPoint = GeoPoint(lat, long);

      // update role
      model_restaurant.Restaurant restaurant = model_restaurant.Restaurant(
          resId: name,
          name: name,
          category: category,
          location: geoPoint,
          timeAvialable: timeAvialable,
          photoUrl: photoUrls,
          telephone: telephone,
          status: status,
          userId: currentUserUid);

      await _firestore
          .collection('restaurants')
          .doc(name)
          .set(restaurant.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
