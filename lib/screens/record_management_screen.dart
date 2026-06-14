import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class RecordManagementScreen extends StatefulWidget {
  const RecordManagementScreen({Key? key}) : super(key: key);

  @override
  State<RecordManagementScreen> createState() => _RecordManagementScreenState();
}

class _RecordManagementScreenState extends State<RecordManagementScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _records = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _admController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  int? _selectedId; // Holds ID when updating a record

  @override
  void initState() {
    super.initState();
    _refreshRecords();
  }

  // Fetch or refresh the data array from SQLite
  Future<void> _refreshRecords() async {
    final data = await _dbHelper.queryAllRecords();
    setState(() {
      _records = data;
      _selectedId = null;
      _clearControllers();
    });
  }

  // Search execution tracking text input state
  Future<void> _runSearch(String query) async {
    if (query.isEmpty) {
      _refreshRecords();
      return;
    }
    final data = await _dbHelper.searchRecords(query);
    setState(() {
      _records = data;
    });
  }

  void _clearControllers() {
    _nameController.clear();
    _courseController.clear();
    _admController.clear();
  }

  // Populate input fields for updating an entry
  void _populateFieldsForEdit(Map<String, dynamic> record) {
    setState(() {
      _selectedId = record['id'];
      _nameController.text = record['name'];
      _courseController.text = record['course'];
      _admController.text = record['admission_number'];
    });
  }

  // Handle Save (Both Insert and Update operations)
  Future<void> _saveRecord() async {
    if (_nameController.text.isEmpty || _courseController.text.isEmpty || _admController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all validation fields')),
      );
      return;
    }

    final rowData = {
      'name': _nameController.text,
      'course': _courseController.text,
      'admission_number': _admController.text,
    };

    if (_selectedId == null) {
      // Create implementation
      await _dbHelper.insertRecord(rowData);
    } else {
      // Update implementation
      rowData['id'] = _selectedId!.toString(); // Add ID field to track map mutations
      await _dbHelper.updateRecord({
        'id': _selectedId,
        ...rowData
      });
    }

    _refreshRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Data Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form Fields Card Container
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Student Full Name')),
                    TextField(controller: _courseController, decoration: const InputDecoration(labelText: 'Course Name')),
                    TextField(controller: _admController, decoration: const InputDecoration(labelText: 'Admission Number')),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _saveRecord,
                      child: Text(_selectedId == null ? 'Add Student Record' : 'Update Record'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Search Input Field
            TextField(
              controller: _searchController,
              onChanged: (value) => _runSearch(value),
              decoration: const InputDecoration(
                labelText: 'Search Record via Name or Adm No.',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Data list visualization rendering
            Expanded(
              child: _records.isEmpty
                  ? const Center(child: Text('No local data records found.'))
                  : ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  final item = _records[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text('${item['course']} | ADM: ${item['admission_number']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _populateFieldsForEdit(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await _dbHelper.deleteRecord(item['id']);
                              _refreshRecords();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}