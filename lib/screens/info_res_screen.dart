import 'package:book_n_eat_senior_project/screens/booking_screen.dart';
import 'package:book_n_eat_senior_project/screens/review_list_screen.dart';
import 'package:book_n_eat_senior_project/widgets/dialog_box_booked.dart';
import 'package:book_n_eat_senior_project/widgets/res_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_bar.dart';
import 'package:book_n_eat_senior_project/utils/restaurant_category.dart';
import 'package:intl/intl.dart';

class ResScreen extends StatefulWidget {
  final String name;

  ResScreen({super.key, required this.name});

  @override
  State<ResScreen> createState() => _ResScreenState();
}

class _ResScreenState extends State<ResScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference saves =
      FirebaseFirestore.instance.collection('save');
  bool isSaved = false;
  double average = 0;
  List<double> numbers = [];
  List<String> saveRes = [''];
  String dutyTime = '';
  List<dynamic> dutyDateList = [];
  String dutyDate = '';
  bool isBooked = false;

  @override
  void initState() {
    super.initState();
    getRating();
    getDutyTime();
    getRes();
    checkBooking();
  }

  void checkBooking() async {
    QuerySnapshot snapshot = await _firestore
        .collection('reservations')
        .where('resId', isEqualTo: widget.name)
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('status', whereIn: [statusPending, statusConfirmed]).get();

    List<Map<String, dynamic>> data =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    if (data.isNotEmpty) {
      isBooked = true;
    }
    // query reservations "userId", "resId" that have status not Reviewed
    // setState isBooked = true
    // change button Reserver a Table to route dialog box
  }

  Future<void> getDutyTime() async {
    String uid = _auth.currentUser!.uid;
    // Get Open/Close time
    QuerySnapshot resSnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .where('resId', isEqualTo: widget.name)
        .get();
    QueryDocumentSnapshot resDocSnapshot = resSnapshot.docs[0];
    DateTime openTimes = resDocSnapshot.get('timeOpen').toDate();
    DateTime closeTimes = resDocSnapshot.get('timeClose').toDate();
    String formattedOpenTime = DateFormat.jm().format(openTimes);
    String formattedCloseTime = DateFormat.jm().format(closeTimes);
    dutyDateList = resDocSnapshot.get('days');
    // dutyDateList = resDocSnapshot.get('days');

    setState(() {
      this.dutyTime = formattedOpenTime + ' - ' + formattedCloseTime;
      for (var i in dutyDateList) {
        dutyDate = dutyDate + i + ' ';
      }
    });
  }

  Future<void> getRes() async {
    String uid = _auth.currentUser!.uid;
    // Check Save Restaurant Status
    QuerySnapshot snapshot = await _firestore
        .collection('save')
        .where('resId', isEqualTo: widget.name)
        .where('userId', isEqualTo: uid)
        .get();
    List<Map<String, dynamic>> data =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    List<String> resnames =
        data.map((item) => item['resId'] as String).toList();
    // Save data to variable
    setState(() {
      saveRes = resnames;
      if (saveRes[0] == widget.name) {
        isSaved = !isSaved;
      }
    });
  }

  Future<void> getRating() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot querySnapshot = await _firestore
        .collection('reviews')
        .where('resId', isEqualTo: widget.name)
        .get();
    querySnapshot.docs.forEach((doc) {
      numbers.add(doc['star']);
    });
    average = numbers.isNotEmpty
        ? (numbers.reduce((a, b) => a + b) / numbers.length).toPrecision(2)
        : 0;
    setState(() {});
  }

  void saveRestaurant(String user, String restaurant) async {
    if (isSaved) {
      Query myQuery = FirebaseFirestore.instance
          .collection('save')
          .where('userId', isEqualTo: user)
          .where('resId', isEqualTo: restaurant);
      QuerySnapshot querySnapshot = await myQuery.get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      documents.forEach((document) {
        document.reference.delete();
      });
      setState(() {
        isSaved = !isSaved;
      });
    } else {
      FirebaseFirestore.instance.collection('save').add({
        'resId': restaurant,
        'userId': user,
      });
      setState(() {
        isSaved = !isSaved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser!.uid;

    return Scaffold(
      appBar: homeAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
                    child: Text(
                      widget.name + '   ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    )),
                if (average > 0)
                  Text(
                    average.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                if (average > 0)
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
                    child: IconButton(
                      iconSize: 30.0,
                      icon: isSaved
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_outline_rounded),
                      onPressed: () async {
                        saveRestaurant(uid, widget.name);
                      },
                    ),
                  ),
                )
              ],
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 25),
                  child: Text(
                    'Open times:  ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 15),
                  child: Text(
                    dutyDate + ' | ' + dutyTime,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('restaurants')
                  .where('name', isEqualTo: widget.name)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final data = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();
                return SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = data[index];
                      final List<dynamic> myList =
                          item['photoUrl'] as List<dynamic>;
                      final String telephone = item['telephone'];
                      final double longtitude = item['location'].longitude;
                      final double latitude = item['location'].latitude;
                      final String menuUrl = item['menuUrl'];
                      return Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 30, bottom: 30),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                ),
                                items: myList
                                    .map((e) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              Image(
                                                image: NetworkImage(e),
                                                width: 1050,
                                                height: 350,
                                                fit: BoxFit.cover,
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: TextButton(
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.all(15)),
                                onPressed: () {
                                  launch("tel:$telephone");
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 24.0,
                                    ),
                                    Text("          Phone Number")
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: TextButton(
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.all(15)),
                                onPressed: () async {
                                  var locationUrl =
                                      "https://www.google.com/maps/search/?api=1&query=$latitude,$longtitude";
                                  await launch(locationUrl);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      size: 24.0,
                                    ),
                                    Text("          Get Location")
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: SizedBox(
                              height: 62,
                              child: TextButton(
                                  style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.all(15)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReviewListScreen(
                                                  resName: widget.name,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.reviews,
                                        size: 24.0,
                                      ),
                                      Text("          Review")
                                    ],
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                            child: SizedBox(
                              height: 62,
                              child: TextButton(
                                  style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.all(15)),
                                  onPressed: () {
                                    var url = menuUrl;
                                    launch(url);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.menu_book,
                                        size: 24.0,
                                      ),
                                      Text("          Menu")
                                    ],
                                  )),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: TextButton(
            style: OutlinedButton.styleFrom(padding: EdgeInsets.all(15)),
            onPressed: () {
              if (isBooked)
                showDialog(
                    context: context,
                    builder: (context) {
                      return DialogBoxBooked(
                        onCancel: () => Navigator.of(context).pop(),
                      );
                    });
              if (!isBooked)
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookingScreen(
                              workDay: dutyDateList,
                              resId: widget.name,
                            )));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 100),
              child: Row(
                children: [
                  Icon(
                    Icons.table_restaurant_outlined,
                    size: 24.0,
                  ),
                  Text(
                    "    Reserver a Table",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
