import 'dart:async';
import 'package:book_n_eat_senior_project/providers/user_provider.dart';
import 'package:book_n_eat_senior_project/screens/history_screen.dart';
import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/utils/restaurant_category.dart';
import 'package:book_n_eat_senior_project/widgets/app_bar.dart';
import 'package:book_n_eat_senior_project/widgets/dialog_box_confirm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model;
import '../resources/auth_methods.dart';

class BookingScreen extends StatefulWidget {
  final String resId;
  final List<dynamic> workDay;

  const BookingScreen({super.key, required this.resId, required this.workDay});

  @override
  State<BookingScreen> createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  final TextEditingController _dateController = TextEditingController();
  Timestamp _dateTimeStamp = Timestamp.fromDate(DateTime.now());

  final TextEditingController _requestController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int maxPeople = 0;
  List<int> peoples = [];
  int _people = 1;

  List<DateTime> aviableTime = [];
  int slot = 0;
  bool _isLoading = true;

  final String status = statusPending;

  int _selectedIndex = 0;

  String phoneNumber = '';
  String name = '';

  final List<String> allDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMaxPeople();
    getUserData();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    print(widget.workDay);
  }

  @override
  void dispose() {
    super.dispose();
    _requestController.dispose();
  }

  bool isWorkDay(DateTime date) {
    String dayOfWeek = DateFormat('E').format(date);
    return widget.workDay.contains(dayOfWeek);
  }

  void onBooking() {
    DateTime noTime = _dateTimeStamp.toDate();
    DateTime bookingDate = DateTime(noTime.year, noTime.month, noTime.day,
        aviableTime[_selectedIndex].hour, aviableTime[_selectedIndex].minute);
    Timestamp bookingTime = Timestamp.fromDate(bookingDate);

    showDialog(
        context: context,
        builder: (context) {
          return DialogBoxConfirm(
              onCancel: () => Navigator.of(context).pop(),
              onConfirm: () => {confirmBooking(), Navigator.of(context).pop()},
              quantity: _people,
              bookingDate: bookingTime,
              request: _requestController.text);
        });
  }

  void confirmBooking() async {
    DateTime noTime = _dateTimeStamp.toDate();
    DateTime bookingDate = DateTime(noTime.year, noTime.month, noTime.day,
        aviableTime[_selectedIndex].hour, aviableTime[_selectedIndex].minute);
    Timestamp bookingTime = Timestamp.fromDate(bookingDate);

    String res = await AuthMedthods().bookingRestaurant(
      userId: _auth.currentUser!.uid,
      quantity: _people,
      bookingDate: bookingTime,
      request: _requestController.text,
      resId: widget.resId,
      status: status,
    );
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ResMainScreen()));
  }

  void getWorkMinute() async {
    DocumentSnapshot snap =
        await _firestore.collection('restaurants').doc(widget.resId).get();

    var min = (snap.data() as Map<String, dynamic>)['workingMinute'];
    slot = (min / 30).round();
  }

  void getMaxPeople() async {
    DocumentSnapshot snap =
        await _firestore.collection('restaurants').doc(widget.resId).get();
    maxPeople = (snap.data() as Map<String, dynamic>)['maxPerson'];

    for (int i = 1; i <= maxPeople; i++) {
      peoples.add(i);
    }
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

  Future<void> getUserData() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: uid)
        .get();
    QueryDocumentSnapshot snapshot = querySnapshot.docs[0];
    setState(() {
      this.name = snapshot.get('firstName') + '  ' + snapshot.get('lastName');
      this.phoneNumber = snapshot.get('telephone');
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              width: 400,
              child: Column(
                children: [
                  _isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(top: 350),
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            const Text(
                              "Booking details",
                              style: TextStyle(fontSize: 30),
                            ),
                            Row(
                              children: [
                                const Text(
                                  "A Table for :   ",
                                  style: TextStyle(fontSize: 20),
                                ),
                                DropdownButton(
                                  value: _people,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: peoples.map((int items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      _people = newValue!;
                                    });
                                  },
                                ),
                                const Text(
                                  "   People",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Select Date",
                                  style: TextStyle(fontSize: 20),
                                )),
                            TextField(
                                controller:
                                    _dateController, //editing controller of this TextField
                                decoration: const InputDecoration(
                                    icon: Icon(Icons
                                        .calendar_today), //icon of text field
                                    labelText:
                                        "Enter Date" //label text of field
                                    ),
                                readOnly:
                                    true, // when true user cannot edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      selectableDayPredicate: (DateTime date) {
                                        if (!isWorkDay(date)) {
                                          return false;
                                        }
                                        return true;
                                      },
                                      context: context,
                                      initialDate:
                                          DateTime.now(), //get today's date
                                      firstDate: DateTime(
                                          2000), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101));

                                  if (pickedDate != null) {
                                    Timestamp timestampPickedDate =
                                        Timestamp.fromDate(pickedDate);
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickedDate);

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
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Select Time",
                                  style: TextStyle(fontSize: 20),
                                )),
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
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.white)
                                          : MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                      foregroundColor: (_selectedIndex != index)
                                          ? MaterialStateProperty.all<Color>(
                                              Colors.blue)
                                          : MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    child: (aviableTime[index]
                                                .minute
                                                .toString()
                                                .length ==
                                            1)
                                        ? Text(
                                            "${aviableTime[index].hour}:0${aviableTime[index].minute}")
                                        : Text(
                                            "${aviableTime[index].hour}:${aviableTime[index].minute}"),
                                  ),
                                ),
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "Contact Details",
                                  style: TextStyle(fontSize: 20),
                                )),
                            Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  "Name: ${name}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                padding: const EdgeInsets.only(top: 12),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Telephone: ${phoneNumber}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 24,
                            ),
                            const Text(
                              "Special Requests",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: _requestController,
                              decoration: InputDecoration(
                                  hintText:
                                      "Ex: Can i get a table near window?",
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
                              onTap: onBooking,
                              child: Container(
                                width: 250,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    color: Colors.blue),
                                child: const Text(
                                  'Book Now',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}
