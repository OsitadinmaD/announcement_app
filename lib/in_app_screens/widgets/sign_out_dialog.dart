import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth_screen/authenticatio_screen/auth_screen.dart';
import '../../auth_screen/controller/auth_controller.dart';

AlertDialog signOutDialog() {
  final authController = Get.put(AuthController());
    return AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
                content: Text(
                  'Do you want to log out?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: Get.back, 
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    )
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                    onPressed: () {
                      authController.signOut();
                      Get.offAll(()=> AuthScreen());
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              );
  }