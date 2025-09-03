import 'package:equatable/equatable.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCameraEvent extends CameraEvent {}

class CaptureImageEvent extends CameraEvent {}

class DisposeCameraEvent extends CameraEvent {}

class CameraPermissionRequestedEvent extends CameraEvent {}
