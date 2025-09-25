import 'dart:io';
import 'package:cleancity/data/model/upload/UploadRequest.dart';
import 'package:cleancity/data/model/upload/UploadResponse.dart';
import 'package:cleancity/data/services/UploadService.dart';
import 'package:cleancity/sharedPref/UserStorage.dart';
import 'package:cleancity/utils/LocationHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class UploadViewModel extends ChangeNotifier {
  final UploadService _service = UploadService();

  bool _isUploading = false;
  UploadResponse? _response;

  bool get isUploading => _isUploading;
  UploadResponse? get response => _response;

  Future<void> upload(File image,String description) async {
    _isUploading = true;
    _response = null;
    notifyListeners();
    final user = await UserStorage.loadUserFromSharedPref();
    final userId = user?.uid;
    if(userId==null){
      throw Exception("Error in uploading the image.");
    }

    Position location = await LocationHelper.getCurrentLocation();

    final requestData = UploadRequest(
      description: description,
      latitude: location.latitude,
      longitude: location.longitude,
      uploadedAt: DateTime.now().toIso8601String(),
      userId: userId,
    );

    _response = await _service.uploadImage(image, requestData);


    _isUploading = false;
    notifyListeners();
  }
}
