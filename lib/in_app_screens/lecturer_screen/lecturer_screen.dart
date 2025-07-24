// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/sign_out_dialog.dart';
import 'controller/announcement_controller.dart';

class LecturerDashboard extends StatelessWidget {
  final AnnouncementController _controller = Get.put<AnnouncementController>(AnnouncementController());
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

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
          'Lecturer Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => Get.dialog(_createAnnouncementDialog()),
        tooltip: 'Create Announcement',
        child: Icon(Icons.add, color: Colors.white,size: 30,),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.lecturerAnnouncements,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.white,));
          }

          if (!snapshot.hasData){
            return Center(child: Text('No Announcement yet'));
          }
          
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              return ListTile(
                title: Text(doc['title']),
                subtitle: Text(doc['content']),
                trailing: doc['isPinned'] 
                  ? Icon(Icons.push_pin) 
                  : null,
              );
            },
          );
        },
      ),
    );
  }

  Widget _createAnnouncementDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      actionsAlignment: MainAxisAlignment.end,
      title: Text(
        'New Announcement',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500
        ),
      ),
      content: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autocorrect: true,
            controller: _titleController, 
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 5
              ),
              labelText: 'Title',
              hintText: 'Fees Payment reminder'
            )
          ),
          TextField(
            controller: _contentController, 
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11),
                borderSide: BorderSide(color: Colors.black),
                gapPadding: 5
              ),
              labelText: 'Content',
              hintText: 'Deadline closer than before'
            ), 
            maxLines: 3
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: Get.back, 
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.w500
            ),
          )
        ),
        Obx( () => _controller.uploading.value ? 
          CircularProgressIndicator(color: Colors.teal,) :
          ElevatedButton(
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.teal)),
            onPressed: (){
              if(_titleController.text.isEmpty || _contentController.text.isEmpty){
                Get.snackbar('Error', 'No text box should be empty',backgroundColor: Colors.red, colorText: Colors.white);
              }
              _controller.createAnnouncement(
                title: _titleController.text,
                content: _contentController.text,
              );
            },
            
            child: Text(
              'Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}