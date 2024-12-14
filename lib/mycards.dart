// ignore_for_file: dead_code
// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mu_card/dashboard.dart';
import 'package:mu_card/showbusinessprofile.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apiConnection/apiConnection.dart';

class MyCards extends StatefulWidget {
  static int businessId = 0;
  static int userId = 0;
  MyCards({super.key, required int userId}) {
    MyCards.userId = userId;
  }

  @override
  State<MyCards> createState() => _MyCardsState();
}

bool containerMain = true;

class _MyCardsState extends State<MyCards> with SingleTickerProviderStateMixin {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  bool cardSelected = false;
  String title = '';
  String name = '';
  String designation = '';
  String industry = '';
  String imageUrl = '';

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Share NFC Card App',
        text: 'Share NFC Card App',
        linkUrl: 'https://ekatech.co.in/NFC/business.php?id=${MyCards.userId}',
        chooserTitle: 'Share NFC Card App');
  }

  @override
  void initState() {
    FetchActiveProfile();

    super.initState();
  }

  Future<void> getImage() async {
    try {
      String userId = MyCards.businessId.toString();
      String fileName = 'profilePic_$userId';
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('businessProfileImages/$fileName');
      imageUrl = await firebaseStorageRef.getDownloadURL();
      setState(() {});
    } catch (e) {
      print('Error fetching image from Firebase Storage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Future<void> showMoreMenu() async {
    //   await showDialog<void>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return SimpleDialog(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(30),
    //           ),
    //           backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    //           children: <Widget>[
    //             SimpleDialogOption(
    //               onPressed: () {
    //                 showSnackBar('This device doesnt support NFC');
    //               },
    //               child: const Center(
    //                 child: Text(
    //                   'Write Physical Card',
    //                   style: TextStyle(
    //                       fontFamily: 'Mooli',
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //             ),
    //             const Divider(),
    //             SimpleDialogOption(
    //               onPressed: () {
    //                 // ignore: avoid_print
    //                 print(MyCards.businessId);

    //               },
    //               child: const Center(
    //                 child: Text(
    //                   'Delete Card',
    //                   style: TextStyle(
    //                       fontFamily: 'Mooli',
    //                       fontSize: 15,
    //                       fontWeight: FontWeight.bold),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       });
    // }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Active Card',
            style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Mooli',
                fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                border: Border.all(color: Colors.black38),
                color: Colors.black87),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 225,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color.fromARGB(255, 127, 173, 183),
                              Color.fromARGB(255, 234, 234, 234),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(21),
                          color: Colors.grey,
                        ),
                      ),
                      cardSelected
                          ? Column(
                              children: [
                                ClipOval(
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
                                          height: 120,
                                          width: 120,
                                        ),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 21,
                                      fontFamily: 'Mooli',
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  designation,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Mooli',
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Mooli',
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  industry,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Mooli',
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'No profile is active on card',
                                style: TextStyle(
                                    fontFamily: 'Mooli',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: IconButton(
                                      onPressed: () {
                                        share();
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.black,
                                        size: 27,
                                      ))),
                            ),
                            const Text('Share',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Mooli',
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    // Navigate to the Profile screen
                                    Get.to(() => ShowBusinessProfile(
                                        businessId: MyCards.businessId));
                                  },
                                  icon: const Icon(
                                    Icons
                                        .person, // Changed icon to a profile-related one
                                    color: Colors.black,
                                    size: 27,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'Profile', // Changed label to 'Profile'
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50)),
                                  child: IconButton(
                                      onPressed: () {
                                        deleteProfile();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                        size: 27,
                                      ))),
                            ),
                            const Text('Delete',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Mooli',
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Active Profile on this card.',
                      style: TextStyle(
                          color: Color.fromARGB(255, 111, 255, 0),
                          fontFamily: 'Mooli',
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  cardSelected
                      ? Padding(
                          padding: const EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // ignore: unnecessary_brace_in_string_interps
                                'Profile selected: ${title}',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'Mooli',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No profile selected ',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 254),
                                    fontFamily: 'Mooli',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showSnackBar(String message) {
    // ignore: non_constant_identifier_names
    var SnackBarVariable = SnackBar(
        content: Text(
          message,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontFamily: 'Mooli'),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        behavior: SnackBarBehavior.floating,
        width: 300,
        duration: const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(SnackBarVariable);
  }

  void deleteProfile() async {
    var res = await http.post(
      Uri.parse(API.deleteBusinessProfile),
      body: {"id": MyCards.businessId.toString()},
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
                  fontFamily: 'Mooli',
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
        );
        Get.offAll(() => Dashboard(
              userId: Dashboard.userId,
            ));
      }
    } else {
      // ignore: avoid_print
      print(res.statusCode);
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> FetchActiveProfile() async {
    final apiUrl = '${API.getActiveProfile}?userId=${Dashboard.userId}';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        MyCards.businessId = int.parse(data['business_id']);
        if (data['business_id'] != null) {
          setState(() {
            cardSelected = true;
          });
          fetchBusinessProfile();
        }
      } else {
        // ignore: avoid_print
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }

  Future<void> fetchBusinessProfile() async {
    final apiUrl = '${API.fetchBusinessDetails}?id=${MyCards.businessId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data['data']['profileId']);
        getImage();
        setState(() {
          title = data['data']['company'];
          industry = data['data']['industry'];
          name = data['data']['name'];
          designation = data['data']['designation'];
        });
      } else {
        // ignore: avoid_print
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");
    }
  }
}
