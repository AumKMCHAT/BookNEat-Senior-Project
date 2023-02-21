import 'package:flutter/material.dart';

import '../widgets/res_card.dart';

class FavScreen extends StatelessWidget {
  const FavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 180, 30),
            child: Text('รายการโปรด',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
          ),
          Center(
            child: ResCard(
              title: "Juju Restaurant",
              catagory: "อาหารคาว",
              status: "Open",
            ),
          ),
        ],
      ),
    );
  }
}
