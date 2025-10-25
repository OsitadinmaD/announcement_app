import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model_class/announcement_model.dart';


class LecturerViewAnnouncementController extends GetxController {
  final supabase = Supabase.instance.client;

  var myAnnouncements = <Announcement>[].obs;
  var isLoading = true.obs;
  StreamSubscription<List<Map<String, dynamic>>>? _announcementSubscription;

  @override
  void onInit() {
    super.onInit();
    _fetchMyAnnouncements();
  }

  // This is the fix for the Bad State error
  @override
  void onClose() {
    _announcementSubscription?.cancel();
    super.onClose();
  }

  void _fetchMyAnnouncements() async {
    final lecturerId = supabase.auth.currentUser?.id;

    if (lecturerId == null) {
      isLoading.value = false;
      Get.snackbar('Error', 'No authenticated user found.');
      return;
    }

    // Don't set isLoading to true here. Set it before the try block.
    // Setting it here can cause a flash in the UI.

    try {
      // 1. Initial Data Fetch
      final response = await supabase
          .from('announcements')
          .select('*, users(full_name)')
          .eq('lecturerId', lecturerId)
          .order('created_at', ascending: false);

      final List<Announcement> initialAnnouncements = [];
      for (var row in response) {
        final announcement = Announcement(
          id: row['id'],
          title: row['title'],
          content: row['content'],
          lecturerId: row['lecturerId'],
          lecturerName: row['users']['full_name'],
          timestamp: DateTime.parse(row['created_at']),
        );

        final fileRows = await supabase
            .from('announcement_files')
            .select()
            .eq('announcement_id', announcement.id)
            .order('file_name', ascending: true);

        final List<AnnouncementFile> fetchedFiles = fileRows.map((fileRow) {
          return AnnouncementFile(
            id: fileRow['id'],
            name: fileRow['file_name'],
            url: fileRow['file_url'],
            fileSize: fileRow['file_size'],
          );
        }).toList();

        announcement.files = fetchedFiles;
        initialAnnouncements.add(announcement);
      }
      myAnnouncements.value = initialAnnouncements;

      // 2. Set up the Real-time Listener (Non-blocking)
      _announcementSubscription?.cancel();
      _announcementSubscription = supabase
          .from('announcements')
          .select('*, users(full_name)')
          .eq('lecturerId', lecturerId)
          .order('created_at', ascending: false)
          .asStream()
          .listen((data) {
            _fetchMyAnnouncements();
          });
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}