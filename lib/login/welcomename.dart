// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mu_card/apiConnection/apiConnection.dart';
import 'package:mu_card/dashboard.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mu_card/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../get_size.dart';

class WelcomeName extends StatefulWidget {
  static String welcomeName = '';
  static String welcomeEmail = '';
  static int id = 0;
  static String phoneNum = '';
  WelcomeName({super.key, required String phoneNum}) {
    // ignore: prefer_initializing_formals
    WelcomeName.phoneNum = phoneNum;
  }

  @override
  State<WelcomeName> createState() => _WelcomeNameState();
}

class _WelcomeNameState extends State<WelcomeName> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController referralController = TextEditingController();
  bool referralVisibility = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topRight,
        // stops: [0.5, 0.5],
        colors: [
          Colors.grey,
          Colors.white,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                      // ignore: sized_box_for_whitespace
                      child: Container(
                        height: getHeight(context, 0.017),
                        width: getWidth(context, 0.8),
                        child: const ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: LinearProgressIndicator(
                            backgroundColor: Color.fromARGB(255, 178, 178, 178),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 0, 255, 34)),
                            value: 0.75,
                            minHeight: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 70, 0, 0),
                      child: Text(
                        'Welcome to Ekagrata',
                        style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 1,
                            fontFamily: 'Mooli',
                            color: Color.fromARGB(255, 38, 36, 36),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        'Let\'s get started...',
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 1,
                            fontFamily: 'Mooli',
                            color: Color.fromARGB(255, 121, 121, 121),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 55, 0, 0),
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 1,
                            fontFamily: 'Mooli',
                            color: Color.fromARGB(255, 38, 36, 36),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SizedBox(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Text(
                        'Email ID',
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 1,
                            fontFamily: 'Mooli',
                            color: Color.fromARGB(255, 38, 36, 36),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SizedBox(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Email';
                        }
                        return null;
                      },
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                      child: SizedBox(
                        height: getHeight(context, 0.06),
                        width: getWidth(context, 0.4),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              validateEmail();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                  'All Fields Are Required!',
                                  style: TextStyle(
                                      fontFamily: 'Mooli',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromARGB(255, 6, 0, 0), // background
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                color: Color.fromARGB(255, 238, 255, 0),
                                fontSize: 21,
                                fontFamily: 'Mooli',
                                letterSpacing: 1.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateEmail() async {
    try {
      var res = await http.post(Uri.parse(API.validEmail), body: {
        'email': emailController.text.trim(),
      });

      if (res.statusCode == 200) {
        var resBodyOfEmail = jsonDecode(res.body);
        if (resBodyOfEmail['emailFound']) {
          Fluttertoast.showToast(msg: "Email already exist");
        } else {
          saveUser();
        }
      } else {}
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void saveUser() async {
    User userModel = User(nameController.text.trim(),
        emailController.text.trim(), WelcomeName.phoneNum);
    try {
      var res = await http.post(Uri.parse(API.sigup), body: userModel.toJson());

      if (res.statusCode == 200) {
        var resBodyOfSignup = jsonDecode(res.body);
        if (resBodyOfSignup['success']) {
          int id = resBodyOfSignup['id'];
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLogin', true);
          await prefs.setInt('userId', id);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successfullly')));
          insertActiveProfile(id);
        } else {
          Fluttertoast.showToast(msg: "Error Sorry!!!!");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void insertActiveProfile(int userId) async {
    try {
      var res = await http.post(Uri.parse(API.insertActiveProfile), body: {
        'userId': userId.toString(),
      });

      if (res.statusCode == 200) {
        var resBodyOfSignup = jsonDecode(res.body);
        if (resBodyOfSignup['success']) {
          Get.off(() => Dashboard(userId: userId));
        } else {
          Fluttertoast.showToast(msg: "Error Sorry!!!!");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
