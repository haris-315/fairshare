import 'package:fairshare/features/auth/domain/usecases/check_user.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/group/data/datasources/group_remote_data_source.dart';
import 'features/group/data/repositories/group_repository_impl.dart';
import 'features/group/domain/repositories/group_repository.dart';
import 'features/group/domain/usecases/add_expense.dart';
import 'features/group/domain/usecases/create_group.dart';
import 'features/group/presentation/bloc/group_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => AuthBloc(signIn: sl(), signUp: sl(), checkUser: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => CheckUser(sl()));
  sl.registerLazySingleton(() => CreateGroup(sl()));
  sl.registerLazySingleton(() => AddExpense(sl()));
  // sl.registerLazySingleton(() => UpdateGroup(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerFactory(
    () => GroupBloc(
      repository: sl(),
      createGroup: sl(),
      addExpense: sl(),
      // updateGroup: sl(),
    ),
  );
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(),
  );
}
