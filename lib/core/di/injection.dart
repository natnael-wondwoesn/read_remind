import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/reminders/data/datasources/reminder_email_datasource.dart';
import '../../features/reminders/data/datasources/reminder_local_datasource.dart';
import '../../features/reminders/data/datasources/reminder_notification_datasource.dart';
import '../../features/reminders/data/repositories/reminder_repository_impl.dart';
import '../../features/reminders/domain/repositories/reminder_repository.dart';
import '../../features/reminders/domain/usecases/create_reminder.dart';
import '../../features/reminders/domain/usecases/delete_reminder.dart';
import '../../features/reminders/domain/usecases/get_all_reminders.dart';
import '../../features/reminders/domain/usecases/trigger_reminder_actions.dart';
import '../../features/reminders/domain/usecases/update_reminder.dart';
import '../../features/reminders/presentation/bloc/reminder_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await Hive.initFlutter();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('UTC'));

  final remindersBox = await Hive.openBox<Map>('reminders_box');
  sl.registerSingleton<Box<Map>>(remindersBox);

  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings = InitializationSettings(android: androidSettings);
  await notificationsPlugin.initialize(initializationSettings);
  sl.registerSingleton<FlutterLocalNotificationsPlugin>(notificationsPlugin);

  sl.registerLazySingleton<ReminderLocalDataSource>(
    () => ReminderLocalDataSourceImpl(box: sl()),
  );
  sl.registerLazySingleton<ReminderNotificationDataSource>(
    () => ReminderNotificationDataSourceImpl(notificationsPlugin: sl()),
  );
  sl.registerLazySingleton<ReminderEmailDataSource>(
    ReminderEmailDataSourceImpl.new,
  );

  sl.registerLazySingleton<ReminderRepository>(
    () => ReminderRepositoryImpl(
      localDataSource: sl(),
      notificationDataSource: sl(),
      emailDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetAllReminders(sl()));
  sl.registerLazySingleton(() => CreateReminder(sl()));
  sl.registerLazySingleton(() => UpdateReminder(sl()));
  sl.registerLazySingleton(() => DeleteReminder(sl()));
  sl.registerLazySingleton(() => TriggerReminderActions(sl()));

  sl.registerFactory(
    () => ReminderBloc(
      getAllReminders: sl(),
      createReminder: sl(),
      updateReminder: sl(),
      deleteReminder: sl(),
      triggerReminderActions: sl(),
    ),
  );
}
