import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart'; // Ensure Karein main.dart mein themeNotifier Defined Ho

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoSync = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Logged-in User ka dynamic data fetch karne ke liye
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? 'No Email Found';
    final userName = user?.displayName ?? 'My Notes User';

    // Avatar ke liye initials generate karne ke liye
    final initials = userName.isNotEmpty
        ? userName.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'U';

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      children: [
        // ==================================================
        // PROFILE CARD (DYNAMIC USER DATA)
        // ==================================================
        Card(
          elevation: 0,
          color: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFE07A5F),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF2D3142),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ==================================================
        // PREFERENCES
        // ==================================================
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            bottom: 8,
          ),
          child: Text(
            'Preferences',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ),

        Card(
          elevation: 0,
          color: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // ================= DARK MODE =================
              SwitchListTile(
                secondary: const Icon(
                  Icons.dark_mode_outlined,
                  color: Color(0xFFE07A5F),
                ),
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch between light and dark theme'),
                value: themeNotifier.value == ThemeMode.dark,
                activeColor: const Color(0xFFE07A5F),
                onChanged: (value) {
                  setState(() {
                    themeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),

              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),

              // ================= NOTIFICATIONS =================
              SwitchListTile(
                secondary: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFFE07A5F),
                ),
                title: const Text('Push Notifications'),
                subtitle: const Text('Get reminders for notes'),
                value: _notificationsEnabled,
                activeColor: const Color(0xFFE07A5F),
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ==================================================
        // CLOUD & STORAGE
        // ==================================================
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            bottom: 8,
          ),
          child: Text(
            'Cloud & Storage',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ),

        Card(
          elevation: 0,
          color: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(
                  Icons.cloud_sync_outlined,
                  color: Color(0xFFE07A5F),
                ),
                title: const Text('Auto Sync'),
                subtitle: const Text('Real-time sync with Firebase Firestore'),
                value: _autoSync,
                activeColor: const Color(0xFFE07A5F),
                onChanged: (value) {
                  setState(() {
                    _autoSync = value;
                  });
                },
              ),

              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),

              ListTile(
                leading: const Icon(
                  Icons.backup_outlined,
                  color: Color(0xFFE07A5F),
                ),
                title: const Text('Backup Data'),
                subtitle: const Text('Last backup: Today'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notes backed up successfully!'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ==================================================
        // SUPPORT & ABOUT
        // ==================================================
        Padding(
          padding: const EdgeInsets.only(
            left: 8,
            bottom: 8,
          ),
          child: Text(
            'Support & About',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ),

        Card(
          elevation: 0,
          color: isDark
              ? const Color(0xFF1E1E1E)
              : Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Color(0xFFE07A5F),
                ),
                title: const Text('About My Notes'),
                subtitle: const Text('Version 1.0.0'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'My Notes',
                    applicationVersion: '1.0.0',
                    applicationLegalese:
                    'A real-time Notes Application built with Flutter & Firebase.',
                  );
                },
              ),

              const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),

              ListTile(
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                  color: Color(0xFFE07A5F),
                ),
                title: const Text('Privacy Policy'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}