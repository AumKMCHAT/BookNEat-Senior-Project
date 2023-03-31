import 'dart:io';
import 'package:book_n_eat_senior_project/resources/auth_methods.dart';
import 'package:book_n_eat_senior_project/screens/login_screen.dart';
import 'package:book_n_eat_senior_project/screens/profile_screen.dart';
import 'package:book_n_eat_senior_project/screens/res_main_screen.dart';
import 'package:book_n_eat_senior_project/utils/colors.dart';
import 'package:book_n_eat_senior_project/utils/utils.dart';
import 'package:book_n_eat_senior_project/widgets/app_bar.dart';
import 'package:book_n_eat_senior_project/widgets/menu_form.dart';
import 'package:book_n_eat_senior_project/widgets/text_field_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:book_n_eat_senior_project/utils/restaurant_category.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:book_n_eat_senior_project/models/menu.dart';
import 'package:path/path.dart' as basename;

class SignupRestaurantScreen extends StatefulWidget {
  const SignupRestaurantScreen({super.key});

  @override
  State<SignupRestaurantScreen> createState() => _SignupRestaurantScreenState();
}

class _SignupRestaurantScreenState extends State<SignupRestaurantScreen> {
  final TextEditingController _resNameController = TextEditingController();
  String _category = category.first;
  late Position _position;
  List<XFile> images = [];
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _maxPersonController = TextEditingController();
  List<String> _telephone = [];
  bool status = false;
  bool _isLoading = false;

  bool pressed = false;

  List<File> files = [];
  late File filePdf;
  String filePdfPath = "No Menu File Selected";

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _desController = TextEditingController();

  List<Menu> menus = [Menu(name: "", price: "", description: "")];
  List<MenuForm> forms = [];

  TimeOfDay timeOpen = TimeOfDay.now();
  TimeOfDay timeClose = TimeOfDay.now();

  Timestamp openTimeStamp = Timestamp.now();
  Timestamp closeTimeStamp = Timestamp.now();
  int workingMinute = 0;

  final List<bool> _clicked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  List<String> days = [];

