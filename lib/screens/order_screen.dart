import 'package:book_n_eat_senior_project/screens/profile_screen.dart';
import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import '../utils/restaurant_category.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> resnames = [''];
  String resName = '';

  @override
  void initState() {
    super.initState();
    getResName();
  }

  Future<void> getResName() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot querySnapshot = await _firestore
        .collection('restaurants')
        .where('userId', isEqualTo: uid)
        .get();
    QueryDocumentSnapshot snapshot = querySnapshot.docs[0];

    setState(() {
      this.resName = snapshot.get('resId');
      print(resName);
    });
  }

  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Book n Eat',
          style: TextStyle(color: kPrimaryColor),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResMainScreen()));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(50, 30, 250, 15),
            child: Text('Orders',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('reservations')
                .where('status', whereNotIn: [
              statusReviewed,
              statusCanceled,
              statusCompleted
            ]).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('No Order Yet');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return SizedBox(
                height: 700,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.docs[index];
                    Timestamp timestamp = item['bookingDate'];
                    DateTime dateTime = timestamp.toDate().toLocal();
                    String dateString =
                        DateFormat('dd/MM/yyyy  hh:mm aaa').format(dateTime);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 180,
                        child: Column(
                          children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, bottom: 20, top: 10),
                                child: Text(
                                  dateString,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                              subtitle: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    Text(
                                      'Request: ' + item['request'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Quantity: ' +
                                        item['quantity'].toString() +
                                        ' คน'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (item['status'] == statusPending) ...[
                                    ElevatedButton(
                                        onPressed: () {
                                          CollectionReference collectionRef =
                                              FirebaseFirestore.instance
                                                  .collection('reservations');

                                          Query query = collectionRef
                                              .where('resId',
                                                  isEqualTo: item['resId'])
                                              .where('bookingDate',
                                                  isEqualTo:
                                                      item['bookingDate'])
                                              .where('userId',
                                                  isEqualTo: item['userId']);
                                          query.get().then((querySnapshot) {
                                            querySnapshot.docs.forEach((doc) {
                                              doc.reference
                                                  .update({
                                                    'status': statusConfirmed
                                                  })
                                                  .then((value) => print(
                                                      "Field updated successfully!"))
                                                  .catchError((error) => print(
                                                      "Failed to update field: $error"));
                                            });
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderScreen()));
                                        },
                                        child: Text('Accept')),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors
                                              .red, // set the button's background color
                                        ),
                                        onPressed: () {
                                          CollectionReference collectionRef =
                                              FirebaseFirestore.instance
                                                  .collection('reservations');

                                          Query query = collectionRef
                                              .where('resId',
                                                  isEqualTo: item['resId'])
                                              .where('bookingDate',
                                                  isEqualTo:
                                                      item['bookingDate'])
                                              .where('userId',
                                                  isEqualTo: item['userId']);
                                          query.get().then((querySnapshot) {
                                            querySnapshot.docs.forEach((doc) {
                                              doc.reference
                                                  .update({
                                                    'status': statusCanceled
                                                  })
                                                  .then((value) => print(
                                                      "Field updated successfully!"))
                                                  .catchError((error) => print(
                                                      "Failed to update field: $error"));
                                            });
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderScreen()));
                                        },
                                        child: Text('Cancel')),
                                  ],
                                  if (item['status'] == statusConfirmed)
                                    ElevatedButton(
                                        onPressed: () {
                                          CollectionReference collectionRef =
                                              FirebaseFirestore.instance
                                                  .collection('reservations');

                                          Query query = collectionRef
                                              .where('resId',
                                                  isEqualTo: item['resId'])
                                              .where('bookingDate',
                                                  isEqualTo:
                                                      item['bookingDate'])
                                              .where('userId',
                                                  isEqualTo: item['userId']);
                                          query.get().then((querySnapshot) {
                                            querySnapshot.docs.forEach((doc) {
                                              doc.reference
                                                  .update({
                                                    'status': statusCompleted
                                                  })
                                                  .then((value) => print(
                                                      "Field updated successfully!"))
                                                  .catchError((error) => print(
                                                      "Failed to update field: $error"));
                                            });
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderScreen()));
                                        },
                                        child: Text('Success'))
                                ],
                              ),
                            ),
                            const Divider(color: Colors.grey, thickness: 1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
