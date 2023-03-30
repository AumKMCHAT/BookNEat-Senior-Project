import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DialogBoxConfirm extends StatelessWidget {
  VoidCallback onCancel;
  VoidCallback onConfirm;
  int quantity;
  Timestamp bookingDate;
  String request;

  DialogBoxConfirm(
      {super.key,
      required this.onCancel,
      required this.onConfirm,
      required this.quantity,
      required this.bookingDate,
      required this.request});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 180,
        child: Column(
          children: [
            Text("จำนวนที่นั่ง: " + quantity.toString()),
            Text("วันที่จอง: " +
                bookingDate.toDate().day.toString() +
                '/' +
                bookingDate.toDate().month.toString() +
                '/' +
                bookingDate.toDate().year.toString()),
            Text("เวลาที่จอง: " +
                bookingDate.toDate().hour.toString() +
                ':' +
                bookingDate.toDate().minute.toString()),
            Text("คำขอพิเศษ: " + request.toString()),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onCancel,
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  child: Text('Cancel'),
                ),
                SizedBox(
                  width: 100,
                ),
                ElevatedButton(onPressed: onConfirm, child: Text('Confirm')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
