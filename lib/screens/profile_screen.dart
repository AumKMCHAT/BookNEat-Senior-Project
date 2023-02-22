import 'package:book_n_eat_senior_project/screens/signup_restaurant_screen.dart';
import 'package:flutter/material.dart';

import '../resources/auth_methods.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  signOut(BuildContext context) async {
    await AuthMedthods().signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/res1.jpg'),
                  radius: 70, // adjust the radius as per your requirement
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "First Last",
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
              child: SizedBox(
                width: 250,
                child: TextButton(
                    style:
                        OutlinedButton.styleFrom(padding: EdgeInsets.all(20)),
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
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                width: 250,
                child: TextButton(
                    style:
                        OutlinedButton.styleFrom(padding: EdgeInsets.all(20)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupRestaurantScreen()));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.storefront,
                          size: 30.0,
                        ),
                        Text(
                          "          Create Restaurant",
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SizedBox(
                width: 250,
                child: TextButton(
                    style:
                        OutlinedButton.styleFrom(padding: EdgeInsets.all(20)),
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
      ),
    );
  }
}
