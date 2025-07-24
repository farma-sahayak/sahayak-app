import 'package:get_it/get_it.dart';
import 'package:mobile/data/repositories/auth_repository_impl.dart';
import 'package:mobile/data/source/remote/firebase_auth_datasource.dart';
import 'package:mobile/domain/commands/auth_cmd.dart';
import 'package:mobile/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setUpDependencyInjection() async {
  // dio instance
  // api client
  // data sources
  sl.registerLazySingleton<FirebaseAuthDatasource>(
    () => FirebaseAuthDatasource(),
  );
  // repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<FirebaseAuthDatasource>()),
  );

  // commands
  sl.registerLazySingleton<AuthCmd>(() => AuthCmd(sl<AuthRepository>()));

  // blocs
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl<AuthCmd>()));
}
