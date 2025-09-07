import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/tasks/presentation/viewmodels/task_view_model.dart';
import 'features/tasks/presentation/screens/task_list_screen.dart';
import 'features/tasks/presentation/screens/new_task_screen.dart';
import 'features/profile/presentation/viewmodels/profile_view_model.dart';
import 'features/profile/presentation/screens/profile_screen.dart';

/// Entry point of the application.
///
/// The application wires up the various view models using [MultiProvider] and
/// configures the global theme through [AppTheme]. Routes are registered for
/// each top–level screen so navigation can be performed declaratively.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp(
        title: 'NoteFlow',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/tasks': (context) => const TaskListScreen(),
          '/new_task': (context) => const NewTaskScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}