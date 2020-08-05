import 'package:countdown/core/network/network_info.dart';
import 'package:countdown/features/event/presentation/bloc/event_bloc.dart';
import 'package:countdown/features/event/repositories/event_repository.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

GetIt sl = GetIt.I;

Future<void> init() async {
  //! event feature

  // bloc
  sl.registerLazySingleton<EventBloc>(() => EventBloc(repository: sl()));

  // repositories
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      sharedPreferences: sl(),
      flutterLocalNotificationsPlugin: sl(),
      imagePicker: sl(),
      networkInfo: sl(),
      client: sl(),
    ),
  );

  //! core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! external

  final sharedPreferences = await SharedPreferences.getInstance();
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => flutterLocalNotificationsPlugin);
  sl.registerLazySingleton<ImagePicker>(() => ImagePicker());
  sl.registerLazySingleton<DataConnectionChecker>(
      () => DataConnectionChecker());
}
