import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../models/analysis_result.dart';
import 'result_screen.dart';

class URLScanScreen extends StatefulWidget {
  const URLScanScreen({super.key});

  @override
  State<URLScanScreen> createState() => _URLScanScreenState();
}

class _URLScanScreenState extends State<URLScanScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  void analyzeURL() async {
    setState(() => isLoading = true);

    AnalysisResult result = await AIService.analyzeURL(_controller.text);

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan URL")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Paste suspicious link here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: analyzeURL,
                    child: const Text("Analyze Link"),
                  ),
          ],
        ),
      ),
    );
  }
}
