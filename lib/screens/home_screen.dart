import 'package:book_n_eat_senior_project/providers/user_provider.dart';
import 'package:book_n_eat_senior_project/resources/auth_methods.dart';
import 'package:book_n_eat_senior_project/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  signOut(BuildContext context) async {
    await AuthMedthods().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  String firstName = "";

  @override
  void initState() {
    super.initState();
    // getFirstName();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  void getFirstName() async {
    // FirebaseAuth.instance..currentUser!.uid => uid reccord
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      firstName = (snap.data() as Map<String, dynamic>)['firstName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text("Home Page"),
      ),

      //  floating Action Button using for signout ,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          signOut(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.logout_rounded),
      ),

      body: Center(
        child: Text(user.email),
      ),
    );
  }
}
