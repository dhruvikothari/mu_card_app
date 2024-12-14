import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mu_card/contact.dart';
import 'package:mu_card/dashboard.dart';
import 'package:mu_card/editprofile.dart';
import 'package:mu_card/login/welcomemobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apiConnection/apiConnection.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DrawerMenu extends StatefulWidget {
  static int userId = 0;
  DrawerMenu({super.key, required userId}) {
    DrawerMenu.userId = userId;
  }

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String name = '';
  String phNum = '';
  String email = '';
  File? _image;
  late AnimationController _animationController;
  String imageUrl = '';

  @override
  void initState() {
    fetchData();
    getImage();
    super.initState();
  }

  Future getImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    final imageTemporary = File(image.path);

    setState(() {
      this._image = imageTemporary;
    });
  }

  Future<void> getImage() async {
    try {
      String userId = DrawerMenu.userId.toString();
      String fileName = 'profilePic_$userId';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profileImages/$fileName');
      imageUrl = await firebaseStorageRef.getDownloadURL();
      setState(() {});
    } catch (e) {
      print('Error fetching image from Firebase Storage: $e');
    }
  }

  Future getImageGallary() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final imageTemporary = File(image.path);

      setState(() {
        this._image = imageTemporary;
      });
      String imageUrl =
          await uploadImageToFirebase(_image!, DrawerMenu.userId.toString());
      print('Image uploaded successfully. URL: $imageUrl');
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadImageToFirebase(File imageFile, String userId) async {
    try {
      String fileName = 'profilePic_$userId';
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('profileImages/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Upload task state: ${snapshot.state}');
        print(
            'Upload task progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      }, onError: (dynamic error) {
        print('Upload task error: $error');
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      print('Image uploaded successfully. URL: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.grey,
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
                  Scaffold.of(context).closeDrawer();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // print('pressed');
                      // getImageGallary();
                      // getImageCamera();
                      _showDialogBox(context);
                    },
                    child: ClipOval(
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              height: 120,
                              width: 120,
                            )
                          : CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      )
                                    : Image.asset(
                                        'assets/images/guest.png',
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                      ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Text(
                        name,
                        style: const TextStyle(
                            color: Colors.indigoAccent,
                            fontFamily: 'Mooli',
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Text(
                        email,
                        style: const TextStyle(
                            color: Colors.indigoAccent,
                            fontFamily: 'Mooli',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Text(
                        phNum,
                        style: const TextStyle(
                            color: Colors.indigoAccent,
                            fontFamily: 'Mooli',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        softWrap: false,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          checkRequest();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 20, 20, 20),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Get Your Card Now!',
                          style: TextStyle(
                              color: Colors.amberAccent,
                              fontSize: 15,
                              fontFamily: 'Mooli'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.off(() => EditProfile(
                          userId: DrawerMenu.userId,
                          name: name,
                          email: email,
                          phoneNum: phNum));
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 13, 21, 24),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mooli',
                          color: Color.fromARGB(255, 0, 2, 125)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 13, 21, 24),
                    ),
                    child: const Text(
                      'Learn',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mooli',
                          color: Color.fromARGB(255, 0, 2, 125)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 13, 21, 24),
                    ),
                    child: const Text(
                      'About us',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mooli',
                          color: Color.fromARGB(255, 0, 2, 125)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.to(() => ContactPage());
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 13, 21, 24),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mooli',
                          color: Color.fromARGB(255, 0, 2, 125)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 13, 21, 24),
                    ),
                    child: const Text(
                      'FAQs',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mooli',
                          color: Color.fromARGB(255, 0, 2, 125)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isLogin', false);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        'Log Out successfullly',
                        style: TextStyle(fontFamily: 'Mooli', fontSize: 12),
                      )));
                      Get.offAll(() => const WelcomeMobile());
                    },
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      backgroundColor: const Color.fromARGB(255, 246, 0, 0),
                      elevation: 0,
                      shadowColor: const Color.fromARGB(255, 13, 21, 24),
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mooli',
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'App Version : XYZ',
                  style: TextStyle(
                      color: Colors.amber[900],
                      fontFamily: 'Mooli',
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    final apiUrl = '${API.getUserinfo}?id=${DrawerMenu.userId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          name = data['uName'];
          email = data['uEmail'];
          phNum = data['uPhone'];
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  void checkRequest() async {
    try {
      var res = await http.post(Uri.parse(API.checkCardRequest), body: {
        'userId': DrawerMenu.userId.toString(),
      });

      if (res.statusCode == 200) {
        var resBodyOfCheck = jsonDecode(res.body);
        if (resBodyOfCheck['userIdExistsWithRequest1']) {
          Fluttertoast.showToast(msg: "Please wait!! Request in process");
          print("Request in process");
        } else {
          requestSend();
        }
      } else {}
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void requestSend() async {
    try {
      var res = await http.post(Uri.parse(API.insertCardRequest), body: {
        'userId': DrawerMenu.userId.toString(),
      });
      if (res.statusCode == 200) {
        var resBodyOfInsert = jsonDecode(res.body);
        if (resBodyOfInsert['success']) {
          Fluttertoast.showToast(msg: "Request Sended");
        }
      } else {
        // ignore: avoid_print
        print(res.statusCode);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _showDialogBox(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 0, 255, 247)),
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(21, 21, 21, 0),
                    child: Text(
                      'Select Picture',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 4, 120),
                          letterSpacing: 2,
                          fontFamily: 'Times New Roman'),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                        child: InkWell(
                          onTap: () {
                            getImageCamera();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/camera.png',
                                height: 70,
                                width: 70,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 21,
                                    color: Color.fromARGB(255, 7, 0, 99),
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
                        child: InkWell(
                          onTap: () {
                            getImageGallary();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/gallery.png',
                                height: 70,
                                width: 70,
                              ),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                    fontFamily: 'Times New Roman',
                                    fontSize: 21,
                                    color: Color.fromARGB(255, 7, 0, 99),
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    _animationController.forward();
  }
}
