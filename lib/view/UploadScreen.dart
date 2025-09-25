import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;

  Future<void> openCamera() async {
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      final XFile? photo = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (photo != null) {
        setState(() {
          image = photo;
        });
      }
    } else if (cameraStatus.isPermanentlyDenied) {
      openAppSettings();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Camera permission denied")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Image.file(
                  File(image!.path),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
                : const Text("No image captured"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: openCamera,
              child: const Text("Click to Take Picture"),
            ),
          ],
        ),
      ),
    );
  }
}
