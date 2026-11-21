import 'package:flutter_blind_navigation/service/stt_service.dart';
import 'package:flutter_blind_navigation/service/tts_service.dart';
import 'package:get/get.dart';

class BasicTestController extends GetxController{
  final TtsService _tts = Get.find<TtsService>();
  RxString textToSpeak = 'HATA'.obs;

  final SttService stt = Get.find<SttService>();
  RxBool get isListening => stt.isListening;
  RxString get textRecognized => stt.recognizedText;
  RxString get statusMessage => stt.statusMessage;

  Future<void> speakText() async{
    if(stt.isListening.value){
      await stt.stopListening();
    }
    _tts.speak(textToSpeak.value);
  }

  Future<void> listenText() async{
    await _tts.stop();
    await stt.toggleListening();
  }
  
}