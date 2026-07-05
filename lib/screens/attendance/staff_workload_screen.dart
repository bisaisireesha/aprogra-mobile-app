import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StaffWorkloadScreen extends StatefulWidget {
  const StaffWorkloadScreen({super.key});

  @override
  State<StaffWorkloadScreen> createState() => _StaffWorkloadScreenState();
}

class _StaffWorkloadScreenState extends State<StaffWorkloadScreen> {
  @override
  void initState() {
    super.initState();
    _loadWorkloads();
  }

  int _bottomNavIndex = 3; // 'Staff' is index 3
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _workloads = [
    {
      'name': 'Priya Sharma',
      'initials': 'PS',
      'department': 'Mathematics',
      'subjects': ['Algebra', 'Calculus'],
      'classes': '9A,9B,10A',
      'periods': 32,
      'utilization': 1.07,
      'status': 'Overloaded',
    },
    {
      'name': 'Rajan Pillai',
      'initials': 'RP',
      'department': 'Science',
      'subjects': ['Physics', 'Lab'],
      'classes': '8A,8B',
      'periods': 28,
      'utilization': 0.93,
      'status': 'Overloaded',
    },
    {
      'name': 'Meena Krishnamurthy',
      'initials': 'MK',
      'department': 'English',
      'subjects': ['Lit', 'Grammar'],
      'classes': '6A,6B,7A',
      'periods': 24,
      'utilization': 0.80,
      'status': 'Balanced',
    },
    {
      'name': 'Suresh Kumar',
      'initials': 'SK',
      'department': 'Social Studies',
      'subjects': ['History', 'Civics'],
      'classes': '7B,8C',
      'periods': 20,
      'utilization': 0.67,
      'status': 'Balanced',
    },
    {
      'name': 'Anita Desai',
      'initials': 'AD',
      'department': 'Hindi',
      'subjects': ['Hindi'],
      'classes': '5A,5B,6C',
      'periods': 18,
      'utilization': 0.60,
      'status': 'Under',
    },
  ];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkloads() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__workloads_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _workloads = decoded.map((item) {
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

  Future<void> _saveWorkloads() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _workloads.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__workloads_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Workload'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        _isTablet ? 40 : 16,
                        24,
                        _isTablet ? 40 : 16,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildHeader()),
                              if (_isTablet) _buildTopControls(),
                            ],
                          ),
                          if (!_isTablet) ...[
                            const SizedBox(height: 16),
                            _buildTopControls(),
                          ],
                          const SizedBox(height: 24),
                          _buildStatsRow(),
                          const SizedBox(height: 32),
                          if (_isTablet)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSearchAndFilterRow(),
                                      const SizedBox(height: 24),
                                      _buildWorkloadList(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [_buildMostLoadedTeachersCard()],
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMostLoadedTeachersCard(),
                                const SizedBox(height: 32),
                                _buildSearchAndFilterRow(),
                                const SizedBox(height: 24),
                                _buildWorkloadList(),
                              ],
                            ),
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
      bottomNavigationBar: const AppBottomNav(),
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
                icon: const Icon(LucideIcons.menu, color: _textDark),
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
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: Color(0xFF8F96A3),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFF8F96A3),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF8F96A3),
              size: 24,
            ),
            const SizedBox(width: 16),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF4F1FF),
              child: Text(
                'A',
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _accent,
                ),
              ),
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
            Text(
              'Home',
              style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
            ),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text(
              'Staff',
              style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
            ),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text(
              'Workload',
              style: GoogleFonts.figtree(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Teacher Workload',
          style: GoogleFonts.figtree(
            fontSize: _isTablet ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Monitor teaching hours, subject distribution, and identify overloaded staff.",
          style: GoogleFonts.figtree(
            fontSize: _isTablet ? 16 : 14,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.bookOpen, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Assign Workload',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: _isTablet ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: _isTablet ? 1.4 : 1.05,
          children: [
            _buildKpiCard(
              '48',
              'Total Teachers',
              LucideIcons.users,
              const Color(0xFF8463E9),
              const Color(0xFFF4F1FF),
            ),
            _buildKpiCard(
              '24',
              'Avg Periods / Week',
              LucideIcons.bookOpen,
              const Color(0xFF0EA5E9),
              const Color(0xFFE0F2FE),
            ),
            _buildKpiCard(
              '6',
              'Overloaded Teachers',
              LucideIcons.alertTriangle,
              const Color(0xFFEF4444),
              const Color(0xFFFEE2E2),
            ),
            _buildKpiCard(
              '5',
              'Under-utilized',
              LucideIcons.trendingDown,
              const Color(0xFFF59E0B),
              const Color(0xFFFEF3C7),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(
    String value,
    String title,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
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
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: _textDark,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: const TextField(
            decoration: InputDecoration(
              icon: Icon(
                LucideIcons.search,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
              hintText: 'Search teacher or department...',
              hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'All Departments',
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      color: _textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.chevronDown,
                    size: 16,
                    color: _textDark,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: const Icon(
                LucideIcons.arrowDownUp,
                size: 16,
                color: _textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWorkloadList() {
    return Column(
      children: _workloads
          .map((workload) => _buildWorkloadCard(workload))
          .toList(),
    );
  }

  Widget _buildWorkloadCard(Map<String, dynamic> workload) {
    Color progressColor;
    if (workload['utilization'] >= 0.9) {
      progressColor = const Color(0xFFEF4444);
    } else if (workload['utilization'] >= 0.8) {
      progressColor = const Color(0xFF8463E9);
    } else {
      progressColor = const Color(0xFF10B981);
    }

    Color statusColor;
    Color statusBgColor;
    if (workload['status'] == 'Overloaded') {
      statusColor = const Color(0xFFEF4444);
      statusBgColor = const Color(0xFFFEE2E2);
    } else if (workload['status'] == 'Balanced') {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFD1FAE5);
    } else {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
    }

    Color avatarBgColor;
    Color avatarTextColor;
    if (workload['name'] == 'Priya Sharma') {
      avatarBgColor = const Color(0xFFFEE2E2);
      avatarTextColor = const Color(0xFFEF4444);
    } else if (workload['name'] == 'Rajan Pillai') {
      avatarBgColor = const Color(0xFFE0F2FE);
      avatarTextColor = const Color(0xFF0284C7);
    } else if (workload['name'] == 'Meena Krishnamurthy') {
      avatarBgColor = const Color(0xFFF4F1FF);
      avatarTextColor = const Color(0xFF8463E9);
    } else if (workload['name'] == 'Suresh Kumar') {
      avatarBgColor = const Color(0xFFDCFCE7);
      avatarTextColor = const Color(0xFF16A34A);
    } else {
      avatarBgColor = const Color(0xFFFEF3C7);
      avatarTextColor = const Color(0xFFF59E0B);
    }

    return GestureDetector(
      onTap: () => _showWorkloadDetails(
        context,
        workload,
        progressColor,
        statusColor,
        statusBgColor,
        avatarBgColor,
        avatarTextColor,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarBgColor,
              child: Text(
                workload['initials'],
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: avatarTextColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        workload['name'],
                        style: GoogleFonts.figtree(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(workload['utilization'] * 100).toInt()}%',
                            style: GoogleFonts.figtree(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: progressColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 48,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: (workload['utilization'] > 1.0)
                                    ? 1.0
                                    : workload['utilization'],
                                backgroundColor: const Color(0xFFF3F4F6),
                                color: progressColor,
                                minHeight: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    workload['department'],
                    style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (workload['subjects'] as List<String>)
                        .map(
                          (subject) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              subject,
                              style: GoogleFonts.figtree(
                                fontSize: 12,
                                color: const Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Classes',
                            style: GoogleFonts.figtree(
                              fontSize: 11,
                              color: _textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            workload['classes'],
                            style: GoogleFonts.figtree(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Periods/Wk',
                            style: GoogleFonts.figtree(
                              fontSize: 11,
                              color: _textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${workload['periods']}',
                            style: GoogleFonts.figtree(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          workload['status'],
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkloadDetails(
    BuildContext context,
    Map<String, dynamic> workload,
    Color progressColor,
    Color statusColor,
    Color statusBgColor,
    Color avatarBgColor,
    Color avatarTextColor,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 380,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Avatar + Name + Department + Status badge + Close
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: avatarBgColor,
                      child: Text(
                        workload['initials'],
                        style: GoogleFonts.figtree(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: avatarTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workload['name'],
                            style: GoogleFonts.figtree(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _textDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            workload['department'],
                            style: GoogleFonts.figtree(
                              fontSize: 13,
                              color: _textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        workload['status'],
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Detail Rows
                _buildWorkloadPopupRow(
                  'Department',
                  Text(
                    workload['department'],
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildWorkloadPopupRow(
                  'Subjects',
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.end,
                    children: (workload['subjects'] as List<String>)
                        .map(
                          (subject) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F6F8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              subject,
                              style: GoogleFonts.figtree(
                                fontSize: 12,
                                color: const Color(0xFF4B5563),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildWorkloadPopupRow(
                  'Classes',
                  Text(
                    workload['classes'],
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildWorkloadPopupRow(
                  'Periods / Week',
                  Text(
                    '${workload['periods']}',
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildWorkloadPopupRow(
                  'Load %',
                  Text(
                    '${(workload['utilization'] * 100).toInt()}%',
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildWorkloadPopupRow(
                  'Status',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (workload['utilization'] > 1.0)
                                ? 1.0
                                : workload['utilization'],
                            backgroundColor: const Color(0xFFF3F4F6),
                            color: progressColor,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          workload['status'],
                          style: GoogleFonts.figtree(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  alignTop: true,
                ),
                const SizedBox(height: 24),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Center(
                            child: Text(
                              'View Profile',
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _accent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Adjust Workload',
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkloadPopupRow(
    String label,
    Widget valueWidget, {
    bool alignTop = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: alignTop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Align(alignment: Alignment.centerRight, child: valueWidget),
        ),
      ],
    );
  }

  Widget _buildMostLoadedTeachersCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Most Loaded Teachers',
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Top 5 by load %',
            style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
          ),
          const SizedBox(height: 24),
          _buildMostLoadedTeacherItem('Sanjay Verma', 'Physics', 1.13),
          const SizedBox(height: 16),
          _buildMostLoadedTeacherItem('Priya Sharma', 'Mathematics', 1.07),
          const SizedBox(height: 16),
          _buildMostLoadedTeacherItem('Vikram Nair', 'Mathematics', 1.00),
          const SizedBox(height: 16),
          _buildMostLoadedTeacherItem('Rajan Pillai', 'Science', 0.93),
          const SizedBox(height: 16),
          _buildMostLoadedTeacherItem('Kavita Mehta', 'Chemistry', 0.90),
        ],
      ),
    );
  }

  Widget _buildMostLoadedTeacherItem(
    String name,
    String department,
    double utilization,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  department,
                  style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
                ),
              ],
            ),
            Text(
              '${(utilization * 100).toInt()}%',
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF43F5E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (utilization > 1.0) ? 1.0 : utilization,
            backgroundColor: const Color(0xFFF3F4F6),
            color: const Color(0xFFF43F5E),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
