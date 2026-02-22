import 'package:flutter/material.dart';
import '../models/analysis_result.dart';
import '../services/history_service.dart';
import '../models/history_item.dart';

class ResultScreen extends StatefulWidget {
  final AnalysisResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();

    // Save history only once when screen opens
    HistoryService.saveHistory(
      HistoryItem(
        type: "Scan",
        riskScore: widget.result.riskScore,
        label: widget.result.label,
        reason: widget.result.reason,
        timestamp: DateTime.now().toString(),
      ),
    );
  }

  Color getRiskColor(int risk) {
    if (risk >= 70) return Colors.red;
    if (risk >= 40) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final Color riskColor = getRiskColor(widget.result.riskScore);
    String correctedLabel;

    if (widget.result.riskScore >= 70) {
      correctedLabel = "Scam";
    } else if (widget.result.riskScore >= 40) {
      correctedLabel = "Suspicious";
    } else {
      correctedLabel = "Safe";
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Analysis Result"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.result.riskScore}%",
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: riskColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                correctedLabel,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: riskColor,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Reason",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.result.reason,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
