import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();

  TTSService() {
    _tts.setLanguage("en-US");
    _tts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  void setCompletionHandler(Function() onComplete) {
    _tts.setCompletionHandler(onComplete);
  }

  void dispose() {
    _tts.stop();
  }
}
