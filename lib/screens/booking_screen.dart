import 'dart:async';

import 'package:book_n_eat_senior_project/widgets/app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../resources/auth_methods.dart';

class BookingScreen extends StatefulWidget {
  final String resId;

  const BookingScreen({super.key, required this.resId});

  @override
  State<BookingScreen> createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  int peopleNumber = 1;
  final TextEditingController _dateController = TextEditingController();
  Timestamp _dateTimeStamp = Timestamp.fromDate(DateTime.now());

  final TextEditingController _requestController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DateTime> aviableTime = [];
  int slot = 0;
  bool _isLoading = true;

  final String status = "pending";

  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _requestController.dispose();
  }

  void addPeople() {
    peopleNumber++;
    setState(() {
      peopleNumber = peopleNumber;
    });
  }

  void removePeople() {
    if (peopleNumber >= 2) {
      peopleNumber--;
    }
    setState(() {
      peopleNumber = peopleNumber;
    });
  }

  void bookNow() async {
    DateTime noTime = _dateTimeStamp.toDate();
    DateTime bookingDate = DateTime(noTime.year, noTime.month, noTime.day,
        aviableTime[_selectedIndex].hour, aviableTime[_selectedIndex].minute);
    Timestamp bookingTime = Timestamp.fromDate(bookingDate);

    String res = await AuthMedthods().bookingRestaurant(
      userId: _auth.currentUser!.uid,
      quantity: peopleNumber,
      bookingDate: bookingTime,
      request: _requestController.text,
      resId: widget.resId,
      status: status,
    );
    print("peopleNumber: $peopleNumber");
    print(bookingTime);
    print(_requestController.text);
    print(status);
    print(widget.resId);
    print(_auth.currentUser!.uid);
    print(res);
  }

  void getWorkMinute() async {
    DocumentSnapshot snap =
        await _firestore.collection('restaurants').doc(widget.resId).get();

    var min = (snap.data() as Map<String, dynamic>)['workingMinute'];
    slot = (min / 30).round();
  }

  void getSlotTime() async {
    DocumentSnapshot snap =
        await _firestore.collection('restaurants').doc(widget.resId).get();
    Timestamp timeOpen = (snap.data() as Map<String, dynamic>)['timeOpen'];
    for (int i = 0; i < slot; i++) {
      if (aviableTime.length <= slot) {
        aviableTime.add(timeOpen.toDate().add(Duration(minutes: (i * 30))));
      }
    }
  }

  void selectTime(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    getWorkMinute();
    getSlotTime();
    return Scaffold(
      appBar: homeAppBar(context),
      body: Column(
        children: [
          _isLoading
              ? const SizedBox(
                  height: 50,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : const Text(
                  "Booking details",
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.left,
                ),
          Row(
            children: [
              const Text("Person: "),
              ElevatedButton(
                onPressed: removePeople,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.redAccent),
                ),
                child: const Text("-"),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(peopleNumber.toString()),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: addPeople,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: const Text("+")),
              const Text("Max Person per Table: ")
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          const Text("Select Date"),
          TextField(
              controller:
                  _dateController, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Enter Date" //label text of field
                  ),
              readOnly: true, // when true user cannot edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(), //get today's date
                    firstDate: DateTime(
                        2000), //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2101));

                if (pickedDate != null) {
                  Timestamp timestampPickedDate =
                      Timestamp.fromDate(pickedDate);
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);

                  setState(() {
                    _dateTimeStamp = timestampPickedDate;
                    _dateController.text = formattedDate;
                  });
                } else {
                  print("Date is not selected");
                }
              }),
          const SizedBox(
            height: 24,
          ),
          const Text("Select Time"),
          SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: slot,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => selectTime(index),
                  style: ButtonStyle(
                    backgroundColor: (_selectedIndex != index)
                        ? MaterialStateProperty.all<Color>(Colors.white)
                        : MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor: (_selectedIndex != index)
                        ? MaterialStateProperty.all<Color>(Colors.blue)
                        : MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: (aviableTime[index].minute == 0)
                      ? Text(
                          "${aviableTime[index].hour}:${aviableTime[index].minute}0")
                      : Text(
                          "${aviableTime[index].hour}:${aviableTime[index].minute}"),
                ),
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text("Special Requests"),
          const SizedBox(
            height: 24,
          ),
          TextFormField(
            controller: _requestController,
            decoration: InputDecoration(
                hintText: "Ex: Can i get a table near window?",
                border: inputBorder,
                focusedBorder: inputBorder,
                enabledBorder: inputBorder,
                filled: true,
                contentPadding: const EdgeInsets.all(8)),
            keyboardType: TextInputType.text,
            obscureText: false,
            maxLines: 5,
          ),
          const SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: bookNow,
            child: Container(
              width: 250,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  color: Colors.blue),
              child: const Text(
                'Book Now',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
