import 'package:flutter/material.dart';

import '../utils/colors.dart';

AppBar screenAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    elevation: 0,
    title: Align(
      alignment: Alignment.center,
      child: Text(
        'Book n Eat',
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
