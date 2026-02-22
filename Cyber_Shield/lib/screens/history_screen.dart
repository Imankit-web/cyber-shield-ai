import 'package:flutter/material.dart';
import '../services/history_service.dart';
import '../models/history_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  void loadHistory() async {
    final data = await HistoryService.getHistory();
    setState(() {
      history = data.reversed.toList();
    });
  }

  Color getColor(int risk) {
    if (risk >= 70) return Colors.red;
    if (risk >= 40) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan History")),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(item.riskScore),
              child: Text(
                "${item.riskScore}%",
                style: const TextStyle(fontSize: 12),
              ),
            ),
            title: Text(item.label),
            subtitle: Text(item.timestamp),
          );
        },
      ),
    );
  }
}
