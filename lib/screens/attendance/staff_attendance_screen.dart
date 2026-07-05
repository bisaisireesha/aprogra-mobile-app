import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/mock_data/staff_attendance_mock.dart';
import '../auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StaffAttendanceScreen extends StatefulWidget {
  const StaffAttendanceScreen({super.key});

  @override
  State<StaffAttendanceScreen> createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  int _bottomNavIndex = 1;
  final TextEditingController _searchController = TextEditingController();

  DateTime _selectedDate = DateTime(2026, 6, 27);
  String _selectedDepartment = 'All Departments';
  String _selectedRole = 'All Roles';
  String _selectedShift = 'All Shifts';
  String _selectedStatus = 'All Status';
  bool _isLocked = false;

  List<Map<String, dynamic>> _roster = [];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void initState() {
    super.initState();
    _loadRoster();
    _roster = StaffAttendanceMockData.attendanceRoster
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredRoster {
    final query = _searchController.text.toLowerCase();
    return _roster.where((item) {
      final matchesQuery =
          query.isEmpty ||
          (item['name'] as String).toLowerCase().contains(query) ||
          (item['empId'] as String).toLowerCase().contains(query) ||
          (item['department'] as String).toLowerCase().contains(query) ||
          (item['role'] as String).toLowerCase().contains(query);

      final matchesDepartment =
          _selectedDepartment == 'All Departments' ||
          item['department'] == _selectedDepartment;
      final matchesRole =
          _selectedRole == 'All Roles' || item['role'] == _selectedRole;
      final matchesShift =
          _selectedShift == 'All Shifts' || item['shift'] == _selectedShift;
      final matchesStatus =
          _selectedStatus == 'All Status' || item['status'] == _selectedStatus;

      return matchesQuery &&
          matchesDepartment &&
          matchesRole &&
          matchesShift &&
          matchesStatus;
    }).toList();
  }

  void _handleMark(Map<String, dynamic> item, String status) {
    setState(() {
      item['status'] = status;
    });
  }

  String _monthString(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _loadRoster() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__roster_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _roster = decoded.map((item) {
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

  Future<void> _saveRoster() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _roster.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__roster_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Staff Attendance'),
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
                            SizedBox(height: 12.h),
                            _buildTopControls(),
                          ],
                          const SizedBox(height: 24),
                          _buildStatsRow(),
                          const SizedBox(height: 24),
                          _buildHourlyCheckInChart(),
                          const SizedBox(height: 24),
                          _buildSearchAndFilters(),
                          const SizedBox(height: 24),
                          _buildRosterList(),
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
      floatingActionButton: !_isTablet
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attendance saved successfully!'),
                  ),
                );
              },
              backgroundColor: _accent,
              icon: const Icon(LucideIcons.save, color: Colors.white, size: 20),
              label: Text(
                'Save',
                style: GoogleFonts.figtree(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : null,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
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
              'Attendance',
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
          'Staff Attendance',
          style: GoogleFonts.figtree(
            fontSize: _isTablet ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Today's check-in/out log for all staff — present, absent, on leave, and late arrivals.",
          style: GoogleFonts.figtree(
            fontSize: _isTablet ? 16 : 14,
            color: _textMuted,
          ),
        ),
        const SizedBox.shrink(),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.download, size: 16, color: _textDark),
              const SizedBox(width: 8),
              Text(
                'Export',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
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
              const Icon(LucideIcons.save, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Save',
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

  Widget _buildSearchAndFilters() {
    if (_isTablet) {
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by name or department...',
                  hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF8F96A3),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(flex: 1, child: const SizedBox()),
          Expanded(flex: 1, child: const SizedBox()),
          _buildTabletDropdown(
            value: _selectedDepartment,
            items: const [
              'All Departments',
              'Administration',
              'Pre-Primary',
              'Languages',
              'Mathematics',
              'Sciences',
              'Social Studies',
              'Computer Science',
              'Arts',
              'Physical Education',
              'Accounts',
              'Library',
              'Transport',
              'Security',
              'Maintenance',
            ],
            onChanged: (v) => setState(() => _selectedDepartment = v!),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name or department...',
                hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF8F96A3),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDepartment,
                    icon: const Icon(
                      LucideIcons.chevronDown,
                      size: 16,
                      color: _textMuted,
                    ),
                    items:
                        const [
                              'All Departments',
                              'Administration',
                              'Pre-Primary',
                              'Languages',
                              'Mathematics',
                              'Sciences',
                              'Social Studies',
                              'Computer Science',
                              'Arts',
                              'Physical Education',
                              'Accounts',
                              'Library',
                              'Transport',
                              'Security',
                              'Maintenance',
                            ]
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                  style: GoogleFonts.figtree(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: _textDark,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _selectedDepartment = v!),
                  ),
                ),
              ),
              Text(
                '${_filteredRoster.length} records',
                style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildTabletDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.white,
            icon: const Icon(
              LucideIcons.chevronDown,
              size: 16,
              color: _textMuted,
            ),
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _textDark,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildRealDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(
            LucideIcons.chevronDown,
            size: 16,
            color: _textMuted,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textDark,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    int total = _filteredRoster.length;
    int present = _filteredRoster.where((r) => r['status'] == 'Present').length;
    int absent = _filteredRoster.where((r) => r['status'] == 'Absent').length;
    int late = _filteredRoster.where((r) => r['status'] == 'Late').length;
    int onLeave = _filteredRoster
        .where((r) => r['status'] == 'On Leave')
        .length;

    double presentPct = total > 0 ? (present / total) * 100 : 0;
    double absentPct = total > 0 ? (absent / total) * 100 : 0;
    double leavePct = total > 0 ? (onLeave / total) * 100 : 0;

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
              '$present',
              'Present',
              '${presentPct.toStringAsFixed(1)}% of total',
              LucideIcons.userCheck,
              const Color(0xFF22C55E),
              const Color(0xFFDCFCE7),
            ),
            _buildKpiCard(
              '$absent',
              'Absent',
              '${absentPct.toStringAsFixed(1)}% of total',
              LucideIcons.userX,
              const Color(0xFFEF4444),
              const Color(0xFFFEE2E2),
            ),
            _buildKpiCard(
              '$onLeave',
              'On Leave',
              '${leavePct.toStringAsFixed(1)}% of total',
              LucideIcons.calendarOff,
              const Color(0xFFF59E0B),
              const Color(0xFFFEF3C7),
            ),
            _buildKpiCard(
              '$late',
              'Late Arrivals',
              'After 9:15 AM',
              LucideIcons.clock,
              const Color(0xFF0EA5E9),
              const Color(0xFFE0F2FE),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(
    String value,
    String title,
    String subtitle,
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
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.figtree(
              fontSize: 13,
              color: const Color(0xFF8F96A3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyCheckInChart() {
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
            'Hourly Check-in Pattern',
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Number of staff checking in per hour',
            style: GoogleFonts.figtree(
              fontSize: 13,
              color: const Color(0xFF8F96A3),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 80,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Color(0xFF8F96A3),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('7AM', style: style);
                            break;
                          case 1:
                            text = const Text('8AM', style: style);
                            break;
                          case 2:
                            text = const Text('8:30', style: style);
                            break;
                          case 3:
                            text = const Text('9AM', style: style);
                            break;
                          case 4:
                            text = const Text('9:30', style: style);
                            break;
                          case 5:
                            text = const Text('10AM', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: text,
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 20 != 0) return const SizedBox.shrink();
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: Color(0xFF8F96A3),
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildHourlyBar(0, 18),
                  _buildHourlyBar(1, 48),
                  _buildHourlyBar(2, 72),
                  _buildHourlyBar(3, 60),
                  _buildHourlyBar(4, 25),
                  _buildHourlyBar(5, 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F1FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.barChart2,
                    color: Color(0xFF8463E9),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peak Time',
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '8:30 AM - 72 Check-ins',
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          color: const Color(0xFF8F96A3),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 20,
                  color: Color(0xFF8F96A3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildHourlyBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF8463E9),
          width: 24,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  Widget _buildRosterList() {
    return Container(
      decoration: BoxDecoration(
        color: _isTablet ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: _isTablet ? Border.all(color: const Color(0xFFE5E7EB)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isTablet)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Roster · ${_filteredRoster.length} of ${_filteredRoster.length}',
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                  ),
                  Text(
                    _isLocked ? 'Locked mode' : 'Editing mode',
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      color: _isLocked ? const Color(0xFFEF4444) : _textMuted,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                "Today's Attendance Log (${_filteredRoster.length})",
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ),
          if (_filteredRoster.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No staff found.',
                style: GoogleFonts.figtree(fontSize: 16, color: _textMuted),
              ),
            ),
          if (_filteredRoster.isNotEmpty && _isTablet) _buildTableHeader(),
          if (_isTablet)
            ..._filteredRoster.map(_buildDesktopRow)
          else
            ..._filteredRoster.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value;
              return Column(
                children: [
                  _buildMobileCard(item),
                  if (idx != _filteredRoster.length - 1)
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                ],
              );
            }),
        ],
      ),
    );
  }

  void _showStaffDetails(Map<String, dynamic> staff) {
    String initials = staff['name']
        .toString()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();
    final colors = [
      (const Color(0xFFEBEBFF), const Color(0xFF6366F1)),
      (const Color(0xFFE0F2FE), const Color(0xFF0EA5E9)),
      (const Color(0xFFDCFCE7), const Color(0xFF22C55E)),
      (const Color(0xFFFEF3C7), const Color(0xFFF59E0B)),
      (const Color(0xFFFEE2E2), const Color(0xFFEF4444)),
      (const Color(0xFFF3E8FF), const Color(0xFF9333EA)),
    ];
    int hash = staff['name'].toString().codeUnits.fold(0, (a, b) => a + b);
    final avatarBg = colors[hash % colors.length].$1;
    final avatarFg = colors[hash % colors.length].$2;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: avatarBg,
                  child: Text(
                    initials,
                    style: GoogleFonts.figtree(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: avatarFg,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff['name'],
                        style: GoogleFonts.figtree(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        staff['role'] ?? staff['department'] ?? '',
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(staff['status']),
              ],
            ),
            const SizedBox(height: 24),
            // Details container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Employee ID', staff['empId'] ?? '—'),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildDetailRow('Department', staff['department'] ?? '—'),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildDetailRow('Role', staff['role'] ?? '—'),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildDetailRow('Shift', staff['shift'] ?? '—'),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildDetailRow('Check-In', staff['checkIn'] ?? '—'),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildDetailRow('Check-Out', staff['checkOut'] ?? '—'),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildDetailRow('Status', staff['status'] ?? '—'),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8463E9),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.figtree(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
          ),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCard(Map<String, dynamic> item) {
    String initials = item['name']
        .toString()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join();
    if (initials.length > 2 && item['name'].toString().startsWith('Dr. '))
      initials = item['name']
          .toString()
          .substring(4)
          .split(' ')
          .map((e) => e[0])
          .take(2)
          .join();
    if (initials.length > 2 && item['name'].toString().startsWith('Mr. '))
      initials = item['name']
          .toString()
          .substring(4)
          .split(' ')
          .map((e) => e[0])
          .take(2)
          .join();
    if (initials.length > 2 && item['name'].toString().startsWith('Ms. '))
      initials = item['name']
          .toString()
          .substring(4)
          .split(' ')
          .map((e) => e[0])
          .take(2)
          .join();
    if (initials.length > 2 && item['name'].toString().startsWith('Mrs. '))
      initials = item['name']
          .toString()
          .substring(5)
          .split(' ')
          .map((e) => e[0])
          .take(2)
          .join();

    final colors = [
      (const Color(0xFFEBEBFF), const Color(0xFF6366F1)),
      (const Color(0xFFE0F2FE), const Color(0xFF0EA5E9)),
      (const Color(0xFFDCFCE7), const Color(0xFF22C55E)),
      (const Color(0xFFFEF3C7), const Color(0xFFF59E0B)),
      (const Color(0xFFFEE2E2), const Color(0xFFEF4444)),
      (const Color(0xFFF3E8FF), const Color(0xFF9333EA)),
    ];
    int hash = item['name'].toString().codeUnits.fold(0, (a, b) => a + b);
    final avatarBg = colors[hash % colors.length].$1;
    final avatarFg = colors[hash % colors.length].$2;

    return GestureDetector(
      onTap: () => _showStaffDetails(item),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: avatarBg,
              child: Text(
                initials,
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: avatarFg,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: GoogleFonts.figtree(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['department'],
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            color: _textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['checkIn'] ?? '—',
                          style: GoogleFonts.figtree(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '— ${item['checkOut'] ?? '—'}',
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusBadge(item['status']),
                      const SizedBox(height: 24),
                      Text(
                        '7h 53m',
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopRow(Map<String, dynamic> item) {
    final isLast = item == _filteredRoster.last;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              item['empId'],
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['name'],
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['department'],
              style: GoogleFonts.figtree(fontSize: 13, color: _textDark),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['role'],
              style: GoogleFonts.figtree(fontSize: 13, color: _textDark),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item['shift'],
              style: GoogleFonts.figtree(fontSize: 13, color: _textDark),
            ),
          ),
          Expanded(flex: 1, child: _buildStatusBadge(item['status'])),
          Expanded(
            flex: 1,
            child: Text(
              item['checkIn'] ?? '—',
              style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item['checkOut'] ?? '—',
              style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
            ),
          ),
          Expanded(flex: 2, child: _buildMarkControls(item)),
          Expanded(flex: 2, child: _buildRemarksField(item)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text('Employee ID', style: _headerStyle()),
          ),
          Expanded(flex: 2, child: Text('Staff Name', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Department', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Role', style: _headerStyle())),
          Expanded(flex: 1, child: Text('Shift', style: _headerStyle())),
          Expanded(flex: 1, child: Text('Status', style: _headerStyle())),
          Expanded(flex: 1, child: Text('Check-in', style: _headerStyle())),
          Expanded(flex: 1, child: Text('Check-out', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Mark', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Remarks', style: _headerStyle())),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF8F96A3),
  );

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;
    if (status == 'Present') {
      color = const Color(0xFF22C55E);
      bgColor = const Color(0xFFDCFCE7);
    } else if (status == 'Absent') {
      color = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEE2E2);
    } else if (status == 'Late') {
      color = const Color(0xFF0EA5E9);
      bgColor = const Color(0xFFE0F2FE);
    } else {
      color = const Color(0xFFF59E0B);
      bgColor = const Color(0xFFFEF3C7);
    } // On Leave

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: GoogleFonts.figtree(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMarkControls(Map<String, dynamic> item) {
    final status = item['status'];
    return Opacity(
      opacity: _isLocked ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMarkBtn(
              'P',
              status == 'Present',
              const Color(0xFF22C55E),
              () {
                if (!_isLocked) _handleMark(item, 'Present');
              },
            ),
            Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
            _buildMarkBtn('L', status == 'Late', const Color(0xFFF59E0B), () {
              if (!_isLocked) _handleMark(item, 'Late');
            }),
            Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
            _buildMarkBtn(
              'Lv',
              status == 'On Leave',
              const Color(0xFF3B82F6),
              () {
                if (!_isLocked) _handleMark(item, 'On Leave');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkBtn(
    String label,
    bool isSelected,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildRemarksField(Map<String, dynamic> item) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        enabled: !_isLocked,
        controller: TextEditingController(text: item['remarks']),
        onChanged: (val) => item['remarks'] = val,
        decoration: const InputDecoration(
          hintText: 'Add note...',
          hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
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
        onTap: (i) => setState(() => _bottomNavIndex = i),
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
}
