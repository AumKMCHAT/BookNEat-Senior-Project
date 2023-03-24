import 'package:flutter/material.dart';

import '../screens/rating_screen.dart';

class HistoryItem extends StatefulWidget {
  final String resName;
  final String date;
  final String status;

  const HistoryItem(
      {super.key,
      required this.resName,
      required this.date,
      required this.status});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    List<String> texts = [widget.resName, widget.date, widget.status];
    int test = 0;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 0, bottom: 20, top: 10),
          child: Text(
            widget.resName,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
        subtitle: Row(
          children: [
            Text(widget.date),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.status == 'Not Review')
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RatingCommentScreen(
                                  name: widget.resName,
                                )));
                  },
                  child: Text('Review'))
          ],
        ),
      ),
    );
  }
}
