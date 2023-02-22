import 'package:book_n_eat_senior_project/resources/auth_methods.dart';
import 'package:book_n_eat_senior_project/screens/home_screen.dart';
import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/screens/signup_screen.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:book_n_eat_senior_project/utils/utils.dart';
import 'package:book_n_eat_senior_project/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispost() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMedthods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResMainScreen()));
    } else {
      //
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          //svg image
          Flexible(flex: 2, child: Container()),
          SvgPicture.asset(
              'assets/images/dining-room-furniture-of-a-table-with-chairs.svg',
              height: 150),
          const SizedBox(height: 64),

          //text field input for email
          TextFieldInput(
              textEditingController: _emailController,
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 24,
          ),

          //text field input for password
          TextFieldInput(
            textEditingController: _passwordController,
            hintText: "Enter your password",
            textInputType: TextInputType.visiblePassword,
            isPass: true,
          ),
          const SizedBox(
            height: 24,
          ),

          //button login
          InkWell(
            onTap: loginUser,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: Colors.blue),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: primaryColor,
                    ))
                  : const Text("Login"),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(flex: 2, child: Container()),

          //Transitioning to signing up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: const Text("Don't have an account?"),
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: navigateToSignup,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          )
        ]),
      )),
    );
  }
}
