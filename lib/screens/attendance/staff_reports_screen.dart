import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StaffReportsScreen extends StatefulWidget {
  const StaffReportsScreen({super.key});

  @override
  State<StaffReportsScreen> createState() => _StaffReportsScreenState();
}

class _StaffReportsScreenState extends State<StaffReportsScreen> {
  int _bottomNavIndex = 3; // 'Staff' is index 3
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
      drawer: const MenuScreen(activeScreen: 'Staff Reports'),
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
                            children: [Expanded(child: _buildHeader())],
                          ),
                          const SizedBox(height: 24),
                          _buildTopControls(),
                          const SizedBox(height: 24),
                          _buildStatsRow(),
                          const SizedBox(height: 32),
                          _buildCharts(),
                          const SizedBox(height: 32),
                          _buildReportTemplates(),
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
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8463E9),
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
              'Reports',
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
          'Staff Reports',
          style: GoogleFonts.figtree(
            fontSize: _isTablet ? 32 : 28,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Generate, schedule, and download HR and operational reports.",
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
              const Icon(LucideIcons.calendar, size: 16, color: _textDark),
              const SizedBox(width: 8),
              Text(
                'Schedule',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
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
              const Icon(LucideIcons.download, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Export All',
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
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: _isTablet ? 1.4 : 0.85,
          children: [
            _buildKpiCard(
              '84',
              'Reports Generated',
              'This month',
              LucideIcons.fileText,
              const Color(0xFF8463E9),
              const Color(0xFFF4F1FF),
            ),
            _buildKpiCard(
              '7',
              'Scheduled Reports',
              'Active schedules',
              LucideIcons.refreshCw,
              const Color(0xFF10B981),
              const Color(0xFFD1FAE5),
            ),
            _buildKpiCard(
              'Payroll\nSummary',
              'Most Downloaded',
              '38 downloads',
              LucideIcons.star,
              const Color(0xFFF59E0B),
              const Color(0xFFFEF3C7),
            ),
            _buildKpiCard(
              '1.2s',
              'Avg Gen Time',
              'Across all types',
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
              fontSize: value.length > 5 ? 22 : 28,
              fontWeight: FontWeight.w900,
              color: _textDark,
              height: 1.1,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
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

  Widget _buildCharts() {
    return Column(
      children: [
        _buildTrendChart(),
        const SizedBox(height: 20),
        _buildAttendanceBarChart(),
      ],
    );
  }

  Widget _buildTrendChart() {
    final months = ['Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May'];
    final teachingData = [43.0, 44.0, 44.0, 44.5, 45.0, 46.0];
    final nonTeachingData = [17.0, 18.0, 19.0, 19.5, 20.0, 21.0];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Staff Strength Trend',
                    style: GoogleFonts.figtree(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Teaching vs Non-Teaching · last 6 months',
                    style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Teaching',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Non-Teaching',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _LineChartPainter(
                months: months,
                teachingData: teachingData,
                nonTeachingData: nonTeachingData,
                highlightIndex: 2,
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceBarChart() {
    final departments = ['Maths', 'English', 'Hindi', 'CS', 'PE', 'Arts'];
    final values = [92.0, 88.0, 90.0, 97.0, 85.0, 88.0];
    final highlightIndex = 3; // CS

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance by Department',
                    style: GoogleFonts.figtree(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'May 2025 · average attendance %',
                    style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                  ),
                ],
              ),
              const Icon(
                LucideIcons.barChart2,
                color: Color(0xFF10B981),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _BarChartPainter(
                departments: departments,
                values: values,
                highlightIndex: highlightIndex,
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTemplates() {
    final templates = [
      {
        'icon': LucideIcons.user,
        'iconBg': const Color(0xFFF4F1FF),
        'iconColor': _accent,
        'title': 'Attendance Report',
        'desc': 'Department-wise and individual daily attendance analysis.',
        'downloads': '38 downloads',
      },
      {
        'icon': LucideIcons.wallet,
        'iconBg': const Color(0xFFD1FAE5),
        'iconColor': const Color(0xFF10B981),
        'title': 'Payroll Summary',
        'desc': 'Monthly gross, deductions, net payout by department.',
        'downloads': '34 downloads',
      },
      {
        'icon': LucideIcons.calendar,
        'iconBg': const Color(0xFFFEF3C7),
        'iconColor': const Color(0xFFF59E0B),
        'title': 'Leave Analysis',
        'desc': 'Leave type distribution, approval rates, and seasonal trends.',
        'downloads': '28 downloads',
      },
      {
        'icon': LucideIcons.clipboardList,
        'iconBg': const Color(0xFFFEE2E2),
        'iconColor': const Color(0xFFEF4444),
        'title': 'Workload Report',
        'desc': 'Periods per teacher, subject load, and overload flagging.',
        'downloads': '22 downloads',
      },
      {
        'icon': LucideIcons.clock,
        'iconBg': const Color(0xFFE0F2FE),
        'iconColor': const Color(0xFF0EA5E9),
        'title': 'Document Expiry',
        'desc': 'Contracts, certificates, and IDs expiring in next 60 days.',
        'downloads': '19 downloads',
      },
      {
        'icon': LucideIcons.trendingUp,
        'iconBg': const Color(0xFFF4F1FF),
        'iconColor': _accent,
        'title': 'Headcount Report',
        'desc': 'Staff strength trend, attrition, and new joins by month.',
        'downloads': '15 downloads',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Report Templates',
              style: GoogleFonts.figtree(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            Text(
              '6 report types',
              style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...templates.map((t) => _buildReportTemplateCard(t)),
      ],
    );
  }

  Widget _buildReportTemplateCard(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: t['iconBg'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  t['icon'] as IconData,
                  color: t['iconColor'] as Color,
                  size: 20,
                ),
              ),
              Text(
                t['downloads'] as String,
                style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            t['title'] as String,
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t['desc'] as String,
            style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloading ${t['title']} as PDF...'),
                    backgroundColor: _textDark,
                    duration: const Duration(seconds: 2),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.download,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'PDF',
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloading ${t['title']} as Excel...'),
                    backgroundColor: _textDark,
                    duration: const Duration(seconds: 2),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.fileSpreadsheet,
                        size: 14,
                        color: _textDark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Excel',
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
}

// ─── Line Chart Painter ─────────────────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  final List<String> months;
  final List<double> teachingData;
  final List<double> nonTeachingData;
  final int highlightIndex;

  _LineChartPainter({
    required this.months,
    required this.teachingData,
    required this.nonTeachingData,
    required this.highlightIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPad = 36;
    const double rightPad = 8;
    const double topPad = 8;
    const double bottomPad = 28;

    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;

    const double minVal = 0;
    const double maxVal = 60;

    double xOf(int i) => leftPad + (i / (months.length - 1)) * chartW;
    double yOf(double v) =>
        topPad + chartH - ((v - minVal) / (maxVal - minVal)) * chartH;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = topPad + (i / 4) * chartH;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );
      final label = ((4 - i) / 4 * (maxVal - minVal)).round().toString();
      _drawText(canvas, label, Offset(0, y - 6), const Color(0xFFBFC4CE), 10);
    }

    // Month labels
    for (int i = 0; i < months.length; i++) {
      _drawText(
        canvas,
        months[i],
        Offset(xOf(i) - 12, size.height - 16),
        const Color(0xFFBFC4CE),
        10,
      );
    }

    // Helper to draw a smooth line
    void drawLine(List<double> data, Color color) {
      final path = Path();
      for (int i = 0; i < data.length; i++) {
        final x = xOf(i);
        final y = yOf(data[i]);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          final prevX = xOf(i - 1);
          final prevY = yOf(data[i - 1]);
          final cpX = (prevX + x) / 2;
          path.cubicTo(cpX, prevY, cpX, y, x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    drawLine(teachingData, const Color(0xFF8463E9));
    drawLine(nonTeachingData, const Color(0xFF10B981));

    // Highlight vertical line + dots at highlightIndex
    final hx = xOf(highlightIndex);
    canvas.drawLine(
      Offset(hx, topPad),
      Offset(hx, topPad + chartH),
      Paint()
        ..color = const Color(0xFFE5E7EB)
        ..strokeWidth = 1.5,
    );

    // Teaching dot
    canvas.drawCircle(
      Offset(hx, yOf(teachingData[highlightIndex])),
      5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(hx, yOf(teachingData[highlightIndex])),
      5,
      Paint()
        ..color = const Color(0xFF8463E9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Non-teaching dot
    canvas.drawCircle(
      Offset(hx, yOf(nonTeachingData[highlightIndex])),
      5,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(hx, yOf(nonTeachingData[highlightIndex])),
      5,
      Paint()
        ..color = const Color(0xFF10B981)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Tooltip
    final tooltipX = hx + 8;
    final tooltipY = yOf(teachingData[highlightIndex]) - 20;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX, tooltipY, 130, 60),
      const Radius.circular(10),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFFE5E7EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    _drawText(
      canvas,
      months[highlightIndex],
      Offset(tooltipX + 8, tooltipY + 6),
      const Color(0xFF181B20),
      12,
      bold: true,
    );
    _drawText(
      canvas,
      'Teaching : ${teachingData[highlightIndex].toInt()}',
      Offset(tooltipX + 8, tooltipY + 24),
      const Color(0xFF8463E9),
      11,
    );
    _drawText(
      canvas,
      'NonTeaching : ${nonTeachingData[highlightIndex].toInt()}',
      Offset(tooltipX + 8, tooltipY + 40),
      const Color(0xFF10B981),
      11,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
    double fontSize, {
    bool bold = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Bar Chart Painter ───────────────────────────────────────────────────────
class _BarChartPainter extends CustomPainter {
  final List<String> departments;
  final List<double> values;
  final int highlightIndex;

  _BarChartPainter({
    required this.departments,
    required this.values,
    required this.highlightIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPad = 40;
    const double rightPad = 8;
    const double topPad = 8;
    const double bottomPad = 28;

    final chartW = size.width - leftPad - rightPad;
    final chartH = size.height - topPad - bottomPad;

    const double minVal = 70;
    const double maxVal = 100;

    final n = departments.length;
    final barW = (chartW / n) * 0.5;
    final slotW = chartW / n;

    double xCenter(int i) => leftPad + slotW * i + slotW / 2;
    double barH(double v) => ((v - minVal) / (maxVal - minVal)) * chartH;

    // Grid lines + y labels
    final gridPaint = Paint()
      ..color = const Color(0xFFF3F4F6)
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final val = minVal + (maxVal - minVal) * i / 3;
      final y = topPad + chartH - ((val - minVal) / (maxVal - minVal)) * chartH;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );
      _drawText(
        canvas,
        val.round().toString(),
        Offset(0, y - 6),
        const Color(0xFFBFC4CE),
        10,
      );
    }

    // Bars
    for (int i = 0; i < n; i++) {
      final cx = xCenter(i);
      final bh = barH(values[i]);
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(cx - barW / 2, topPad + chartH - bh, barW, bh),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );

      final isHighlight = i == highlightIndex;
      final barColor = isHighlight
          ? const Color(0xFFCBBFF8)
          : const Color(0xFF8463E9);
      canvas.drawRRect(rect, Paint()..color = barColor);

      if (isHighlight) {
        // Tooltip above highlighted bar
        final tx = cx - 30;
        final ty = topPad + chartH - bh - 56;
        final tooltipRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(tx, ty, 60, 40),
          const Radius.circular(8),
        );
        canvas.drawRRect(
          tooltipRect,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill,
        );
        canvas.drawRRect(
          tooltipRect,
          Paint()
            ..color = const Color(0xFFE5E7EB)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        _drawText(
          canvas,
          departments[i],
          Offset(tx + 6, ty + 4),
          const Color(0xFF181B20),
          11,
          bold: true,
        );
        _drawText(
          canvas,
          '${values[i].toInt()}%',
          Offset(tx + 8, ty + 20),
          const Color(0xFF8463E9),
          12,
          bold: true,
        );
      }

      // Department label
      _drawText(
        canvas,
        departments[i],
        Offset(cx - departments[i].length * 3.2, topPad + chartH + 8),
        const Color(0xFFBFC4CE),
        10,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
    double fontSize, {
    bool bold = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
