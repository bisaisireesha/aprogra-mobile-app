import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_bottom_nav.dart';
import '../auth/menu_screen.dart';
import 'staff_details_popup.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _primary = Color(0xFF7F61EA);
const _cardBorder = Color(0xFFF0F0F0);

class StaffInsightsScreen extends StatefulWidget {
  const StaffInsightsScreen({super.key});

  @override
  State<StaffInsightsScreen> createState() => _StaffInsightsScreenState();
}

class _StaffInsightsScreenState extends State<StaffInsightsScreen> {


  
  @override
  void initState() {
    super.initState();
    _loadStaffdirectory();
  }

  String _activeTab2 = 'All';
  String _searchQuery = '';
  List<String> _selectedDepartments = [];

  List<Map<String, dynamic>> get _filteredStaff {
    return _staffDirectory.where((staff) {
      final matchesStatus = _activeTab2 == 'All' || staff['status'] == _activeTab2;
      
      final matchesSearch = _searchQuery.isEmpty || 
          staff['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          staff['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          staff['role'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
          
      final matchesDept = _selectedDepartments.isEmpty || 
          _selectedDepartments.contains(staff['department']);
          
      return matchesStatus && matchesSearch && matchesDept;
    }).toList();
  }

  List<Map<String, dynamic>> _staffDirectory = [
    {
      'initials': 'SI',
      'initialsColor': const Color(0xFFEF4444),
      'initialsBg': const Color(0xFFFEF2F2),
      'name': 'Suresh Iyer',
      'role': 'Front Desk Executive',
      'id': 'EMP-201',
      'department': 'Reception',
      'departmentIcon': LucideIcons.phone,
      'status': 'Present',
    },
    {
      'initials': 'RM',
      'initialsColor': const Color(0xFF7F61EA),
      'initialsBg': const Color(0xFFF4F1FD),
      'name': 'Rekha Mehta',
      'role': 'Accountant',
      'id': 'EMP-202',
      'department': 'Accounts',
      'departmentIcon': LucideIcons.fileText,
      'status': 'Present',
    },
    {
      'initials': 'AK',
      'initialsColor': const Color(0xFF7F61EA),
      'initialsBg': const Color(0xFFF4F1FD),
      'name': 'Anil Kumar',
      'role': 'Cashier',
      'id': 'EMP-203',
      'department': 'Accounts',
      'departmentIcon': LucideIcons.fileText,
      'status': 'Leave',
    },
    {
      'initials': 'BS',
      'initialsColor': const Color(0xFFF59E0B),
      'initialsBg': const Color(0xFFFFFBEB),
      'name': 'Bharat Singh',
      'role': 'Security Head',
      'id': 'EMP-204',
      'department': 'Security',
      'departmentIcon': LucideIcons.shield,
      'status': 'Present',
    },
    {
      'initials': 'RN',
      'initialsColor': const Color(0xFFF59E0B),
      'initialsBg': const Color(0xFFFFFBEB),
      'name': 'Ramesh Naik',
      'role': 'Security Guard',
      'id': 'EMP-205',
      'department': 'Security',
      'departmentIcon': LucideIcons.shield,
      'status': 'Absent',
    },
    {
      'initials': 'KN',
      'initialsColor': const Color(0xFF7F61EA),
      'initialsBg': const Color(0xFFF4F1FD),
      'name': 'Kishore Naidu',
      'role': 'Transport Manager',
      'id': 'EMP-206',
      'department': 'Transport',
      'departmentIcon': LucideIcons.bus,
      'status': 'Present',
    },
    {
      'initials': 'RK',
      'initialsColor': const Color(0xFF10B981),
      'initialsBg': const Color(0xFFECFDF5),
      'name': 'Ravi Kumar',
      'role': 'Driver',
      'id': 'EMP-207',
      'department': 'Transport',
      'departmentIcon': LucideIcons.bus,
      'status': 'Present',
    },
  ];

  
  Future<void> _loadStaffdirectory() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__staffDirectory_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _staffDirectory = decoded.map((item) {
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

  Future<void> _saveStaffdirectory() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _staffDirectory.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__staffDirectory_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Non Teaching Staff'),
      bottomNavigationBar: const AppBottomNav(),
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
                    const SizedBox(height: 32),
                    _buildMetricsGrid(),
                    const SizedBox(height: 32),
                    _buildFilterTabs(),
                    const SizedBox(height: 32),
                    _buildDirectoryList(),
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
          'Staff Insights',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  void _showAddStaffModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController roleController = TextEditingController();
    final TextEditingController deptController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Add New Staff', style: GoogleFonts.figtree(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: roleController,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: deptController,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
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
                final name = nameController.text.trim();
                final role = roleController.text.trim();
                final dept = deptController.text.trim();
                
                if (name.isNotEmpty && role.isNotEmpty && dept.isNotEmpty) {
                  setState(() {
                    _staffDirectory.add({
                      'initials': name.substring(0, name.length > 1 ? 2 : 1).toUpperCase(),
                      'initialsColor': const Color(0xFF10B981),
                      'initialsBg': const Color(0xFFECFDF5),
                      'name': name,
                      'role': role,
                      'id': 'EMP-${200 + _staffDirectory.length + 1}',
                      'department': dept,
                      'departmentIcon': LucideIcons.user,
                      'status': 'Present',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Save', style: GoogleFonts.figtree(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: LucideIcons.userCheck,
                iconColor: const Color(0xFF10B981),
                iconBg: const Color(0xFFECFDF5),
                title: 'Present Today',
                value: '11',
                subtitle: 'On duty now',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricItem(
                icon: LucideIcons.userMinus,
                iconColor: const Color(0xFFEF4444),
                iconBg: const Color(0xFFFEF2F2),
                title: 'Absent / Leave',
                value: '4',
                subtitle: '2 absent • 2 on leave',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                icon: LucideIcons.briefcase,
                iconColor: const Color(0xFFF59E0B),
                iconBg: const Color(0xFFFFFBEB),
                title: 'Open Positions',
                value: '5',
                subtitle: 'Active hiring',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricItem(
                icon: LucideIcons.users,
                iconColor: const Color(0xFF3B82F6),
                iconBg: const Color(0xFFEFF6FF),
                title: 'Departments',
                value: '8',
                subtitle: 'Total departments',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _textDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.figtree(
              fontSize: 12,
              color: _textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Present'),
                _buildFilterChip('Absent'),
                _buildFilterChip('Leave'),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.search, size: 18, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _searchQuery = value),
                        decoration: InputDecoration(
                          hintText: 'Search staff by name, role or ID...',
                          hintStyle: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF9CA3AF)),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _showDepartmentFilterDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedDepartments.isNotEmpty ? _primary : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _selectedDepartments.isNotEmpty ? _primary : _cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.slidersHorizontal, size: 18, color: _selectedDepartments.isNotEmpty ? Colors.white : _textDark),
                    const SizedBox(width: 8),
                    Text(
                      'Filter',
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _selectedDepartments.isNotEmpty ? Colors.white : _textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDepartmentFilterDialog() {
    List<String> tempSelected = List.from(_selectedDepartments);
    final departments = ['Reception', 'Accounts', 'Security', 'Transport', 'Housekeeping', 'Maintenance', 'Librarian'];
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by Department',
                    style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: departments.map((dept) {
                      final isSelected = tempSelected.contains(dept);
                      return FilterChip(
                        label: Text(dept),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              tempSelected.add(dept);
                            } else {
                              tempSelected.remove(dept);
                            }
                          });
                        },
                        selectedColor: _primary.withValues(alpha: 0.2),
                        checkmarkColor: _primary,
                        labelStyle: GoogleFonts.figtree(
                          color: isSelected ? _primary : _textMuted,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedDepartments.clear();
                            });
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            side: const BorderSide(color: _cardBorder),
                          ),
                          child: Text('Reset', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedDepartments = List.from(tempSelected);
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: _primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Save', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isActive = _activeTab2 == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab2 = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? _primary : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildDirectoryList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3, 
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text('Employee', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted)),
                  ),
                ),
                Expanded(flex: 2, child: Text('Role', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted))),
                Expanded(flex: 2, child: Text('Attendance', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted))),
                Expanded(flex: 1, child: Text('Action', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted))),
              ],
            ),
          ),
          const Divider(height: 1, color: _cardBorder),
          ..._filteredStaff.map((staff) {
            Color statusColor;
            Color statusBg;
            if (staff['status'] == 'Present') {
              statusColor = const Color(0xFF10B981);
              statusBg = const Color(0xFFECFDF5);
            } else if (staff['status'] == 'Absent') {
              statusColor = const Color(0xFFEF4444);
              statusBg = const Color(0xFFFEF2F2);
            } else {
              statusColor = const Color(0xFFF59E0B);
              statusBg = const Color(0xFFFFFBEB);
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: staff['initialsBg'],
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  staff['initials'],
                                  style: GoogleFonts.figtree(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: staff['initialsColor'],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      staff['name'],
                                      style: GoogleFonts.figtree(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      staff['id'],
                                      style: GoogleFonts.figtree(
                                        fontSize: 12,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          staff['role'],
                          style: GoogleFonts.figtree(
                            fontSize: 13,
                            color: _textDark,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  staff['status'],
                                  style: GoogleFonts.figtree(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => StaffDetailsPopup(
                                staff: staff,
                                onUpdate: (updatedStaff) {
                                  setState(() {
                                    final index = _staffDirectory.indexWhere((s) => s['id'] == updatedStaff['id']);
                                    if (index != -1) {
                                      _staffDirectory[index] = updatedStaff;
                                    }
                                  });
                                },
                              ),
                            );
                          },
                          child: Text(
                            'View',
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (staff != _filteredStaff.last)
                  const Divider(height: 1, color: _cardBorder),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primary,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(LucideIcons.users)),
            label: 'Directory',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(LucideIcons.calendar)),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(LucideIcons.building)),
            label: 'Departments',
          ),
          BottomNavigationBarItem(
            icon: Padding(padding: EdgeInsets.only(bottom: 4), child: Icon(LucideIcons.user)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
