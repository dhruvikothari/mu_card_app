import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mu_card/drawer.dart';
import 'package:mu_card/login/welcomemobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apiConnection/apiConnection.dart';
import 'get_size.dart';

class EditProfile extends StatefulWidget {
  static int userId = 0;
  static String name = '';
  static String email = '';
  static String phoneNum = '';
  EditProfile(
      {super.key,
      required int userId,
      required String name,
      required String email,
      required String phoneNum}) {
    // ignore: prefer_initializing_formals
    EditProfile.userId = userId;
    // ignore: prefer_initializing_formals
    EditProfile.name = name;
    // ignore: prefer_initializing_formals
    EditProfile.email = email;
    // ignore: prefer_initializing_formals
    EditProfile.phoneNum = phoneNum;
  }

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Colors.grey,
          Colors.white,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(2.5, 2.5, 0, 2.5),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1, color: const Color.fromARGB(255, 167, 167, 167)),
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(22, 76, 76, 76),
              ),
              child: IconButton(
                onPressed: () {
                  Get.off(() => DrawerMenu(
                        userId: EditProfile.userId,
                      ));
                },
                icon: const Icon(
                  Icons.chevron_left_sharp,
                  color: Color.fromARGB(255, 9, 0, 103),
                  size: 30,
                ),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(100)),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 50,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontSize: 15,
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
                        fontSize: 15,
                        letterSpacing: 1.1,
                        fontFamily: 'Mooli'),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                      // filled: true,
                      // fillColor: Colors.white,
                      border: OutlineInputBorder(
                          // borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Text(
                      'Contact',
                      style: TextStyle(
                          fontSize: 15,
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
                  // height: 50,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Contact Number';
                      }
                      return null;
                    },
                    controller: contactController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 1.1,
                        fontFamily: 'Mooli'),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                      border: OutlineInputBorder(
                          // borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Text(
                      'Email ID',
                      style: TextStyle(
                          fontSize: 15,
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
                      fontFamily: 'Mooli',
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                      border: OutlineInputBorder(
                          // borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: getHeight(context, 0.06),
                      width: getWidth(context, 0.28),
                      child: ElevatedButton(
                        onPressed: () {
                          updateUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 20, 20, 20),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 20,
                              fontFamily: 'Mooli'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          showDeleteConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 252, 0, 0),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Mooli'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateUser() async {
    var res = await http.post(
      Uri.parse(API.editUserProfile),
      body: {
        "id": EditProfile.userId.toString(),
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phoneNum": contactController.text.trim()
      },
    );

    if (res.statusCode == 200) {
      var resBodyOfUpdate = jsonDecode(res.body);
      if (resBodyOfUpdate['success']) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );
        Get.off(() => DrawerMenu(userId: EditProfile.userId));
      } else {
        // ignore: avoid_print
        print("Update Failed");
      }
    }
  }

  void deleteUser() async {
    var res = await http.post(
      Uri.parse(API.deleteUserProfile),
      body: {"id": EditProfile.userId.toString()},
    );

    if (res.statusCode == 200) {
      var resBodyOfUpdate = jsonDecode(res.body);
      if (resBodyOfUpdate['success']) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLogin', false);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'Account deleted successfully',
            style: TextStyle(
                fontSize: 20, letterSpacing: 1.1, fontFamily: 'Mooli'),
          )),
        );
        Get.offAll(() => WelcomeMobile());
      } else {
        // ignore: avoid_print
        print("Update Failed");
      }
    }
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dialog will not dismiss when tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete your account?',
                  style: TextStyle(
                      fontSize: 20, letterSpacing: 1.1, fontFamily: 'Mooli'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 20, letterSpacing: 1.1, fontFamily: 'Mooli'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                deleteUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                    fontSize: 20, letterSpacing: 1.1, fontFamily: 'Mooli'),
              ),
            ),
          ],
        );
      },
    );
  }
}
