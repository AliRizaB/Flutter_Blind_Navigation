import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsService extends GetxService{
  final FlutterTts _flutterTts = FlutterTts();
  final RxBool isSpeaking = false.obs;

  Future<TtsService> init() async{
    await _flutterTts.setLanguage("tr-TR");

    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    // Wait until speech is finished default is false
    await _flutterTts.awaitSpeakCompletion(true);

    // tracking Speech Progress
    _flutterTts.setStartHandler(() => isSpeaking.value = true,); // If speaking is true
    _flutterTts.setCompletionHandler(() => isSpeaking.value = false,); // If completed speaking then it is not speaking
    _flutterTts.setCancelHandler(() => isSpeaking.value = false,); // Cancelled 
    _flutterTts.setErrorHandler((_) => isSpeaking.value = false,); // When error occurs speaking is false

    return this;
  }

  Future<void> speak(String text) async{
    if(text.trim().isEmpty) return;
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stop() async{
    await _flutterTts.stop();
    isSpeaking.value = false;
  }
}