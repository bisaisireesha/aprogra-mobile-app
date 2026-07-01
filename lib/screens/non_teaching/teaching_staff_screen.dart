import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';

class TeachingStaffScreen extends StatefulWidget {
  const TeachingStaffScreen({super.key});

  
  @override
  void initState() {
    super.initState();
    _loadAllteachers();
  }

  @override
  State<TeachingStaffScreen> createState() => _TeachingStaffScreenState();
}

class _TeachingStaffScreenState extends State<TeachingStaffScreen> {
  int _bottomNavIndex = 3; // Staff
  final Color _bgPrimary = const Color(0xFFFAFAFA);
  final Color _textDark = const Color(0xFF111827);
  final Color _textMuted = const Color(0xFF6B7280);
  final Color _accent = const Color(0xFF4F46E5);

  String _searchQuery = '';
  String _selectedStatus = 'All';
  String _selectedDesignation = 'All Designations';
  String _selectedSubject = 'All Subjects';

  List<Map<String, dynamic>> _allTeachers = [
    {
      'initials': 'AS', 'name': 'Anjali Sharma', 'role': 'Senior Teacher', 'dept': 'Mathematics', 
      'subjects': ['Algebra', 'Calculus'], 'classes': '10A 10B 11A', 'exp': '14', 'status': 'Active', 
      'bgColor': const Color(0xFFF4F1FF), 'textColor': const Color(0xFF4F46E5)
    },
    {
      'initials': 'RI', 'name': 'Rajesh Iyer', 'role': 'Teacher', 'dept': 'Sciences', 
      'subjects': ['Physics', 'Chemistry'], 'classes': '9A 9B', 'exp': '8', 'status': 'On Leave', 
      'bgColor': const Color(0xFFE0F2FE), 'textColor': const Color(0xFF0EA5E9)
    },
    {
      'initials': 'MK', 'name': 'Meera Kapoor', 'role': 'Senior Teacher', 'dept': 'English', 
      'subjects': ['Grammar', 'Literature'], 'classes': '8A 8B 7A', 'exp': '11', 'status': 'Active', 
      'bgColor': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF22C55E)
    },
    {
      'initials': 'SN', 'name': 'Sunil Nair', 'role': 'Head of Dept', 'dept': 'Social Studies', 
      'subjects': ['History', 'Geography'], 'classes': '6A 6B 7B', 'exp': '18', 'status': 'Active', 
      'bgColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFFF59E0B)
    },
    {
      'initials': 'PK', 'name': 'Priya Krishnan', 'role': 'Teacher', 'dept': 'Hindi', 
      'subjects': ['Hindi Lang', 'Hindi Lit'], 'classes': '5A 5B 6A', 'exp': '6', 'status': 'Active', 
      'bgColor': const Color(0xFFFEE2E2), 'textColor': const Color(0xFFEF4444)
    },
    {
      'initials': 'AM', 'name': 'Arjun Mehta', 'role': 'HOD', 'dept': 'Computer Science', 
      'subjects': ['Python', 'DBMS'], 'classes': '11A 12A 12B', 'exp': '12', 'status': 'Active', 
      'bgColor': const Color(0xFFF4F1FF), 'textColor': const Color(0xFF4F46E5)
    },
    {
      'initials': 'KR', 'name': 'Kavitha Reddy', 'role': 'Teacher', 'dept': 'Sciences', 
      'subjects': ['Biology'], 'classes': '9A 10A', 'exp': '7', 'status': 'Active', 
      'bgColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFFA855F7)
    },
    {
      'initials': 'DJ', 'name': 'Deepak Joshi', 'role': 'PET', 'dept': 'Physical Education', 
      'subjects': ['Yoga', 'Athletics'], 'classes': 'All Classes', 'exp': '9', 'status': 'Probation', 
      'bgColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF6366F1)
    },
  ];

  bool get _isTablet => MediaQuery.of(context).size.width > 768;

  
  Future<void> _loadAllteachers() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__allTeachers_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _allTeachers = decoded.map((item) {
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

  Future<void> _saveAllteachers() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _allTeachers.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__allTeachers_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Teaching Staff'),
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
                          _buildTeacherListSection(),
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
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), activeIcon: Icon(Icons.show_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(LucideIcons.menu, color: Color(0xFF111827)),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Teaching Staff', style: GoogleFonts.figtree(fontSize: 28, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 8),
                  Text('Browse and manage all teaching faculty — departments, designations, subjects, and daily status.',
                      style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _showAddTeacherDialog,
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: Text('Add Teacher', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddTeacherDialog() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final deptController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Add Teacher', style: GoogleFonts.figtree(fontWeight: FontWeight.bold, color: _textDark)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: GoogleFonts.figtree(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(
                    labelText: 'Role (e.g., Teacher)',
                    labelStyle: GoogleFonts.figtree(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: deptController,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    labelStyle: GoogleFonts.figtree(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.figtree(color: _textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    String initials = nameController.text.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
                    if (initials.isEmpty) initials = 'T';
                    
                    _allTeachers.insert(0, {
                      'initials': initials,
                      'name': nameController.text.trim(),
                      'role': roleController.text.trim().isEmpty ? 'Teacher' : roleController.text.trim(),
                      'dept': deptController.text.trim().isEmpty ? 'General' : deptController.text.trim(),
                      'subjects': ['General'],
                      'classes': 'TBD',
                      'exp': '0',
                      'status': 'Active',
                      'bgColor': const Color(0xFFE0F2FE),
                      'textColor': const Color(0xFF0EA5E9)
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Add', style: GoogleFonts.figtree(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }
    );
  }

  Widget _buildKpis() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: _isTablet ? 1.4 : 0.9,
          children: [
            _buildKpiCard(
              title: 'Total Teachers',
              value: '132',
              subtitle: 'across all depts',
              icon: LucideIcons.users,
              color: _accent,
              bgColor: const Color(0xFFF4F1FF),
            ),
            _buildKpiCard(
              title: 'Present Today',
              value: '118',
              subtitle: '89.4% attendance',
              icon: LucideIcons.userCheck,
              color: const Color(0xFF22C55E),
              bgColor: const Color(0xFFDCFCE7),
            ),
            _buildKpiCard(
              title: 'On Leave',
              value: '9',
              subtitle: '5 approved • 4 pending',
              icon: LucideIcons.calendarOff,
              color: const Color(0xFFF59E0B),
              bgColor: const Color(0xFFFEF3C7),
            ),
            _buildKpiCard(
              title: 'Vacancies',
              value: '11',
              subtitle: 'across 5 departments',
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 16),
              Text(title, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted)),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.figtree(fontSize: 28, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.chevron_right, size: 18, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildStatusToggle('All')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatusToggle('Active')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatusToggle('On Leave')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatusToggle('Probation')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Search by name or department...',
                    hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 18),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  style: GoogleFonts.figtree(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _showFilterDialog,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.filter, size: 16, color: Color(0xFF6B7280)),
                    const SizedBox(width: 8),
                    Text('Filters', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildTeacherGrid(),
      ],
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempDesignation = _selectedDesignation;
        String tempSubject = _selectedSubject;
        
        final designations = ['All Designations', 'Teacher', 'Senior Teacher', 'Head of Dept', 'HOD', 'PET'];
        final subjects = ['All Subjects', 'Algebra', 'Calculus', 'Physics', 'Chemistry', 'Grammar', 'Literature', 'History', 'Geography', 'Hindi Lang', 'Hindi Lit', 'Python', 'DBMS', 'Biology', 'Yoga', 'Athletics'];

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('Filters', style: GoogleFonts.figtree(fontWeight: FontWeight.bold, color: _textDark)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Designation', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: tempDesignation,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: designations.map((d) => DropdownMenuItem(value: d, child: Text(d, style: GoogleFonts.figtree(fontSize: 14)))).toList(),
                    onChanged: (val) => setStateDialog(() => tempDesignation = val!),
                  ),
                  const SizedBox(height: 16),
                  Text('Subject', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: tempSubject,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s, style: GoogleFonts.figtree(fontSize: 14)))).toList(),
                    onChanged: (val) => setStateDialog(() => tempSubject = val!),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.figtree(color: _textMuted)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDesignation = tempDesignation;
                      _selectedSubject = tempSubject;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Apply', style: GoogleFonts.figtree(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  Widget _buildStatusToggle(String status) {
    bool isActive = _selectedStatus == status;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive ? null : Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          status,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherGrid() {
    final filteredTeachers = _allTeachers.where((t) {
      final name = (t['name'] as String).toLowerCase();
      final dept = (t['dept'] as String).toLowerCase();
      final status = t['status'] as String;
      final role = t['role'] as String;
      final subjects = t['subjects'] as List<String>;

      if (_searchQuery.isNotEmpty && !name.contains(_searchQuery.toLowerCase()) && !dept.contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedStatus != 'All' && status != _selectedStatus) {
        return false;
      }
      if (_selectedDesignation != 'All Designations' && role != _selectedDesignation) {
        return false;
      }
      if (_selectedSubject != 'All Subjects' && !subjects.contains(_selectedSubject)) {
        return false;
      }
      return true;
    }).toList();

    if (filteredTeachers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Text('No teachers found.', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted)),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1100) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 550) {
          crossAxisCount = 2;
        }
        
        double spacing = 16.0;
        double cardWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: filteredTeachers.map((t) => SizedBox(
            width: cardWidth,
            child: _buildTeacherCard(t),
          )).toList(),
        );
      },
    );
  }

  Widget _buildTeacherCard(Map<String, dynamic> data) {
    final status = data['status'] as String;
    Color statusBg = const Color(0xFFDCFCE7);
    Color statusText = const Color(0xFF22C55E);
    if (status == 'On Leave') {
      statusBg = const Color(0xFFFEF3C7);
      statusText = const Color(0xFFF59E0B);
    } else if (status == 'Probation') {
      statusBg = const Color(0xFFDBEAFE);
      statusText = const Color(0xFF3B82F6);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: data['bgColor'] as Color,
                child: Text(data['initials'] as String, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: data['textColor'] as Color)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: statusText)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(data['name'] as String, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text(data['role'] as String, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(LucideIcons.graduationCap, size: 14, color: Color(0xFF4F46E5)),
              const SizedBox(width: 6),
              Text(data['dept'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF4F46E5))),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (data['subjects'] as List<String>).map((sub) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF4F1FF), borderRadius: BorderRadius.circular(6)),
              child: Text(sub, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF4F46E5))),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(LucideIcons.bookOpen, size: 14, color: Color(0xFF8F96A3)),
              const SizedBox(width: 6),
              Text(data['classes'] as String, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF6B7280))),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${data['exp']} yrs experience', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              Row(
                children: [
                  const Icon(LucideIcons.phone, size: 16, color: Color(0xFF8F96A3)),
                  const SizedBox(width: 12),
                  const Icon(LucideIcons.mail, size: 16, color: Color(0xFF8F96A3)),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const Icon(LucideIcons.eye, size: 16, color: Color(0xFF4F46E5)),
                      const SizedBox(width: 4),
                      Text('View', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
