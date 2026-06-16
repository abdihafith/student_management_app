import 'package:student_management_app/services/database_helper.dart';
import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Map<String, dynamic>> _dbStudents = [];
  List<Map<String, dynamic>> _filteredStudents = []; // 🔍 Holds search results
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController(); // 🔍 Controls search input

  // Manual fallback names so they are ALWAYS visible at launch
  final List<Map<String, String>> _manualStudents = [
    {
      'id': 'manual_1',
      'name': 'Abdi',
      'rollNumber': '62112',
      'department': 'Information Technology'
    },
    {
      'id': 'manual_2',
      'name': 'Amiri',
      'rollNumber': 'CS102',
      'department': 'Computer Science'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadStoredStudents();
  }

  // Reads any permanently added students from the database file
  Future<void> _loadStoredStudents() async {
    try {
      final data = await _dbHelper.queryAllRecords();
      setState(() {
        _dbStudents = data;

        // Combine your manual list and database list together
        final allItems = [..._manualStudents, ..._dbStudents];
        _filteredStudents = allItems; // Default search layout to show everything
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Database fetch error: $e");
    }
  }

  // 🔍 Filters through names, departments, or roll numbers in real-time
  void _filterSearch(String query) {
    final allItems = [..._manualStudents, ..._dbStudents];

    if (query.isEmpty) {
      setState(() {
        _filteredStudents = allItems;
      });
      return;
    }

    setState(() {
      _filteredStudents = allItems.where((student) {
        final name = (student['name'] ?? '').toString().toLowerCase();
        final dept = (student['department'] ?? student['course'] ?? '').toString().toLowerCase();
        final roll = (student['rollNumber'] ?? student['admission_number'] ?? '').toString().toLowerCase();
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) || dept.contains(searchLower) || roll.contains(searchLower);
      }).toList();
    });
  }

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
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  // Save directly into the permanent SQLite Database
                  await _dbHelper.insertRecord({
                    'name': nameController.text,
                    'course': deptController.text,
                    'admission_number': rollController.text,
                  });

                  if (!mounted) return;
                  Navigator.pop(context);

                  _searchController.clear(); // Reset search input box
                  _loadStoredStudents(); // Force UI rebuild with fresh database row
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
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registry')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔍 REAL-TIME SEARCH BAR COMPONENT
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSearch, // Runs filter logic automatically as you type
              decoration: InputDecoration(
                labelText: 'Search by Name, Dept, or Roll No...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // THE LIST VIEW
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(child: Text('No students found.'))
                : ListView.builder(
              itemCount: _filteredStudents.length, // Reads from your filtered data subset
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];

                final String id = student['id']?.toString() ?? '';
                final String name = student['name'] ?? '';
                final String rollNumber = student['rollNumber'] ?? student['admission_number'] ?? '';
                final String department = student['department'] ?? student['course'] ?? '';

                // Blocks deletion of system defaults (abdi, amiri)
                final bool isFromDb = !id.startsWith('manual_');

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$rollNumber • $department'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (isFromDb) {
                          // Safely delete permanent database record row
                          await _dbHelper.deleteRecord(student['id']);
                          _searchController.clear();
                          _loadStoredStudents();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cannot delete system default profiles.')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}