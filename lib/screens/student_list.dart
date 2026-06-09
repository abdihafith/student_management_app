import 'package:flutter/material.dart';
import '../model/student.dart';
import '../services/student_service.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _service = StudentService();

  void _showAddStudentModal() {
    final nameController = TextEditingController();
    final rollController = TextEditingController();
    final deptController = TextEditingController();
    final emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add New Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: rollController, decoration: const InputDecoration(labelText: 'Roll Number')),
            TextField(controller: deptController, decoration: const InputDecoration(labelText: 'Department')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _service.addStudent(Student(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      rollNumber: rollController.text,
                      department: deptController.text,
                      email: emailController.text,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Student'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final students = _service.getStudents();

    return Scaffold(
      appBar: AppBar(title: const Text('Student Registry')),
      body: students.isEmpty
          ? const Center(child: Text('No students registered yet.'))
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${student.rollNumber} • ${student.department}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _service.deleteStudent(student.id);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}