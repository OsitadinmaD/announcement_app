
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorageServices extends GetxService{
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile({required String path, required String fileName}) async {
    try {
      Reference ref = _storage.ref().child('attachments/$fileName');
      await ref.putFile(File(path));
      return ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Upload Failed', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }
  }
}