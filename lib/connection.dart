// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print

import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mu_card/get_size.dart';
import 'package:mu_card/showbusinessprofile.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;

import 'apiConnection/apiConnection.dart';
import 'dashboard.dart';

class Connection extends StatefulWidget {
  const Connection({Key? key}) : super(key: key);

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  List<Map<String, dynamic>> profiles = [];
  @override
  void initState() {
    getConnection();
    super.initState();
  }

  Widget getProfileImage(Map<String, dynamic>? profile) {
    if (profile != null &&
        profile['imageUrl'] != null &&
        profile['imageUrl'].isNotEmpty) {
      return Image.network(
        profile['imageUrl'],
        fit: BoxFit.cover,
        height: 180,
        width: 180,
      );
    } else {
      return Image.asset(
        'assets/images/guest.png',
        fit: BoxFit.cover,
        height: 120,
        width: 120,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      width: double.infinity,
      child: profiles.isEmpty
          ? const Center(
              child: Text(
                'No Profile Found',
                style: TextStyle(
                  fontFamily: 'Mooli',
                  color: Color.fromARGB(255, 255, 17, 0),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ShowBusinessProfile(
                              businessId:
                                  int.parse(profiles[index]['business_id'])));
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: ClipOval(
                              child: CircleAvatar(
                                radius: 15,
                                child: getProfileImage(profiles[index]),
                              ),
                            ),
                            title: Text(
                              profiles[index]['company'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Mooli',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  deleteConnection(int.parse(
                                      profiles[index]['business_id']));
                                  getConnection();
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          showImageDialog(context);
                          nfcReading();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        child: SizedBox(
                          height: getHeight(context, 0.05),
                          width: getWidth(context, 0.3),
                          child: const Row(
                            children: [
                              Text(
                                "Connect",
                                style: TextStyle(
                                  fontFamily: 'Mooli',
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deleteAllConnection();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Delete all",
                            style: TextStyle(
                              fontFamily: 'Mooli',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(child: Text(" ")),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: getHeight(context, 0.45),
                width: getWidth(context, 0.9),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/logo/nfc.json',
                    ),
                    const Text(
                      "Ready to scan",
                      style: TextStyle(
                        fontFamily: 'Mooli',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Hold your card on the upper back of your phone",
                      style: TextStyle(
                        fontFamily: 'Mooli',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: getWidth(context, 0.35),
                      height: getHeight(context, 0.055),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, // Set the background color here
                        ),
                        child: const Text(
                          "Cancle",
                          style: TextStyle(
                            fontFamily: 'Mooli',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getConnection() async {
    final apiUrl = '${API.getConnections}?id=${Dashboard.userId}';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          final List<Map<String, dynamic>> fetchedProfiles =
              List<Map<String, dynamic>>.from(data['data']);

          // Fetch images for each profile
          for (var profile in fetchedProfiles) {
            String businessId = profile['business_id'].toString();
            String fileName = 'profilePic_$businessId';
            Reference firebaseStorageRef = FirebaseStorage.instance
                .ref()
                .child('businessProfileImages/$fileName');

            try {
              String imageUrl = await firebaseStorageRef.getDownloadURL();
              profile['imageUrl'] =
                  imageUrl; // Add the image URL to the profile map
            } catch (e) {
              print('Error fetching image for business_id $businessId: $e');
              profile['imageUrl'] =
                  null; // Handle cases where no image is available
            }
          }

          // Update the state with profiles including image URLs
          setState(() {
            profiles = fetchedProfiles;
          });
        } else {
          print("No data received from API.");
        }
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void nfcReading() async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      List<int> identifierBytes =
          List<int>.from(tag.data['nfca']['identifier']);

      // Convert each byte to a two-digit hexadecimal string and join with colons
      String identifier = identifierBytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join(':');

      final apiUrl =
          '${API.addConnections}?identifier=${identifier}&userId=${Dashboard.userId}';
      try {
        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            // ignore: avoid_print
            NfcManager.instance.stopSession();
            getConnection();
            Get.back();
            Get.to(() => ShowBusinessProfile(
                businessId: int.parse(data['profile']['business_id'])));
          } else {
            // ignore: avoid_print
            print("object");
          }
        } else {
          // ignore: avoid_print
          print("Request failed with status: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
      }
    });
  }

  void deleteConnection(int id) async {
    var res = await http.post(
      Uri.parse(API.deleteConnection),
      body: {"id": id.toString(), "user_id": Dashboard.userId.toString()},
    );

    if (res.statusCode == 200) {
      var resBodyOfUpdate = jsonDecode(res.body);
      if (resBodyOfUpdate['success']) {
        print("object");
        setState(() {});
      }
    } else {
      // ignore: avoid_print
      print(res.statusCode);
    }
    getConnection();
  }

  void deleteAllConnection() async {
    var res = await http.post(
      Uri.parse(API.deleteAllConnection),
      body: {"user_id": Dashboard.userId.toString()},
    );

    if (res.statusCode == 200) {
      var resBodyOfUpdate = jsonDecode(res.body);
      if (resBodyOfUpdate['success']) {
        Fluttertoast.showToast(msg: "Delete all");
        setState(() {});
      }
    } else {
      // ignore: avoid_print
      print(res.statusCode);
    }
    getConnection();
  }
}
