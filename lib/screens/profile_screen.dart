import 'package:book_n_eat_senior_project/screens/signup_restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_n_eat_senior_project/models/user.dart' as model;
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/auth_methods.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  signOut(BuildContext context) async {
    await AuthMedthods().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }
            final userCheck = context.watch<User?>();
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
                          radius:
                              70, // adjust the radius as per your requirement
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
                      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: SizedBox(
                        width: 250,
                        child: TextButton(
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(20)),
                            onPressed: () async {},
                            child: Row(
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 30.0,
                                ),
                                Text(
                                  "          Edit Profile",
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
                            )),
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
                              } else if (user.role == 'restaurant') {
                                print('test');
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.storefront,
                                  size: 30.0,
                                ),
                                if (user.role == 'customer')
                                  Text(
                                    "          Create Restaurant",
                                    style: TextStyle(fontSize: 16),
                                  )
                                else if (user.role == 'restaurant')
                                  Text(
                                    "          Edit Restaurant",
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
                              onPressed: () {},
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
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.pause_circle_outline_rounded,
                                    size: 30.0,
                                  ),
                                  Text(
                                    "          Close Restaurant",
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
