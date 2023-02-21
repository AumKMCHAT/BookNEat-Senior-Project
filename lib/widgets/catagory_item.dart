import 'package:flutter/material.dart';
import 'catagory_box.dart';

class CatagoryItem extends StatefulWidget {
  const CatagoryItem({super.key});

  @override
  State<CatagoryItem> createState() => _CatagoryItemState();
}

class _CatagoryItemState extends State<CatagoryItem> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          CatagoryBox(
            title: "แนะนำ",
          ),
          CatagoryBox(
            title: "อาหารคาว",
          ),
          CatagoryBox(
            title: "ของหวาน",
          ),
          CatagoryBox(
            title: "บุฟเฟ่ต์",
          ),
          CatagoryBox(
            title: "test",
          ),
        ],
      ),
    );
  }
}
