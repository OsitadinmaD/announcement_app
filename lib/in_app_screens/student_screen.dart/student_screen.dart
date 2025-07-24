// ignore_for_file: use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../lecturer_screen/controller/announcement_controller.dart';
import '../widgets/sign_out_dialog.dart';

class StudentDashboard extends StatelessWidget {
  final AnnouncementController _controller = Get.put<AnnouncementController>(AnnouncementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                signOutDialog()
              );
            }, 
            icon: Icon(Icons.logout_rounded, size: 25,color: Colors.white,)
          )
        ],
        backgroundColor: Colors.teal,
        title: Text(
          'Notice Board',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.announcementsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal,));
          }

          if(!snapshot.hasData){
            return Center(child: Text('No Announcement yet'));
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 8),
                      Text(doc['content']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}