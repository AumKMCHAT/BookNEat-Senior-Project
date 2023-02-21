import 'package:book_n_eat_senior_project/providers/user_provider.dart';
import 'package:book_n_eat_senior_project/screens/home_screen.dart';
import 'package:book_n_eat_senior_project/screens/login_screen.dart';
import 'package:book_n_eat_senior_project/screens/signup_restaurant_screen.dart';
import 'package:book_n_eat_senior_project/screens/signup_screen.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          title: 'Book N Eat',
          theme: ThemeData.dark(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return HomeScreen();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              // return const LoginScreen();
              return const SignupRestaurantScreen();
            },
          )),
    );
  }
}
