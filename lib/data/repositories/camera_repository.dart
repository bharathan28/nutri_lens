import 'dart:io';
import 'package:camera/camera.dart' hide CameraException;
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/camera_datasource.dart';

abstract class CameraRepository {
  Future<Either<Failure, CameraController>> initializeCamera();
  Future<Either<Failure, File>> captureImage(CameraController controller);
  Future<void> disposeCamera(CameraController controller);
}

class CameraRepositoryImpl implements CameraRepository {
  final CameraDataSource dataSource;

  CameraRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, CameraController>> initializeCamera() async {
    try {
      final controller = await dataSource.initializeCamera();
      return Right(controller);
    } on CameraException catch (e) {
      return Left(CameraFailure(e.message));
    } catch (e) {
      return Left(CameraFailure('Failed to initialize camera'));
    }
  }

  @override
  Future<Either<Failure, File>> captureImage(CameraController controller) async {
    try {
      final imageFile = await dataSource.captureImage(controller);
      return Right(imageFile);
    } on CameraException catch (e) {
      return Left(CameraFailure(e.message));
    } catch (e) {
      return Left(CameraFailure('Failed to capture image'));
    }
  }

  @override
  Future<void> disposeCamera(CameraController controller) async {
    await dataSource.disposeCamera(controller);
  }
}
