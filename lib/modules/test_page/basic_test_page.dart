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

      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Seslendirici metni yazın...",
                  ),
                  onChanged: (value) => controller.text.value = value,
                ),
              ),

              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: controller.speakText,
                child: Text("Konuş"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
