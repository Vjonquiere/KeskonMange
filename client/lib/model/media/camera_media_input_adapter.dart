import 'dart:io';

import 'package:camera/camera.dart';
import 'package:client/core/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/message_bus.dart';
import 'media_input_service.dart';

class CameraMediaInputAdapter extends MediaInputService {
  late CameraController _controller;
  late List<CameraDescription> _cameras;
  int _currentCamera = 0;

  @override
  Widget? cameraPreview() {
    if (!_controller.value.isInitialized) {
      return null;
    }
    return AspectRatio(
      aspectRatio: 1,
      child: CameraPreview(_controller),
    );
  }

  @override
  Future<File?> captureFromCamera() async {
    if (!_controller.value.isInitialized) return null;
    final XFile picture = await _controller.takePicture();
    return File(picture.path);
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
    _controller = CameraController(
        _cameras[_currentCamera], ResolutionPreset.max,
        enableAudio: false);
    await _controller.initialize().catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            MessageBus.instance.addMessage(
                Message(MessageType.error, "Camera access was denied"));
            break;
          default:
            MessageBus.instance.addMessage(Message(
                MessageType.error, "An error occurred while accessing camera"));
            break;
        }
      }
    });
  }

  @override
  Future<void> switchCamera() async {
    _currentCamera = (_currentCamera + 1) % _cameras.length;
    await initialize();
  }

  @override
  Future<void> switchFlash() async {
    await _controller.setFlashMode(
        _controller.value.flashMode != FlashMode.torch
            ? FlashMode.torch
            : FlashMode.off);
  }
}
