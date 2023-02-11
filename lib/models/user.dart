import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String photoUrl;

  const User({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "role": role,
        "photoUrl": photoUrl
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        uid: snapshot['uid'],
        email: snapshot['email'],
        firstName: snapshot['firstName'],
        lastName: snapshot['lastName'],
        role: snapshot['role'],
        photoUrl: snapshot['photoUrl']);
  }
}
