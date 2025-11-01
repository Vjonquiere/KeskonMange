import 'dart:io';

import 'package:client/core/state_viewmodel.dart';
import 'package:client/core/widget_states.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/media/camera_media_input_adapter.dart';
import '../../../model/media/media_input_service.dart';

class GeneralInformationViewModel extends StateViewModel {
  final MediaInputService _camera = CameraMediaInputAdapter();
  int _portions = 1;
  String _typeOfMeal = "";
  final TextEditingController _recipeTitleController = TextEditingController();
  int _preparationTime = 10;
  int _cookingTime = 15;
  bool _usingCamera = false;
  File? _picturePath;

  int get portions => _portions;
  String get typeOfMeal => _typeOfMeal;
  TextEditingController get recipeTitleController => _recipeTitleController;
  int get preparationTime => _preparationTime;
  int get cookingTime => _cookingTime;
  bool get usingCamera => _usingCamera;
  File? get picturePath => _picturePath;

  GeneralInformationViewModel() {
    _initializeCamera();
  }

  void changeCamera() async {
    await _camera.switchCamera();
    notifyListeners();
  }

  void switchCameraUse() {
    _usingCamera = !_usingCamera;
    notifyListeners();
  }

  void switchCameraFlash() {
    _camera.switchFlash();
  }

  Future<void> _initializeCamera() async {
    await _camera.initialize();
    setStateValue(WidgetStates.ready);
    notifyListeners();
  }

  Widget? cameraPreview() {
    return _camera.cameraPreview();
  }

  void takePicture() async {
    _picturePath = await _camera.captureFromCamera();
    switchCameraUse();
  }

  void setPortions(int portions) {
    _portions = portions;
    notifyListeners();
  }

  File? getPictureFile() {
    return _picturePath;
  }

  void setPreparationTime(int newPreparationTime) {
    _preparationTime = newPreparationTime;
    notifyListeners();
  }

  void setCookingTime(int newCookingTime) {
    _cookingTime = newCookingTime;
    notifyListeners();
  }

  void setMealType(String? typeOfMeal) {
    if (typeOfMeal != null) {
      _typeOfMeal = typeOfMeal;
      notifyListeners();
    }
  }

  @override
  Future<bool> isValid() async {
    if (_recipeTitleController.text == "") {
      return false;
    }
    if (_typeOfMeal == "") {
      return false;
    }
    return true;
  }
}
