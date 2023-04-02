import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/rating_screen.dart';
import '../utils/restaurant_category.dart';

class HistoryItem extends StatefulWidget {
  final String resName;
  final String date;
  final String status;
  final Timestamp bookingTimestamp;

  const HistoryItem(
      {super.key,
      required this.resName,
      required this.date,
      required this.status,
      required this.bookingTimestamp});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser!.uid;
    List<String> texts = [widget.resName, widget.date, widget.status];
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('reservations');
    Query query = collectionRef
        .where('resId', isEqualTo: widget.resName)
        .where('status', isEqualTo: statusPending)
        .where('userId', isEqualTo: uid);
    int test = 0;
    return Column(
      children: [
        Container(
          height: 100,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0, bottom: 0, top: 10),
              child: Text(
                widget.resName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            subtitle: Row(
              children: [
                Align(
                    alignment: Alignment.centerLeft, child: Text(widget.date)),
                if (widget.status == statusPending) ...[
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                    'ท่านยืนยันจะทำรายยกเลิกใช่หรือหรือไม่'),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        textStyle:
                                            TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      query.get().then((querySnapshot) {
                                        querySnapshot.docs.forEach((doc) {
                                          doc.reference
                                              .update(
                                                  {'status': statusCanceled})
                                              .then((value) => print(
                                                  "Field updated successfully!"))
                                              .catchError((error) => print(
                                                  "Failed to update field: $error"));
                                        });
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Confirm'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Cancel')),
                  ),
                ]
              ],
            ),
            trailing: SizedBox(
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.status == 'Completed')
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RatingCommentScreen(
                                        name: widget.resName,
                                        date: widget.date,
                                        bookingTimestamp:
                                            widget.bookingTimestamp,
                                      )));
                        },
                        child: Text('Review')),
                  if (widget.status == 'Pending')
                    Column(
                      children: [
                        Text(
                          'Pending',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  if (widget.status == 'Canceled')
                    Text(
                      'Canceled',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  if (widget.status == 'Reviewed')
                    Text(
                      'Done',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  if (widget.status == 'Confirmed')
                    Text(
                      'Confirmed',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }
}
