import 'package:flutter_blind_navigation/service/nfc_service.dart';
import 'package:flutter_blind_navigation/service/stt_service.dart';
import 'package:flutter_blind_navigation/service/tts_service.dart';
import 'package:get/get.dart';

class BasicTestController extends GetxController {
  final TtsService _tts = Get.find<TtsService>();
  RxString textToSpeak = 'HATA'.obs;

  final SttService stt = Get.find<SttService>();
  RxBool get isListening => stt.isListening;
  RxString get textRecognized => stt.recognizedText;
  RxString get statusMessage => stt.statusMessage;

  final NfcService nfcService = Get.find<NfcService>();
  RxString get readedNfcId => nfcService.lastTagId;
  RxBool get isScanning => nfcService.isScanning;

  Future<void> speakText() async {
    if (stt.isListening.value) {
      await stt.stopListening();
    }
    _tts.speak(textToSpeak.value);
  }

  Future<void> listenText() async {
    await _tts.stop();
    await stt.toggleListening();
  }

  Future<void> scanNfc() async {
    if (isScanning.value) {
      await nfcService.stopSession();
      return;
    }
    await nfcService.startSession();
  }

  @override
  void onClose() {
    nfcService.onTagDiscovered = null;
    super.onClose();
  }
}
