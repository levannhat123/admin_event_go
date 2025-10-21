import 'package:admin_event_go/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool darkModeEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileCard(),
            SizedBox(height: 24),

            // General Settings
            _buildSectionTitle('General'),
            SizedBox(height: 12),
            _buildSettingsGroup([
              _buildSwitchTile(
                'Notifications',
                'Enable push notifications',
                Icons.notifications,
                Color(0xFF6366F1),
                notificationsEnabled,
                (value) {
                  notificationsEnabled = value;
                },
              ),
              _buildSwitchTile(
                'Email Notifications',
                'Receive email updates',
                Icons.email,
                Color(0xFFEC4899),
                emailNotifications,
                (value) {
                  emailNotifications = value;
                },
              ),
              _buildSwitchTile(
                'Dark Mode',
                'Use dark theme',
                Icons.dark_mode,
                Color(0xFF8B5CF6),
                darkModeEnabled,
                (value) {
                  darkModeEnabled = value;
                },
              ),
            ]),
            SizedBox(height: 24),

            // Preferences
            _buildSectionTitle('Preferences'),
            SizedBox(height: 12),
            _buildSettingsGroup([
              _buildNavigationTile(
                'Language',
                selectedLanguage,
                Icons.language,
                Color(0xFF10B981),
                () => _showLanguageDialog(),
              ),
              _buildNavigationTile(
                'Currency',
                'USD (\$)',
                Icons.attach_money,
                Color(0xFFF59E0B),
                () {},
              ),
              _buildNavigationTile(
                'Time Zone',
                'GMT+7 (Bangkok)',
                Icons.access_time,
                Color(0xFF06B6D4),
                () {},
              ),
            ]),
            SizedBox(height: 24),

            // Account
            _buildSectionTitle('Account'),
            SizedBox(height: 12),
            _buildSettingsGroup([
              _buildNavigationTile(
                'Change Password',
                'Update your password',
                Icons.lock,
                Color(0xFF6366F1),
                () {},
              ),
              _buildNavigationTile(
                'Privacy Settings',
                'Manage your privacy',
                Icons.privacy_tip,
                Color(0xFFEC4899),
                () {},
              ),
              _buildNavigationTile(
                'Two-Factor Authentication',
                'Add extra security',
                Icons.security,
                Color(0xFF10B981),
                () {},
              ),
            ]),
            SizedBox(height: 24),

            // Support
            _buildSectionTitle('Support'),
            SizedBox(height: 12),
            _buildSettingsGroup([
              _buildNavigationTile(
                'Help Center',
                'Get help and support',
                Icons.help,
                Color(0xFF8B5CF6),
                () {},
              ),
              _buildNavigationTile(
                'Report a Bug',
                'Help us improve',
                Icons.bug_report,
                Color(0xFFF59E0B),
                () {},
              ),
              _buildNavigationTile(
                'Terms of Service',
                'Read our terms',
                Icons.description,
                Color(0xFF06B6D4),
                () {},
              ),
            ]),
            SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(),
            SizedBox(height: 24),

            // App Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 32),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'admin@eventgo.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.edit, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF334155)),
      ),
      child: Column(
        children: List.generate(
          children.length * 2 - 1,
          (index) {
            if (index.isOdd) {
              return Divider(color: Color(0xFF334155), height: 1);
            }
            return children[index ~/ 2];
          },
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white60, fontSize: 12),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: color,
        activeTrackColor: color.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNavigationTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white60, fontSize: 12),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFEF4444).withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showLogoutDialog(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4444).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.logout, color: Color(0xFFEF4444), size: 22),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Color(0xFFEF4444).withOpacity(0.5), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Language',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption('English'),
              _buildLanguageOption('Vietnamese'),
              _buildLanguageOption('Japanese'),
              _buildLanguageOption('Korean'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = selectedLanguage == language;
    return ListTile(
      title: Text(
        language,
        style: TextStyle(
          color: isSelected ? Color(0xFF6366F1) : Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Color(0xFF6366F1))
          : null,
      onTap: () {
        selectedLanguage = language;
        context.pop();
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            ElevatedButton(
              onPressed: () {
                context.pop();
                // TODO: Handle logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444),
              ),
              child: Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

