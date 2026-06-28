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

class FeeReportsScreen extends StatefulWidget {
  const FeeReportsScreen({super.key});

  @override
  State<FeeReportsScreen> createState() => _FeeReportsScreenState();
}

class _FeeReportsScreenState extends State<FeeReportsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  int _touchedPieIndex = -1;

  // Monthly collection data (₹L)
  final List<double> _revenueData = [4.2, 4.5, 5.1, 4.8, 5.4, 5.7, 5.2, 5.9];
  final List<double> _expenseData = [2.6, 2.8, 3.0, 2.9, 3.2, 3.3, 3.1, 3.4];
  final List<String> _months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];

  final List<Map<String, dynamic>> _feeTypeBreakdown = [
    {'label': 'Tuition', 'pct': 62.0, 'amount': '₹35.59L', 'color': const Color(0xFF6366F1)},
    {'label': 'Transport', 'pct': 14.0, 'amount': '₹8.04L', 'color': const Color(0xFF3B82F6)},
    {'label': 'Hostel', 'pct': 12.0, 'amount': '₹6.89L', 'color': const Color(0xFF10B981)},
    {'label': 'Exam', 'pct': 7.0, 'amount': '₹4.02L', 'color': const Color(0xFFF59E0B)},
    {'label': 'Misc', 'pct': 5.0, 'amount': '₹2.87L', 'color': const Color(0xFF9CA3AF)},
  ];

  final List<Map<String, dynamic>> _expenseBreakdown = [
    {'label': 'Salaries', 'amount': '₹14.80L', 'pct': 59.0, 'color': const Color(0xFF6366F1)},
    {'label': 'Utilities', 'amount': '₹3.20L', 'pct': 13.0, 'color': const Color(0xFF3B82F6)},
    {'label': 'Maintenance', 'amount': '₹2.40L', 'pct': 10.0, 'color': const Color(0xFF10B981)},
    {'label': 'Transport', 'amount': '₹2.10L', 'pct': 8.0, 'color': const Color(0xFFF59E0B)},
    {'label': 'Supplies', 'amount': '₹1.50L', 'pct': 6.0, 'color': const Color(0xFFEF4444)},
    {'label': 'Misc', 'amount': '₹0.90L', 'pct': 4.0, 'color': const Color(0xFF9CA3AF)},
  ];

  final List<Map<String, dynamic>> _paymentModeData = [
    {'mode': 'Online / UPI', 'amount': '₹24.52L', 'pct': 60.0, 'color': const Color(0xFF6366F1), 'icon': LucideIcons.smartphone},
    {'mode': 'Cash', 'amount': '₹11.10L', 'pct': 27.0, 'color': const Color(0xFF3B82F6), 'icon': LucideIcons.banknote},
    {'mode': 'Bank Transfer', 'amount': '₹3.28L', 'pct': 8.0, 'color': const Color(0xFF10B981), 'icon': LucideIcons.building2},
    {'mode': 'Card', 'amount': '₹1.64L', 'pct': 4.0, 'color': const Color(0xFFF59E0B), 'icon': LucideIcons.creditCard},
    {'mode': 'Cheque', 'amount': '₹0.41L', 'pct': 1.0, 'color': const Color(0xFFEF4444), 'icon': LucideIcons.fileText},
  ];

  final List<Map<String, dynamic>> _classWiseCollection = [
    {'class': 'Class 12', 'collected': '₹5.6L', 'pending': '₹0.8L', 'pct': 87.5},
    {'class': 'Class 11', 'collected': '₹5.2L', 'pending': '₹0.6L', 'pct': 89.7},
    {'class': 'Class 10', 'collected': '₹5.8L', 'pending': '₹1.2L', 'pct': 82.9},
    {'class': 'Class 9', 'collected': '₹4.9L', 'pending': '₹0.9L', 'pct': 84.5},
    {'class': 'Class 8', 'collected': '₹4.4L', 'pending': '₹1.0L', 'pct': 81.5},
    {'class': 'Class 7', 'collected': '₹3.9L', 'pending': '₹0.7L', 'pct': 84.8},
    {'class': 'Class 6', 'collected': '₹3.6L', 'pending': '₹0.8L', 'pct': 81.8},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Fee Reports'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 0), child: CommonAppBar(showMenu: false)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    _buildKPIRow(),
                    const SizedBox(height: 12),
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: _primary,
                      labelColor: _primary,
                      unselectedLabelColor: _muted,
                      labelStyle: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600),
                      unselectedLabelStyle: GoogleFonts.figtree(fontSize: 13),
                      tabs: const [
                        Tab(text: 'Revenue & Expenses'),
                        Tab(text: 'Collection by Type'),
                        Tab(text: 'Payment Modes'),
                        Tab(text: 'Class-wise'),
                      ],
                    ),
                  ]),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRevenueTab(),
                      _buildCollectionTypeTab(),
                      _buildPaymentModeTab(),
                      _buildClassWiseTab(),
                    ],
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
    return Row(children: [
      GestureDetector(
        onTap: () {
          if (canPop) {
            Navigator.pop(context);
          } else {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)), child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 18, color: _dark)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fee Reports', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        Text('Analytics, trends and financial insights', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
      ])),
      _periodSelector(),
      const SizedBox(width: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(LucideIcons.download, size: 14, color: _dark),
          const SizedBox(width: 5),
          Text('Export', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
        ]),
      ),
    ]);
  }

  Widget _periodSelector() {
    final periods = ['This Month', 'Last Month', 'Q1', 'Q2', 'Q3', 'This Year'];
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 8),
          ...periods.map((p) => ListTile(
            title: Text(p, style: GoogleFonts.figtree(fontSize: 14, color: p == _selectedPeriod ? _primary : _dark, fontWeight: p == _selectedPeriod ? FontWeight.w600 : FontWeight.normal)),
            trailing: p == _selectedPeriod ? Icon(LucideIcons.check, size: 16, color: _primary) : null,
            onTap: () { setState(() => _selectedPeriod = p); Navigator.pop(context); },
          )),
          const SizedBox(height: 16),
        ]),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(LucideIcons.calendarDays, size: 13, color: _primary),
          const SizedBox(width: 5),
          Text(_selectedPeriod, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _primary)),
          const SizedBox(width: 3),
          const Icon(LucideIcons.chevronDown, size: 12, color: _primary),
        ]),
      ),
    );
  }

  Widget _buildKPIRow() {
    return Row(children: [
      _kpi('₹57.4L', 'Total Invoiced', '+9.12%', true, const Color(0xFF6366F1)),
      const SizedBox(width: 8),
      _kpi('₹48.6L', 'Collected', '+7.04%', true, const Color(0xFF22C55E)),
      const SizedBox(width: 8),
      _kpi('₹8.74L', 'Pending', '-10.35%', false, const Color(0xFFF59E0B)),
      const SizedBox(width: 8),
      _kpi('₹24.9L', 'Expenses', '+4.2%', false, const Color(0xFFEF4444)),
    ]);
  }

  Widget _kpi(String value, String label, String trend, bool positive, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        Text(label, style: GoogleFonts.figtree(fontSize: 9, color: _muted), maxLines: 1, overflow: TextOverflow.ellipsis),
        Row(children: [
          Icon(positive ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 9, color: positive ? const Color(0xFF22C55E) : const Color(0xFFEF4444)),
          const SizedBox(width: 2),
          Expanded(child: Text(trend, style: GoogleFonts.figtree(fontSize: 9, color: positive ? const Color(0xFF22C55E) : const Color(0xFFEF4444), fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
        ]),
      ]),
    ));
  }

  // ── TAB 1: Revenue vs Expenses ──────────────────────────────────────────
  Widget _buildRevenueTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        _sectionCard('Revenue vs Expenses', 'Monthly comparison · 2025-26', _buildBarChart()),
        const SizedBox(height: 16),
        _sectionCard('Monthly Collection Trend', 'Last 8 months (₹L)', _buildLineChart()),
        const SizedBox(height: 16),
        _buildExpenseBreakdownCard(),
        const SizedBox(height: 60),
      ]),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 7,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (v, _) => Text('₹${v.toInt()}L', style: GoogleFonts.inter(fontSize: 9, color: _muted)))),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
              final idx = v.toInt();
              return idx >= 0 && idx < _months.length ? Text(_months[idx], style: GoogleFonts.inter(fontSize: 9, color: _muted)) : const SizedBox();
            })),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: _border.withValues(alpha: 0.5), strokeWidth: 1)),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(_revenueData.length, (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(toY: _revenueData[i], color: _primary, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
              BarChartRodData(toY: _expenseData[i], color: const Color(0xFFEF4444).withValues(alpha: 0.7), width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: _border.withValues(alpha: 0.5), strokeWidth: 1)),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
              final idx = v.toInt();
              return idx >= 0 && idx < _months.length ? Text(_months[idx], style: GoogleFonts.inter(fontSize: 9, color: _muted)) : const SizedBox();
            })),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (v, _) => Text('₹${v.toInt()}L', style: GoogleFonts.inter(fontSize: 9, color: _muted)))),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(_revenueData.length, (i) => FlSpot(i.toDouble(), _revenueData[i])),
              isCurved: true,
              color: _primary,
              barWidth: 3,
              dotData: FlDotData(getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 4, color: _primary, strokeWidth: 2, strokeColor: Colors.white)),
              belowBarData: BarAreaData(show: true, gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_primary.withValues(alpha: 0.2), _primary.withValues(alpha: 0.0)])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Expense Breakdown', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 4),
        Text('Total ₹24.90L', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        const SizedBox(height: 16),
        ..._expenseBreakdown.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: e['color'] as Color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(e['label'], style: GoogleFonts.figtree(fontSize: 13, color: _dark)),
              ]),
              Text('${e['amount']} · ${e['pct'].toInt()}%', style: GoogleFonts.figtree(fontSize: 12, color: _muted, fontWeight: FontWeight.w500)),
            ]),
            const SizedBox(height: 6),
            Stack(children: [
              Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(3))),
              FractionallySizedBox(widthFactor: (e['pct'] as double) / 100, child: Container(height: 6, decoration: BoxDecoration(color: e['color'] as Color, borderRadius: BorderRadius.circular(3)))),
            ]),
          ]),
        )),
      ]),
    );
  }

  // ── TAB 2: Collection by Fee Type ───────────────────────────────────────
  Widget _buildCollectionTypeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Collection by Fee Type', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
            const SizedBox(height: 4),
            Text('Share of total revenue · ₹57.4L', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            const SizedBox(height: 20),
            Row(children: [
              SizedBox(
                width: 160,
                height: 160,
                child: PieChart(PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(touchCallback: (e, r) => setState(() => _touchedPieIndex = r?.touchedSection?.touchedSectionIndex ?? -1)),
                  sections: _feeTypeBreakdown.asMap().entries.map((e) {
                    final isTouched = e.key == _touchedPieIndex;
                    return PieChartSectionData(
                      value: e.value['pct'] as double,
                      title: '${(e.value['pct'] as double).toInt()}%',
                      color: e.value['color'] as Color,
                      radius: isTouched ? 35 : 28,
                      titleStyle: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                )),
              ),
              const SizedBox(width: 20),
              Expanded(child: Column(
                children: _feeTypeBreakdown.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: f['color'] as Color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f['label'], style: GoogleFonts.figtree(fontSize: 13, color: _dark))),
                    Text(f['amount'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
                  ]),
                )).toList(),
              )),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        _sectionCard('Payment Status', 'Across all invoices', _buildPaymentStatusBars()),
        const SizedBox(height: 60),
      ]),
    );
  }

  Widget _buildPaymentStatusBars() {
    final statuses = [
      {'label': 'Paid', 'pct': 0.847, 'color': const Color(0xFF22C55E), 'icon': LucideIcons.checkCircle, 'value': '₹48.6L'},
      {'label': 'Pending', 'pct': 0.106, 'color': const Color(0xFFF59E0B), 'icon': LucideIcons.clock, 'value': '₹6.1L'},
      {'label': 'Overdue', 'pct': 0.047, 'color': const Color(0xFFEF4444), 'icon': LucideIcons.alertCircle, 'value': '₹2.7L'},
    ];
    return Column(children: statuses.map((s) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(s['icon'] as IconData, size: 14, color: s['color'] as Color),
            const SizedBox(width: 6),
            Text(s['label'] as String, style: GoogleFonts.figtree(fontSize: 13, color: _dark, fontWeight: FontWeight.w500)),
          ]),
          Row(children: [
            Text(s['value'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
            const SizedBox(width: 8),
            Text('${((s['pct'] as double) * 100).toStringAsFixed(1)}%', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ]),
        ]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: s['pct'] as double, backgroundColor: const Color(0xFFF3F4F6), valueColor: AlwaysStoppedAnimation<Color>(s['color'] as Color), minHeight: 8)),
      ]),
    )).toList());
  }

  // ── TAB 3: Payment Modes ────────────────────────────────────────────────
  Widget _buildPaymentModeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Payment Mode Breakdown', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
            const SizedBox(height: 4),
            Text('Total collected ₹40.80L', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            const SizedBox(height: 16),
            ..._paymentModeData.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(children: [
                Row(children: [
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: (m['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(m['icon'] as IconData, size: 14, color: m['color'] as Color)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(m['mode'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w500, color: _dark)),
                      Row(children: [
                        Text(m['amount'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
                        const SizedBox(width: 6),
                        Text('(${(m['pct'] as double).toInt()}%)', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                      ]),
                    ]),
                    const SizedBox(height: 6),
                    Stack(children: [
                      Container(height: 7, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4))),
                      FractionallySizedBox(widthFactor: (m['pct'] as double) / 100, child: Container(height: 7, decoration: BoxDecoration(color: m['color'] as Color, borderRadius: BorderRadius.circular(4)))),
                    ]),
                  ])),
                ]),
              ]),
            )),
          ]),
        ),
        const SizedBox(height: 60),
      ]),
    );
  }

  // ── TAB 4: Class-wise Collection ────────────────────────────────────────
  Widget _buildClassWiseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(children: [
                Expanded(flex: 3, child: _th('CLASS')),
                Expanded(flex: 2, child: _th('COLLECTED')),
                Expanded(flex: 2, child: _th('PENDING')),
                Expanded(flex: 2, child: _th('RATE')),
              ]),
            ),
            const Divider(height: 1, color: _border),
            ..._classWiseCollection.asMap().entries.map((e) => Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(flex: 3, child: Text(e.value['class'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark))),
                    Expanded(flex: 2, child: Text(e.value['collected'] as String, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF22C55E), fontWeight: FontWeight.w600))),
                    Expanded(flex: 2, child: Text(e.value['pending'] as String, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFFF59E0B), fontWeight: FontWeight.w600))),
                    Expanded(flex: 2, child: _rateChip(e.value['pct'] as double)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: (e.value['pct'] as double) / 100, backgroundColor: const Color(0xFFF3F4F6), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)), minHeight: 5)),
                ]),
              ),
              if (e.key < _classWiseCollection.length - 1) const Divider(height: 1, color: _border),
            ])),
          ]),
        ),
        const SizedBox(height: 16),
        _buildQuickExportsCard(),
        const SizedBox(height: 60),
      ]),
    );
  }

  Widget _rateChip(double pct) {
    final color = pct >= 85 ? const Color(0xFF22C55E) : pct >= 75 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text('${pct.toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _buildQuickExportsCard() {
    final reports = [
      {'name': 'Collection Summary', 'desc': 'Full fee collection report', 'icon': LucideIcons.fileText, 'color': const Color(0xFF6366F1)},
      {'name': 'Outstanding Dues', 'desc': 'List of pending payments', 'icon': LucideIcons.alertCircle, 'color': const Color(0xFFEF4444)},
      {'name': 'Receipt Register', 'desc': 'All receipts in date range', 'icon': LucideIcons.receipt, 'color': const Color(0xFF10B981)},
      {'name': 'Defaulters List', 'desc': 'Students with overdue > 30d', 'icon': LucideIcons.userX, 'color': const Color(0xFFF59E0B)},
      {'name': 'Expense Report', 'desc': 'Monthly expense breakdown', 'icon': LucideIcons.trendingDown, 'color': const Color(0xFF8B5CF6)},
      {'name': 'Discount Summary', 'desc': 'Scholarships & concessions', 'icon': LucideIcons.award, 'color': const Color(0xFF3B82F6)},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Quick Exports', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 4),
        Text('Download specific reports as PDF or Excel', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        const SizedBox(height: 14),
        ...reports.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: (r['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(9)),
              child: Icon(r['icon'] as IconData, size: 15, color: r['color'] as Color)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r['name'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
              Text(r['desc'] as String, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
            ])),
            Row(children: [
              _exportBtn('PDF', const Color(0xFFEF4444)),
              const SizedBox(width: 6),
              _exportBtn('Excel', const Color(0xFF22C55E)),
            ]),
          ]),
        )),
      ]),
    );
  }

  Widget _exportBtn(String label, Color color) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Generating $label report...', style: GoogleFonts.figtree(color: Colors.white)),
        backgroundColor: color, behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      )),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(7), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      ),
    );
  }

  Widget _th(String label) => Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.5));

  Widget _sectionCard(String title, String subtitle, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 2),
        Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 4),
          Text('Revenue', style: GoogleFonts.inter(fontSize: 10, color: _muted)),
          const SizedBox(width: 10),
          Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFFEF4444).withValues(alpha: 0.7), borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 4),
          Text('Expenses', style: GoogleFonts.inter(fontSize: 10, color: _muted)),
        ]),
        const SizedBox(height: 8),
        child,
      ]),
    );
  }
}
