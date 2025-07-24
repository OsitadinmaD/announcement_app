import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login_screen/login_screen.dart';
import '../../signUpScreen/sign_up_screen.dart';

class TabBarWidgetView {
  TabBarWidgetView();

  static Widget tabPagesView(TabController controller) {
    return SizedBox(
      height: Get.height * 0.7,
      child: TabBarView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SignUpScreen(),
          LoginScreen()
        ]
      ),
    );
  }

  static PreferredSize tabBarIndicator(TabController controller) {
    return PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Card(
          color: Colors.teal.shade200,
          child: TabBar(
            controller: controller,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Colors.teal
            ),
            tabs: [
              Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500
                ),
              )
            ]
          ),
        ),
      );
  }
}