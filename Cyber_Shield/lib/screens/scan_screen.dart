import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/analysis_result.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  void analyzeMessage() async {
    setState(() => isLoading = true);

    AnalysisResult result = await AIService.analyzeSMS(_controller.text);

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paste SMS")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Paste suspicious message here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: analyzeMessage,
                    child: const Text("Analyze"),
                  ),
          ],
        ),
      ),
    );
  }
}
