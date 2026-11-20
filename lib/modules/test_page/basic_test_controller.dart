import 'package:flutter_blind_navigation/service/tts_service.dart';
import 'package:get/get.dart';

class BasicTestController extends GetxController{
  final TtsService _tts = Get.find<TtsService>();
  RxString text = 'HATA'.obs;

  Future<void> speakText() async{
    _tts.speak(text.value);
    
  }
  
}