import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/snackbar_helpers.dart';

class LecturerAnnouncementController extends GetxController {
  final supabase = Supabase.instance.client;

  // Reactive variables for the UI
  var title = ''.obs;
  var content = ''.obs;
  var selectedFiles = <PlatformFile>[].obs;
  var isLoading = false.obs;
  var uploadProgress = 0.0.obs;

  // Method to pick files from the device
  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      selectedFiles.value = result.files;
    }
  }

  // Method to upload a single file to Supabase Storage
  Future<String> _uploadFile(PlatformFile file) async {
    // Generate a unique file name to avoid conflicts
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    final storagePath = 'announcements/$fileName';

    // Upload the file to the 'announcement_files' bucket
    await supabase.storage.from('announcement-files').upload(
      storagePath,
      File(file.path!),
      fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );

    // Get the public URL for the uploaded file
    final publicUrl = supabase.storage.from('announcement-files').getPublicUrl(storagePath);
    
    return publicUrl;
  }

  // The main method to create the announcement
  void createAnnouncement() async {
    if (title.isEmpty || content.isEmpty) {
      snackbarError(title: 'Error', message: 'Title and content cannot be empty.');
      return;
    }

    isLoading.value = true;
    
    try {
      // 1. Upload all files to Supabase Storage and get their URLs
      final List<Map<String, dynamic>> uploadedFilesData = [];
      for (var file in selectedFiles) {
        final downloadUrl = await _uploadFile(file);
        
        uploadedFilesData.add({
          'file_name': file.name,
          'file_url': downloadUrl,
          'file_size': file.size,
        });
      }

      final currentUser = Supabase.instance.client.auth.currentUser;

      if(currentUser == null){
        snackbarError(title: 'Error', message: 'You must be logged in to post announcements');
      }

      final String lecturerId = supabase.auth.currentUser!.id;

      printError(info: 'Attempting to insert announcement for lecturer ID: $lecturerId');



      // 2. Insert the announcement into the 'announcements' table
      // The .select() method returns the newly inserted row, including its ID.
      final announcementInsertResult = await supabase.from('announcements').insert({
        'title': title.value,
        'content': content.value,
        'lecturerId': lecturerId, 
      }).select();

      final newAnnouncementId = announcementInsertResult[0]['id'];

      // 3. Insert the files into the 'announcement_files' table, linking them to the new announcement
      for (var fileData in uploadedFilesData) {
        fileData['announcement_id'] = newAnnouncementId;
      }
      if (uploadedFilesData.isNotEmpty) {
        await supabase.from('announcement_files').insert(uploadedFilesData);
      }
      
      // Success! Clear the form and show a message
      isLoading.value = false;
      title.value = '';
      content.value = '';
      selectedFiles.value = [];
      snackbarSuccess(title: 'Success', message: 'Announcement created successfully!');

    } catch (e) {
      isLoading.value = false;
      snackbarError(title: 'Error', message: 'Failed to create announcement: $e');
    }
  }
}