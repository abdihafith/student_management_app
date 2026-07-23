import 'dart:io'; // Required for Platform check
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Required for FFI drivers
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/student_list.dart';
import 'screens/api_student_registry.dart';
import 'screens/attendance_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/department_screen.dart';
import 'screens/pending_requests_screen.dart';
import 'screens/record_management_screen.dart';
import 'screens/student_detail_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  // 1. Ensure Flutter is ready
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize database for Windows/Desktop
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/registration': (context) => const RegistrationScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/student_list': (context) => const StudentListScreen(),
        '/api_registry': (context) => const ApiStudentRegistryScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/departments': (context) => const DepartmentScreen(),
        '/pending_requests': (context) => const PendingRequestsScreen(),
        '/record_management': (context) => const RecordManagementScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/student_detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return StudentDetailScreen(student: args);
            },
          );
        }
        return null;
      },
    );
  }
}