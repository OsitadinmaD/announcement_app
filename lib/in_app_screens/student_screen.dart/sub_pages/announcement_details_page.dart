// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lecturer_screen/model_class/announcement_model.dart';
import '../controller/student_view_controller.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailsPage({Key? key, required this.announcement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentController = Get.find<StudentViewController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          announcement.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Posted by: Lecturer [ID: ${announcement.lecturerId}]',
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 18),
            ),
            Text(
              'Date: ${announcement.timestamp.toString().split(' ')[0]}',
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              announcement.content,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            if (announcement.files.isNotEmpty) ...[
              const Divider(height: 32),
              const Text(
                'Attached Files',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...announcement.files.map(
                (file) => FileDownloadTile(
                file: file,
                onTap: () => studentController.downloadFile(file),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

// Re-using the FileDownloadTile from the previous response
class FileDownloadTile extends StatelessWidget {
  final AnnouncementFile file;
  final VoidCallback onTap;

  const FileDownloadTile({Key? key, required this.file, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.insert_drive_file, color: Colors.teal),
        title: Text(file.name, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18)),
        trailing: IconButton(
          icon: const Icon(Icons.download, color: Colors.green),
          onPressed: onTap,
        ),
        onTap: onTap, // Making the whole tile tappable
      ),
    );
  }
}