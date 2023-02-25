import 'package:flutter/material.dart';
import '../utils/restaurant_category.dart';

class CatagoryItem extends StatefulWidget {
  String type;
  bool isButtonPressed;
  final Function(String) onButtonPressed;
  CatagoryItem(
      {required this.type,
      required this.isButtonPressed,
      required this.onButtonPressed});

  @override
  State<CatagoryItem> createState() => _CatagoryItemState();
}

class _CatagoryItemState extends State<CatagoryItem> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: category.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onButtonPressed(category[index]);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: <Widget>[
                    Text(
                      category[index],
                      style: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.blue
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      height: 3,
                      width: 22,
                      decoration: BoxDecoration(
                        color: _selectedIndex == index
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
