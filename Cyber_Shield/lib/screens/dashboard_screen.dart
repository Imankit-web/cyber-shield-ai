import 'package:flutter/material.dart';
import '../services/history_service.dart';
import 'scan_screen.dart';
import 'url_scan_screen.dart';
import 'history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int totalScans = 0;
  int highRisk = 0;
  int safe = 0;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    loadStats();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.95, end: 1.0).animate(_controller);

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadStats() async {
    final history = await HistoryService.getHistory();

    int high = 0;
    int safeCount = 0;

    for (var item in history) {
      if (item.riskScore >= 70) {
        high++;
      } else {
        safeCount++;
      }
    }

    setState(() {
      totalScans = history.length;
      highRisk = high;
      safe = safeCount;
    });
  }

  String getSecurityStatus() {
    if (highRisk >= 3) {
      return "HIGH RISK";
    } else if (highRisk >= 1) {
      return "MEDIUM RISK";
    } else {
      return "SECURE";
    }
  }

  Color getStatusColor() {
    if (highRisk >= 3) {
      return const Color(0xFFE53935); // deep red
    } else if (highRisk >= 1) {
      return const Color(0xFFFFB300); // amber
    } else {
      return const Color(0xFF00C853); // cyber green
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = getSecurityStatus();
    final statusColor = getStatusColor();

    return Scaffold(
      appBar: AppBar(title: const Text("AI Cyber Shield"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔐 Animated Status Card
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: highRisk >= 3 ? _animation.value : 1,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: statusColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "System Status",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // 📊 Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStatCard("Total", totalScans, Colors.blue),
                buildStatCard("High Risk", highRisk, const Color(0xFFE53935)),
                buildStatCard("Safe", safe, const Color(0xFF00C853)),
              ],
            ),

            const SizedBox(height: 40),

            // 🔘 Buttons
            buildButton("Scan SMS", () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanScreen()),
              );
              loadStats();
            }),

            const SizedBox(height: 15),

            buildButton("Scan URL", () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const URLScanScreen()),
              );
              loadStats();
            }),

            const SizedBox(height: 15),

            buildButton("View History", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            }),

            const SizedBox(height: 20),

            // 🗑 Reset History
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Reset"),
                    content: const Text("Delete all scan history?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          await HistoryService.clearHistory();
                          loadStats();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                "Reset History",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStatCard(String title, int value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 65),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
