import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
  // final _isDarkMode = Pref.isDarkMode.obs;
  final _isDarkMode = Get.isDarkMode.obs; //bug fix

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Pref.showOnboarding = false;
  }

  @override
  Widget build(BuildContext context) {
    // initializing device size
    mq = MediaQuery.sizeOf(context);

    // sample api call
    // APIs.getAnswer('hii');

    return Scaffold(
      // AppBar with futuristic feel
      appBar: AppBar(
        title: const Text(appName),
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 10,
        shadowColor: Colors.cyanAccent
            .withOpacity(0.5), // Glow effect for futuristic feel
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
                color: Colors.cyanAccent, // Futuristic cyan glow for icon
              ),
            ),
          ),
        ],
      ),

      // Bottom navigation bar with futuristic ad placeholder
      bottomNavigationBar: AdHelper.nativeBannerAd(),

      // Main body of the screen with futuristic design
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.blueGrey.withOpacity(0.8),
            ], // Futuristic dark background
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .015),
          children: HomeType.values.map((e) => HomeCard(homeType: e)).toList(),
        ),
      ),
    );
  }
}
