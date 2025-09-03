import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';
import 'dart:io';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraReady extends CameraState {
  final CameraController controller;

  const CameraReady(this.controller);

  @override
  List<Object> get props => [controller];
}

class CameraCapturing extends CameraState {}

class CameraImageCaptured extends CameraState {
  final File imageFile;

  const CameraImageCaptured(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class CameraError extends CameraState {
  final String message;

  const CameraError(this.message);

  @override
  List<Object> get props => [message];
}

class CameraPermissionDenied extends CameraState {}
