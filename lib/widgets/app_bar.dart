import 'package:flutter/material.dart';

import '../utils/colors.dart';

AppBar homeAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: const BackButton(
      color: Colors.black,
    ),
    title: RichText(
      text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const TextSpan(
              text: "Book n Eat",
              style: TextStyle(color: kPrimaryColor),
            ),
          ]),
    ),
  );
}
