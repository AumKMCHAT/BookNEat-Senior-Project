import 'package:book_n_eat_senior_project/widgets/search_box.dart';
import 'package:flutter/material.dart';

import 'catagory_item.dart';
import 'res_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          SearchBox(onChanged: (value) {}),
          CatagoryItem(),
          ResCard(
            title: "Juju Restaurant",
            catagory: "อาหารคาว",
            status: "Open",
          ),
          ResCard(
              title: "Test Restaurant", catagory: "อาหารคาว", status: "Close"),
          ResCard(
              title: "Third Restaurant", catagory: "อาหารคาว", status: "Open"),
        ],
      ),
    );
  }
}
