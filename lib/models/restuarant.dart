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
  final int maxPerson;
  final bool status; // boolean true | false
  final String userId;
  final String menuUrl;

  const Restaurant({
    required this.resId,
    required this.name,
    required this.category,
    required this.location,
    required this.photoUrl,
    required this.telephone,
    required this.maxPerson,
    required this.status,
    required this.userId,
    required this.days,
    required this.timeOpen,
    required this.timeClose,
    required this.workingMinute,
    required this.menuUrl,
  });

  Map<String, dynamic> toJson() => {
        "resId": resId,
        "name": name,
        "category": category,
        "location": location,
        "photoUrl": photoUrl,
        "telephone": telephone,
        "maxPerson": maxPerson,
        "status": status,
        "days": days,
        "timeOpen": timeOpen,
        "timeClose": timeClose,
        "workingMinute": workingMinute,
        "userId": userId,
        "menuUrl": menuUrl
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
      maxPerson: snapshot['manPerson'],
      status: snapshot['status'],
      days: snapshot['days'],
      timeOpen: snapshot['timeOpen'],
      timeClose: snapshot['timeClose'],
      workingMinute: snapshot['workingMinute'],
      userId: snapshot['userId'],
      menuUrl: snapshot['menuUrl'],
    );
  }
}
