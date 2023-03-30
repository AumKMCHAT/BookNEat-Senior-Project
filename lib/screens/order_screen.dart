import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> resnames = [''];

  @override
  void initState() {
    super.initState();
    getRes();
  }

  Future<void> getRes() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await _firestore
        .collection('restaurants')
        .where('userId', isEqualTo: uid)
        .get();
    List<Map<String, dynamic>> data =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    List<String> resnames =
        data.map((item) => item['resId'] as String).toList();
    setState(() {
      this.resnames = resnames;
    });
    print(resnames);
  }

  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser!.uid;
    int count = 0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                .where('status', isEqualTo: 'Pending')
                .where('resId', whereIn: resnames)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('No Order Yet');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              return SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.docs[index];
                    Timestamp timestamp = item['bookingDate'];
                    DateTime dateTime = timestamp.toDate().toLocal();
                    String dateString =
                        DateFormat('dd.MM.yyyy  hh:mm aaa').format(dateTime);
                    return ListTile(
                      title: Padding(
                        padding:
                            const EdgeInsets.only(left: 0, bottom: 20, top: 10),
                        child: Text(
                          dateString,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'request: ' + item['request'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(item['quantity'].toString() + ' คน'),
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item['status'] == 'Pending') ...[
                            ElevatedButton(
                                onPressed: () {
                                  CollectionReference collectionRef =
                                      FirebaseFirestore.instance
                                          .collection('reservations');

                                  Query query = collectionRef
                                      .where('resId', isEqualTo: item['resId'])
                                      .where('bookingDate',
                                          isEqualTo: item['bookingDate'])
                                      .where('userId',
                                          isEqualTo: item['userId']);
                                  query.get().then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference
                                          .update({'status': 'Confirmed'})
                                          .then((value) => print(
                                              "Field updated successfully!"))
                                          .catchError((error) => print(
                                              "Failed to update field: $error"));
                                    });
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderScreen()));
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
                                      .where('resId', isEqualTo: item['resId'])
                                      .where('bookingDate',
                                          isEqualTo: item['bookingDate'])
                                      .where('userId',
                                          isEqualTo: item['userId']);
                                  query.get().then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference
                                          .update({'status': 'Canceled'})
                                          .then((value) => print(
                                              "Field updated successfully!"))
                                          .catchError((error) => print(
                                              "Failed to update field: $error"));
                                    });
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderScreen()));
                                },
                                child: Text('Cancel')),
                          ],
                          if (item['status'] == 'Confirmed')
                            ElevatedButton(
                                onPressed: () {
                                  CollectionReference collectionRef =
                                      FirebaseFirestore.instance
                                          .collection('reservations');

                                  Query query = collectionRef
                                      .where('resId', isEqualTo: item['resId'])
                                      .where('bookingDate',
                                          isEqualTo: item['bookingDate'])
                                      .where('userId',
                                          isEqualTo: item['userId']);
                                  query.get().then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference
                                          .update({'status': 'Completed'})
                                          .then((value) => print(
                                              "Field updated successfully!"))
                                          .catchError((error) => print(
                                              "Failed to update field: $error"));
                                    });
                                  });
                                  setState(() {
                                    count++;
                                  });
                                },
                                child: Text('Success'))
                        ],
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
