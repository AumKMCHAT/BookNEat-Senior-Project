import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchBox({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(23),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Color(0xFFB5BFD0).withOpacity(0.32),
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            // ignore: prefer_const_constructors
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.search),
              hintText: "Search Here",
              hintStyle: TextStyle(color: Color(0xFFB5BFD0)),
            ),
          ),
        )
      ],
    );
  }
}
