import 'package:flutter/material.dart';

class DialogBoxBooked extends StatelessWidget {
  VoidCallback onCancel;

  DialogBoxBooked({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 120,
        child: Column(
          children: [
            // Text('You already has a reservation with this restaurant'),
            // Text("Try to cancel that or finish the meal"),
            const Text("ท่านได้ทำการจองร้านค้านี้แล้ว"),
            const Text("โปรดดำเนินการทานอาหารให้เสร็จสิ้น"),
            const Text("จึงจะทำการจองใหม่ได้"),
            const SizedBox(
              height: 6,
            ),
            ElevatedButton(onPressed: onCancel, child: const Text('OK')),
          ],
        ),
      ),
    );
  }
}
