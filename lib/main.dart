import 'package:assistant_blinds/preferences/theme_preferences.dart';
import 'package:assistant_blinds/routes/approutes.dart';
import 'package:assistant_blinds/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Assistant Blinds',
            theme: notifier.darkTheme ? dark : light,
            darkTheme: notifier.darkTheme ? dark : light,
            getPages: appRoutes(),
            home: const LoadingScreen(),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
