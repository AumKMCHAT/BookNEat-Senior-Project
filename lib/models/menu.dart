import 'package:cloud_firestore/cloud_firestore.dart';

class Menu {
  String name;
  String price;
  String description;

  Menu({
    required this.name,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "description": description,
      };

  static Menu fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Menu(
        name: snapshot['name'],
        price: snapshot['price'],
        description: snapshot['description']);
  }
}
