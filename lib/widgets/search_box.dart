import 'package:book_n_eat_senior_project/screens/search_screen.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 400,
          margin: EdgeInsets.all(23),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Color(0xFFB5BFD0).withOpacity(0.32),
            ),
          ),
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
            icon: Icon(Icons.search),
            label: Text('Search Heare'),
          ),
        )
      ],
    );
  }
}
