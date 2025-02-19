import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../preferences/theme_preferences.dart';

class FeatureBox extends StatelessWidget {
  const FeatureBox({
    super.key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
  });

  final Color color;
  final String headerText;
  final String descriptionText;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeNotifier>(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0).copyWith(
          left: 15,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                headerText,
                style: TextStyle(
                  fontSize: 18,
                  color: provider.darkTheme ? Colors.black : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: AutoSizeText(
                descriptionText,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: provider.darkTheme ? Colors.black : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
