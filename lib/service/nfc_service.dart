import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';

class NfcService extends GetxService {
  final RxBool isAvaliable = false.obs;
  final RxBool isScanning = false.obs;
  final RxString lastTagId = ''.obs;
  final RxString loggingMessage = 'NFC kontrol ediliyor...'.obs;

  void Function(String tagId)? onTagDiscovered;

  Future<NfcService> init() async {
    final availability = await NfcManager.instance.checkAvailability();
    isAvaliable.value = availability == NfcAvailability.enabled;
    loggingMessage.value = isAvaliable.value
        ? 'NFC Hazır'
        : 'NFC kapalı veya desteklenmiyor';

    return this;
  }

  Future<void> startSession() async {
    if (!isAvaliable.value || isScanning.value) return;

    isScanning.value = true;
    loggingMessage.value = 'NFC etiketi bekleniyor';

    await NfcManager.instance.startSession(
      pollingOptions: {
        // TODO: Hangi NFC tagi kullanıyorsak bunun etiketini buraya yaz
        NfcPollingOption.iso14443,
      },
      onDiscovered: (NfcTag tag) async {
        final id = _extractTagId(tag);
        if (id != null && id.isNotEmpty) {
          lastTagId.value = id;
          loggingMessage.value = 'Okunan Etiket: $id';
          onTagDiscovered?.call(id);
        }
      },
    );
  }

  String? _extractTagId(NfcTag tag) {
    final androidTag = NfcTagAndroid.from(tag);
    if (androidTag != null) {
      return _bytesToHex(androidTag.id);
    }
    return null;
  }

  String _bytesToHex(Uint8List bytes) {
    // Extract hardware UID on Android (e.g. "04:A1:2B:9C:11:00:80")
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(':');
  }

  Future<void> stopSession() async {
    if (!isScanning.value) return;
    await NfcManager.instance.stopSession();
    isScanning.value = false;
  }

  @override
  void onClose() {
    stopSession();
    super.onClose();
  }
}
