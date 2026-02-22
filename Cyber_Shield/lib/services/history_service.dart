import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_item.dart';

class HistoryService {
  static const String key = "scan_history";

  static Future<void> saveHistory(HistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(key) ?? [];

    history.add(jsonEncode(item.toJson()));

    await prefs.setStringList(key, history);
  }

  static Future<List<HistoryItem>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(key) ?? [];

    return history
        .map((item) => HistoryItem.fromJson(jsonDecode(item)))
        .toList();
  }

  // 🔥 ADD THIS METHOD
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
