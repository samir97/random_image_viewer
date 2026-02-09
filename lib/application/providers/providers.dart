import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/http_client.dart';
import '../../data/repositories/image_repository_impl.dart';
import '../../domain/repositories/image_repository.dart';

final dioProvider = Provider<Dio>((ref) => createHttpClient());

final imageRepositoryProvider = Provider<ImageRepository>(
  (ref) => ImageRepositoryImpl(ref.watch(dioProvider)),
);
