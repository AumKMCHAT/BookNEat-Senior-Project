import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final String name;
  final String comment;
  final String star;
  final String photoUrl;
  const ReviewCard(
      {super.key,
      required this.name,
      required this.comment,
      required this.star,
      required this.photoUrl});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.photoUrl),
              radius: 50,
            ),
            title: Text(
              widget.name,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, height: 1.5),
            ),
            subtitle: Row(
              children: [
                Text(
                  widget.comment,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            trailing: Container(
                width: 48,
                child: Row(
                  children: [
                    Text(widget.star),
                    Icon(Icons.star, color: Colors.yellow)
                  ],
                )),
          ),
          const Divider(color: Colors.grey, thickness: 1),
        ],
      ),
    );
  }
}
