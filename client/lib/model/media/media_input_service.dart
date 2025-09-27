import 'dart:io';
import 'package:flutter/material.dart';

abstract class MediaInputService {
  Future<void> initialize();
  void dispose();
  Future<File?> captureFromCamera();
  Widget? cameraPreview();
  Future<void> switchCamera();
}
