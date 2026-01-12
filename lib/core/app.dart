import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/reminders/presentation/bloc/reminder_bloc.dart';
import '../features/reminders/presentation/bloc/reminder_event.dart';
import '../features/reminders/presentation/pages/startup_page.dart';
import 'di/injection.dart';
import 'utils/app_theme.dart';

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ReminderBloc>()..add(const LoadReminders()),
        ),
      ],
      child: MaterialApp(
        title: 'Read & Remind',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const StartUpPage(),
      ),
    );
  }
}
