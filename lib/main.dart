// ignore_for_file: use_key_in_widget_constructors

import 'package:announcement_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_screen/authenticatio_screen/auth_screen.dart';
import 'in_app_screens/lecturer_screen/lecturer_screen.dart';
import 'in_app_screens/student_screen.dart/student_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(NoticeBoardApp());
}

class NoticeBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => AuthScreen()),
        GetPage(name: '/lecturer', page: () => LecturerDashboard()),
        GetPage(name: '/student', page: () => StudentDashboard()),
      ],
    );
  }
}