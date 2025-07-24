// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _role = 'select role'.obs;

  final AuthController _authController = Get.put(AuthController());

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 5,
        children: [
          Text(
            'Enter Login Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w600,
              wordSpacing: 1
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person, color: Colors.black,size: 25,),
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person, color: Colors.black,size: 25,)
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Role',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w400
                ),
              ),
              Obx(() => DropdownButton<String>(
                dropdownColor: Colors.white,
                value: _role.value,
                items: ['select role','student', 'lecturer']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) => _role.value = value!,
              )),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: Get.width * 0.8,
            child: Obx(() => _authController.isLoading.value
                ? Center(child: CircularProgressIndicator(color:Colors.teal,))
                : ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.teal)),
                    onPressed: () {
                      if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                        Get.snackbar('Error', 'No textfield detail should be empty', backgroundColor: Colors.red,colorText: Colors.white);
                          return;
                      }
                      _authController.signIn(_emailController.text, _passwordController.text);
                    },
                    child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
            ),
          )
        ],
      ),
    );
  }
}