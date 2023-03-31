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
  String name = '';
  String role = '';
  String photoUrl = '';

  bool resStatus = true;

  @override
  void initState() {
    super.initState();
    // addData();
    getStatus();
    getUser();
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
      print(this.status[0]);
      if (this.status[0] == 'true') {
        this.resStatus = false;
      } else if (this.status[0] == 'false') {
        this.resStatus = true;
      }
    });
  }

  Future<void> getUser() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: uid)
        .get();
    QueryDocumentSnapshot snapshot = querySnapshot.docs[0];
    setState(() {
      this.name = snapshot.get('firstName') + '  ' + snapshot.get('lastName');
      this.role = snapshot.get('role');
      this.photoUrl = snapshot.get('photoUrl');
    });
  }

  signOut(BuildContext context) async {
    await AuthMedthods().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _updateResStatus(bool status) async {
    String uid = _auth.currentUser!.uid;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("restaurants")
          .where("userId", isEqualTo: uid)
          .get();
      querySnapshot.docs.forEach((document) async {
        if (resStatus) {
          await document.reference.update({
            "status": false,
          });
        } else {
          await document.reference.update({
            "status": true,
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser!.uid;
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('restaurants');
    Query query = collectionRef.where('userId', isEqualTo: uid);
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(photoUrl),
                        radius: 70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    name,
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
                            if (role == 'customer') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignupRestaurantScreen()));
                            } else if (role == 'restaurant') {}
                          },
                          child: Row(
                            children: [
                              if (role == 'customer')
                                Icon(
                                  Icons.storefront,
                                  size: 30.0,
                                ),
                              if (role == 'customer')
                                Text(
                                  "          Create Restaurant",
                                  style: TextStyle(fontSize: 16),
                                )
                            ],
                          )),
                    ),
                  ),
                  if (role == 'restaurant')
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
                  if (role == 'restaurant')
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
                  if (role == 'restaurant')
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 20, 10, 0),
                      child: SizedBox(
                        width: 300,
                        child: TextButton(
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(20)),
                            onPressed: () {
                              _updateResStatus(resStatus);
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
                                if (resStatus == false) ...[
                                  Text(
                                    "          Close Restaurant",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ] else if (resStatus == true)
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
          }),
    );
  }
}
