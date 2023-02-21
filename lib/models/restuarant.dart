import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Restaurant {
  final String resId;
  final String name; // text
  final String category; // list
  final GeoPoint location; // map pin and get geopoint
  final String timeAvialable; // don't know
  final List<String> photoUrl; // multiple img
  final String telephone; // + button
  final bool status; // boolean true | false
  final String userId;

  const Restaurant(
      {required this.resId,
      required this.name,
      required this.category,
      required this.location,
      required this.timeAvialable,
      required this.photoUrl,
      required this.telephone,
      required this.status,
      required this.userId});

  Map<String, dynamic> toJson() => {
        "resId": resId,
        "name": name,
        "category": category,
        "location": location,
        "timeAvialable": timeAvialable,
        "photoUrl": photoUrl,
        "telephone": telephone,
        "status": status,
        "userId": userId
      };

  static Restaurant fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Restaurant(
      resId: snapshot['resId'],
      name: snapshot['name'],
      category: snapshot['category'],
      location: snapshot['location'],
      timeAvialable: snapshot['timeAvialable'],
      photoUrl: snapshot['photoUrl'],
      telephone: snapshot['telephone'],
      status: snapshot['status'],
      userId: snapshot['userId'],
    );
  }
}
