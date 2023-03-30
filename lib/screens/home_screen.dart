import 'package:book_n_eat_senior_project/providers/user_provider.dart';
import 'package:book_n_eat_senior_project/screens/login_screen.dart';
import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          title: 'Book N Eat',
          theme: ThemeData(
            primaryColor: Colors.blue[300],
            scaffoldBackgroundColor: Colors.white,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResMainScreen();
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
              return const LoginScreen();
            },
          )),
    );
  }
}
