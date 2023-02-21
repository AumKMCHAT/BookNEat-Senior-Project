import 'package:book_n_eat_senior_project/screens/info_res_screen.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ResCard extends StatelessWidget {
  final String title;
  final String catagory;
  final String status;

  const ResCard({
    super.key,
    required this.title,
    required this.catagory,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResScreen()));
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(left: 0, top: 5, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 20,
                color: Color(0xFFB0CCE1).withOpacity(0.32),
              )
            ]),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.13),
                shape: BoxShape.circle,
              ),
              child: Image(
                image: AssetImage('assets/images/res1.jpg'),
                height: 150,
                width: 200,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    catagory,
                  ),
                ),
                if (status == 'Open') ...[
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ] else if (status == 'Close') ...[
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
