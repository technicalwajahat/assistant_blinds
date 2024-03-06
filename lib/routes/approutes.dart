import 'package:get/get.dart';

import '../views/dashboard.dart';
import '../widgets/loading_widget.dart';

appRoutes() => [
      GetPage(
        name: '/loading',
        page: () => const LoadingScreen(),
      ),
      GetPage(
        name: '/dashboard',
        page: () => const Dashboard(),
      ),
    ];
