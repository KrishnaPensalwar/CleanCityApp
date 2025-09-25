import 'dart:convert';
import 'package:http/http.dart' as http;

/// Model class for History
class HistoryResponse {
  final String imageUrl;
  final double latitude;
  final double longitude;
  final DateTime uploadedAt;
  final String description;
  final String userId;
  final String status;

  HistoryResponse({
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.uploadedAt,
    required this.description,
    required this.userId,
    required this.status,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    DateTime parseUploadedAt(dynamic value) {
      if (value is int) {
        // Timestamp in milliseconds
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is String) {
        // ISO8601 string
        return DateTime.parse(value);
      } else {
        throw Exception("Invalid uploadedAt format");
      }
    }

    return HistoryResponse(
      imageUrl: json['imageUrl'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      uploadedAt: parseUploadedAt(json['uploadedAt']),
      description: json['description'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
    );
  }
}


