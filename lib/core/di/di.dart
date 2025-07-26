import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/data/repositories/auth_repository_impl.dart';
import 'package:mobile/data/source/base/auth_local_datasource.dart';
import 'package:mobile/data/source/base/auth_remote_datasource.dart';
import 'package:mobile/data/source/remote/auth_remote_datasource_impl.dart';
import 'package:mobile/domain/commands/auth_cmd.dart';
import 'package:mobile/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setUpDependencyInjection() async {
  // dio instance
  // Dio instances
  sl.registerLazySingleton<Dio>(() {
    return Dio(
      BaseOptions(
        // baseUrl: 'http://192.168.0.114:8000/api/v1/', // move to env in future
        baseUrl: 'http://127.0.0.1:8050/api',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );
  });

  // api client
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));

  // data sources
  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  sl.registerLazySingleton(
    () => AuthLocalDatasource(secureStorage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl(), sl()),
  );

  // repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDatasource: sl<AuthLocalDatasource>(),
      remoteDatasource: sl<AuthRemoteDatasource>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );

  // commands
  sl.registerLazySingleton<AuthCmd>(() => AuthCmd(sl<AuthRepository>()));

  // blocs
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl<AuthCmd>()));
}
