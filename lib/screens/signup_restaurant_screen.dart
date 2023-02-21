import 'dart:io';
import 'package:book_n_eat_senior_project/resources/auth_methods.dart';
import 'package:book_n_eat_senior_project/screens/home_screen.dart';
import 'package:book_n_eat_senior_project/screens/login_screen.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:book_n_eat_senior_project/utils/utils.dart';
import 'package:book_n_eat_senior_project/widgets/text_field_input.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_n_eat_senior_project/utils/restaurant_category.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SignupRestaurantScreen extends StatefulWidget {
  const SignupRestaurantScreen({super.key});

  @override
  State<SignupRestaurantScreen> createState() => _SignupRestaurantScreenState();
}

class _SignupRestaurantScreenState extends State<SignupRestaurantScreen> {
  final TextEditingController _resNameController = TextEditingController();
  String _category = category.first;
  late Position _position;
  final String _time = DateTime.now().toString();
  List<XFile> images = [];
  final TextEditingController _phoneController = TextEditingController();
  List<String> _telephone = [];
  bool status = false;
  bool _isLoading = false;

  List<File> files = [];

  @override
  void dispost() {
    super.dispose();
    _resNameController.dispose();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      _position = position;
    });
    print(_position);
    print(_time);
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void selectImages() async {
    final List<XFile> res = await pickImages(ImageSource.gallery);
    setState(() {
      images = res;
    });
    if (res != null) {
      res.forEach((element) {
        files.add(File(element.path));
      });
    }
  }

  void signUpRestuarant() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMedthods().signUpRestaurant(
      name: _resNameController.text,
      category: _category,
      position: _position,
      timeAvialable: _time,
      files: files,
      telephone: _phoneController.text,
      status: status,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      print("success");
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
          const Text("Register Restaurant"),
          Flexible(flex: 2, child: Container()),
          SvgPicture.asset(
              'assets/images/dining-room-furniture-of-a-table-with-chairs.svg',
              height: 150),
          const SizedBox(height: 30),

          // select multiple photo
          images.isNotEmpty
              ? CarouselSlider(
                  items: images.map(
                    (i) {
                      return Builder(
                        builder: (BuildContext context) => Image.file(
                          File(i.path),
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      );
                    },
                  ).toList(),
                  options: CarouselOptions(
                    viewportFraction: 1,
                    height: 200,
                  ),
                )
              : GestureDetector(
                  onTap: selectImages,
                  child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.folder_open,
                                size: 40,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Select Restaurant Images',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade400),
                              )
                            ]),
                      )),
                ),
          const SizedBox(
            height: 24,
          ),

          TextFieldInput(
              textEditingController: _resNameController,
              hintText: "Restaurant Name",
              textInputType: TextInputType.text),
          const SizedBox(
            height: 24,
          ),

          TextFieldInput(
              textEditingController: _phoneController,
              hintText: "Telephone Number",
              textInputType: TextInputType.text),
          const SizedBox(
            height: 24,
          ),

          DropdownButton(
            // Initial Value
            value: _category,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: category.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                _category = newValue!;
              });
            },
          ),
          const SizedBox(
            height: 24,
          ),

          // get current location button
          InkWell(
            onTap: getCurrentLocation,
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
                  : const Text('Assign Restaurant Location'),
            ),
          ),
          const SizedBox(
            height: 24,
          ),

          //button login
          InkWell(
            onTap: signUpRestuarant,
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
    );
  }
}
