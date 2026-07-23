import 'package:flutter/material.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  final List<Map<String, dynamic>> departments = const [
    {'name': 'Computer Science', 'students': 450, 'icon': Icons.computer, 'color': Colors.blue},
    {'name': 'Information Technology', 'students': 380, 'icon': Icons.lan, 'color': Colors.orange},
    {'name': 'Engineering', 'students': 310, 'icon': Icons.precision_manufacturing, 'color': Colors.red},
    {'name': 'Business', 'students': 220, 'icon': Icons.business_center, 'color': Colors.green},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Departments', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          final dept = departments[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: dept['color'].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(dept['icon'], color: dept['color']),
              ),
              title: Text(dept['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('${dept['students']} Enrolled Students'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
