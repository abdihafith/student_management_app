import 'package:student_management_app/screens/student_detail_screen.dart';
import 'package:student_management_app/services/database_helper.dart';
import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

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
      if (!mounted) return;
      setState(() {
        _dbStudents = data;

        // Combine your manual list and database list together
        final allItems = [..._manualStudents, ..._dbStudents];
        _filteredStudents = allItems; // Default search layout to show everything
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bContext).viewInsets.bottom + 20,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add New Student',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildModalTextField(controller: nameController, label: 'Full Name', icon: Icons.person_outline),
            const SizedBox(height: 16),
            _buildModalTextField(controller: rollController, label: 'Roll Number', icon: Icons.badge_outlined),
            const SizedBox(height: 16),
            _buildModalTextField(controller: deptController, label: 'Department', icon: Icons.account_balance_outlined),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  
                  await _dbHelper.insertRecord({
                    'name': nameController.text,
                    'course': deptController.text,
                    'admission_number': rollController.text,
                  });

                  if (!mounted) return;
                  
                  navigator.pop();

                  _searchController.clear();
                  _loadStoredStudents();
                  
                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text('Student added to database'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
              child: const Text('Save Record', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
          // 🔍 FLOATING SEARCH BAR COMPONENT
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterSearch,
                decoration: InputDecoration(
                  hintText: 'Search by Name, Dept, or Roll No...',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.deepOrange),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _filterSearch('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),

          // THE LIST VIEW
          Expanded(
            child: _filteredStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No students found',
                          style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Try searching with a different name or roll number',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )
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
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/student_detail',
                      arguments: student,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Hero(
                      tag: 'student_avatar_${student['id']}',
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '$rollNumber • $department',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () async {
                        if (isFromDb) {
                          // Safely delete permanent database record row
                          await _dbHelper.deleteRecord(student['id']);
                          _searchController.clear();
                          _loadStoredStudents();
                        } else {
                          if (!context.mounted) return;
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