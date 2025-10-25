import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/announcement_controller.dart';

class LecturerPostAnnouncementPage extends StatelessWidget {
  final controller = Get.put(LecturerAnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 25,),
        ),
        backgroundColor: Colors.teal,
        title: const Text(
          'Create Announcement',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Prayer walk...',
                    border: OutlineInputBorder(),
                    hintFadeDuration: Duration(milliseconds: 200)
                  ),
                  onChanged: (value) => controller.title.value = value,
                ),
                const SizedBox(height: 16),
                Text(
                  'Content',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Do not miss out of this event...',
                    border: OutlineInputBorder(),
                    hintFadeDuration: Duration(milliseconds: 200)
                  ),
                  maxLines: 5,
                  onChanged: (value) => controller.content.value = value,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () => controller.pickFiles(),
                  label: const Text(
                    'Select Files',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  icon: Icon(Icons.file_open_rounded, color: Colors.white,size: 20,),
                ),
                const SizedBox(height: 16),
                // Display the selected files
                if (controller.selectedFiles.isNotEmpty)
                  Text(
                    'Selected Files: ${controller.selectedFiles.length}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ...controller.selectedFiles.map(
                  (file) => Card(
                    color: Colors.grey[200],
                    child: ListTile(
                      title: Text(file.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 18)),
                      subtitle: Text('Size: ${file.size} bytes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontSize: 15)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Show a progress indicator when uploading
                if (controller.isLoading.value)
                  Column(
                    children: [
                      LinearProgressIndicator(value: controller.uploadProgress.value),
                      Text(
                        '${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% uploaded',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400
                    ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: controller.isLoading.value ? null : () => controller.createAnnouncement(),
                  label: Text(
                    controller.isLoading.value ?
                    'Please wait...' :
                    'Post Announcement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  icon: controller.isLoading.value ? const CircularProgressIndicator(color: Colors.white) : Icon(Icons.send_rounded, color: Colors.white,size: 20,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}