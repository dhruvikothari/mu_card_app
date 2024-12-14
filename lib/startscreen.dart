import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mu_card/dashboard.dart';
import 'package:mu_card/login/welcomemobile.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();

    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      setState(() {
        if (results.isNotEmpty) {
          _connectionStatus = results.first;
        }
      });
    });

    Timer(const Duration(seconds: 3), () async {
      if (_connectionStatus == ConnectivityResult.mobile ||
          _connectionStatus == ConnectivityResult.wifi) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isLogin = prefs.getBool('isLogin') ?? false;
        int id = prefs.getInt('userId') ?? 0;
        if (isLogin && id != 0) {
          Get.off(() => Dashboard(userId: id));
        } else {
          Get.off(() => const WelcomeMobile());
        }
      } else {
        _showNoInternetDialog();
      }
    });
  }

  Future<void> _checkInternetConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isNotEmpty) {
      setState(() {
        _connectionStatus = results.first;
      });
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey,
            Colors.white,
          ],
        ),
      ),
      child: Image.asset(
        'assets/images/logo.png',
        width: 300,
      ),
    );
  }
}
