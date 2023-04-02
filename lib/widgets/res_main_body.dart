import 'package:book_n_eat_senior_project/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/restaurant_category.dart';
import 'catagory_item.dart';
import 'res_card.dart';
import 'package:intl/intl.dart';

class ResBody extends StatefulWidget {
  const ResBody({super.key});

  @override
  State<ResBody> createState() => _ResBodyState();
}

class _ResBodyState extends State<ResBody> {
  final firestoreInstance = FirebaseFirestore.instance;
  String type = '';
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    updateStatusRes();
  }

  Future<void> updateStatusRes() async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('restaurants');
    final QuerySnapshot querySnapshot = await collection.get();
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('EEE').format(currentDate);

    for (final DocumentSnapshot document in querySnapshot.docs) {
      final Timestamp timeOpen = document['timeOpen'];
      final Timestamp timeClose = document['timeClose'];
      final String statusManual = document['statusManual'];

      final TimeOfDay timeOpenOfDay = TimeOfDay.fromDateTime(timeOpen.toDate());
      final TimeOfDay timeCloseOfDay =
          TimeOfDay.fromDateTime(timeClose.toDate());

      final TimeOfDay currentTime = TimeOfDay.now();
      List<String> myArray = document.get('days').cast<String>();

      int index = myArray.indexOf(formattedDate);

      if (currentTime.hour >= timeOpenOfDay.hour &&
          currentTime.minute >= timeOpenOfDay.minute &&
          currentTime.hour < timeCloseOfDay.hour &&
          statusManual != forceClose &&
          index != -1) {
        await document.reference.update({'status': true});
      } else {
        await document.reference.update({'status': false});
      }
    }
  }

  Stream<QuerySnapshot> getAllData() {
    return FirebaseFirestore.instance
        .collection('restaurants')
        .orderBy('status', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getDataWithQuery(String newType) {
    if (newType == 'All') {
      return FirebaseFirestore.instance
          .collection('restaurants')
          .orderBy('status', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('restaurants')
          .orderBy('status', descending: true)
          .where('category', isEqualTo: newType)
          .snapshots();
    }
  }

  void resonButtonPressed(String newType) {
    setState(() {
      type = newType;
      _isButtonPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SearchBox(),
          CatagoryItem(
            type: type,
            isButtonPressed: _isButtonPressed,
            onButtonPressed: resonButtonPressed,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _isButtonPressed ? getDataWithQuery(type) : getAllData(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    return ResCard(
                        title: item['name'],
                        catagory: item['category'],
                        status: item['status'],
                        photo: [myList[0]]);
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
