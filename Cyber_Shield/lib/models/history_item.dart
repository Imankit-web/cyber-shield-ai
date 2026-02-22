class HistoryItem {
  final String type; // SMS or URL
  final int riskScore;
  final String label;
  final String reason;
  final String timestamp;

  HistoryItem({
    required this.type,
    required this.riskScore,
    required this.label,
    required this.reason,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "riskScore": riskScore,
      "label": label,
      "reason": reason,
      "timestamp": timestamp,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      type: json["type"],
      riskScore: json["riskScore"],
      label: json["label"],
      reason: json["reason"],
      timestamp: json["timestamp"],
    );
  }
}
