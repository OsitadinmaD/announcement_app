// student_announcements_page.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../auth_screen/controller/auth_controller.dart';
import '../lecturer_screen/model_class/announcement_model.dart';
import 'controller/student_view_controller.dart';
import 'sub_pages/announcement_details_page.dart';

class StudentAnnouncementsPage extends StatelessWidget {
  final controller = Get.put(StudentViewController());
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:[
          IconButton(
            icon: Icon(Icons.logout_rounded,color: Colors.white,size: 25,),
            onPressed: (){
              Get.defaultDialog(
                backgroundColor: Colors.teal.shade200,
                actions: [
                  ElevatedButton(
                    onPressed: () async => await authController.signOutUser(), 
                    child: Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                      ),
                    )
                  )
                ],
                title: 'Log out',
                content: Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                )
              );
            },
          )
        ],
        title: Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.allAnnouncements.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 60, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'No announcements available.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.allAnnouncements.length,
          itemBuilder: (context, index) {
            final announcement = controller.allAnnouncements[index];
            return GestureDetector(
              onTap: () {
                  // Navigate to the detailed announcement screen, passing the announcement object
                  Get.to(() => AnnouncementDetailsPage (announcement: announcement));
                },
              child: AnnouncementCard(
                announcement: announcement,
                onDownload: (file) => controller.downloadFile(file),
              ),
            );
          },
        );
      }),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final Function(AnnouncementFile) onDownload;

  const AnnouncementCard({Key? key, required this.announcement, required this.onDownload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('EEE, m/d/y');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
            width: Get.width,
            height: Get.height * 0.08,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(
                      Icons.person,color: Colors.teal,size:35 ,
                    ),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        announcement.lecturerName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18, 
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                        formatter.format(announcement.timestamp).toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12, 
                          fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18, 
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    announcement.content,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15, 
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              ),
            ),
          ),
            if (announcement.files.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8.0 , right: 4.0),
                child: const Divider(height: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                child: const Text(
                  'Attached Files:',
                  style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic, color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(height: 8),
              // Use a Column for a vertical list of files
              ...announcement.files.map((file) => Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                child: FileDownloadTile(
                  file: file,
                  onTap: () => onDownload(file),
                ),
              )),
            ],
          ],
        ),
      );
  }
}

class FileDownloadTile extends StatelessWidget {
  final AnnouncementFile file;
  final VoidCallback onTap;

  const FileDownloadTile({Key? key, required this.file, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.download_for_offline, color: Colors.green),
      title: Text(file.name, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 18),),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}