// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_screen/authenticatio_screen/auth_screen.dart';
import 'in_app_screens/lecturer_screen/lecturer_screen.dart';
import 'in_app_screens/student_screen.dart/student_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jtnlmuysipoezuybczmi.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp0bmxtdXlzaXBvZXp1eWJjem1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ5NTQ1ODAsImV4cCI6MjA3MDUzMDU4MH0.w2afpD_MwBF2ScksqJQMCyb-hMZ0QUDqpdFPszC-OyI',
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
        GetPage(name: '/lecturer', page: () => LecturerAnnouncementsPage()),
        GetPage(name: '/student', page: () => StudentAnnouncementsPage()),
      ],
    );
  }
}