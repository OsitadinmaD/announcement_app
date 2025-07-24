import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'storage_services.dart';

class AnnouncementController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  final RxList<PlatformFile> _pickedFiles =<PlatformFile>[].obs;
  List<PlatformFile> get pickedFiles => _pickedFiles; 
  final StorageServices storageService = Get.put<StorageServices>(StorageServices());

  RxBool uploading = false.obs;
  // Create announcement
  Future<void> createAnnouncement({
    required String title,
    required String content,
    List<String> attachments = const [],
  }) async {
    uploading.value == true;
    try {
      await _firestore.collection('announcements').add({
        'title': title,
        'content': content,
        'lecturerId': userId,
        'attachments': attachments,
        'timestamp': FieldValue.serverTimestamp(),
        'isPinned': false,
      }).whenComplete(() => Get.snackbar('Success', 'Announcement posted!',backgroundColor: Colors.green,colorText: Colors.white));
      Get.back(); // Close dialog
    } catch (e) {
      Get.snackbar('Error', 'Failed to post: ${e.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      uploading.value = false;
    }
  }

  // Get announcements stream
  Stream<QuerySnapshot> get announcementsStream {
    return _firestore
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Get lecturer-specific announcements
  Stream<QuerySnapshot> get lecturerAnnouncements {
    return _firestore
        .collection('announcements')
        .where('lecturerId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> pickFiles() async {
    //FilePickerResult? result = await FilePicker
  }
}