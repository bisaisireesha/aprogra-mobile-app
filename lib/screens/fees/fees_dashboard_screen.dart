import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'collect_fee_screen.dart';
import 'invoices_screen.dart';
import 'fee_structure_screen.dart';
import 'due_payments_screen.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class FeesDashboardScreen extends StatefulWidget {
  const FeesDashboardScreen({super.key});

  @override
  State<FeesDashboardScreen> createState() => _FeesDashboardScreenState();
}

class _FeesDashboardScreenState extends State<FeesDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedClass = 'All Classes';
  String _selectedFeeType = 'All Fee Types';
  String _selectedStatus = 'Payment Status';
  int _touchedIndex = -1;

  final List<Map<String, dynamic>> _invoices = [
    {'id': 'INV-2025-1041', 'student': 'Aryan Reddy', 'class': 'Class 6A', 'type': 'Tuition Fee', 'due': '10 May 2025', 'amount': '₹24,500', 'status': 'Paid'},
    {'id': 'INV-2025-1040', 'student': 'Priya Sharma', 'class': 'Class 8B', 'type': 'Hostel Fee', 'due': '10 May 2025', 'amount': '₹18,000', 'status': 'Pending'},
    {'id': 'INV-2025-1039', 'student': 'Rohan Mehta', 'class': 'Class 10A', 'type': 'Transport', 'due': '05 May 2025', 'amount': '₹4,500', 'status': 'Overdue'},
    {'id': 'INV-2025-1038', 'student': 'Ananya Iyer', 'class': 'Class 7C', 'type': 'Tuition Fee', 'due': '10 May 2025', 'amount': '₹24,500', 'status': 'Paid'},
    {'id': 'INV-2025-1037', 'student': 'Kiran Nair', 'class': 'Class 9B', 'type': 'Exam Fee', 'due': '15 May 2025', 'amount': '₹2,000', 'status': 'Pending'},
    {'id': 'INV-2025-1036', 'student': 'Meera Gupta', 'class': 'Class 11A', 'type': 'Tuition Fee', 'due': '10 May 2025', 'amount': '₹28,000', 'status': 'Paid'},
    {'id': 'INV-2025-1035', 'student': 'Aditya Kumar', 'class': 'Class 12B', 'type': 'Misc', 'due': '01 May 2025', 'amount': '₹1,200', 'status': 'Overdue'},
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Fees & Invoices'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(showMenu: false),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildKPIs(isTablet),
                        const SizedBox(height: 24),
                        _buildQuickActions(isTablet),
                        const SizedBox(height: 32),
                        _buildFiltersRow(),
                        const SizedBox(height: 16),
                        _buildInvoicesTable(),
                        const SizedBox(height: 32),
                        _buildCollectionStatus(),
                        const SizedBox(height: 20),
                        _buildCollectionTrendChart(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Icon(LucideIcons.menu, size: 24, color: _dark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Fees & Invoices',
                style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark, letterSpacing: -0.5),
              ),
            ),
            _headerBtn('Export Report', LucideIcons.download, Colors.white, _dark),
            const SizedBox(width: 10),
            _headerBtn('+ Create Invoice', LucideIcons.plus, _primary, Colors.white, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoicesScreen(showCreate: true)));
            }),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 36),
          child: Text(
            'Manage student fee structures, generate invoices,\ntrack dues and monitor collections.',
            style: GoogleFonts.figtree(fontSize: 13, color: _muted, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _headerBtn(String label, IconData icon, Color bg, Color fg, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: bg == Colors.white ? Border.all(color: _border) : null,
          boxShadow: bg == _primary ? [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: fg)),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIs(bool isTablet) {
    final kpis = [
      {'label': 'TOTAL INVOICED', 'value': '₹57.4L', 'trend': '+₹4.8L (+9.12%)', 'sub': 'vs last month', 'positive': true, 'icon': LucideIcons.fileText, 'iconBg': const Color(0xFFEEF2FF), 'iconColor': _primary, 'sparkColor': _primary, 'data': [3.0, 3.5, 4.2, 4.8, 5.1, 5.4, 5.7]},
      {'label': 'AMOUNT COLLECTED', 'value': '₹48.6L', 'trend': '+₹3.2L (+7.04%)', 'sub': '84.7% collected', 'positive': true, 'icon': LucideIcons.checkCircle, 'iconBg': const Color(0xFFF0FDF4), 'iconColor': const Color(0xFF22C55E), 'sparkColor': const Color(0xFF22C55E), 'data': [2.5, 3.0, 3.8, 4.1, 4.5, 4.7, 4.9]},
      {'label': 'PENDING DUES', 'value': '₹8.74L', 'trend': '-₹0.82L (+10.35%)', 'sub': 'requires follow-up', 'positive': false, 'icon': LucideIcons.clock, 'iconBg': const Color(0xFFFFF7ED), 'iconColor': const Color(0xFFF59E0B), 'sparkColor': const Color(0xFFF59E0B), 'data': [1.2, 1.0, 1.1, 0.95, 0.88, 0.91, 0.87]},
      {'label': 'OVERDUE INVOICES', 'value': '126', 'trend': '▼ 18', 'sub': 'past due date', 'positive': false, 'icon': LucideIcons.alertCircle, 'iconBg': const Color(0xFFFEF2F2), 'iconColor': const Color(0xFFEF4444), 'sparkColor': const Color(0xFFEF4444), 'data': [180.0, 165.0, 152.0, 145.0, 138.0, 131.0, 126.0]},
    ];

    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isTablet ? 1.3 : 0.95,
      children: kpis.map((k) => _buildKPICard(k)).toList(),
    );
  }

  Widget _buildKPICard(Map<String, dynamic> k) {
    final iconColor = k['iconColor'] as Color;
    final sparkColor = k['sparkColor'] as Color;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.15)),
        boxShadow: [BoxShadow(color: iconColor.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(k['label'], style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.6), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(color: k['iconBg'], borderRadius: BorderRadius.circular(8)),
                        child: Icon(k['icon'] as IconData, size: 14, color: iconColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(k['value'], style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark, height: 1.1)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(k['positive'] ? LucideIcons.trendingUp : LucideIcons.trendingDown, size: 11, color: k['positive'] ? const Color(0xFF22C55E) : const Color(0xFFEF4444)),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(k['trend'], style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: k['positive'] ? const Color(0xFF22C55E) : const Color(0xFFEF4444)), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(k['sub'], style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 35,
              child: CustomPaint(painter: _SparklinePainter(data: (k['data'] as List).cast<double>(), color: sparkColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isTablet) {
    final actions = [
      {'label': 'Collect Fee', 'icon': LucideIcons.wallet, 'color': _primary, 'bg': const Color(0xFFEEF2FF)},
      {'label': 'Create Invoice', 'icon': LucideIcons.filePlus, 'color': const Color(0xFF3B82F6), 'bg': const Color(0xFFEFF6FF)},
      {'label': 'Send Reminder', 'icon': LucideIcons.bell, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFFF7ED)},
      {'label': 'Fee Structure', 'icon': LucideIcons.layoutGrid, 'color': const Color(0xFF8B5CF6), 'bg': const Color(0xFFF5F3FF)},
      {'label': 'Bulk Invoice', 'icon': LucideIcons.layers, 'color': const Color(0xFF10B981), 'bg': const Color(0xFFF0FDF4)},
      {'label': 'Download Report', 'icon': LucideIcons.download, 'color': const Color(0xFF6B7280), 'bg': const Color(0xFFF9FAFB)},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Actions', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: actions.map((a) => _buildQuickActionBtn(a, context)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionBtn(Map<String, dynamic> a, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (a['label'] == 'Collect Fee') Navigator.push(context, MaterialPageRoute(builder: (_) => const CollectFeeScreen()));
        if (a['label'] == 'Create Invoice') Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoicesScreen(showCreate: true)));
        if (a['label'] == 'Fee Structure') Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeStructureScreen()));
        if (a['label'] == 'Send Reminder') Navigator.push(context, MaterialPageRoute(builder: (_) => const DuePaymentsScreen()));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: a['bg'], borderRadius: BorderRadius.circular(12)),
            child: Icon(a['icon'] as IconData, size: 20, color: a['color']),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 52,
            child: Text(a['label'], style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: _dark), textAlign: TextAlign.center, maxLines: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Invoices', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
            Text('1,486 invoices', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip(_selectedClass, ['All Classes', 'Class 6A', 'Class 7C', 'Class 8B', 'Class 9B', 'Class 10A', 'Class 11A', 'Class 12B'], (v) => setState(() => _selectedClass = v)),
              const SizedBox(width: 8),
              _filterChip(_selectedFeeType, ['All Fee Types', 'Tuition Fee', 'Transport', 'Hostel Fee', 'Exam Fee', 'Misc'], (v) => setState(() => _selectedFeeType = v)),
              const SizedBox(width: 8),
              _filterChip(_selectedStatus, ['Payment Status', 'Paid', 'Pending', 'Overdue'], (v) => setState(() => _selectedStatus = v)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterChip(String value, List<String> items, ValueChanged<String> onChanged) {
    return GestureDetector(
      onTap: () => _showFilterSheet(value, items, onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500, color: _dark)),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronDown, size: 12, color: _muted),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(String current, List<String> items, ValueChanged<String> onChanged) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          ...items.map((item) => ListTile(
            title: Text(item, style: GoogleFonts.figtree(fontSize: 14, color: item == current ? _primary : _dark, fontWeight: item == current ? FontWeight.w600 : FontWeight.normal)),
            trailing: item == current ? Icon(LucideIcons.check, size: 16, color: _primary) : null,
            onTap: () { onChanged(item); Navigator.pop(context); },
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredInvoices {
    return _invoices.where((inv) {
      final classMatch = _selectedClass == 'All Classes' || inv['class'] == _selectedClass;
      final typeMatch = _selectedFeeType == 'All Fee Types' || inv['type'] == _selectedFeeType;
      final statusMatch = _selectedStatus == 'Payment Status' || inv['status'] == _selectedStatus;
      return classMatch && typeMatch && statusMatch;
    }).toList();
  }

  Widget _buildInvoicesTable() {
    final items = _filteredInvoices;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(flex: 3, child: _th('INVOICE / STUDENT')),
                Expanded(flex: 2, child: _th('CLASS')),
                Expanded(flex: 2, child: _th('FEE TYPE')),
                Expanded(flex: 2, child: _th('DUE DATE')),
                Expanded(flex: 2, child: _th('AMOUNT')),
                Expanded(flex: 2, child: _th('STATUS')),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text('No invoices found', style: GoogleFonts.figtree(fontSize: 14, color: _muted))),
            )
          else
            ...items.asMap().entries.map((e) => Column(
              children: [
                _buildInvoiceRow(e.value),
                if (e.key < items.length - 1) const Divider(height: 1, color: _border),
              ],
            )),
          const Divider(height: 1, color: _border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Showing 1-7 of 1,486', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                Row(children: [
                  Text('10 per page', style: GoogleFonts.figtree(fontSize: 12, color: _dark, fontWeight: FontWeight.w500)),
                  const Icon(LucideIcons.chevronDown, size: 14, color: _muted),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _th(String label) => Text(label, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.5));

  Widget _buildInvoiceRow(Map<String, dynamic> inv) {
    Color statusColor;
    Color statusBg;
    switch (inv['status']) {
      case 'Paid':
        statusColor = const Color(0xFF16A34A); statusBg = const Color(0xFFF0FDF4); break;
      case 'Overdue':
        statusColor = const Color(0xFFDC2626); statusBg = const Color(0xFFFEF2F2); break;
      default:
        statusColor = const Color(0xFFD97706); statusBg = const Color(0xFFFFFBEB);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(inv['id'], style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _primary)),
            Text(inv['student'], style: GoogleFonts.figtree(fontSize: 12, color: _dark, fontWeight: FontWeight.w500)),
          ])),
          Expanded(flex: 2, child: Text(inv['class'], style: GoogleFonts.figtree(fontSize: 12, color: _muted))),
          Expanded(flex: 2, child: Text(inv['type'], style: GoogleFonts.figtree(fontSize: 12, color: _dark))),
          Expanded(flex: 2, child: Text(inv['due'], style: GoogleFonts.figtree(fontSize: 11, color: _muted))),
          Expanded(flex: 2, child: Text(inv['amount'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark))),
          Expanded(flex: 2, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
            child: Text(inv['status'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor), textAlign: TextAlign.center),
          )),
        ],
      ),
    );
  }

  Widget _buildCollectionStatus() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Collection Status', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(6), border: Border.all(color: _border)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('This Month', style: GoogleFonts.figtree(fontSize: 11, color: _dark, fontWeight: FontWeight.w500)),
                const SizedBox(width: 4), const Icon(LucideIcons.chevronDown, size: 12, color: _muted),
              ]),
            ),
          ]),
          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 45,
                    pieTouchData: PieTouchData(touchCallback: (event, response) {
                      setState(() { _touchedIndex = response?.touchedSection?.touchedSectionIndex ?? -1; });
                    }),
                    sections: [
                      PieChartSectionData(value: 84.7, title: '84.7%', color: const Color(0xFF6366F1), radius: _touchedIndex == 0 ? 30 : 25, titleStyle: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(value: 10.6, title: '10.6%', color: const Color(0xFFF59E0B), radius: _touchedIndex == 1 ? 30 : 25, titleStyle: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      PieChartSectionData(value: 4.7, title: '4.7%', color: const Color(0xFFEF4444), radius: _touchedIndex == 2 ? 30 : 25, titleStyle: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legend('Collected', '₹48.6L', const Color(0xFF6366F1)),
                    const SizedBox(height: 16),
                    _legend('Pending', '₹6.2L', const Color(0xFFF59E0B)),
                    const SizedBox(height: 16),
                    _legend('Overdue', '₹2.7L', const Color(0xFFEF4444)),
                    const SizedBox(height: 16),
                    const Divider(color: _border),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('TOTAL', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 0.5)),
                      Text('₹57.4L', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(String label, String value, Color color) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _muted))),
      Text(value, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
    ]);
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fee Collection Trend', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                  Text('Invoiced vs Collected · last 6 months', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                ],
              ),
              const Icon(LucideIcons.trendingUp, size: 16, color: _primary),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Text('Invoiced', style: GoogleFonts.inter(fontSize: 9, color: _muted)),
              const SizedBox(width: 12),
              Container(width: 10, height: 10, decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 4),
              Text('Collected', style: GoogleFonts.inter(fontSize: 9, color: _muted)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 7,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (v, _) => Text('₹${v.toInt()}L', style: GoogleFonts.inter(fontSize: 9, color: _muted)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                    final months = ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
                    final idx = v.toInt();
                    return idx >= 0 && idx < months.length ? Text(months[idx], style: GoogleFonts.inter(fontSize: 9, color: _muted)) : const SizedBox();
                  })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: _border.withValues(alpha: 0.5), strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _doubleBarGroup(0, 4.2, 3.6),
                  _doubleBarGroup(1, 4.5, 4.0),
                  _doubleBarGroup(2, 5.1, 4.5),
                  _doubleBarGroup(3, 4.8, 4.1),
                  _doubleBarGroup(4, 5.4, 4.8),
                  _doubleBarGroup(5, 5.7, 5.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _doubleBarGroup(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y1, color: _primary, width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
        BarChartRodData(toY: y2, color: const Color(0xFF10B981), width: 8, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    final min = data.reduce((a, b) => a < b ? a : b);
    final max = data.reduce((a, b) => a > b ? a : b);
    final range = (max - min).abs() < 0.001 ? 1.0 : max - min;

    final paint = Paint()..color = color..strokeWidth = 1.8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final fillPaint = Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.0)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final y = size.height - ((data[i] - min) / range) * (size.height * 0.8) - size.height * 0.1;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      i == 0 ? fillPath.moveTo(x, y) : fillPath.lineTo(x, y);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
