import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String resId;
  final String name; // text
  final String category; // list
  final GeoPoint location; // map pin and get geopoint
  final List<String> days;
  final Timestamp timeOpen;
  final Timestamp timeClose;
  final int workingMinute;
  final List<String> photoUrl; // multiple img
  final String telephone; // + button
  final bool status; // boolean true | false
  final String userId;

  const Restaurant({
    required this.resId,
    required this.name,
    required this.category,
    required this.location,
    required this.photoUrl,
    required this.telephone,
    required this.status,
    required this.userId,
    required this.days,
    required this.timeOpen,
    required this.timeClose,
    required this.workingMinute,
  });

  Map<String, dynamic> toJson() => {
        "resId": resId,
        "name": name,
        "category": category,
        "location": location,
        "photoUrl": photoUrl,
        "telephone": telephone,
        "status": status,
        "days": days,
        "timeOpen": timeOpen,
        "timeClose": timeClose,
        "workingMinute": workingMinute,
        "userId": userId
      };

  static Restaurant fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Restaurant(
      resId: snapshot['resId'],
      name: snapshot['name'],
      category: snapshot['category'],
      location: snapshot['location'],
      photoUrl: snapshot['photoUrl'],
      telephone: snapshot['telephone'],
      status: snapshot['status'],
      days: snapshot['days'],
      timeOpen: snapshot['timeOpen'],
      timeClose: snapshot['timeClose'],
      workingMinute: snapshot['workingMinute'],
      userId: snapshot['userId'],
    );
  }
}