  @override
  void dispost() {
    super.dispose();
    _resNameController.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      filePdf = file;
      setState(() {
        filePdfPath = basename.basename(file.path).toString();
      });
      // Do something with the PDF file
    }
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    setState(() {
      _position = position;
      pressed = true;
    });
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
      filePdf: filePdf,
      position: _position,
      files: files,
      telephone: _phoneController.text,
      maxPerson: int.parse(_maxPersonController.text),
      status: status,
      days: days,
      timeOpen: openTimeStamp,
      timeClose: closeTimeStamp,
      workingMinute: workingMinute,
    );

    setState(() {
      _isLoading = false;
    });

    // if (res != 'success') {
    //   showSnackBar(res, context);
    // } else {
    print("success");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ResMainScreen()));
    // }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void selectTimeOpen() async {
    TimeOfDay? newTimeOpen =
        await showTimePicker(context: context, initialTime: timeOpen);

    setState((() => timeOpen = newTimeOpen!));
  }

  void selectTimeClose() async {
    TimeOfDay? newTimeClose =
        await showTimePicker(context: context, initialTime: timeClose);

    setState((() => timeClose = newTimeClose!));
  }

  void addOpenDay(String day, int index) {
    _clicked[index] = true;
    days.add(day);
    setState(() {
      _clicked[index] = _clicked[index];
    });
    // int work = (timeClose.hour - timeOpen.hour) % 12 ? (timeClose.hour==timeOpen.hour) ? 12 : 24;
    DateTime now = DateTime.now();
    // if timeClose < timeOpen --->>>> now.day+1
    if (timeClose.hour <= timeOpen.hour &&
        timeClose.minute <= timeOpen.minute) {
      DateTime dateTimeClose = DateTime(
          now.year, now.month, now.day + 1, timeClose.hour, timeClose.minute);
      DateTime dateTimeOpen = DateTime(
          now.year, now.month, now.day, timeOpen.hour, timeOpen.minute);

      openTimeStamp = Timestamp.fromDate(dateTimeOpen);
      closeTimeStamp = Timestamp.fromDate(dateTimeClose);

      int workingTime = dateTimeClose.difference(dateTimeOpen).inMinutes;
      workingMinute = workingTime;
    } else {
      DateTime dateTimeClose = DateTime(
          now.year, now.month, now.day, timeClose.hour, timeClose.minute);
      DateTime dateTimeOpen = DateTime(
          now.year, now.month, now.day, timeOpen.hour, timeOpen.minute);

      openTimeStamp = Timestamp.fromDate(dateTimeOpen);
      closeTimeStamp = Timestamp.fromDate(dateTimeClose);

      int workingTime = dateTimeClose.difference(dateTimeOpen).inMinutes;
      workingMinute = workingTime;
    }
  }

  void removeOpenday(String day, int index) {
    _clicked[index] = false;
    days.removeWhere((element) => element.contains(day));
    setState(() {
      _clicked[index] = _clicked[index];
    });
  }

  void onDelete(int index) {
    setState(() {
      menus.removeAt(index);
    });
  }

  void onAddMenuForm() {
    setState(() {
      menus.add(Menu(name: "", price: "", description: ""));
    });
  }

  void printData() {
    AuthMedthods().uploadMenu(menus);
  }

  @override
  Widget build(BuildContext context) {
    forms.clear();
    for (int i = 0; i < menus.length; i++) {
      forms.add(MenuForm(
        menu: menus[i],
        onDelete: (() => onDelete(i)),
        key: GlobalKey(),
      ));
    }
    return Scaffold(
      appBar: homeAppBar(context),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //svg image
            const Text(
              "Register Restaurant",
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 24,
            ),

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
                                      fontSize: 15,
                                      color: Colors.grey.shade400),
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
                textInputType: TextInputType.phone),
            const SizedBox(
              height: 24,
            ),

            TextFieldInput(
                textEditingController: _maxPersonController,
                hintText: "Max Person of Table",
                textInputType: TextInputType.number),
            const SizedBox(
              height: 24,
            ),

            // get current location button
            Row(
              children: [
                const Text("Category:    "),
                DropdownButton(
                  value: _category,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: category.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Location: "),
                OutlinedButton(
                  onPressed: getCurrentLocation,
                  style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: pressed ? Colors.blue : Colors.white),
                  child: Icon(
                    Icons.place_outlined,
                    color: pressed ? Colors.white : Colors.black,
                    size: 24.0,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),

            Row(
              children: [
                Row(
                  children: [
                    const Text(
                      "Open Time:",
                      style: TextStyle(fontSize: 15),
                    ),
                    OutlinedButton(
                      onPressed: selectTimeOpen,
                      style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder()),
                      child: Text(
                        "${timeOpen.hour}:${timeOpen.minute}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  children: [
                    const Text(
                      "Close Time:",
                      style: TextStyle(fontSize: 15),
                    ),
                    OutlinedButton(
                        onPressed: selectTimeClose,
                        style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder()),
                        child: Text(
                          "${timeClose.hour}:${timeClose.minute}",
                          style: const TextStyle(fontSize: 18),
                        ))
                  ],
                )
              ],
            ),

            const Text("Open Day"),
            const SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _clicked[0]
                            ? removeOpenday(
                                "Sun", 0) // Sun DateTime.weekday = 7
                            : addOpenDay("Sun", 0),
                        style: _clicked[0]
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                        child: const Text("Sun"),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () => _clicked[1]
                            ? removeOpenday("Mon", 1)
                            : addOpenDay("Mon", 1),
                        style: _clicked[1]
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                        child: Text("Mon"),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () => _clicked[2]
                            ? removeOpenday("Tue", 2)
                            : addOpenDay("Tue", 2),
                        style: _clicked[2]
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                        child: Text("Tue"),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () => _clicked[3]
                            ? removeOpenday("Wed", 3)
                            : addOpenDay("Wed", 3),
                        style: _clicked[3]
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                        child: Text("Wed"),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () => _clicked[4]
                            ? removeOpenday("Thu", 4)
                            : addOpenDay("Thu", 4),
                        style: _clicked[4]
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                        child: Text("Thu"),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () => _clicked[5]
                            ? removeOpenday("Fri", 5)
                            : addOpenDay("Fri", 5),
                        style: _clicked[5]
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                        child: Text("Fri"),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () => _clicked[6]
                            ? removeOpenday("Sat", 6)
                            : addOpenDay("Sat", 6),
                        style: _clicked[6]
                            ? null
                            : ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                        child: Text("Sat"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // // list of menu
            // SizedBox(
            //   height: 320,
            //   child: ListView.builder(
            //     addAutomaticKeepAlives: true,
            //     itemCount: forms.length,
            //     itemBuilder: (_, i) {
            //       return forms[i];
            //     },
            //   ),
            // ),
            // FloatingActionButton(
            //     onPressed: onAddMenuForm, child: const Icon(Icons.add)),

            const SizedBox(
              height: 12,
            ),
            Column(
              children: [
                Text(filePdfPath),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(Colors.blue)),
                  onPressed: _pickFile,
                  child: Text('Pick a PDF file'),
                ),
              ],
            ),

            const SizedBox(
              height: 44,
            ),
            //button
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
                    : const Text(
                        'Create Restaurant Account',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            // const SizedBox(
            //   height: 12,
            // ),

            // InkWell(
            //   onTap: printData,
            //   child: Container(
            //     width: double.infinity,
            //     alignment: Alignment.center,
            //     padding: const EdgeInsets.symmetric(vertical: 12),
            //     decoration: const ShapeDecoration(
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(4)),
            //         ),
            //         color: Colors.blue),
            //     child: _isLoading
            //         ? const Center(
            //             child: CircularProgressIndicator(
            //               color: primaryColor,
            //             ),
            //           )
            //         : const Text(
            //             'Print Menu',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //   ),
            // ),
          ]),
        )),
      ),
    );
  }
}
