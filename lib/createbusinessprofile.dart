// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mu_card/dashboard.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import 'Business/business.dart';
import 'apiConnection/apiConnection.dart';
import 'get_size.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateBusinessProfile extends StatefulWidget {
  static int userId = 0;
  CreateBusinessProfile({super.key, required userId}) {
    // ignore: prefer_initializing_formals
    CreateBusinessProfile.userId = userId;
  }

  @override
  State<CreateBusinessProfile> createState() => _CreateBusinessProfileState();
}

class _CreateBusinessProfileState extends State<CreateBusinessProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController designation = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController company_name = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController industry_name = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController bio_text = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController add_edu = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController hobby = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController info_add = TextEditingController();
  TextEditingController service = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController house_number = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController whatsapp_num = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController phone_num = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController insta_id = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController facebook_id = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController linkedin_id = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController twitter_id = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController skype_id = TextEditingController();
  TextEditingController gpay = TextEditingController();
  TextEditingController paytm = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController web_link = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController drive_link = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController docs_link = TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController cloud_link = TextEditingController();
  TextEditingController messanger = TextEditingController();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  File? _image;

  Future<String> uploadImageToFirebase(
      File imageFile, String businessId) async {
    try {
      String fileName = 'profilePic_$businessId';
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('businessProfileImages/$fileName');

      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('State: ${snapshot.state}'); // e.g., running, paused
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      print('Upload successful. Image URL: $imageUrl');
      print("function call");
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
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
    } catch (e) {
      print(e);
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

  @override
  Widget build(BuildContext context) {
    Future<void> showName() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Basic Info',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Your Name',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            // borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: designation,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Designation',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: company_name,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Company',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: industry_name,
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Industry',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          name.clear();
                          designation.clear();
                          company_name.clear();
                          industry_name.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addbio() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Bio',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: bio_text,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Bio Here',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          bio_text.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    //add edu menu
    Future<void> addedu() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Education',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: add_edu,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Education Here',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          add_edu.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addExp() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Experience',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: experience,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Experience Here',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          add_edu.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addhobby() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Hobby',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: hobby,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Hobby Here',
                        counterText: '',
                        hintStyle: TextStyle(
                            fontFamily: 'Mooli',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          hobby.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addinfo() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Info',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: info_add,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Info Here',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          info_add.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addservices(context) async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Services',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: service,
                      maxLines: 7,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Services Here',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          service.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addAddress(context) async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Address',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: house_number,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add House Number',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: city,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add City',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: state,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add State',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: country,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Country',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          house_number.clear();
                          city.clear();
                          state.clear();
                          country.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addwhatsapp() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add WhatsApp',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: whatsapp_num,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add WhatsApp',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          whatsapp_num.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addMobileNumberField() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Mobile No.',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 25,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: phone_num,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Enter your number',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          phone_num.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addEmailAddress() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Email id',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    // height: 50,
                    child: TextFormField(
                      controller: email,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          email.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addInstagram() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Instagram',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: insta_id,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Instagram',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          insta_id.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addFacebook() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Facebook',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: facebook_id,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Facebook',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          facebook_id.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addLinkedin() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add LinkedIn',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: linkedin_id,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add LinkedIn',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          linkedin_id.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addTwitter() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Twitter',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: twitter_id,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Twitter',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          twitter_id.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addSkype() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Skype',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: skype_id,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Skype',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          skype_id.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    //gpay add
    Future<void> addGpay() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add GPay',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: gpay,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add GPay',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          gpay.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addPaytm() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Paytm',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: paytm,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Paytm',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          paytm.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addWebsite() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Website',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: web_link,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Website Link',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          web_link.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addDrive() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Drive',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: drive_link,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Drive Link',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          drive_link.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addDocument() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Document',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: docs_link,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Document Link',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          docs_link.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addCloud() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Cloud',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: cloud_link,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Cloud Link',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          cloud_link.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    Future<void> addMessenger() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Text(
                          'Add Messenger',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Mooli',
                              fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 35,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: messanger,
                      cursorColor: Colors.black,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          letterSpacing: 1.1,
                          fontFamily: 'Mooli'),
                      decoration: InputDecoration(
                        hintText: 'Add Messenger',
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        // filled: true,
                        // fillColor: Colors.white,
                        border: OutlineInputBorder(
                            // borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          messanger.clear();
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Remove',
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Mooli',
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
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
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 20, 20, 20),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
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
              ],
            );
          });
    }

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: const [
          Color.fromARGB(255, 114, 114, 114),
          Colors.white,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Business Profile',
            style: TextStyle(
                fontFamily: 'Mooli',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Color.fromARGB(255, 208, 211, 211),
                    Color.fromARGB(255, 255, 255, 255),
                  ]),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 7, 7),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    if (validateForm()) {
                      print("function calling");
                      saveBusinessProfile();

                      print("function called");
                    } else {
                      showAlertDialog();
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(50, 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    ' Save',
                    style: TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 20,
                        fontFamily: 'Mooli',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: const [
                        Color.fromARGB(82, 72, 81, 82),
                        Color.fromARGB(197, 105, 164, 164)
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(21, 12, 21, 8),
                        child: InkWell(
                          onTap: () {
                            // print('pressed');
                            // getImageGallary();
                            // getImageCamera();
                            _showDialogBox(context);
                          },
                          child: ClipOval(
                            //no need to provide border radius to make circular image
                            child: _image != null
                                ? Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/guest.png',
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showName();
                        },
                        child: Column(
                          children: const [
                            Text(
                              'Your Name',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontFamily: 'Mooli',
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Designation',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Mooli',
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Company',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Mooli',
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Industry',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Mooli',
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: getHeight(context, 0.06),
                  width: getWidth(context, 0.4),
                  child: ElevatedButton(
                    onPressed: () {
                      addbio();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      'Add Bio',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Mooli'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: getHeight(context, 0.06),
                  width: getWidth(context, 0.55),
                  child: ElevatedButton(
                    onPressed: () {
                      addservices(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      'Add Services',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Mooli'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 15, 2, 5),
                child: Text(
                  'Phone messenger & Emails',
                  style: TextStyle(
                      fontFamily: 'Mooli',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addMobileNumberField();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.call,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Contact',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addEmailAddress();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.email,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Email ID',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addwhatsapp();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.whatsapp,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Whatsapp',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addMessenger();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.facebookMessenger,
                              size: 42,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            'Messenger',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 15, 2, 5),
                child: Text(
                  'Address & Location',
                  style: TextStyle(
                      fontFamily: 'Mooli',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    addAddress(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 42,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Text(
                        'Add new',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Mooli',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 15, 2, 5),
                child: Text(
                  'Website & Links',
                  style: TextStyle(
                    fontFamily: 'Mooli',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addWebsite();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.earthAsia,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Website',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addDrive();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.googleDrive,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Drive Link',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addDocument();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.edit_document,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Document',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addCloud();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.cloud,
                              size: 42,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            'Cloud Link',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 15, 2, 5),
                child: Text(
                  'Social Media',
                  style: TextStyle(
                    fontFamily: 'Mooli',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addSkype();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.skype,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Skype',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addTwitter();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.twitter,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Twitter',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addLinkedin();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.linkedin,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'LinkedIn',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addFacebook();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.facebook,
                              size: 42,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            'Facebook',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addInstagram();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.instagram,
                              size: 42,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Text(
                            'Instagram',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 15, 2, 5),
                child: Text(
                  'Payment',
                  style: TextStyle(
                    fontFamily: 'Mooli',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addGpay();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.googlePay,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'GPay',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addPaytm();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.paypal,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Paytm',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 15, 2, 5),
                child: Text(
                  'Other Information',
                  style: TextStyle(
                    fontFamily: 'Mooli',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addedu();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.graduationCap,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Education',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addExp();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.certificate,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Experience',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addhobby();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.puzzlePiece,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Hobbies',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: InkWell(
                      onTap: () {
                        addinfo();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              FontAwesomeIcons.info,
                              size: 42,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Info',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveBusinessProfile() async {
    print("Saving business profile");
    Business businessProfile = Business(
      CreateBusinessProfile.userId.toString(),
      company_name.text.trim(),
      industry_name.text.trim(),
      name.text.trim(),
      designation.text.trim(),
      phone_num.text.trim(),
      email.text.trim(),
      bio_text.text.trim(),
      service.text.trim(),
      whatsapp_num.text.trim(),
      messanger.text.trim(),
      "${house_number.text.trim()} ${city.text.trim()} ${state.text.trim()}${country.text.trim()}",
      web_link.text.trim(),
      drive_link.text.trim(),
      docs_link.text.trim(),
      cloud_link.text.trim(),
      skype_id.text.trim(),
      twitter_id.text.trim(),
      insta_id.text.trim(),
      linkedin_id.text.trim(),
      facebook_id.text.trim(),
      gpay.text.trim(),
      paytm.text.trim(),
      add_edu.text.trim(),
      experience.text.trim(),
      hobby.text.trim(),
      info_add.text.trim(),
    );

    try {
      var res = await http.post(Uri.parse(API.createProfile),
          body: businessProfile.toJson());
      print(res.body);
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);

        if (resBody['success']) {
          uploadImageToFirebase(_image!, resBody['businessId'].toString());
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Business profile Created successfully')));

          Get.to(() => Dashboard(userId: CreateBusinessProfile.userId));
        } else {
          Fluttertoast.showToast(msg: "Error: Unable to save profile");
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  bool validateForm() {
    return name.text.isNotEmpty &&
        designation.text.isNotEmpty &&
        company_name.text.isNotEmpty &&
        industry_name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        house_number.text.isNotEmpty &&
        state.text.isNotEmpty &&
        city.text.isNotEmpty &&
        country.text.isNotEmpty &&
        phone_num.text.isNotEmpty &&
        whatsapp_num.text.isNotEmpty;
  }

  void showAlertDialog() {
    showDialog(
      context: context, // Make sure you have access to the context variable
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text('Please fill out the required fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
