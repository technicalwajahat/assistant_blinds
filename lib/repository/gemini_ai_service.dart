import 'package:assistant_blinds/utils/constant.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAPIService {
  Future<String?> promptApi(String geminiPrompt) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: GEMINI_API_KEY);

    final prompt = geminiPrompt;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    print(response.text);
    return response.text;
  }
}
