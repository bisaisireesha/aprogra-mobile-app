import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _reportTypes = [
    {
      'title': 'Daily Collection Report',
      'desc': 'Day-wise collection summary by mode and class.',
      'downloads': '62',
      'icon': LucideIcons.barChart2,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF3E8FF),
    },
    {
      'title': 'Monthly Collection Report',
      'desc': 'Month-on-month invoiced vs collected analysis.',
      'downloads': '48',
      'icon': LucideIcons.barChart,
      'color': const Color(0xFF22C55E),
      'bg': const Color(0xFFF0FDF4),
    },
    {
      'title': 'Outstanding Dues Report',
      'desc': 'Aged receivables grouped by class and bucket.',
      'downloads': '41',
      'icon': LucideIcons.clock,
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEF2F2),
    },
    {
      'title': 'Defaulters Report',
      'desc': 'List of students with overdue balances and last contact.',
      'downloads': '38',
      'icon': LucideIcons.fileText,
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFFBEB),
    },
    {
      'title': 'Scholarship / Discount Report',
      'desc': 'Award distribution, beneficiaries and impact.',
      'downloads': '29',
      'icon': LucideIcons.pieChart,
      'color': const Color(0xFF0EA5E9),
      'bg': const Color(0xFFF0F9FF),
    },
    {
      'title': 'Mode-wise Settlement Report',
      'desc': 'Reconcile UPI, card, cash, and bank transfers.',
      'downloads': '24',
      'icon': LucideIcons.fileSpreadsheet,
      'color': const Color(0xFF6366F1),
      'bg': const Color(0xFFEEF2FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Fees & Invoices'),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(showMenu: true),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildActionButtons(),
                        const SizedBox(height: 24),
                        _buildSummaryCards(),
                        const SizedBox(height: 32),
                        _buildCollectionTrendChart(),
                        const SizedBox(height: 32),
                        _buildCollectionByClassChart(),
                        const SizedBox(height: 32),
                        _buildDownloadReportsSection(),
                        const SizedBox(height: 60),
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

  Widget _buildHeader(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (canPop) {
              Navigator.pop(context);
            } else {
              _scaffoldKey.currentState?.openDrawer();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 24, color: _dark),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reports', style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(height: 4),
              Text('Download financial reports and explore collection insights at a glance.', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule clicked')));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.calendar, size: 14, color: _dark),
                const SizedBox(width: 6),
                Text('Schedule', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export All clicked')));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.download, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text('Export All', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final kpis = [
      {'value': '148', 'label': 'Generated This Month', 'sub': '+12 vs last month', 'icon': LucideIcons.fileText, 'color': const Color(0xFF8B5CF6), 'bg': const Color(0xFFF3E8FF)},
      {'value': 'Daily Collection', 'label': 'Most Downloaded', 'sub': '62 downloads', 'icon': LucideIcons.star, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFFFBEB)},
      {'value': '1.4s', 'label': 'Avg Generation Time', 'sub': 'across all types', 'icon': LucideIcons.clock, 'color': const Color(0xFF0EA5E9), 'bg': const Color(0xFFF0F9FF)},
      {'value': '9', 'label': 'Scheduled Reports', 'sub': 'active schedules', 'icon': LucideIcons.refreshCcw, 'color': const Color(0xFF22C55E), 'bg': const Color(0xFFF0FDF4)},
    ];

    return Column(
      children: [
        Row(children: [Expanded(child: _kpiCard(kpis[0])), const SizedBox(width: 12), Expanded(child: _kpiCard(kpis[1]))]),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: _kpiCard(kpis[2])), const SizedBox(width: 12), Expanded(child: _kpiCard(kpis[3]))]),
      ],
    );
  }

  Widget _kpiCard(Map<String, dynamic> k) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: k['bg'] as Color, borderRadius: BorderRadius.circular(10)),
            child: Icon(k['icon'] as IconData, size: 18, color: k['color'] as Color),
          ),
          const SizedBox(height: 16),
          Text(k['value'] as String, style: GoogleFonts.figtree(fontSize: k['value'] == 'Daily Collection' ? 18 : 24, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 2),
          Text(k['label'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
          Text(k['sub'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primary,
        unselectedItemColor: _muted,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Fees'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }

  Widget _buildCollectionTrendChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
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
                  Text('Collection Trend', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                  const SizedBox(height: 4),
                  Text('Invoiced vs Collected · last 6 months (₹L)', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                ],
              ),
              Row(
                children: [
                  _buildLegendItem('Invoiced', const Color(0xFF8B5CF6)),
                  const SizedBox(width: 12),
                  _buildLegendItem('Collected', const Color(0xFF22C55E)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: 30, getDrawingHorizontalLine: (value) => const FlLine(color: _border, strokeWidth: 1, dashArray: [4, 4]), getDrawingVerticalLine: (value) => const FlLine(color: _border, strokeWidth: 1, dashArray: [4, 4])),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(padding: const EdgeInsets.only(top: 8), child: Text(months[value.toInt()], style: GoogleFonts.figtree(fontSize: 11, color: _muted)));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), style: GoogleFonts.figtree(fontSize: 11, color: _muted));
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true, border: const Border(bottom: BorderSide(color: _muted, width: 1), left: BorderSide(color: _muted, width: 1))),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 120,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [FlSpot(0, 78), FlSpot(1, 89), FlSpot(2, 92), FlSpot(3, 96), FlSpot(4, 102), FlSpot(5, 110)],
                    isCurved: true,
                    color: const Color(0xFF8B5CF6),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: const Color(0xFF8B5CF6), strokeWidth: 2, strokeColor: Colors.white)),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: const [FlSpot(0, 65), FlSpot(1, 75), FlSpot(2, 80), FlSpot(3, 82), FlSpot(4, 88), FlSpot(5, 94)],
                    isCurved: true,
                    color: const Color(0xFF22C55E),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true, getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(radius: 4, color: const Color(0xFF22C55E), strokeWidth: 2, strokeColor: Colors.white)),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
      ],
    );
  }

  Widget _buildCollectionByClassChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Collection by Class', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                  const SizedBox(height: 4),
                  Text('This month (₹L)', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                ],
              ),
              const Icon(LucideIcons.barChart, size: 20, color: Color(0xFF22C55E)),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 10, getDrawingHorizontalLine: (value) => const FlLine(color: _border, strokeWidth: 1, dashArray: [4, 4])),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const classes = ['Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
                        if (value.toInt() >= 0 && value.toInt() < classes.length) {
                          return Padding(padding: const EdgeInsets.only(top: 8), child: Text(classes[value.toInt()], style: GoogleFonts.figtree(fontSize: 11, color: _muted)));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString(), style: GoogleFonts.figtree(fontSize: 11, color: _muted));
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true, border: const Border(bottom: BorderSide(color: _muted, width: 1), left: BorderSide(color: _muted, width: 1))),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 18, color: const Color(0xFF8B5CF6), width: 36, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 22, color: const Color(0xFF8B5CF6), width: 36, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 24, color: const Color(0xFF8B5CF6), width: 36, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 28, color: const Color(0xFF8B5CF6), width: 36, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 32, color: const Color(0xFF8B5CF6), width: 36, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 38, color: const Color(0xFF8B5CF6), width: 36, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]),
                ],
                maxY: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadReportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Download Reports', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
            Text('6 report types available', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ],
        ),
        const SizedBox(height: 16),
        ..._reportTypes.map((r) => _buildReportCard(r)),
      ],
    );
  }

  Widget _buildReportCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: r['bg'] as Color, borderRadius: BorderRadius.circular(10)),
                child: Icon(r['icon'] as IconData, size: 20, color: r['color'] as Color),
              ),
              Text('${r['downloads']} downloads', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ],
          ),
          const SizedBox(height: 16),
          Text(r['title'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 4),
          Text(r['desc'] as String, style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildReportActionButton('PDF', LucideIcons.download, true),
              const SizedBox(width: 12),
              _buildReportActionButton('Excel', LucideIcons.fileSpreadsheet, false),
              const SizedBox(width: 12),
              _buildReportActionButton('Schedule', LucideIcons.refreshCcw, false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportActionButton(String label, IconData icon, bool isPrimary) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label clicked')));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? _primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isPrimary ? _primary : _border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isPrimary ? Colors.white : _dark),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: isPrimary ? Colors.white : _dark)),
          ],
        ),
      ),
    );
  }
}
