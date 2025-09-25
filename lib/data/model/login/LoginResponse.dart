import 'package:cleancity/data/model/User.dart';

class LoginResponse {
  final String status;
  final String message;
  final User? data;


  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  // Factory constructor to create LoginResponse from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: json['data'] != null ? User.fromJson(json['data']) : null,
    );
  }

  // Convert LoginResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
