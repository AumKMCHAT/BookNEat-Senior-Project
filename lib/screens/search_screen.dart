import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/app_bar.dart';
import '../widgets/res_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  List _searchResults = [];

  Future<void> _searchFirestore(String searchText) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('resId', isGreaterThanOrEqualTo: searchText)
          .where('resId', isLessThan: searchText + 'z')
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _searchResults = snapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        setState(() {
          _searchResults = ['No data found'];
        });
      }
    } catch (e) {
      setState(() {
        _searchResults = ['Error: ${e.toString()}'];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.search),
                hintText: "Search Here",
                hintStyle: TextStyle(color: Color(0xFFB5BFD0)),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    final searchText = _controller.text.trim();
                    if (searchText.isNotEmpty) {
                      await _searchFirestore(searchText);
                    }
                  },
            child: Text('Search'),
          ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : _searchResults.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          final List<dynamic> myList =
                              result['photoUrl'] as List<dynamic>;
                          return ResCard(
                              title: result['name'],
                              catagory: result['category'],
                              status: 'Open',
                              photo: [myList[0]]);
                        },
                      ),
                    )
                  : SizedBox.shrink(),
        ],
      ),
    );
  }
}
