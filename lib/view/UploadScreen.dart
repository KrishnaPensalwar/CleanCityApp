import 'dart:io';
import 'package:cleancity/viewmodel/UploadViewModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;
  final TextEditingController descriptionController = TextEditingController();
  UploadViewModel viewModel = UploadViewModel();

  Future<void> openCamera() async {
    var cameraStatus = await Permission.camera.status;
    Logger().i(cameraStatus);
    if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();
    }

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
      // Open app settings if permanently denied
      openAppSettings();
    } else {
      // Handle all other cases
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Camera permission denied")),
      );
    }
  }

  void handleSubmit() {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image to submit")),
      );
      return;
    }

    print("Submitting image: ${image!.path}");
    print("Description: ${descriptionController.text}");

    final isUploading = viewModel.isUploading;
    if(isUploading){
      CircularProgressIndicator();
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    viewModel.upload(
      File(image!.path),
      descriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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

              if (image != null)
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),

              const SizedBox(height: 20),


              ElevatedButton(
                onPressed: image == null ? openCamera : handleSubmit,
                child: Text(
                    image == null ? "Click to Take Picture" : "Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}