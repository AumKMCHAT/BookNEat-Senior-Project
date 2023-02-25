import 'package:book_n_eat_senior_project/screens/rating_screen.dart';
import 'package:book_n_eat_senior_project/widgets/res_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model;
import 'package:url_launcher/url_launcher.dart';
import '../providers/user_provider.dart';
import '../widgets/app_bar.dart';

class ResScreen extends StatefulWidget {
  final String name;

  ResScreen({super.key, required this.name});

  @override
  State<ResScreen> createState() => _ResScreenState();
}

class _ResScreenState extends State<ResScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference saves =
      FirebaseFirestore.instance.collection('save');
  bool isSaved = false;
  @override
  void initState() {
    super.initState();
    // getFirstName();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  checkData(iSaved, user, res) {}

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: homeAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                    child: Text(widget.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 20,
                        ))),
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('save').snapshots(),
                  builder: (context, snapshot) {
                    // Check if there's data in the collection
                    if (snapshot.hasData) {
                      // Loop through the documents in the collection
                      for (DocumentSnapshot doc in snapshot.data!.docs) {
                        // Check if the data that you saved earlier exists in the collection
                        if (doc.get('userId') == user.userId &&
                            doc.get('resId') == widget.name) {
                          // Set isSaved to true
                          print('success');
                          // isSaved = true;
                          setState(() {
                            isSaved = true;
                          });
                        }
                      }
                    }
                    return SizedBox(
                      width: 100,
                      height: 100,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(130, 5, 0, 0),
                        child: IconButton(
                          iconSize: 30.0,
                          icon: isSaved
                              ? Icon(Icons.favorite)
                              : Icon(Icons.favorite_border_outlined),
                          onPressed: () async {
                            if (isSaved == false) {
                              print('faleid');
                              saves.add({
                                'resId': widget.name,
                                'userId': user.userId,
                              });
                              isSaved = true;
                            } else {
                              CollectionReference collectionRef =
                                  FirebaseFirestore.instance.collection('save');
                              Query query = collectionRef
                                  .where('resId', isEqualTo: widget.name)
                                  .where('userId', isEqualTo: user.userId);
                              query.get().then((querySnapshot) {
                                querySnapshot.docs.forEach((doc) {
                                  doc.reference.delete();
                                  isSaved = false;
                                });
                              }).catchError((error) =>
                                  print('Error querying documents: $error'));
                            }
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
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
                      String googleUrl =
                          'https://www.google.com/maps/search/?api=1&query=$latitude,$longtitude';
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
                                onPressed: () async {
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
                                  if (await canLaunch(googleUrl)) {
                                    await launch(googleUrl);
                                  } else {
                                    throw 'Could not open the map.';
                                  }
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
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
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
                                                RatingCommentScreen()));
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
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            ),
            Column(
              children: [
                Text(
                  "Menu",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: TextButton(
            style: OutlinedButton.styleFrom(padding: EdgeInsets.all(15)),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ReservScreen()));
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
