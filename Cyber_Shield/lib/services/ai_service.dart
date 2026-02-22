import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

class AIService {
  static const String baseUrl = "http://10.83.168.63:8000";

  static Future<AnalysisResult> analyzeSMS(String message) async {
    final response = await http.post(
      Uri.parse("$baseUrl/analyze_sms"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return AnalysisResult(
        riskScore: data["risk_score"],
        label: data["label"],
        reason: data["reason"],
      );
    } else {
      throw Exception("Server Error");
    }
  }

  static Future<AnalysisResult> analyzeURL(String url) async {
    final response = await http.post(
      Uri.parse("$baseUrl/analyze_url"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"url": url}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return AnalysisResult(
        riskScore: data["risk_score"],
        label: data["label"],
        reason: data["reason"],
      );
    } else {
      throw Exception("URL Scan Failed");
    }
  }
}
