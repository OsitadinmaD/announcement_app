import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userRole = ''.obs;
  var isLoading = false.obs;
  var displayProceed = false.obs;

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _fetchUserRole();
      _redirectBasedOnRole();
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password, String role, String regNumber, String name) async {
    try {
      isLoading.value = true;
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      await _firestore.collection('users').doc(result.user!.uid).set({
        'email': email,
        'name': name,
        'regNumber': regNumber,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      }).whenComplete(() {
        displayProceed.value = true; 
        Get.snackbar(
          'Success', 
          'Account Created Successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
      },);
      userRole.value = role;
    } catch (e) {
      Get.snackbar('Error', 'Signup failed: ${e.toString()}',backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      displayProceed.value = false;
    }
  }

  Future<void> _fetchUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = 
          await _firestore.collection('users').doc(user.uid).get();
      userRole.value = doc['role'] ?? '';
    }
  }

  void _redirectBasedOnRole() {
    if (userRole.value == 'lecturer') {
      Get.offAllNamed('/lecturer');
    } else {
      Get.offAllNamed('/student');
    }
  }

  void signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/');
  }
}