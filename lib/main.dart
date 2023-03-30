import 'package:book_n_eat_senior_project/providers/user_provider.dart';
import 'package:book_n_eat_senior_project/screens/login_screen.dart';
import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/screens/search_screen.dart';
import 'package:book_n_eat_senior_project/screens/signup_restaurant_screen.dart';
import 'package:book_n_eat_senior_project/screens/signup_screen.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_n_eat_senior_project/screens/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

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
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppScreen(),
    );
  }
}
