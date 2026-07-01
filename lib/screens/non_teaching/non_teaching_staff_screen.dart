import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';
import 'non_teaching_staff_details_screen.dart';

class NonTeachingStaffScreen extends StatefulWidget {
  const NonTeachingStaffScreen({super.key});

  @override
  State<NonTeachingStaffScreen> createState() => _NonTeachingStaffScreenState();
}

class _NonTeachingStaffScreenState extends State<NonTeachingStaffScreen> {


  
  @override
  void initState() {
    super.initState();
    _loadAllstaff();
  }

  final Color _bgPrimary = const Color(0xFFFAFAFA);
  final Color _textDark = const Color(0xFF111827);
  final Color _textMuted = const Color(0xFF6B7280);
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  List<Map<String, dynamic>> _allStaff = [
    {
      'initials': 'SI', 'name': 'Suresh Iyer', 'role': 'Front Desk Executive', 'dept': 'Administration', 
      'joined': '12 Mar 2018', 'shift': '8AM-4PM', 'contact': '+91 98450 11201', 'status': 'Active', 
      'bgColor': const Color(0xFFF4F1FF), 'textColor': const Color(0xFF4F46E5)
    },
    {
      'initials': 'RM', 'name': 'Rekha Mehta', 'role': 'Senior Accountant', 'dept': 'Accounts', 
      'joined': '5 Jun 2016', 'shift': '9AM-5PM', 'contact': '+91 98450 11202', 'status': 'Active', 
      'bgColor': const Color(0xFFE0F2FE), 'textColor': const Color(0xFF0EA5E9)
    },
    {
      'initials': 'AP', 'name': 'Anand Pillai', 'role': 'HR Executive', 'dept': 'Human Resources', 
      'joined': '20 Aug 2020', 'shift': '9AM-5PM', 'contact': '+91 98450 11203', 'status': 'Probation', 
      'bgColor': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF22C55E)
    },
    {
      'initials': 'BS', 'name': 'Bharat Singh', 'role': 'Security Head', 'dept': 'Security', 
      'joined': '1 Jan 2015', 'shift': '6AM-2PM', 'contact': '+91 98450 11204', 'status': 'Active', 
      'bgColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFFF59E0B)
    },
    {
      'initials': 'RK', 'name': 'Ramesh Kumar', 'role': 'Security Guard', 'dept': 'Security', 
      'joined': '14 Sep 2019', 'shift': '2PM-10PM', 'contact': '+91 98450 11205', 'status': 'Active', 
      'bgColor': const Color(0xFFFEE2E2), 'textColor': const Color(0xFFEF4444)
    },
    {
      'initials': 'KN', 'name': 'Kishore Naidu', 'role': 'Transport Manager', 'dept': 'Transport', 
      'joined': '7 Feb 2017', 'shift': '6AM-2PM', 'contact': '+91 98450 11206', 'status': 'Active', 
      'bgColor': const Color(0xFFF4F1FF), 'textColor': const Color(0xFF4F46E5)
    },
    {
      'initials': 'MP', 'name': 'Murugan Pillai', 'role': 'School Bus Driver', 'dept': 'Transport', 
      'joined': '3 Apr 2018', 'shift': '5AM-1PM', 'contact': '+91 98450 11207', 'status': 'Active', 
      'bgColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFFA855F7)
    },
    {
      'initials': 'SR', 'name': 'Selva Raj', 'role': 'School Bus Driver', 'dept': 'Transport', 
      'joined': '11 Nov 2020', 'shift': '5AM-1PM', 'contact': '+91 98450 11208', 'status': 'Contract', 
      'bgColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF6366F1)
    },
    {
      'initials': 'PJ', 'name': 'Pradeep Joshi', 'role': 'Librarian', 'dept': 'Library', 
      'joined': '22 Jul 2014', 'shift': '8AM-4PM', 'contact': '+91 98450 11209', 'status': 'On Leave', 
      'bgColor': const Color(0xFFF4F1FF), 'textColor': const Color(0xFF4F46E5)
    },
    {
      'initials': 'SB', 'name': 'Sunita Bose', 'role': 'Lab Technician', 'dept': 'Science Lab', 
      'joined': '18 Mar 2019', 'shift': '8AM-4PM', 'contact': '+91 98450 11210', 'status': 'Active', 
      'bgColor': const Color(0xFFE0F2FE), 'textColor': const Color(0xFF0EA5E9)
    },
    {
      'initials': 'TK', 'name': 'Tariq Khan', 'role': 'Maintenance', 'dept': 'Maintenance', 
      'joined': '9 Oct 2021', 'shift': '7AM-3PM', 'contact': '+91 98450 11211', 'status': 'Probation', 
      'bgColor': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF22C55E)
    },
  ];

  bool get _isTablet => MediaQuery.of(context).size.width > 768;

  
  Future<void> _loadAllstaff() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__allStaff_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _allStaff = decoded.map((item) {
          final map = Map<String, dynamic>.from(item);
          for (final key in map.keys.toList()) {
            if (key.toLowerCase().contains('color') && map[key] is int) {
              map[key] = Color(map[key] as int);
            }
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveAllstaff() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _allStaff.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__allStaff_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Non-Teaching Staff'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 32 : 16, 24, _isTablet ? 32 : 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildKpis(),
                          const SizedBox(height: 24),
                          _buildStaffListSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: BottomNavigationBar(
        currentIndex: 1, // Staff
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: const Color(0xFF6B7280),
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.menu_rounded, color: Color(0xFF8F96A3), size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.notifications_none_rounded, color: Color(0xFF8F96A3), size: 24),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF4F1FF),
              child: Text('A', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8463E9))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Home', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text('Staff', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text('Non-Teaching Staff', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        const SizedBox(height: 16),
        Text('Non-Teaching Staff', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 8),
        Text('Administration, support services, transport,\nsecurity and housekeeping personnel.',
            style: GoogleFonts.figtree(fontSize: 13, color: _textMuted, height: 1.4)),
      ],
    );
  }

  Widget _buildKpis() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isTablet ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 164,
          ),
          children: [
            _buildKpiCard(
              title: 'Total Staff',
              value: '116',
              subtitle: 'all categories',
              icon: LucideIcons.users,
              color: const Color(0xFF4F46E5),
              bgColor: const Color(0xFFF4F1FF),
            ),
            _buildKpiCard(
              title: 'Present Today',
              value: '101',
              subtitle: '87.1% attendance',
              icon: LucideIcons.userCheck,
              color: const Color(0xFF22C55E),
              bgColor: const Color(0xFFDCFCE7),
            ),
            _buildKpiCard(
              title: 'Departments\nServed',
              value: '8',
              subtitle: 'Admin to Housekeeping',
              icon: LucideIcons.briefcase,
              color: const Color(0xFF0EA5E9),
              bgColor: const Color(0xFFE0F2FE),
            ),
            _buildKpiCard(
              title: 'Open Roles',
              value: '7',
              subtitle: 'hiring in progress',
              icon: LucideIcons.alertCircle,
              color: const Color(0xFFEF4444),
              bgColor: const Color(0xFFFEE2E2),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark, height: 1.2)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
        ],
      ),
    );
  }

  Widget _buildStaffListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: [
            _buildStatusToggle('All'),
            _buildStatusToggle('Administration'),
            _buildStatusToggle('Support'),
            _buildStatusToggle('Transport'),
            _buildStatusToggle('Security'),
            _buildStatusToggle('Housekeeping'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Staff List (${_allStaff.length})', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE5E7EB))),
                  child: const Icon(LucideIcons.search, size: 16, color: Color(0xFF4B5563)),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE5E7EB))),
                  child: const Icon(LucideIcons.filter, size: 16, color: Color(0xFF4B5563)),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        _buildStaffList(),
      ],
    );
  }

  Widget _buildStatusToggle(String status) {
    bool isActive = _selectedStatus == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4F46E5) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          status,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildStaffList() {
    final filteredStaff = _allStaff.where((s) {
      if (_selectedStatus != 'All' && s['dept'] != _selectedStatus) {
        return false;
      }
      return true;
    }).toList();

    if (filteredStaff.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text('No staff found.', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredStaff.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
      itemBuilder: (context, index) {
        final data = filteredStaff[index];
        return _buildStaffListItem(data);
      },
    );
  }

  Widget _buildStaffListItem(Map<String, dynamic> data) {
    final status = data['status'] as String;
    Color statusText = const Color(0xFF22C55E); // Active green
    if (status == 'On Leave') {
      statusText = const Color(0xFFF59E0B);
    } else if (status == 'Probation') {
      statusText = const Color(0xFF0EA5E9);
    } else if (status == 'Contract') {
      statusText = const Color(0xFF6366F1); // Purple
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NonTeachingStaffDetailsScreen(staff: data),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: data['bgColor'] as Color,
              child: Text(data['initials'] as String, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: data['textColor'] as Color)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 2),
                  Text(data['role'] as String, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  const SizedBox(height: 2),
                  Text(data['dept'] as String, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(data['joined'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.clock, size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(data['shift'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF), size: 20),
                const SizedBox(height: 60),
                Text(status, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: statusText)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
