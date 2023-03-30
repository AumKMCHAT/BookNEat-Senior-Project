import 'dart:io';
import 'package:book_n_eat_senior_project/resources/auth_methods.dart';
import 'package:book_n_eat_senior_project/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DialogBoxEditMenu extends StatefulWidget {
  VoidCallback onCancel;

  DialogBoxEditMenu({
    super.key,
    required this.onCancel,
  });

  @override
  State<DialogBoxEditMenu> createState() => _DialogBoxEditMenuState();
}

class _DialogBoxEditMenuState extends State<DialogBoxEditMenu> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  late File filePdf;
  String filePdfPath = "No File Selected";
  String resId = "";

  @override
  void initState() {
    super.initState();
    getResId();
  }

  void getResId() async {
    var resId = await _firestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then(
            (DocumentSnapshot snapshot) => snapshot.get(FieldPath(['resId'])));
    setState(() {
      this.resId = resId;
    });
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      filePdf = file;
      setState(() {
        filePdfPath = path.basename(file.path).toString();
      });
    }
  }

  void onSubmit() async {
    String res = await AuthMedthods()
        .updateRestaurantMenu(filePdf: filePdf, resId: resId);
    showSnackBar(res, context);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 150,
        child: Column(
          children: [
            Text(filePdfPath),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Colors.blue)),
              onPressed: pickFile,
              child: Text('Pick a PDF file'),
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                ),
                SizedBox(
                  width: 80,
                ),
                ElevatedButton(
                    onPressed: onSubmit,
                    child: const Text('Submit'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.blue))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
