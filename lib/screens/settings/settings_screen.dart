import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../main.dart';
import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _primary = Color(0xFF8463E9);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.value == ThemeMode.dark;
    
    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Settings'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 32),
                        
                        _buildSectionTitle('Preferences'),
                        SizedBox(height: 12.h),
                        _buildSettingsContainer(
                          children: [
                            _buildToggleRow('Push Notifications', LucideIcons.bell, _notificationsEnabled, (val) {
                              setState(() => _notificationsEnabled = val);
                            }),
                            const Divider(height: 1, color: Color(0xFFE5E7EB)),
                            _buildToggleRow('Dark Mode', LucideIcons.moon, isDarkMode, (val) {
                              setState(() {
                                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                              });
                            }),
                          ]
                        ),
                        
                        const SizedBox(height: 32),
                        _buildSectionTitle('Account'),
                        SizedBox(height: 12.h),
                        _buildSettingsContainer(
                          children: [
                            _buildNavigationRow('Profile Info', LucideIcons.user),
                            const Divider(height: 1, color: Color(0xFFE5E7EB)),
                            _buildNavigationRow('Change Password', LucideIcons.lock),
                          ]
                        ),
                        
                        const SizedBox(height: 32),
                        _buildSectionTitle('System'),
                        SizedBox(height: 12.h),
                        _buildSettingsContainer(
                          children: [
                            _buildNavigationRow('About SmartCampusOS', LucideIcons.info),
                            const Divider(height: 1, color: Color(0xFFE5E7EB)),
                            _buildNavigationRow('Terms of Service', LucideIcons.fileText),
                            const Divider(height: 1, color: Color(0xFFE5E7EB)),
                            _buildNavigationRow('Log Out', LucideIcons.logOut, color: Colors.red),
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.figtree(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _textDark,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: const Icon(LucideIcons.menu, size: 24, color: _textDark),
        ),
        const SizedBox(width: 16),
        Text('Settings', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
      ],
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildToggleRow(String title, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _textMuted),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: GoogleFonts.figtree(fontSize: 16, color: _textDark))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: _primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow(String title, IconData icon, {Color color = _textDark}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color == _textDark ? _textMuted : color),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: GoogleFonts.figtree(fontSize: 16, color: color))),
            Icon(LucideIcons.chevronRight, size: 20, color: _textMuted.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
