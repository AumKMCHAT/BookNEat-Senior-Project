import 'package:book_n_eat_senior_project/screens/signup_restaurant_screen.dart';
import 'package:book_n_eat_senior_project/widgets/dialog_box_edit_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model;

import '../providers/user_provider.dart';
import '../resources/auth_methods.dart';
import 'login_screen.dart';
import 'order_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> status = [''];
  bool resStatus = true;

  @override
  void initState() {
    super.initState();
    addData();
    getStatus();
  }

  Future<void> getStatus() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot snapshot = await _firestore
        .collection('restaurants')
        .where('userId', isEqualTo: uid)
        .get();
    List<Map<String, dynamic>> data =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    List<String> resnames =
        data.map((item) => item['status'].toString() as String).toList();
    setState(() {
      this.status = resnames;
      if (resnames[0] == true) resStatus = !resStatus;
      if (resnames[0] == false) resStatus = !resStatus;
    });
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  signOut(BuildContext context) async {
    await AuthMedthods().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final userCheck = context.watch<User?>();
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }

            if (userCheck == null) {
              model.User user = Provider.of<UserProvider>(context).getUser;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                      child: Center(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                          radius: 70,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      user.firstName + '  ' + user.lastName,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 20, 10, 0),
                      child: SizedBox(
                        width: 300,
                        child: TextButton(
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(20)),
                            onPressed: () {
                              if (user.role == 'customer') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignupRestaurantScreen()));
                              } else if (user.role == 'restaurant') {}
                            },
                            child: Row(
                              children: [
                                if (user.role == 'customer')
                                  Icon(
                                    Icons.storefront,
                                    size: 30.0,
                                  ),
                                if (user.role == 'customer')
                                  Text(
                                    "          Create Restaurant",
                                    style: TextStyle(fontSize: 16),
                                  )
                              ],
                            )),
                      ),
                    ),
                    if (user.role == 'restaurant')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 20, 10, 0),
                        child: SizedBox(
                          width: 300,
                          child: TextButton(
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(20)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DialogBoxEditMenu(
                                        onCancel: () =>
                                            Navigator.of(context).pop(),
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 30.0,
                                  ),
                                  Text(
                                    "          Edit Menu",
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              )),
                        ),
                      ),
                    if (user.role == 'restaurant')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 20, 10, 0),
                        child: SizedBox(
                          width: 300,
                          child: TextButton(
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(20)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderScreen()));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 30.0,
                                  ),
                                  Text(
                                    "          Order",
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              )),
                        ),
                      ),
                    if (user.role == 'restaurant')
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 20, 10, 0),
                        child: SizedBox(
                          width: 300,
                          child: TextButton(
                              style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(20)),
                              onPressed: () {
                                CollectionReference collectionRef =
                                    FirebaseFirestore.instance
                                        .collection('restaurants');
                                Query query = collectionRef.where('userId',
                                    isEqualTo: user.userId);
                                if (resStatus == true)
                                  // ignore: curly_braces_in_flow_control_structures
                                  query.get().then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference
                                          .update({'status': false})
                                          .then((value) => print(
                                              "Field updated successfully!"))
                                          .catchError((error) => print(
                                              "Failed to update field: $error"));
                                    });
                                  });
                                if (resStatus == false)
                                  // ignore: curly_braces_in_flow_control_structures
                                  query.get().then((querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      doc.reference
                                          .update({'status': true})
                                          .then((value) => print(
                                              "Field updated successfully!"))
                                          .catchError((error) => print(
                                              "Failed to update field: $error"));
                                    });
                                  });
                                setState(() {
                                  resStatus = !resStatus;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.pause_circle_outline_rounded,
                                    size: 30.0,
                                  ),
                                  if (resStatus == true)
                                    Text(
                                      "          Close Restaurant",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  if (resStatus == false)
                                    Text(
                                      "          Open Restaurant",
                                      style: TextStyle(fontSize: 18),
                                    )
                                ],
                              )),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 10, 20),
                      child: SizedBox(
                        width: 250,
                        child: TextButton(
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(20)),
                            onPressed: () {
                              signOut(context);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 30.0,
                                ),
                                Text(
                                  "          Logout",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            )),
                      ),
                    )
                  ],
                ),
              );
            }
            return Text('User data is not available');
          }),
    );
  }
}
