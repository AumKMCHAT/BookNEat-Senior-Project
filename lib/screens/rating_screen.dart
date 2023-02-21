import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';

class RatingCommentScreen extends StatefulWidget {
  @override
  _RatingCommentScreenState createState() => _RatingCommentScreenState();
}

class _RatingCommentScreenState extends State<RatingCommentScreen> {
  double _rating = 0.0;
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 150, 0),
            child: Text(
              'Rate this restaurant:',
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 130, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.star_rounded,
                    size: 40,
                  ),
                  color: _rating >= 1 ? Colors.black : Colors.grey,
                  onPressed: () {
                    setState(() {
                      _rating = 1.0;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.star_rounded,
                    size: 40,
                  ),
                  color: _rating >= 2 ? Colors.black : Colors.grey,
                  onPressed: () {
                    setState(() {
                      _rating = 2.0;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.star_rounded,
                    size: 40,
                  ),
                  color: _rating >= 3 ? Colors.black : Colors.grey,
                  onPressed: () {
                    setState(() {
                      _rating = 3.0;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.star_rounded,
                    size: 40,
                  ),
                  color: _rating >= 4 ? Colors.black : Colors.grey,
                  onPressed: () {
                    setState(() {
                      _rating = 4.0;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.star_rounded,
                    size: 40,
                  ),
                  color: _rating >= 5 ? Colors.black : Colors.grey,
                  onPressed: () {
                    setState(() {
                      _rating = 5.0;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 150, 30),
            child: Text(
              'Leave a comment:',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: 360,
              height: 160,
              child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  hintText: 'Type your comment here',
                ),
                onChanged: (value) {
                  setState(() {
                    _comment = value;
                  });
                },
              ),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.blue,
                padding: EdgeInsets.all(15)),
            child: Text(
              'Submit',
              style: TextStyle(
                color: Colors.white, // Set the text color
                fontSize: 16, // Set the font size
                fontWeight: FontWeight.bold, // Set the font weight
              ),
            ),
            onPressed: () {
              // Do something with the rating and comment, e.g. send them to a server
              print('Rating: $_rating, Comment: $_comment');
            },
          ),
        ],
      ),
    );
  }
}
