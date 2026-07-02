import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import '../students/students_list_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'create_teacher_wizard.dart';
import 'teacher_details_screen.dart';

class TeachersListScreen extends StatefulWidget {
  const TeachersListScreen({super.key});

  @override
  State<TeachersListScreen> createState() => _TeachersListScreenState();
}

class _TeachersListScreenState extends State<TeachersListScreen> {


  
  @override
  void initState() {
    super.initState();
    _loadAllteachers();
  }

  String _selectedFilter = 'All';
  String _searchQuery = '';
  int _currentIndex = 1; // 1 represents Academics
  
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  String? _filterExperience;
  String? _filterRole;
  
  final List<String> _availableRoles = ['Teacher', 'Class Teacher', 'Senior Teacher', 'Subject Lead', 'Coordinator', 'Head of Department'];
  final List<String> _availableExperiences = ['0-5 yrs', '5-10 yrs', '10+ yrs'];

  List<Map<String, dynamic>> _allTeachers = [
    // 6 Pre-Primary
    {'initials': 'MJ', 'name': 'Meera Joshi', 'id': 'EMP-101', 'role': 'Senior Teacher', 'department': 'Pre-Primary', 'subjects': ['Rhymes'], 'experience': '3 yrs', 'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)},
    {'initials': 'PR', 'name': 'Pooja Rao', 'id': 'EMP-102', 'role': 'Class Teacher', 'department': 'Pre-Primary', 'subjects': ['Story Time'], 'experience': '4 yrs', 'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)},
    {'initials': 'NK', 'name': 'Nita Kumar', 'id': 'EMP-106', 'role': 'Teacher', 'department': 'Pre-Primary', 'subjects': ['Art'], 'experience': '2 yrs', 'avatarColor': const Color(0xFFFCE7F3), 'textColor': const Color(0xFFBE185D)},
    {'initials': 'SP', 'name': 'Sneha Patel', 'id': 'EMP-107', 'role': 'Teacher', 'department': 'Pre-Primary', 'subjects': ['Activity'], 'experience': '5 yrs', 'avatarColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFFB45309)},
    {'initials': 'RV', 'name': 'Roshni Verma', 'id': 'EMP-108', 'role': 'Teacher', 'department': 'Pre-Primary', 'subjects': ['Numbers'], 'experience': '1 yrs', 'avatarColor': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF15803D)},
    {'initials': 'AK', 'name': 'Aditi Kapoor', 'id': 'EMP-109', 'role': 'Teacher', 'department': 'Pre-Primary', 'subjects': ['Letters'], 'experience': '6 yrs', 'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)},

    // 10 Primary
    {'initials': 'AS', 'name': 'Anita Sharma', 'id': 'EMP-103', 'role': 'Subject Lead', 'department': 'Primary', 'subjects': ['Art & Craft'], 'experience': '5 yrs', 'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)},
    {'initials': 'RJ', 'name': 'Rajiv Jain', 'id': 'EMP-110', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Mathematics'], 'experience': '8 yrs', 'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)},
    {'initials': 'SM', 'name': 'Simran Kaur', 'id': 'EMP-111', 'role': 'Class Teacher', 'department': 'Primary', 'subjects': ['English'], 'experience': '4 yrs', 'avatarColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFFB45309)},
    {'initials': 'PG', 'name': 'Priya Gupta', 'id': 'EMP-112', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Science'], 'experience': '3 yrs', 'avatarColor': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF15803D)},
    {'initials': 'VN', 'name': 'Vikram Nath', 'id': 'EMP-113', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Hindi'], 'experience': '7 yrs', 'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)},
    {'initials': 'SG', 'name': 'Suresh Garg', 'id': 'EMP-114', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Social Studies'], 'experience': '10 yrs', 'avatarColor': const Color(0xFFFCE7F3), 'textColor': const Color(0xFFBE185D)},
    {'initials': 'MN', 'name': 'Manju Nair', 'id': 'EMP-115', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Computer Science'], 'experience': '2 yrs', 'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)},
    {'initials': 'RB', 'name': 'Rahul Bose', 'id': 'EMP-116', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Physical Education'], 'experience': '6 yrs', 'avatarColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFFB45309)},
    {'initials': 'TP', 'name': 'Tara Prasad', 'id': 'EMP-117', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Music'], 'experience': '9 yrs', 'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)},
    {'initials': 'DK', 'name': 'Deepa Krishnan', 'id': 'EMP-118', 'role': 'Teacher', 'department': 'Primary', 'subjects': ['Art'], 'experience': '5 yrs', 'avatarColor': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF15803D)},

    // 9 Secondary
    {'initials': 'SD', 'name': 'Sneha Das', 'id': 'EMP-104', 'role': 'Coordinator', 'department': 'Secondary', 'subjects': ['Music'], 'experience': '6 yrs', 'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)},
    {'initials': 'KM', 'name': 'Kavita Menon', 'id': 'EMP-105', 'role': 'Head of Department', 'department': 'Secondary', 'subjects': ['English'], 'experience': '7 yrs', 'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)},
    {'initials': 'AR', 'name': 'Amit Roy', 'id': 'EMP-119', 'role': 'Senior Teacher', 'department': 'Secondary', 'subjects': ['Physics'], 'experience': '12 yrs', 'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)},
    {'initials': 'SS', 'name': 'Sunita Sen', 'id': 'EMP-120', 'role': 'Senior Teacher', 'department': 'Secondary', 'subjects': ['Chemistry'], 'experience': '11 yrs', 'avatarColor': const Color(0xFFFCE7F3), 'textColor': const Color(0xFFBE185D)},
    {'initials': 'VM', 'name': 'Varun Mehra', 'id': 'EMP-121', 'role': 'Teacher', 'department': 'Secondary', 'subjects': ['Mathematics'], 'experience': '8 yrs', 'avatarColor': const Color(0xFFFEF3C7), 'textColor': const Color(0xFFB45309)},
    {'initials': 'PN', 'name': 'Poonam Nanda', 'id': 'EMP-122', 'role': 'Teacher', 'department': 'Secondary', 'subjects': ['Biology'], 'experience': '10 yrs', 'avatarColor': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF15803D)},
    {'initials': 'RM', 'name': 'Rakesh Mishra', 'id': 'EMP-123', 'role': 'Teacher', 'department': 'Secondary', 'subjects': ['History'], 'experience': '14 yrs', 'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)},
    {'initials': 'NJ', 'name': 'Nisha Jha', 'id': 'EMP-124', 'role': 'Teacher', 'department': 'Secondary', 'subjects': ['Geography'], 'experience': '5 yrs', 'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)},
    {'initials': 'KT', 'name': 'Karan Tiwari', 'id': 'EMP-125', 'role': 'Teacher', 'department': 'Secondary', 'subjects': ['Economics'], 'experience': '7 yrs', 'avatarColor': const Color(0xFFFCE7F3), 'textColor': const Color(0xFFBE185D)},
  ];

  List<Map<String, dynamic>> get _teachers {
    var filtered = _allTeachers;
    if (_selectedFilter != 'All') {
      filtered = filtered.where((t) => t['department'] == _selectedFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((t) => 
        t['name'].toString().toLowerCase().contains(q) ||
        t['id'].toString().toLowerCase().contains(q) ||
        (t['subjects'] as List).any((s) => s.toString().toLowerCase().contains(q))
      ).toList();
    }
    if (_filterRole != null) {
      filtered = filtered.where((t) => t['role'] == _filterRole).toList();
    }
    if (_filterExperience != null) {
      filtered = filtered.where((t) {
        int exp = int.tryParse((t['experience'] as String).replaceAll(' yrs', '')) ?? 0;
        if (_filterExperience == '0-5 yrs') return exp <= 5;
        if (_filterExperience == '5-10 yrs') return exp > 5 && exp <= 10;
        if (_filterExperience == '10+ yrs') return exp > 10;
        return true;
      }).toList();
    }
    return filtered;
  }

  List<Map<String, dynamic>> get _paginatedTeachers {
    final start = (_currentPage - 1) * _itemsPerPage;
    final end = start + _itemsPerPage;
    final tList = _teachers;
    if (start >= tList.length) return [];
    return tList.sublist(start, end > tList.length ? tList.length : end);
  }

  
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
      backgroundColor: Colors.white,
      drawer: const MenuScreen(activeScreen: 'Teachers'),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildStatsCards(),
                    const SizedBox(height: 24),
                    _buildFiltersAndSearch(),
                    const SizedBox(height: 24),
                    _buildTeachersTable(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }

    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Teachers',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Future<void> _showAddTeacherPopup() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => const CreateTeacherWizard(),
    );

    if (result != null) {
      setState(() {
        // Add random avatar color
        result['avatarColor'] = const Color(0xFFF3E8FF);
        result['textColor'] = const Color(0xFF7E22CE);
        
        // Calculate initials
        final name = result['name'] as String;
        final parts = name.split(' ');
        if (parts.length > 1) {
          result['initials'] = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
        } else if (parts.isNotEmpty) {
          result['initials'] = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
        } else {
          result['initials'] = 'T';
        }

        _allTeachers.insert(0, result);
        _saveAllteachers();
      });
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Advanced Filters', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Role', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableRoles.map((role) {
                        final isSelected = _filterRole == role;
                        return ChoiceChip(
                          label: Text(role, style: GoogleFonts.inter(fontSize: 13)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() => _filterRole = selected ? role : null);
                          },
                          selectedColor: const Color(0xFFEEF2FF),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: isSelected ? const Color(0xFF818CF8) : const Color(0xFFE5E7EB)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text('Experience', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableExperiences.map((exp) {
                        final isSelected = _filterExperience == exp;
                        return ChoiceChip(
                          label: Text(exp, style: GoogleFonts.inter(fontSize: 13)),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() => _filterExperience = selected ? exp : null);
                          },
                          selectedColor: const Color(0xFFEEF2FF),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: isSelected ? const Color(0xFF818CF8) : const Color(0xFFE5E7EB)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _filterRole = null;
                      _filterExperience = null;
                    });
                  },
                  child: Text('Clear All', style: GoogleFonts.inter(color: const Color(0xFF6B7280))),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentPage = 1;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Apply Filters', style: GoogleFonts.inter(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleTeacherAction(String action, Map<String, dynamic> teacher) {
    if (action == 'view') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeacherDetailsScreen(
            initials: teacher['initials'],
            name: teacher['name'],
            grades: teacher['department'],
            subject: (teacher['subjects'] as List).join(', '),
            avatarColor: teacher['avatarColor'],
            status: 'Active',
            classesToday: '5',
          ),
        ),
      );
    } else if (action == 'edit') {
      showDialog<Map<String, dynamic>>(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.3),
        builder: (context) => CreateTeacherWizard(initialData: teacher),
      ).then((result) {
        if (result != null) {
          setState(() {
            final index = _allTeachers.indexWhere((t) => t['id'] == teacher['id']);
            if (index != -1) {
              result['avatarColor'] = teacher['avatarColor'];
              result['textColor'] = teacher['textColor'];
              result['initials'] = teacher['initials'];
              _allTeachers[index] = result;
            }
          });
        }
      });
    } else if (action == 'delete') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Delete Teacher', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to delete ${teacher['name']}?', style: GoogleFonts.inter()),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey))),
            TextButton(
              onPressed: () {
                setState(() => _allTeachers.removeWhere((t) => t['id'] == teacher['id']));
                Navigator.pop(context);
              },
              child: Text('Delete', style: GoogleFonts.inter(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatsCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final Widget totalCard = _buildStatCard(
          title: 'Total Teachers',
          value: '25',
          icon: LucideIcons.users,
          iconColor: const Color(0xFF6366F1),
          iconBgColor: const Color(0xFFEEF2FF),
          isActive: _selectedFilter == 'All',
          onTap: () => setState(() => _selectedFilter = 'All'),
        );
        final Widget prePrimaryCard = _buildStatCard(
          title: 'Pre-Primary Teachers',
          value: '6',
          icon: LucideIcons.baby,
          iconColor: const Color(0xFFEF4444),
          iconBgColor: const Color(0xFFFEF2F2),
          isActive: _selectedFilter == 'Pre-Primary',
          onTap: () => setState(() => _selectedFilter = 'Pre-Primary'),
        );
        final Widget primaryCard = _buildStatCard(
          title: 'Primary Teachers',
          value: '10',
          icon: LucideIcons.blocks,
          iconColor: const Color(0xFFF59E0B),
          iconBgColor: const Color(0xFFFFF7ED),
          isActive: _selectedFilter == 'Primary',
          onTap: () => setState(() => _selectedFilter = 'Primary'),
        );
        final Widget secondaryCard = _buildStatCard(
          title: 'Secondary Teachers',
          value: '9',
          icon: LucideIcons.graduationCap,
          iconColor: const Color(0xFF10B981),
          iconBgColor: const Color(0xFFECFDF5),
          isActive: _selectedFilter == 'Secondary',
          onTap: () => setState(() => _selectedFilter = 'Secondary'),
        );

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: totalCard),
                  const SizedBox(width: 16),
                  Expanded(child: prePrimaryCard),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(child: primaryCard),
                  const SizedBox(width: 16),
                  Expanded(child: secondaryCard),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: totalCard),
            const SizedBox(width: 16),
            Expanded(child: prePrimaryCard),
            const SizedBox(width: 16),
            Expanded(child: primaryCard),
            const SizedBox(width: 16),
            Expanded(child: secondaryCard),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterButtons(),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            final searchField = Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.search, size: 20, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setState(() => _searchQuery = val),
                            decoration: InputDecoration(
                              hintText: 'Search teachers, ID, email, or subject',
                              hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => _showFilterDialog(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (_filterExperience != null || _filterRole != null) ? const Color(0xFFEEF2FF) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: (_filterExperience != null || _filterRole != null) ? const Color(0xFF818CF8) : const Color(0xFFE5E7EB)),
                    ),
                    child: Icon(
                      LucideIcons.slidersHorizontal,
                      size: 20,
                      color: (_filterExperience != null || _filterRole != null) ? const Color(0xFF6366F1) : const Color(0xFF4B5563),
                    ),
                  ),
                ),
              ],
            );
            final showingText = Text(
              'Showing ${_teachers.length} teachers',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            );

            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchField,
                  SizedBox(height: 12.h),
                  showingText,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: searchField),
                const SizedBox(width: 16),
                showingText,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildFilterButton('All')),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Pre-Primary')),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Primary')),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Secondary')),
      ],
    );
  }

  Widget _buildFilterButton(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFEBEBEB)),
          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF595973),
          ),
        ),
      ),
    );
  }

  Widget _buildTeachersTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              if (isMobile) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _paginatedTeachers.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  itemBuilder: (context, index) => _buildMobileTeacherCard(_paginatedTeachers[index]),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 800,
                    maxWidth: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text('TEACHER', style: _tableHeaderStyle())),
                            Expanded(flex: 2, child: Text('DEPARTMENT', style: _tableHeaderStyle())),
                            Expanded(flex: 2, child: Text('SUBJECTS', style: _tableHeaderStyle())),
                            Expanded(flex: 2, child: Text('EXPERIENCE', style: _tableHeaderStyle())),
                            const SizedBox(width: 40), // For more_vert icon
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _paginatedTeachers.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        itemBuilder: (context, index) {
                          final t = _paginatedTeachers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: t['avatarColor'],
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          t['initials'],
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: t['textColor'],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            t['name'],
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${t['id']} • ${t['role']}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: const Color(0xFF6B7280),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    t['department'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: (t['subjects'] as List).map((s) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        s,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF374151),
                                        ),
                                      ),
                                    )).toList(),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    t['experience'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  color: Colors.white,
                                  icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF9CA3AF)),
                                  onSelected: (value) => _handleTeacherAction(value, t),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(value: 'view', child: Text('View', style: GoogleFonts.inter())),
                                    PopupMenuItem(value: 'edit', child: Text('Edit', style: GoogleFonts.inter())),
                                    PopupMenuItem(value: 'delete', child: Text('Delete', style: GoogleFonts.inter(color: Colors.red))),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildMobileTeacherCard(Map<String, dynamic> t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: t['avatarColor'], shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(t['initials'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: t['textColor'])),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(t['name'], style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF111827)))),
                    PopupMenuButton<String>(
                      color: Colors.white,
                      icon: const Icon(Icons.more_vert, size: 20, color: Color(0xFF9CA3AF)),
                      onSelected: (value) => _handleTeacherAction(value, t),
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'view', child: Text('View', style: GoogleFonts.inter())),
                        PopupMenuItem(value: 'edit', child: Text('Edit', style: GoogleFonts.inter())),
                        PopupMenuItem(value: 'delete', child: Text('Delete', style: GoogleFonts.inter(color: Colors.red))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${t['id']} • ${t['role']}', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280))),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(child: Text('${t['department']} • ', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280)), overflow: TextOverflow.ellipsis)),
                          if ((t['subjects'] as List).isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
                              child: Text(t['subjects'][0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
                            ),
                        ],
                      ),
                    ),
                    Text(t['experience'], style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 450;
          final totalItems = _teachers.length;
          final totalPages = (totalItems / _itemsPerPage).ceil().clamp(1, 9999);
          final startItem = totalItems == 0 ? 0 : ((_currentPage - 1) * _itemsPerPage) + 1;
          final endItem = (_currentPage * _itemsPerPage).clamp(0, totalItems);

          final showingText = Text(
            'Showing $startItem-$endItem of $totalItems',
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280)),
          );

          final pageControls = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPageButton(
                Icons.chevron_left,
                onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
              ),
              const SizedBox(width: 12),
              Text(
                'Page $_currentPage / $totalPages',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF374151)),
              ),
              const SizedBox(width: 12),
              _buildPageButton(
                Icons.chevron_right,
                onTap: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
              ),
            ],
          );

          if (isSmall) {
            return Column(
              children: [
                showingText,
                SizedBox(height: 12.h),
                pageControls,
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showingText,
              pageControls,
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageButton(IconData icon, {VoidCallback? onTap}) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFFF9FAFB) : Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isDisabled ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF9CA3AF),
      letterSpacing: 0.5,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.dashboard_customize_outlined, 'Home'),
              _buildNavItem(1, Icons.school_outlined, 'Academics'),
              _buildNavItem(2, Icons.chat_bubble_outline, 'Messages', badge: '9'),
              _buildNavItem(3, Icons.cases_outlined, 'Operations'),
              _buildNavItem(4, Icons.menu, 'More'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {String? badge}) {
    final isSelected = _currentIndex == index;
    final accentColor = const Color(0xFF8463E9);
    final textMuted = const Color(0xFF595973);

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: Duration.zero,
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const StudentInsightsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: Duration.zero,
            ),
          );
        } else {
          setState(() => _currentIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isSelected ? accentColor : textMuted,
                size: 24,
              ),
              if (badge != null)
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? accentColor : textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

