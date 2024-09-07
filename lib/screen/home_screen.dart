import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async'; // Import Timer class

import '../helper/ad_helper.dart';
import '../helper/global.dart';
import '../helper/pref.dart';
import '../model/home_type.dart';
import '../widget/home_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _isDarkMode = Get.isDarkMode.obs;
  bool _showAd = true; // Variable to track ad visibility

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;

    // Start a timer to hide the ad after 5 seconds
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showAd = false; // Hide the ad after 5 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // initializing device size
    mq = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            onPressed: () {
              Get.changeThemeMode(
                  _isDarkMode.value ? ThemeMode.light : ThemeMode.dark);
              _isDarkMode.value = !_isDarkMode.value;
              Pref.isDarkMode = _isDarkMode.value;
            },
            icon: Obx(
              () => Icon(
                _isDarkMode.value
                    ? Icons.brightness_2_rounded
                    : Icons.brightness_5_rounded,
                size: 26,
              ),
            ),
          ),
        ],
      ),

      // Show the ad only if _showAd is true
      bottomNavigationBar: _showAd ? AdHelper.nativeBannerAd() : null,

      // Main body of the screen
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: mq.width * .04, vertical: mq.height * .015),
        children: HomeType.values.map((e) => HomeCard(homeType: e)).toList(),
      ),
    );
  }
}
