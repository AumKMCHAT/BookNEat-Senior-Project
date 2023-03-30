import 'package:book_n_eat_senior_project/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/review_card.dart';

class ReviewListScreen extends StatefulWidget {
  final String resName;
  const ReviewListScreen({super.key, required this.resName});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 250, 15),
          child: Text('Reviews',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('resId', isEqualTo: widget.resName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];
                  String star = item['star'].toString();
                  return ReviewCard(
                    name: item['username'],
                    comment: item['comment'],
                    star: star,
                    photoUrl: item['photoUrl'],
                  );
                },
              ),
            );
          },
        )
      ]),
    );
  }
}
