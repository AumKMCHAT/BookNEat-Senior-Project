import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CatagoryBox extends StatefulWidget {
  final String title;

  const CatagoryBox({
    super.key,
    required this.title,
  });

  @override
  State<CatagoryBox> createState() => _CatagoryBox();
}

class _CatagoryBox extends State<CatagoryBox> {
  _press(String title) {
    if (widget.title == 'อาหารคาว') {
      print("โง่แต่ใช้ได้");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.title == "แนะนำ") {
          print('kuy');
        } else {
          print("ma yed mae");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              height: 3,
              width: 22,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    );
  }
}
