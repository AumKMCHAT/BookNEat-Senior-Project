import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage

    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadFile(String childName, File file, bool isPost) async {
    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final storageRef = _storage.ref();
    Reference ref = storageRef.child(childName).child(file.hashCode.toString());
    final uploadTask = ref.putFile(file, metaData);

    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();

    return url;
  }
}
