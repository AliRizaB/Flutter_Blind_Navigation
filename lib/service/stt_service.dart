import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService extends GetxService {
  final SpeechToText _speech = SpeechToText();

  final RxBool isAvaliable = false.obs;
  final RxBool isListening = false.obs;
  final RxString recognizedText = ''.obs;
  final RxString statusMessage = 'Başlatılamadı'.obs;

  String _turkishLocaleId = 'tr_TR';

  Future<SttService> init() async {
    isAvaliable.value = await _speech.initialize(
      onStatus: (status) {
        statusMessage.value = status;
        isListening.value = _speech.isListening;
      },
      onError: (error) {
        statusMessage.value = "Hata: ${error.errorMsg}";
        isListening.value = false;
      },
    );

    if (isAvaliable.value) {
      final locales = await _speech.locales();
      final trLocale = locales.firstWhereOrNull(
        (l) => l.localeId.toLowerCase().startsWith('tr'),
      );

      if (trLocale != null) {
        _turkishLocaleId = trLocale.localeId;
      }
      statusMessage.value = 'Hazır ($_turkishLocaleId)';
    } else {
      statusMessage.value = "STT kullanılamıyor";
    }

    return this;
  }

  Future<void> toggleListening() async {
    if (!isAvaliable.value) return;

    if(_speech.isListening){
      await stopListening();
      return;
    }
    

    recognizedText.value = '';
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true,
        localeId: _turkishLocaleId,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      ),
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
      },
    );
    isListening.value = true;
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
      isListening.value = false;
    }
  }

  @override
  void onClose() {
    _speech.cancel();
    super.onClose();
  }
}
