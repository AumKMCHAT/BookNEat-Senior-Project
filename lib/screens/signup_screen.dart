import 'package:book_n_eat_senior_project/resources/auth_methods.dart';
import 'package:book_n_eat_senior_project/screens/login_screen.dart';
import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:book_n_eat_senior_project/utils/utils.dart';
import 'package:book_n_eat_senior_project/widgets/text_field_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _telephoneController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMedthods().signUpUser(
        email: _emailController.text,
        telephone: _telephoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        file: _image);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResMainScreen()));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 1000,
          width: double.infinity,
          child: SafeArea(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //svg image
                  Flexible(flex: 2, child: Container()),
                  SvgPicture.asset(
                      'assets/images/dining-room-furniture-of-a-table-with-chairs.svg',
                      height: 150),

                  // circular widget to accept and show our selected file
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://t3.ftcdn.net/jpg/00/64/67/80/360_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg'),
                            ),
                      Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input for first name
                  TextFieldInput(
                      textEditingController: _firstNameController,
                      hintText: "First name",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input for last name
                  TextFieldInput(
                      textEditingController: _lastNameController,
                      hintText: "Last name",
                      textInputType: TextInputType.text),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input for telephone
                  TextFieldInput(
                      textEditingController: _telephoneController,
                      hintText: "Telephone Number",
                      textInputType: TextInputType.number),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input for email
                  TextFieldInput(
                      textEditingController: _emailController,
                      hintText: "Email address",
                      textInputType: TextInputType.emailAddress),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input for password
                  TextFieldInput(
                    textEditingController: _passwordController,
                    hintText: "Password",
                    textInputType: TextInputType.visiblePassword,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //text field input for confirm password
                  TextFieldInput(
                    textEditingController: _confirmPasswordController,
                    hintText: "Confirm password",
                    textInputType: TextInputType.visiblePassword,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),

                  //button login
                  InkWell(
                    onTap: signUpUser,
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
                              ),
                            )
                          : const Text('Create account'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(flex: 2, child: Container()),

                  //Transitioning to sighning up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: const Text("Already have an account?"),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          )),
        ),
      ),
    );
  }
}
