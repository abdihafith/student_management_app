import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/student_api_model.dart';

class ApiStudentRegistryScreen extends StatefulWidget {
  const ApiStudentRegistryScreen({Key? key}) : super(key: key);

  @override
  State<ApiStudentRegistryScreen> createState() => _ApiStudentRegistryScreenState();
}

class _ApiStudentRegistryScreenState extends State<ApiStudentRegistryScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Network Registry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}), // Triggers the FutureBuilder to pull fresh data
          )
        ],
      ),
      body: FutureBuilder<List<ApiStudent>>(
        future: _apiService.fetchStudentsFromServer(), // Your network call
        builder: (context, snapshot) {
          // State 1: Server is still processing request (Show spinning wheel)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 2: Network error or server crash occurred
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Network Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          // State 3: Data arrived successfully, list is empty
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No records found on the remote server.'));
          }

          // State 4: Connection success! Display list parsing the JSON models
          final serverStudents = snapshot.data!;
          return ListView.builder(
            itemCount: serverStudents.length,
            itemBuilder: (context, index) {
              final student = serverStudents[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.cloud)),
                  title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${student.admissionNumber} • ${student.course}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}






















































































































