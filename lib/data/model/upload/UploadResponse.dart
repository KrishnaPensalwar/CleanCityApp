class UploadResponse {
  final String status;
  final String message;
  final String? imageUrl;

  UploadResponse({
    required this.status,
    required this.message,
    this.imageUrl,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      imageUrl: json["imageUrl"],
    );
  }
}