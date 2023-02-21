import 'package:book_n_eat_senior_project/screens/rating_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../widgets/app_bar.dart';

class ResScreen extends StatelessWidget {
  ResScreen({super.key});

  final List<String> imageList = [
    "assets/images/res1.jpg",
    "assets/images/res2.jpg",
    "assets/images/res3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
                    child: Text("Juju Restaurant",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 20,
                        ))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(160, 15, 0, 0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border),
                    iconSize: 35,
                  ),
                )
              ],
            ),
            Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                child: CarouselSlider(
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                  ),
                  items: imageList
                      .map((e) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Image(
                                  image: AssetImage(e),
                                  width: 1050,
                                  height: 350,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                          ))
                      .toList(),
                )),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextButton(
                      style:
                          OutlinedButton.styleFrom(padding: EdgeInsets.all(15)),
                      onPressed: () async {
                        await FlutterPhoneDirectCaller.callNumber('123456789');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 24.0,
                          ),
                          Text("          Phone Number")
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: TextButton(
                      style:
                          OutlinedButton.styleFrom(padding: EdgeInsets.all(15)),
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: 24.0,
                          ),
                          Text("          Get Location")
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                  child: SizedBox(
                    height: 62,
                    child: TextButton(
                        style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(15)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RatingCommentScreen()));
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.reviews,
                              size: 24.0,
                            ),
                            Text("          Review")
                          ],
                        )),
                  ),
                )
              ],
            ),
            Column(
              children: [
                Text(
                  "Menu",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: TextButton(
            style: OutlinedButton.styleFrom(padding: EdgeInsets.all(15)),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ReservScreen()));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 100),
              child: Row(
                children: [
                  Icon(
                    Icons.table_restaurant_outlined,
                    size: 24.0,
                  ),
                  Text(
                    "    Reserver a Table",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
