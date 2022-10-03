import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadImage(String filePath, String fileName) async {

    File file = File(filePath);

    try {
      await storage.ref('staffs/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print('error');
      print(e.toString());
    }
  }

  Future<String> downloadUrl (String imageName) async {
    String donwloadUrl = await storage.ref('staffs/$imageName').getDownloadURL();
    return donwloadUrl;
  }
}