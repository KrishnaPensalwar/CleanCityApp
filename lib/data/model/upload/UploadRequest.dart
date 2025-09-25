class UploadRequest {
  final String description;
  final double latitude;
  final double longitude;
  final String uploadedAt;
  final String userId;

  UploadRequest({
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.uploadedAt,
    required this.userId,
  });

  Map<String, String> toMap() {
    return {
      "description": description,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "uploadedAt": uploadedAt,
      "userId": userId,
    };
  }
}
