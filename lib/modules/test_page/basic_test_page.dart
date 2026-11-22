import 'package:flutter/material.dart';
import 'package:flutter_blind_navigation/modules/test_page/basic_test_controller.dart';
import 'package:get/get.dart';

class BasicTestPage extends GetView<BasicTestController> {
  const BasicTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing The Packages"),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 16,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Seslendirici metni yazın...",
                    ),
                    onChanged: (value) => controller.textToSpeak.value = value,
                  ),
                ),

                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.speakText,
                  child: Text("Konuş"),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    child: Obx(
                      () => Text(
                        controller.textRecognized.value.isEmpty
                            ? 'Mikrofona basıp konuşun'
                            : controller.textRecognized.value,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Obx(() {
                  final listening = controller.isListening.value;

                  return Semantics(
                    label: listening ? 'Dinlemeyi Durdur' : 'Dinlemeyi Başlat',
                    button: true,
                    child: ElevatedButton(
                      onPressed: controller.listenText,
                      child: Icon(
                        listening ? Icons.mic : Icons.mic_none,
                        semanticLabel: listening
                            ? 'Dinlemeyi durdur'
                            : 'Dinlemeyi Başlat',
                      ),
                    ),
                  );
                }),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    child: Obx(
                      () => Text(
                        controller.readedNfcId.value.isEmpty
                            ? 'Okunan Nfc Id'
                            : controller.readedNfcId.value,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Obx(() {
                  final isScanning = controller.isScanning.value;

                  return Semantics(
                    label: isScanning
                        ? 'Nfc Okuma etkin'
                        : 'Nfc Okuma Devre Dışı',
                    button: true,
                    child: ElevatedButton(
                      onPressed: controller.scanNfc,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isScanning ? Colors.blue : Colors.red,
                      ),
                      child: Icon(Icons.nfc),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
