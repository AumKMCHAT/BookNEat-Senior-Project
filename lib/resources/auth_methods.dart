import 'dart:io';
import 'package:book_n_eat_senior_project/models/menu.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model_user;
import 'package:book_n_eat_senior_project/models/restuarant.dart'
    as model_restaurant;
import 'package:book_n_eat_senior_project/models/reservation.dart'
    as model_reservation;
import 'package:book_n_eat_senior_project/resources/storage_methods.dart';
import 'package:book_n_eat_senior_project/utils/restaurant_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/time.dart';
import 'package:geolocator/geolocator.dart';

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
      required String telephone,
      Uint8List? file,
      String role = "customer"}) async {
    String res = "Some error occurred";
    if (file == null) {
      final ByteData bytes = await rootBundle.load(
          '/Users/kmchat/FlutterProject/book_n_eat_senior_project/assets/images/userPic.jpg');
      final Uint8List list = bytes.buffer.asUint8List();
      file = list;
    }
    try {
      print("pass to auth_methods");
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          firstName.isNotEmpty &&
          telephone.isNotEmpty &&
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
              telephone: telephone,
              photoUrl: photoUrl);

          await _firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());

          res = "success";
        } else {
          res = 'Password is not match';
        }
      } else {
        res = ("Please fill every box");
      }
    } on FirebaseAuthException catch (err) {
      if (err.code.isNotEmpty) {
        res = err.message!;
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
    } on FirebaseAuthException catch (err) {
      if (err.code.isNotEmpty) {
        res = err.message!;
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
      required List<File> files,
      required String telephone,
      required int maxPerson,
      required bool status,
      String role = "restaurant",
      required Timestamp timeOpen,
      required Timestamp timeClose,
      required int workingMinute,
      required File filePdf,
      required List<String> days}) async {
    String res = "Some error occurred";
    List<String> photoUrls = [];

    // current user foreignkey
    final User? user = _auth.currentUser;
    final currentUserUid = user!.uid;

    var collection = _firestore.collection('users');
    try {
      int count = files.length;
      files.forEach((element) async {
        String photoUrl =
            await StorageMethods().uploadFile('restaurantPics', element, false);
        print(photoUrl);
        photoUrls.add(photoUrl);
        count--;

        double lat = position.latitude;
        double long = position.longitude;
        GeoPoint geoPoint = GeoPoint(lat, long);

        // update role
        if (count == 0) {
          String filePdfPath = await StorageMethods().uploadFilePdf(filePdf);
          await collection
              .doc(currentUserUid) // <-- Doc ID where data should be updated.
              .update({'role': role}) // <-- Updated data
              .then((_) => print('Updated'))
              .catchError((error) => print('Update failed: $error'));

          collection
              .doc(currentUserUid)
              .update({'resId': name})
              .then((value) => print("Add resId to users"))
              .catchError((error) => print('Add failed: $error'));
          model_restaurant.Restaurant restaurant = model_restaurant.Restaurant(
              resId: name,
              name: name,
              statusManual: auto,
              menuUrl: filePdfPath,
              category: category,
              location: geoPoint,
              photoUrl: photoUrls,
              telephone: telephone,
              maxPerson: maxPerson,
              status: status,
              days: days,
              timeOpen: timeOpen,
              timeClose: timeClose,
              workingMinute: workingMinute,
              userId: currentUserUid);

          await _firestore
              .collection('restaurants')
              .doc(name)
              .set(restaurant.toJson());
          res = "success";
        }
      });
    } on FirebaseException catch (e) {
      if (e.code.isNotEmpty) {
        res = e.message!;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> bookingRestaurant({
    required int quantity,
    required Timestamp bookingDate,
    required String request,
    required String resId,
    required String status,
    required String userId,
  }) async {
    String res = "Some error occurred";
    try {
      model_reservation.Reservation reservation = model_reservation.Reservation(
        userId: userId,
        quantity: quantity,
        bookingDate: bookingDate,
        request: request,
        resId: resId,
        status: status,
      );

      await _firestore
          .collection('reservations')
          .doc()
          .set(reservation.toJson());

      res = "success";
    } on FirebaseAuthException catch (err) {
      if (err.code.isNotEmpty) {
        res = err.message!;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateRestaurantMenu(
      {required File filePdf, required String resId}) async {
    String res = "waiting";
    String oldFilePdfPath = await _firestore
        .collection('restaurants')
        .doc(resId)
        .get()
        .then((DocumentSnapshot snapshot) =>
            snapshot.get(FieldPath(['menuUrl'])));
    print(oldFilePdfPath);
    StorageMethods().deleteFileMenu(oldFilePdfPath);
    String newFilePdfPath = await StorageMethods().uploadFilePdf(filePdf);
    if (newFilePdfPath.isNotEmpty) {
      await _firestore
          .collection('restaurants')
          .doc(resId)
          .update({'menuUrl': newFilePdfPath})
          .then((value) => res = "ระบบได้เปลี่ยนเมนูใหม่เรียบร้อยแล้ว")
          .catchError((error) => res = error.toString());
    }
    return res;
  }
}
