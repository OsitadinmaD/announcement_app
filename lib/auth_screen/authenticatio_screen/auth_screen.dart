// ignore_for_file: use_key_in_widget_constructors

import 'package:announcement_app/auth_screen/authenticatio_screen/widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
 
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 5,
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                ),
                Text(
                  'Announce It',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                  ),
                ),
                TabBarWidgetView.tabBarIndicator(_tabController),
                TabBarWidgetView.tabPagesView(_tabController)
              ],
            ),
          ),
        ),
      )
    );
  }
}