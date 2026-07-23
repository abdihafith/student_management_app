import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../model/student_api_model.dart';

class ApiStudentRegistryScreen extends StatefulWidget {
  const ApiStudentRegistryScreen({super.key});

  @override
  State<ApiStudentRegistryScreen> createState() => _ApiStudentRegistryScreenState();
}

class _ApiStudentRegistryScreenState extends State<ApiStudentRegistryScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Live Network Registry', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.orange),
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange.withValues(alpha: 0.05),
            child: Row(
              children: [
                const Icon(Icons.cloud_done_rounded, color: Colors.orange),
                const SizedBox(width: 12),
                const Text(
                  "Connected to central server",
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ApiStudent>>(
              future: _apiService.fetchStudentsFromServer(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.orange),
                        const SizedBox(height: 20),
                        Text("Syncing with cloud...", style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off_rounded, size: 60, color: Colors.red.shade200),
                        const SizedBox(height: 16),
                        Text('Sync Failed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red.shade300)),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text('${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No records found on the remote server.'));
                }

                final serverStudents = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: serverStudents.length,
                  itemBuilder: (context, index) {
                    final student = serverStudents[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cloud_queue_rounded, color: Colors.orange),
                        ),
                        title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${student.admissionNumber} • ${student.course}'),
                        trailing: const Icon(Icons.sync_alt_rounded, size: 16, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
