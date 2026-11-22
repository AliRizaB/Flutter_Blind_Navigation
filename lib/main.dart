import 'package:flutter/material.dart';
import 'package:flutter_blind_navigation/modules/test_page/basic_test_controller.dart';
import 'package:flutter_blind_navigation/modules/test_page/basic_test_page.dart';
import 'package:flutter_blind_navigation/service/database_service.dart';
import 'package:flutter_blind_navigation/service/nfc_service.dart';
import 'package:flutter_blind_navigation/service/stt_service.dart';
import 'package:flutter_blind_navigation/service/tts_service.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => TtsService().init());
  await Get.putAsync(() => SttService().init());
  await Get.putAsync(() => DatabaseService().init());
  await Get.putAsync(() => NfcService().init());
  
  Get.lazyPut<BasicTestController>(() => BasicTestController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: BasicTestPage());
  }
}
