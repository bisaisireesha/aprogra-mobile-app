import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../auth/menu_screen.dart';

const _bgPrimary = Color(0xFFF9FAFB);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  int _bottomNavIndex = 3; // Staff
  final TextEditingController _searchController = TextEditingController();

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Staff Overview'),
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
                          _buildQuickActions(),
                          const SizedBox(height: 32),
                          if (_isTablet)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: _buildAttendanceChart()),
                                          const SizedBox(width: 16),
                                          Expanded(child: _buildDepartmentChart()),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: _buildWorkloadOverview()),
                                          const SizedBox(width: 16),
                                          Expanded(child: _buildLeaveSummary()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 1,
                                  child: _buildPrincipalInsights(),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _buildPrincipalInsights(),
                                const SizedBox(height: 24),
                                _buildAttendanceChart(),
                                const SizedBox(height: 24),
                                _buildDepartmentChart(),
                                const SizedBox(height: 24),
                                _buildWorkloadOverview(),
                                const SizedBox(height: 24),
                                _buildLeaveSummary(),
                              ],
                            ),
                          const SizedBox(height: 32),
                          _buildStaffDirectory(),
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

    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Staff Management',
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

  Widget _buildDropdownButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _accent),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(width: 4),
          const Icon(LucideIcons.chevronDown, size: 16, color: _textMuted),
        ],
      ),
    );
  }

  Widget _buildKpis() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: _isTablet ? 2.8 : 1.2,
      children: [
        _buildKpiCard(
          title: 'TOTAL STAFF',
          value: '248',
          trendIcon: Icons.arrow_drop_up,
          trendText: '12 (+5.1%)',
          trendColor: Colors.green,
          subtitle: 'teaching + non-teaching',
          icon: LucideIcons.users,
          iconBg: const Color(0xFFF4F1FF),
          iconColor: _accent,
        ),
        _buildKpiCard(
          title: 'PRESENT TODAY',
          value: '219',
          trendIcon: Icons.arrow_drop_up,
          trendText: '92.4% attendance',
          trendColor: Colors.green,
          subtitle: 'as of 09:30 AM',
          icon: LucideIcons.userCheck,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF22C55E),
        ),
        _buildKpiCard(
          title: 'ON LEAVE',
          value: '17',
          trendIcon: Icons.arrow_drop_down,
          trendText: '6 pending approval',
          trendColor: Colors.red,
          subtitle: '11 approved · 6 pending',
          icon: LucideIcons.calendarOff,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFF59E0B),
        ),
        _buildKpiCard(
          title: 'PENDING ACTIONS',
          value: '23',
          trendIcon: Icons.arrow_drop_down,
          trendText: '9 documents · 8 leaves',
          trendColor: Colors.red,
          subtitle: 'needs review',
          icon: LucideIcons.alertCircle,
          iconBg: const Color(0xFFFEE2E2),
          iconColor: const Color(0xFFEF4444),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required IconData trendIcon,
    required String trendText,
    required Color trendColor,
    required String subtitle,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
            ],
          ),
          Text(value, style: GoogleFonts.figtree(fontSize: 32, fontWeight: FontWeight.w900, color: _textDark)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(trendIcon, size: 16, color: trendColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  trendText,
                  style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: trendColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            subtitle,
            style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'title': 'Add Staff', 'icon': Icons.add, 'color': _accent, 'bg': const Color(0xFFF4F1FF)},
      {'title': 'Mark\nAttendance', 'icon': LucideIcons.clipboardCheck, 'color': const Color(0xFF22C55E), 'bg': const Color(0xFFDCFCE7)},
      {'title': 'Assign\nDepartment', 'icon': LucideIcons.building, 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFDBEAFE)},
      {'title': 'Approve\nLeave', 'icon': LucideIcons.calendarClock, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7)},
      {'title': 'Upload\nDocuments', 'icon': LucideIcons.filePlus, 'color': _accent, 'bg': const Color(0xFFF4F1FF)},
      {'title': 'Download\nReport', 'icon': LucideIcons.downloadCloud, 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFDBEAFE)},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: _isTablet ? 6 : 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: _isTablet ? 0.8 : 0.65,
          children: actions.map((action) => _buildQuickActionCard(
            title: action['title'] as String,
            icon: action['icon'] as IconData,
            color: action['color'] as Color,
            bgColor: action['bg'] as Color,
          )).toList(),
        );
      },
    );
  }

  Widget _buildQuickActionCard({required String title, required IconData icon, required Color color, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark, height: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrincipalInsights() {
    final insights = [
      {'title': 'Shortage: Sciences', 'subtitle': 'Needs 2 more teachers', 'icon': LucideIcons.building2, 'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEE2E2)},
      {'title': '12 absent today', 'subtitle': 'Across 5 departments', 'icon': LucideIcons.userMinus, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7)},
      {'title': '6 leave approvals', 'subtitle': 'Awaiting your review', 'icon': LucideIcons.calendarCheck, 'color': _accent, 'bg': const Color(0xFFF4F1FF)},
      {'title': '4 teachers overloaded', 'subtitle': '>32 periods this week', 'icon': LucideIcons.listTodo, 'color': const Color(0xFF0EA5E9), 'bg': const Color(0xFFE0F2FE)},
      {'title': '9 documents pending', 'subtitle': 'Verification required', 'icon': LucideIcons.fileText, 'color': _accent, 'bg': const Color(0xFFF4F1FF)},
      {'title': '3 contract renewals', 'subtitle': 'Due within 30 days', 'icon': LucideIcons.calendarClock, 'color': const Color(0xFF22C55E), 'bg': const Color(0xFFDCFCE7)},
    ];

    final quickActions = [
      {'title': 'Approve Leave', 'icon': LucideIcons.calendarClock},
      {'title': 'Send Message', 'icon': LucideIcons.mail},
      {'title': 'View Profile', 'icon': LucideIcons.eye},
      {'title': 'Assign Dept', 'icon': LucideIcons.clipboardList},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Principal Insights', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
              _buildDropdownButton('Today', LucideIcons.calendar),
            ],
          ),
          const SizedBox(height: 4),
          Text('Action-required signals across staff', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 24),
          ...insights.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: item['bg'] as Color, borderRadius: BorderRadius.circular(10)),
                    child: Icon(item['icon'] as IconData, size: 20, color: item['color'] as Color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] as String, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(height: 4),
                        Text(item['subtitle'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                      ],
                    ),
                  ),
                  const Icon(LucideIcons.arrowUpRight, size: 18, color: _textMuted),
                ],
              ),
            ),
          )),
          SizedBox(height: 12.h),
          Text('QUICK ACTIONS', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: quickActions.map((action) => OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(action['icon'] as IconData, size: 14, color: _accent),
              label: Text(action['title'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                side: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Container(
      height: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Staff Attendance Trend', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
              Row(
                children: [
                  _buildLegendIndicator(const Color(0xFF22C55E), 'Present'),
                  const SizedBox(width: 12),
                  _buildLegendIndicator(const Color(0xFFEF4444), 'Absent'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Present vs Absent · last 6 weeks', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 32),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 240,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => Colors.white,
                        tooltipPadding: const EdgeInsets.all(12),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            'Wk ${group.x.toInt()}\n',
                            GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Present : ${group.barRods[0].toY.toInt()}\n',
                                style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF22C55E)),
                              ),
                              TextSpan(
                                text: 'Absent : ${group.barRods[1].toY.toInt()}',
                                style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444)),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Wk ${value.toInt()}', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                            );
                          },
                          reservedSize: 28,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value % 60 != 0) return const SizedBox.shrink();
                            return Text('${value.toInt()}', style: GoogleFonts.figtree(fontSize: 11, color: _textMuted));
                          },
                          reservedSize: 32,
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 60,
                      getDrawingHorizontalLine: (value) => FlLine(color: const Color(0xFFF3F4F6), strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _buildBarGroup(1, 230, 20),
                      _buildBarGroup(2, 232, 18),
                      _buildBarGroup(3, 225, 25),
                      _buildBarGroup(4, 238, 12),
                      _buildBarGroup(5, 230, 20),
                      _buildBarGroup(6, 240, 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double present, double absent) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: present, color: const Color(0xFF10B981), width: 24, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
        BarChartRodData(toY: absent, color: const Color(0xFFEF4444), width: 24, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      ],
    );
  }

  Widget _buildLegendIndicator(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
      ],
    );
  }

  Widget _buildDepartmentChart() {
    final depts = [
      {'name': 'Teaching', 'value': 132.0, 'color': _accent},
      {'name': 'Admin', 'value': 28.0, 'color': const Color(0xFF3B82F6)},
      {'name': 'Transport', 'value': 22.0, 'color': const Color(0xFF22C55E)},
      {'name': 'Security', 'value': 18.0, 'color': const Color(0xFFF59E0B)},
      {'name': 'Accounts', 'value': 12.0, 'color': const Color(0xFFEF4444)},
      {'name': 'Library', 'value': 8.0, 'color': const Color(0xFF0EA5E9)},
      {'name': 'Housekeeping', 'value': 28.0, 'color': const Color(0xFF8B5CF6)},
    ];

    return Container(
      height: 340,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Department-wise Staff', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF4F1FF), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(LucideIcons.users, size: 14, color: _accent),
                    const SizedBox(width: 4),
                    Text('248 total', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Distribution across all departments', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 32),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: depts.map((d) => PieChartSectionData(
                            color: d['color'] as Color,
                            value: d['value'] as double,
                            title: '',
                            radius: 24,
                          )).toList(),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('STAFF', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                          Text('248', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.w900, color: _textDark)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: depts.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(width: 8, height: 8, decoration: BoxDecoration(color: d['color'] as Color, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Text(d['name'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                              ],
                            ),
                            Text('${(d['value'] as double).toInt()}', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkloadOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Workload Overview', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(LucideIcons.slidersHorizontal, size: 12, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text('4 overloaded', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFF59E0B))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Teaching assignment & period load', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 24),
          _buildWorkloadRow('Class Teachers', 42, 48, '42', ' / 48'),
          SizedBox(height: 12.h),
          _buildWorkloadRow('Subject Teachers', 96, 132, '96', ' / 132'),
          SizedBox(height: 12.h),
          _buildWorkloadRow('Periods Assigned', 1820, 2160, '1,820', ' / 2,160'),
          SizedBox(height: 12.h),
          _buildWorkloadRow('Free Periods', 340, 2160, '340', ' / 2,160'),
        ],
      ),
    );
  }

  Widget _buildWorkloadRow(String title, double current, double max, String currentText, String maxText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
            Row(
              children: [
                Text(currentText, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                Text(maxText, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: current / max,
            child: Container(
              decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Leave Summary', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
              _buildDropdownButton('This Month', LucideIcons.calendar),
            ],
          ),
          const SizedBox(height: 4),
          Text('Approved, pending, rejected & upcoming', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildLeaveCard('Approved', '28', const Color(0xFF22C55E))),
              const SizedBox(width: 16),
              Expanded(child: _buildLeaveCard('Pending', '6', _accent)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _buildLeaveCard('Rejected', '3', const Color(0xFFEF4444))),
              const SizedBox(width: 16),
              Expanded(child: _buildLeaveCard('Upcoming', '11', const Color(0xFF0EA5E9))),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.calendarCheck, size: 20, color: _accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('6 leave requests await your approval', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _accent)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text('Review now', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _accent)),
                          const SizedBox(width: 4),
                          const Icon(LucideIcons.arrowUpRight, size: 14, color: _accent),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 12),
          Text(count, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildStaffDirectory() {
    final staffMembers = [
      {'name': 'Anjali Sharma', 'id': 'EMP-101', 'role': 'Senior Math Teacher', 'dept': 'Mathematics', 'initials': 'AS', 'color': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4F46E5), 'status1': 'Present', 'status1Color': const Color(0xFFDCFCE7), 'status1Text': const Color(0xFF16A34A), 'status2': '-', 'status2Color': const Color(0xFFF3F4F6), 'status2Text': const Color(0xFF9CA3AF), 'status3': 'Active', 'status3Color': const Color(0xFFDCFCE7), 'status3Text': const Color(0xFF16A34A)},
      {'name': 'Rajesh Iyer', 'id': 'EMP-102', 'role': 'Physics Teacher', 'dept': 'Sciences', 'initials': 'RI', 'color': const Color(0xFFE0F2FE), 'textColor': const Color(0xFF0284C7), 'status1': 'On Leave', 'status1Color': const Color(0xFFFEF3C7), 'status1Text': const Color(0xFFD97706), 'status2': 'Approved', 'status2Color': const Color(0xFFDCFCE7), 'status2Text': const Color(0xFF16A34A), 'status3': 'Active', 'status3Color': const Color(0xFFDCFCE7), 'status3Text': const Color(0xFF16A34A)},
      {'name': 'Meera Kapoor', 'id': 'EMP-103', 'role': 'English Teacher', 'dept': 'Languages', 'initials': 'MK', 'color': const Color(0xFFDCFCE7), 'textColor': const Color(0xFF16A34A), 'status1': 'Present', 'status1Color': const Color(0xFFDCFCE7), 'status1Text': const Color(0xFF16A34A), 'status2': '-', 'status2Color': const Color(0xFFF3F4F6), 'status2Text': const Color(0xFF9CA3AF), 'status3': 'Active', 'status3Color': const Color(0xFFDCFCE7), 'status3Text': const Color(0xFF16A34A)},
      {'name': 'Suresh Iyer', 'id': 'EMP-201', 'role': 'Front Desk Executive', 'dept': 'Admin', 'initials': 'SI', 'color': const Color(0xFFFEF3C7), 'textColor': const Color(0xFFD97706), 'status1': 'Absent', 'status1Color': const Color(0xFFFEE2E2), 'status1Text': const Color(0xFFDC2626), 'status2': '-', 'status2Color': const Color(0xFFF3F4F6), 'status2Text': const Color(0xFF9CA3AF), 'status3': 'Active', 'status3Color': const Color(0xFFDCFCE7), 'status3Text': const Color(0xFF16A34A)},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Staff Directory', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 24),
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
                    decoration: const InputDecoration(
                      hintText: 'Search staff name, ID, phone or department',
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('248 members', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
              if (_isTablet)
                Row(
                  children: [
                    Text('Showing 1-10 of 248', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                    const SizedBox(width: 16),
                    _buildDirectoryDropdown('Sort: Newest'),
                    const SizedBox(width: 12),
                    _buildDirectoryDropdown('10 per page'),
                  ],
                ),
            ],
          ),
          if (!_isTablet) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDirectoryDropdown('Sort: Newest'),
                _buildDirectoryDropdown('10 per page'),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          ...staffMembers.map((staff) => _buildStaffCard(staff)),
        ],
      ),
    );
  }

  Widget _buildDirectoryDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronDown, size: 14, color: _textMuted),
        ],
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> staff) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: staff['color'] as Color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              staff['initials'] as String,
              style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: staff['textColor'] as Color),
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
                    Text(staff['name'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                    const Icon(Icons.more_vert, color: _textMuted, size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${staff['id']} • ${staff['role']}', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F1FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.monitor, size: 12, color: _accent),
                      const SizedBox(width: 4),
                      Text(staff['dept'] as String, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatusPill(staff['status1'] as String, staff['status1Color'] as Color, staff['status1Text'] as Color),
                    const SizedBox(width: 8),
                    _buildStatusPill(staff['status2'] as String, staff['status2Color'] as Color, staff['status2Text'] as Color),
                    const SizedBox(width: 8),
                    _buildStatusPill(staff['status3'] as String, staff['status3Color'] as Color, staff['status3Text'] as Color),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filters', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFilterSection('Staff Type', ['All Staff Type', 'Teaching', 'Non-Teaching', 'Admin']),
                  SizedBox(height: 12.h),
                  _buildFilterSection('Department', ['All Departments', 'Sciences', 'Languages', 'Mathematics', 'Physical Education']),
                  SizedBox(height: 12.h),
                  _buildFilterSection('Role', ['All Roles', 'Senior Teacher', 'Teacher', 'HOD', 'Assistant']),
                  SizedBox(height: 12.h),
                  _buildFilterSection('Attendance', ['All Attendance', 'Present', 'Absent', 'On Leave']),
                  SizedBox(height: 12.h),
                  _buildFilterSection('Employment', ['All Employment', 'Permanent', 'Contract', 'Probation']),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Clear', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF374151))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: Text('Apply Filters', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF374151))),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(options.first, style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF111827))),
              const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ],
    );
  }
}
