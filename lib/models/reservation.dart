import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final int quantity;
  final Timestamp bookingDate;
  final String request;
  final String resId;
  final String status;
  final String userId;

  Reservation({
    required this.quantity,
    required this.bookingDate,
    required this.request,
    required this.resId,
    required this.status,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "bookingDate": bookingDate,
        "request": request,
        "resId": resId,
        "status": status,
        "userId": userId,
      };

  static Reservation fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Reservation(
      quantity: snapshot['quantity'],
      bookingDate: snapshot['bookingDate'],
      request: snapshot['request'],
      resId: snapshot['resId'],
      status: snapshot['status'],
      userId: snapshot['userId'],
    );
  }
}
