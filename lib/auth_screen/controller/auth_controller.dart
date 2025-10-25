// auth_controller.dart
import 'package:announcement_app/helpers/snackbar_helpers.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../in_app_screens/lecturer_screen/lecturer_screen.dart';
import '../../in_app_screens/student_screen.dart/student_home.dart';
import '../authenticatio_screen/auth_screen.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Sign-up logic
  Future<void> signUpUser({
    required String email,
    required String password,
    required String fullName,
    required String idNumber,
    required String role,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 1. Create the user in Supabase Auth
      final AuthResponse authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;

      if (user != null) {
        // 2. Insert the user's details into the 'users' table
        await supabase.from('users').insert({
          'id': user.id,
          'full_name': fullName,
          'id_number': idNumber,
          'role': role,
        });
        snackbarSuccess(title: 'Success', message: 'Sign-up successful! Please check your email to confirm your account.');
        //Get.offAll(() => LoginScreen());
      } else {
        errorMessage.value = 'Sign-up failed.';
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message ;
      snackbarError(title: 'Error', message: errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      snackbarError(title: 'Error', message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign-in logic with role-based routing
  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final AuthResponse authResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      
      if (user != null) {
        // Fetch the user's role from the 'users' table
        final List<Map<String, dynamic>> response = await supabase
            .from('users')
            .select('role')
            .eq('id', user.id);

        //check if the response is empty before accessing the role
        if(response.isNotEmpty){
          final role = response.first['role'];
          if (role == 'lecturer') {
            Get.offAll(() => LecturerAnnouncementsPage());
          } else {
            Get.offAll(() => StudentAnnouncementsPage());
          }
          snackbarSuccess(title: 'Success', message: 'Signed in successfully as a $role.');
        } else {
          //Handle case where user has no profile
          errorMessage.value = 'User profile not found.';
          snackbarError(title: 'Error', message: errorMessage.value);
        }
        
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      snackbarError(title: 'Error', message: errorMessage.value);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      snackbarError(title: 'Error', message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Sign-out logic
  Future<void> signOutUser() async {
    await supabase.auth.signOut();
    Get.offAll(() => AuthScreen());
    snackbarSuccess(title: 'Info', message: 'You have been signed out.');
  }
}