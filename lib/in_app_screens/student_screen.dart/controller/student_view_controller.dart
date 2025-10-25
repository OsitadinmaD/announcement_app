// student_view_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:announcement_app/helpers/snackbar_helpers.dart';
import 'package:announcement_app/in_app_screens/lecturer_screen/model_class/announcement_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class StudentViewController extends GetxController {
  // Supabase client instance
  final supabase = Supabase.instance.client;

  var allAnnouncements = <Announcement>[].obs;
  var filteredAnnouncements = <Announcement>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;
  StreamSubscription<List<Map<String, dynamic>>>? _announcementSubscription;

  @override
  void onInit() {
    super.onInit();
    _fetchAllAnnouncements();
    ever(allAnnouncements, (_) => _filterAnnouncements());
    ever(searchQuery, (_) => _filterAnnouncements());
  }

  Future<void> _fetchAllAnnouncements() async {
    try {
      // Step 1: Initial Data Fetch (Blocking)
      // This query will get all announcements for the initial page load.
      final response = await supabase
          .from('announcements')
          .select('*, users(full_name)')
          .order('created_at', ascending: false);

      final List<Announcement> initialAnnouncements = [];
      for (var row in response) {
        final announcement = Announcement(
          id: row['id'],
          title: row['title'],
          content: row['content'],
          lecturerId: row['lecturerId'],
          lecturerName: row['users']?['full_name']??'Unknown Lecturer', // 'full_name' is now guaranteed
          timestamp: DateTime.parse(row['created_at']),
        );

        final fileRows = await supabase
            .from('announcement_files')
            .select()
            .eq('announcement_id', announcement.id)
            .order('file_name', ascending: true);

        final fetchedFiles = fileRows.map((fileRow) {
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
      allAnnouncements.value = initialAnnouncements;

      // Step 2: Set up the Real-time Listener (Non-blocking)
      // This listener will only be set up once and will update the list on changes
      _announcementSubscription?.cancel();
      _announcementSubscription = supabase
          .from('announcements')
          .select('id, created_at') // A lighter query for the stream
          .order('created_at', ascending: false)
          .asStream()
          .listen((data) {
            // Re-fetch the data when a change is detected to ensure consistency
            _fetchAllAnnouncements();
          }, onError: (error) {
            snackbarError(title:'Stream Error',message: 'Failed to update announcements: $error');
          });

    } catch (e) {
      printError(info: 'An unexpected error occurred: $e');
     snackbarError(title:'Error',message: 'An unexpected error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _filterAnnouncements() {
    if (searchQuery.isEmpty) {
      filteredAnnouncements.value = allAnnouncements;
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredAnnouncements.value = allAnnouncements.where((announcement) {
        final title = announcement.title.toLowerCase();
        final content = announcement.content.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    }
  }

  Future<void> downloadFile(AnnouncementFile file) async {
    snackbarInfo(title: 'Downloading',message: 'Downloading ${file.name}...');
    try {
      //final status = Permission
      final response = await http.get(Uri.parse(file.url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${file.name}';
        final fileInstance = File(filePath);
        await fileInstance.writeAsBytes(response.bodyBytes);
        snackbarSuccess(title: 'Success',message: '${file.name} downloaded to ${directory.path}');
      } else {
        snackbarError(title: 'Error',message: 'Failed to download file.');
      }
    } catch (e) {
      //snackbarError(title: 'Error', message: 'An error occurred during download: $e');
      printError(info: e.toString());
    }
  }
}