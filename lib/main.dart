import 'dart:io'; // Required for Platform check
import 'package:student_management_app/screens/record_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // Required for databaseFactory
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Required for FFI drivers
import 'screens/login.dart';

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
  const StudentManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}