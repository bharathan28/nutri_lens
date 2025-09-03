import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:nutri_lens/core/utils/permission.dart';
import '../../data/repositories/camera_repository.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraRepository repository;
  CameraController? _controller;

  CameraBloc(this.repository) : super(CameraInitial()) {
    on<InitializeCameraEvent>(_onInitializeCamera);
    on<CaptureImageEvent>(_onCaptureImage);
    on<DisposeCameraEvent>(_onDisposeCamera);
    on<CameraPermissionRequestedEvent>(_onPermissionRequested);
  }

  Future<void> _onPermissionRequested(
    CameraPermissionRequestedEvent event,
    Emitter<CameraState> emit,
  ) async {
    final hasPermission = await PermissionHelper.requestCameraPermission();
    if (hasPermission) {
      add(InitializeCameraEvent());
    } else {
      emit(CameraPermissionDenied());
    }
  }

  Future<void> _onInitializeCamera(
    InitializeCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraLoading());

    final hasPermission = await PermissionHelper.checkCameraPermission();
    if (!hasPermission) {
      emit(CameraPermissionDenied());
      return;
    }

    final result = await repository.initializeCamera();
    result.fold(
      (failure) => emit(CameraError(failure.message)),
      (controller) {
        _controller = controller;
        emit(CameraReady(controller));
      },
    );
  }

  Future<void> _onCaptureImage(
    CaptureImageEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (_controller == null || state is! CameraReady) {
      emit(CameraError('Camera not ready'));
      return;
    }

    emit(CameraCapturing());

    final result = await repository.captureImage(_controller!);
    result.fold(
      (failure) => emit(CameraError(failure.message)),
      (imageFile) => emit(CameraImageCaptured(imageFile)),
    );
  }

  Future<void> _onDisposeCamera(
    DisposeCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    if (_controller != null) {
      await repository.disposeCamera(_controller!);
      _controller = null;
    }
    emit(CameraInitial());
  }

  @override
  Future<void> close() {
    if (_controller != null) {
      repository.disposeCamera(_controller!);
    }
    return super.close();
  }
}
