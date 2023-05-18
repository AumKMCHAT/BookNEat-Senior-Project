import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/utils/restaurant_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/app_bar.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model;
import 'package:intl/intl.dart';

import 'info_res_screen.dart';

class RatingCommentScreen extends StatefulWidget {
  final String name;
  final String date;
  final Timestamp bookingTimestamp;

  RatingCommentScreen(
      {super.key,
      required this.name,
      required this.date,
      required this.bookingTimestamp});
  @override
  _RatingCommentScreenState createState() => _RatingCommentScreenState();
}

class _RatingCommentScreenState extends State<RatingCommentScreen> {
  double _rating = 0.0;
  String _comment = '';
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  final firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final userCheck = context.watch<User?>();
    String uid = _auth.currentUser!.uid;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('reservations');
    Query query = collectionRef
        .where('userId', isEqualTo: uid)
        .where('bookingDate', isEqualTo: widget.bookingTimestamp);
    return Scaffold(
      appBar: homeAppBar(context),
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (userCheck == null) {
              model.User user = Provider.of<UserProvider>(context).getUser;
              return SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 150, 0),
                    child: Text(
                      'Rate this restaurant:',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 130, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.star_rounded,
                            size: 40,
                          ),
                          color: _rating >= 1 ? Colors.yellow : Colors.grey,
                          onPressed: () {
                            setState(() {
                              _rating = 1.0;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star_rounded,
                            size: 40,
                          ),
                          color: _rating >= 2 ? Colors.yellow : Colors.grey,
                          onPressed: () {
                            setState(() {
                              _rating = 2.0;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star_rounded,
                            size: 40,
                          ),
                          color: _rating >= 3 ? Colors.yellow : Colors.grey,
                          onPressed: () {
                            setState(() {
                              _rating = 3.0;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star_rounded,
                            size: 40,
                          ),
                          color: _rating >= 4 ? Colors.yellow : Colors.grey,
                          onPressed: () {
                            setState(() {
                              _rating = 4.0;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.star_rounded,
                            size: 40,
                          ),
                          color: _rating >= 5 ? Colors.yellow : Colors.grey,
                          onPressed: () {
                            setState(() {
                              _rating = 5.0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 150, 30),
                    child: Text(
                      'Leave a comment:',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: 360,
                      height: 160,
                      child: TextField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          hintText: 'Type your comment here',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _comment = value;
                          });
                        },
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.all(15)),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white, // Set the text color
                        fontSize: 16, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance.collection('reviews').add({
                        'star': _rating,
                        'comment': _comment,
                        'date': formattedDate,
                        'username': user.firstName + ' ' + user.lastName,
                        'resId': widget.name,
                        'photoUrl': user.photoUrl
                      });
                      query.get().then((querySnapshot) {
                        querySnapshot.docs.forEach((doc) {
                          doc.reference
                              .update({'status': statusReviewed})
                              .then((value) =>
                                  print("Field updated successfully!"))
                              .catchError((error) =>
                                  print("Failed to update field: $error"));
                        });
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResMainScreen()));
                    },
                  ),
                ],
              ));
            }
            return Text('User data is not available');
          }),
    );
  }
}
