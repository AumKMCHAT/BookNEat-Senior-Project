import 'package:book_n_eat_senior_project/widgets/app_bar.dart';
import 'package:book_n_eat_senior_project/widgets/screen_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/res_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            width: 1000,
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Color(0xFFB5BFD0).withOpacity(0.32),
              ),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search Here",
                hintStyle: TextStyle(color: Color(0xFFB5BFD0)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('restaurants')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var filteredData = snapshot.data!.docs
                  .where((doc) => doc['resId']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList();

              return SizedBox(
                height: 370,
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final List<dynamic> myList =
                        filteredData[index]['photoUrl'] as List<dynamic>;
                    return ResCard(
                        title: filteredData[index]['name'],
                        catagory: filteredData[index]['category'],
                        status: filteredData[index]['status'],
                        photo: [myList[0]]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
