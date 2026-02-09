import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:random_image_viewer/domain/repositories/image_repository.dart';

class MockImageRepository extends Mock implements ImageRepository {}

class MockDio extends Mock implements Dio {}
