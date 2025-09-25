import 'dart:convert';
import 'package:cleancity/data/model/history/HistoryResponse.dart';
import 'package:cleancity/sharedPref/UserStorage.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  final String baseUrl = "https://cleancity-backend-3euk.onrender.com";

  Future<List<HistoryResponse>> fetchHistory() async {
    final user = await UserStorage.loadUserFromSharedPref();
    final userId = user?.uid;
    final response = await http.get(Uri.parse("$baseUrl/api/history/$userId"));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => HistoryResponse.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load history: ${response.statusCode}");
    }
  }
}
