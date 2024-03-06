import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controller/dashboard_controller.dart';
import '../preferences/theme_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class DrawerData {
  const DrawerData(this.label, this.selectedIcon);

  final String label;
  final Widget selectedIcon;
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final dashboardController = Get.put(DashboardController());

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  static List<DrawerData> destinations = <DrawerData>[
    const DrawerData(
      'Home',
      FaIcon(
        FontAwesomeIcons.house,
        size: 18,
      ),
    ),
    const DrawerData(
      'Exit',
      FaIcon(
        FontAwesomeIcons.solidCircleXmark,
        size: 18,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            openDrawer();
          },
          icon: const Icon(Icons.menu_open),
        ),
        actions: [
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => IconButton(
              onPressed: () {
                notifier.toggleTheme();
              },
              tooltip: "Theme Mode",
              icon: notifier.darkTheme
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
            ),
          ),
        ],
        title: const AutoSizeText(
          "Assistant Blinds",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Card(
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    child: AutoSizeText(
                      textAlign: TextAlign.center,
                      "Kindness is a language which the deaf can hear and the blind can see!",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.03),
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/textToSpeech');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.library_books, size: 20),
                      SizedBox(width: Get.width * 0.03),
                      const AutoSizeText(
                        "Text to Speech",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                FilledButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/chatBot');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat, size: 20),
                      SizedBox(width: Get.width * 0.03),
                      const AutoSizeText(
                        "Chat Bot",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: NavigationDrawer(
        onDestinationSelected: dashboardController.handleScreenChanged,
        selectedIndex: dashboardController.screenIndex.value,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 22, 16, 5),
            child: AutoSizeText(
              'Assistant Blinds',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 5, 24, 10),
            child: Divider(
              color: Colors.black45,
            ),
          ),
          ...destinations.map(
            (DrawerData destination) {
              return NavigationDrawerDestination(
                label: AutoSizeText(destination.label),
                icon: destination.selectedIcon,
                selectedIcon: destination.selectedIcon,
              );
            },
          ),
        ],
      ),
    );
  }
}
