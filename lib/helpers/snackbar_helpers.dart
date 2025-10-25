import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController snackbarSuccess({required String title,required String message}) {
  return Get.snackbar(
    title, 
    message,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

SnackbarController snackbarError({required String title,required String message}) {
  return Get.snackbar(
    title, 
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

SnackbarController snackbarInfo({required String title,required String message}) {
  return Get.snackbar(
    title, 
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}