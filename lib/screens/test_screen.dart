import 'package:book_n_eat_senior_project/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model;
import '../providers/user_provider.dart';
import '../widgets/res_card.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> resnames = [];

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  Future<void> _getUsers() async {
    QuerySnapshot snapshot = await _firestore
        .collection('save')
        .where('userId', isEqualTo: 'U6aUNtE3w0gp5OUDbThPoWTTIfu2')
        .get();
    List<Map<String, dynamic>> data =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    List<String> resnames =
        data.map((item) => item['resId'] as String).toList();
    setState(() {
      this.resnames = resnames;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: homeAppBar(context),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('restaurants')
              .where('resId', whereIn: resnames)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var document = snapshot.data!.docs[index];
                final List<dynamic> myList =
                    document['photoUrl'] as List<dynamic>;
                return ResCard(
                    title: document['name'],
                    catagory: document['category'],
                    status: 'Open',
                    photo: [myList[0]]);
              },
            );
          },
        ));
  }
}
