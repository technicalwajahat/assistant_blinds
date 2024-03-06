import 'package:assistant_blinds/views/chat_bot.dart';
import 'package:assistant_blinds/views/text_to_speech.dart';
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
        page: () => const DashboardScreen(),
      ),
      GetPage(
        name: '/textToSpeech',
        page: () => const TextToSpeechScreen(),
      ),
      GetPage(
        name: '/chatBot',
        page: () => const ChatBotScreen(),
      ),
    ];
