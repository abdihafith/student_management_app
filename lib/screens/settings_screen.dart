import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('System Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader("Account Security"),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.person_outline_rounded,
              title: "Admin Profile",
              subtitle: "Update personal details",
              iconColor: Colors.blue,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 60),
            _buildSettingsTile(
              icon: Icons.lock_outline_rounded,
              title: "Password & Security",
              subtitle: "Change password & 2FA",
              iconColor: Colors.indigo,
              onTap: () {},
            ),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionHeader("App Preferences"),
          _buildSettingsCard([
            SwitchListTile(
              secondary: _buildIconContainer(Icons.notifications_active_outlined, Colors.orange),
              title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.w600)),
              value: _notificationsEnabled,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
              activeColor: Colors.deepOrange,
            ),
            const Divider(height: 1, indent: 60),
            SwitchListTile(
              secondary: _buildIconContainer(Icons.dark_mode_outlined, Colors.purple),
              title: const Text("Dark Theme", style: TextStyle(fontWeight: FontWeight.w600)),
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
              activeColor: Colors.deepOrange,
            ),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionHeader("System Info"),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.help_outline_rounded,
              title: "Help & Support",
              subtitle: "Documentation & FAQs",
              iconColor: Colors.teal,
              onTap: () {},
            ),
            const Divider(height: 1, indent: 60),
            _buildSettingsTile(
              icon: Icons.info_outline_rounded,
              title: "About Version",
              subtitle: "Build 1.0.5 • Stable",
              iconColor: Colors.grey,
              onTap: () {},
            ),
          ]),
          
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {},
            child: const Text("Logout Session", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: _buildIconContainer(icon, iconColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
