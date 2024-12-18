import 'package:assistant_blinds/views/TextToSpeech/saved_audio.dart';
import 'package:assistant_blinds/views/TextToSpeech/text_to_speech.dart';
import 'package:assistant_blinds/views/TextToSpeech/view_speech.dart';
import 'package:get/get.dart';

import '../views/ChatBot/chat_bot.dart';
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
        name: '/viewSpeech',
        page: () => const ViewSpeech(),
      ),
      GetPage(
        name: '/chatBot',
        page: () => const ChatBotScreen(),
      ),
      GetPage(
        name: '/savedAudio',
        page: () => const SavedAudio(),
      ),
    ];
