import 'package:student_management_app/screens/api_student_registry.dart';
import 'package:student_management_app/screens/attendance_screen.dart';
import 'package:student_management_app/screens/settings_screen.dart';
import 'package:student_management_app/screens/department_screen.dart';
import 'package:student_management_app/screens/pending_requests_screen.dart';
import 'package:student_management_app/screens/record_management_screen.dart';
import 'package:student_management_app/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'student_list.dart';
import 'login.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalStudents = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final data = await _dbHelper.queryAllRecords();
    if (mounted) {
      setState(() {
        _totalStudents = 2 + data.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin Console', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.deepOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.deepOrange),
              onPressed: () {},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.black87),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome back,", style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
            const Text("Administrator", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 25),
            
            // --- QUICK STATS SECTION ---
            const Text("Quick Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildStatCard(
                    "Total Students", 
                    _totalStudents.toString(), 
                    Icons.school, 
                    Colors.blue,
                    onTap: () => Navigator.pushNamed(context, '/student_list').then((_) => _loadStats()),
                  ),
                  _buildStatCard(
                    "Attendance", 
                    "94%", 
                    Icons.done_all, 
                    Colors.green,
                    onTap: () => Navigator.pushNamed(context, '/attendance'),
                  ),
                  _buildStatCard(
                    "Departments", 
                    "4", 
                    Icons.account_balance, 
                    Colors.orange,
                    onTap: () => Navigator.pushNamed(context, '/departments'),
                  ),
                  _buildStatCard(
                    "Pending", 
                    "0", 
                    Icons.pending_actions, 
                    Colors.purple,
                    onTap: () => Navigator.pushNamed(context, '/pending_requests'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            const Text("Administrative Tools", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            // --- GRID SECTION ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildActionCard(
                  context,
                  title: 'Student\nDatabase',
                  icon: Icons.people_alt_rounded,
                  color: Colors.indigo,
                  onTap: () => Navigator.pushNamed(context, '/student_list').then((_) => _loadStats()),
                ),
                _buildActionCard(
                  context,
                  title: 'Cloud\nRegistry',
                  icon: Icons.cloud_circle_rounded,
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/api_registry'),
                ),
                _buildActionCard(
                  context,
                  title: 'Daily\nAttendance',
                  icon: Icons.event_available_rounded,
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, '/attendance'),
                ),
                _buildActionCard(
                  context,
                  title: 'Record\nManager',
                  icon: Icons.manage_accounts_rounded,
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/record_management').then((_) => _loadStats()),
                ),
                _buildActionCard(
                  context,
                  title: 'System\nSettings',
                  icon: Icons.tune_rounded,
                  color: Colors.pink,
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            const Text("Recent Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildActivityTile("Database synced successfully", "Just now", Icons.sync, Colors.blue),
            _buildActivityTile("Attendance marked for IT Dept", "1 hour ago", Icons.check_circle_outline, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, height: 1.2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTile(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
