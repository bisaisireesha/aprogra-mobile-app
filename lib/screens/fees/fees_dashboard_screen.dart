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
import 'create_invoice_modal.dart';

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
  int _touchedBarIndex = -1;

  final List<Map<String, dynamic>> _invoices = [
    {'id': 'INV-2025-1048', 'student': 'Aryan Reddy', 'class': 'Class 6A', 'type': 'Tuition Fee', 'due': '27 May 2025', 'amount': '₹24,500', 'status': 'Pending'},
    {'id': 'INV-2025-1047', 'student': 'Saanvi Patel', 'class': 'Class 4B', 'type': 'Transport', 'due': '25 May 2025', 'amount': '₹3,200', 'status': 'Paid'},
    {'id': 'INV-2025-1046', 'student': 'Vivaan Singh', 'class': 'Class 9C', 'type': 'Tuition Fee', 'due': '24 May 2025', 'amount': '₹28,000', 'status': 'Overdue'},
    {'id': 'INV-2025-1045', 'student': 'Aadhya Sharma', 'class': 'Class 2A', 'type': 'Hostel Fee', 'due': '22 May 2025', 'amount': '₹15,000', 'status': 'Partial'},
    {'id': 'INV-2025-1044', 'student': 'Reyansh Gupta', 'class': 'Class 10A', 'type': 'Tuition Fee', 'due': '20 May 2025', 'amount': '₹30,000', 'status': 'Pending'},
    {'id': 'INV-2025-1043', 'student': 'Myra Verma', 'class': 'Class 5B', 'type': 'Exam Fee', 'due': '18 May 2025', 'amount': '₹1,500', 'status': 'Paid'},
    {'id': 'INV-2025-1042', 'student': 'Kabir Desai', 'class': 'Class 11C', 'type': 'Transport', 'due': '15 May 2025', 'amount': '₹4,500', 'status': 'Overdue'},
    {'id': 'INV-2025-1041', 'student': 'Ananya Iyer', 'class': 'Class 7C', 'type': 'Tuition Fee', 'due': '10 May 2025', 'amount': '₹24,500', 'status': 'Paid'},
    {'id': 'INV-2025-1040', 'student': 'Priya Sharma', 'class': 'Class 8B', 'type': 'Hostel Fee', 'due': '10 May 2025', 'amount': '₹18,000', 'status': 'Pending'},
    {'id': 'INV-2025-1039', 'student': 'Rohan Mehta', 'class': 'Class 10A', 'type': 'Transport', 'due': '05 May 2025', 'amount': '₹4,500', 'status': 'Overdue'},
    {'id': 'INV-2025-1038', 'student': 'Arjun Das', 'class': 'Class 1A', 'type': 'Tuition Fee', 'due': '01 May 2025', 'amount': '₹20,000', 'status': 'Paid'},
    {'id': 'INV-2025-1037', 'student': 'Kiran Nair', 'class': 'Class 9B', 'type': 'Exam Fee', 'due': '15 Apr 2025', 'amount': '₹2,000', 'status': 'Pending'},
  ];

  void _showCreateInvoiceModal(BuildContext context, [Map<String, dynamic>? inv]) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: CreateInvoiceModal(initialData: inv),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (inv != null) {
          final index = _invoices.indexWhere((element) => element['id'] == inv['id']);
          if (index != -1) _invoices[index] = result;
        } else {
          _invoices.insert(0, result);
        }
      });
    }
  }

  void _showInvoiceDetails(BuildContext context, Map<String, dynamic> inv) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Invoice Details', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x))
              ],
            ),
            const SizedBox(height: 24),
            _detailRow('Invoice No', inv['id']),
            _detailRow('Student', inv['student']),
            _detailRow('Class', inv['class']),
            _detailRow('Fee Type', inv['type']),
            _detailRow('Due Date', inv['due']),
            _detailRow('Amount', inv['amount']),
            _detailRow('Status', inv['status']),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: _primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: Text('Close', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
          Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
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
                        _buildKPIs(isTablet),
                        const SizedBox(height: 24),
                        _buildQuickActions(isTablet),
                        const SizedBox(height: 24),
                        _buildSearchBar(),
                        const SizedBox(height: 32),
                        _buildFiltersRow(),
                        const SizedBox(height: 16),
                        _buildInvoicesTable(),
                        const SizedBox(height: 32),
                        _buildCollectionStatus(),
                        _buildCollectionTrendChart(),
                        const SizedBox(height: 20),
                        _buildOverdueByClass(),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Fees & Invoices',
                style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark, letterSpacing: -0.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                _headerBtn('Export', LucideIcons.download, Colors.white, _dark),
                const SizedBox(width: 8),
                _headerBtn('Create', LucideIcons.plus, _primary, Colors.white, onTap: () {
                  _showCreateInvoiceModal(context);
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Manage student fee structures, generate invoices,\ntrack dues and monitor collections.',
          style: GoogleFonts.figtree(fontSize: 13, color: _muted, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search invoice or student...',
              hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted),
              prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _primary)),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: const Icon(LucideIcons.filter, size: 20, color: _dark),
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
      {
        'label': 'TOTAL INVOICED', 
        'value': '₹57.4L', 
        'trend': '▲ ₹4.8L (+9.12%)', 
        'sub': 'vs last month', 
        'positive': true, 
        'icon': LucideIcons.fileText, 
        'iconBg': const Color(0xFF6366F1), 
        'cardBg': Colors.white, 
        'cardBorder': const Color(0xFFEBE5FF), 
        'trendColor': const Color(0xFF22C55E),
        'sparkColor': const Color(0xFF6366F1), 
        'data': [3.0, 3.5, 4.2, 4.8, 5.1, 5.4, 5.7]
      },
      {
        'label': 'AMOUNT COLLECTED', 
        'value': '₹48.6L', 
        'trend': '▲ ₹3.2L (+7.04%)', 
        'sub': '84.7% collected', 
        'positive': true, 
        'icon': LucideIcons.wallet, 
        'iconBg': const Color(0xFF22C55E), 
        'cardBg': Colors.white,
        'cardBorder': const Color(0xFFE0F3E8), 
        'trendColor': const Color(0xFF22C55E),
        'sparkColor': const Color(0xFF22C55E), 
        'data': [2.5, 3.0, 3.8, 4.1, 4.5, 4.7, 4.9]
      },
      {
        'label': 'PENDING DUES', 
        'value': '₹8.74L', 
        'trend': '▼ ₹0.82L (+10.35%)', 
        'sub': 'requires follow-up', 
        'positive': false, 
        'icon': LucideIcons.clock, 
        'iconBg': const Color(0xFFF59E0B), 
        'cardBg': Colors.white,
        'cardBorder': const Color(0xFFFDE8D4), 
        'trendColor': const Color(0xFFEF4444),
        'sparkColor': const Color(0xFFF59E0B), 
        'data': [0.8, 0.9, 0.9, 1.2, 1.0, 1.1, 1.3]
      },
      {
        'label': 'OVERDUE INVOICES', 
        'value': '126', 
        'trend': '▼ 18', 
        'sub': 'past due date', 
        'positive': false, 
        'icon': LucideIcons.alertCircle, 
        'iconBg': const Color(0xFFEF4444), 
        'cardBg': Colors.white,
        'cardBorder': const Color(0xFFFCE1E1), 
        'trendColor': const Color(0xFFEF4444),
        'sparkColor': const Color(0xFFEF4444), 
        'data': [130.0, 140.0, 125.0, 135.0, 120.0, 130.0, 126.0]
      },
    ];

    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: isTablet ? 1.3 : 0.85,
      children: kpis.map((k) => _buildKPICard(k)).toList(),
    );
  }

  Widget _buildKPICard(Map<String, dynamic> k) {
    final iconBg = k['iconBg'] as Color;
    final sparkColor = k['sparkColor'] as Color;
    final cardBg = k['cardBg'] as Color;
    final cardBorder = k['cardBorder'] as Color;
    final trendColor = k['trendColor'] as Color;
    
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                    child: Icon(k['icon'] as IconData, size: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(k['label'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: _muted, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text(k['value'], style: GoogleFonts.figtree(fontSize: 28, fontWeight: FontWeight.bold, color: _dark, height: 1.1)),
                  const SizedBox(height: 8),
                  Text(k['trend'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: trendColor)),
                  const SizedBox(height: 4),
                  Text(k['sub'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LineChart(
                  LineChartData(
                    minX: 0, 
                    maxX: (k['data'] as List).length.toDouble() - 1,
                    minY: (k['data'] as List).cast<double>().reduce((a,b)=>a<b?a:b) * 0.95,
                    maxY: (k['data'] as List).cast<double>().reduce((a,b)=>a>b?a:b) * 1.05,
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: (k['data'] as List).cast<double>().asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: sparkColor,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: sparkColor.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isTablet) {
    final actions = [
      {'label': 'Collect Fee', 'desc': 'Record fee payments', 'icon': LucideIcons.wallet, 'color': const Color(0xFF22C55E), 'bg': Colors.white, 'border': const Color(0xFFE0F3E8), 'iconBg': const Color(0xFFDCFCE7)},
      {'label': 'Create Invoice', 'desc': 'Generate new invoices', 'icon': LucideIcons.fileText, 'color': const Color(0xFF6366F1), 'bg': Colors.white, 'border': const Color(0xFFEBE5FF), 'iconBg': const Color(0xFFEEF2FF)},
      {'label': 'Send Reminder', 'desc': 'Send payment reminders', 'icon': LucideIcons.bell, 'color': const Color(0xFFF59E0B), 'bg': Colors.white, 'border': const Color(0xFFFDE8D4), 'iconBg': const Color(0xFFFFF7ED)},
      {'label': 'Fee Structure', 'desc': 'Manage fee structures', 'icon': LucideIcons.settings, 'color': const Color(0xFF3B82F6), 'bg': Colors.white, 'border': const Color(0xFFE5EDFF), 'iconBg': const Color(0xFFEFF6FF)},
      {'label': 'Bulk Invoice', 'desc': 'Create invoices in bulk', 'icon': LucideIcons.layers, 'color': const Color(0xFF8B5CF6), 'bg': Colors.white, 'border': const Color(0xFFEBE5FF), 'iconBg': const Color(0xFFF5F3FF)},
      {'label': 'Download Report', 'desc': 'Download fee reports', 'icon': LucideIcons.download, 'color': const Color(0xFF0EA5E9), 'bg': Colors.white, 'border': const Color(0xFFE0F2FE), 'iconBg': const Color(0xFFE0F2FE)},
    ];
    return GridView.count(
      crossAxisCount: isTablet ? 6 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.75,
      children: actions.map((a) => _buildQuickActionBtn(a, context)).toList(),
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
      child: Container(
        decoration: BoxDecoration(
          color: a['bg'],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: a['border']),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: a['iconBg'], shape: BoxShape.circle),
              child: Icon(a['icon'] as IconData, size: 24, color: a['color']),
            ),
            const SizedBox(height: 12),
            Text(a['label'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _dark), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(a['desc'], style: GoogleFonts.figtree(fontSize: 10, color: _muted), textAlign: TextAlign.center, maxLines: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent Invoices', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(height: 2),
              Text('1,486 invoices', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Text('10 per page', style: GoogleFonts.figtree(fontSize: 12, color: _dark, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevronDown, size: 14, color: _muted),
                ],
              ),
            ),
            Text('Showing 1-7 of 1,486', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(child: Text('No invoices found', style: GoogleFonts.figtree(fontSize: 14, color: _muted))),
          )
        else
          ...items.map((inv) => _buildInvoiceCard(inv)),
        const SizedBox(height: 16),
        _buildPagination(),
      ],
    );
  }

  Widget _buildPagination() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pageBtn(LucideIcons.chevronLeft, false),
          _pageBtn('1', true),
          _pageBtn('2', false),
          _pageBtn('3', false),
          _pageBtn('...', false),
          _pageBtn('149', false),
          _pageBtn(LucideIcons.chevronRight, false),
        ],
      ),
    );
  }

  Widget _pageBtn(dynamic content, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? const Color(0xFF6366F1) : _border),
      ),
      child: content is String
          ? Text(content, style: GoogleFonts.figtree(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? Colors.white : _dark))
          : Icon(content as IconData, size: 14, color: _dark),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> inv) {
    Color statusColor;
    Color statusBg;
    switch (inv['status']) {
      case 'Paid':
        statusColor = const Color(0xFF22C55E); statusBg = const Color(0xFFDCFCE7); break;
      case 'Overdue':
        statusColor = const Color(0xFFEF4444); statusBg = const Color(0xFFFEE2E2); break;
      case 'Partial':
        statusColor = const Color(0xFF0EA5E9); statusBg = const Color(0xFFE0F2FE); break;
      default:
        statusColor = const Color(0xFFF59E0B); statusBg = const Color(0xFFFEF3C7);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4, right: 12),
                width: 18,
                height: 18,
                decoration: BoxDecoration(border: Border.all(color: _border), borderRadius: BorderRadius.circular(4)),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(LucideIcons.fileText, size: 20, color: Color(0xFF6366F1)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(inv['id'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 2),
                    Text(inv['student'], style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(inv['amount'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                    child: Text(inv['status'], style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: const Icon(LucideIcons.moreHorizontal, size: 20, color: _muted),
                padding: EdgeInsets.zero,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  if (value == 'view') {
                    _showInvoiceDetails(context, inv);
                  } else if (value == 'edit') {
                    _showCreateInvoiceModal(context, inv);
                  } else if (value == 'delete') {
                    setState(() {
                      _invoices.removeWhere((element) => element['id'] == inv['id']);
                    });
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.eye, size: 16, color: _dark),
                        const SizedBox(width: 8),
                        Text('View Details', style: GoogleFonts.figtree(fontSize: 14, color: _dark)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.edit2, size: 16, color: _dark),
                        const SizedBox(width: 8),
                        Text('Edit', style: GoogleFonts.figtree(fontSize: 14, color: _dark)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                        const SizedBox(width: 8),
                        Text('Delete', style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFFEF4444))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 30),
              Row(
                children: [
                  const Icon(LucideIcons.graduationCap, size: 14, color: _muted),
                  const SizedBox(width: 6),
                  Text(inv['class'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(LucideIcons.tag, size: 14, color: _muted),
                  const SizedBox(width: 6),
                  Text(inv['type'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 14, color: _muted),
                  const SizedBox(width: 6),
                  Text(inv['due'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionStatus() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Collection Status', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('This Month', style: GoogleFonts.figtree(fontSize: 12, color: _dark, fontWeight: FontWeight.w500)),
                const SizedBox(width: 4), const Icon(LucideIcons.chevronDown, size: 14, color: _muted),
              ]),
            ),
          ]),
          const SizedBox(height: 32),
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 70,
                      startDegreeOffset: -90,
                      sections: [
                        PieChartSectionData(value: 68, title: '', color: const Color(0xFF8B5CF6), radius: 30),
                        PieChartSectionData(value: 17, title: '', color: const Color(0xFF3B82F6), radius: 30),
                        PieChartSectionData(value: 10, title: '', color: const Color(0xFFF59E0B), radius: 30),
                        PieChartSectionData(value: 5, title: '', color: const Color(0xFFEF4444), radius: 30),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('TOTAL', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _muted, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      Text('₹57.4L', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _dark)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          _legend('Paid', '₹39.0L', '68%', const Color(0xFF8B5CF6)),
          const SizedBox(height: 16),
          _legend('Partial', '₹9.8L', '17%', const Color(0xFF3B82F6)),
          const SizedBox(height: 16),
          _legend('Pending', '₹5.7L', '10%', const Color(0xFFF59E0B)),
          const SizedBox(height: 16),
          _legend('Overdue', '₹2.9L', '5%', const Color(0xFFEF4444)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFFFF6F6), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFCE1E1))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.alertCircle, size: 18, color: Color(0xFFEF4444)),
                    const SizedBox(width: 8),
                    Expanded(child: Text('126 overdue invoices need follow-up', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444)))),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Row(
                    children: [
                      Text('Send Reminders', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.arrowUpRight, size: 14, color: Color(0xFFEF4444)),
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

  Widget _legend(String label, String value, String percent, Color color) {
    return Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: GoogleFonts.figtree(fontSize: 14, color: _dark))),
      Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
      const SizedBox(width: 6),
      Text('·', style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
      const SizedBox(width: 6),
      Text(percent, style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
    ]);
  }

  Widget _buildCollectionTrendChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
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
                    Text('Fee Collection Trend', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 4),
                    Text('Invoiced vs Collected · last 6 months', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF8B5CF6), borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text('Invoiced', style: GoogleFonts.inter(fontSize: 12, color: _muted, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 16),
                  Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF22C55E), borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text('Collected', style: GoogleFonts.inter(fontSize: 12, color: _muted, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 120,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.white,
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    tooltipMargin: 8,
                    tooltipBorder: const BorderSide(color: Color(0xFFE5E7EB)),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
                      final month = months[group.x.toInt()];
                      final invoiced = group.barRods[0].toY.toInt();
                      final collected = group.barRods[1].toY.toInt();
                      return BarTooltipItem(
                        '$month\n',
                        GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark),
                        children: [
                          TextSpan(text: '\nInvoiced : $invoiced\n', style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF8B5CF6))),
                          TextSpan(text: '\nCollected : $collected', style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF22C55E))),
                        ],
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                        _touchedBarIndex = -1;
                        return;
                      }
                      _touchedBarIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, 
                      reservedSize: 40,
                      interval: 30,
                      getTitlesWidget: (v, _) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text('₹${v.toInt()}L', style: GoogleFonts.inter(fontSize: 11, color: _muted), textAlign: TextAlign.right),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, 
                      getTitlesWidget: (v, _) {
                        final months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
                        final idx = v.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: idx >= 0 && idx < months.length ? Text(months[idx], style: GoogleFonts.inter(fontSize: 12, color: _muted)) : const SizedBox(),
                        );
                      }
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false, 
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (_) => FlLine(color: _border.withValues(alpha: 0.3), strokeWidth: 1)
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _doubleBarGroup(0, 78, 65, _touchedBarIndex == 0),
                  _doubleBarGroup(1, 88, 74, _touchedBarIndex == 1),
                  _doubleBarGroup(2, 54, 54, _touchedBarIndex == 2),
                  _doubleBarGroup(3, 96, 82, _touchedBarIndex == 3),
                  _doubleBarGroup(4, 102, 88, _touchedBarIndex == 4),
                  _doubleBarGroup(5, 110, 94, _touchedBarIndex == 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _doubleBarGroup(int x, double y1, double y2, bool isTouched) {
    return BarChartGroupData(
      x: x,
      barsSpace: 4,
      barRods: [
        BarChartRodData(
          toY: y1, 
          color: const Color(0xFF8B5CF6), 
          width: 14, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: y2, 
          color: const Color(0xFF22C55E), 
          width: 14, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
      showingTooltipIndicators: isTouched ? [0] : [],
    );
  }

  Widget _buildOverdueByClass() {
    final overdueData = [
      {'class': 'Class 10', 'count': 42, 'percent': 0.84},
      {'class': 'Class 9', 'count': 31, 'percent': 0.62},
      {'class': 'Class 8', 'count': 24, 'percent': 0.48},
      {'class': 'Class 7', 'count': 18, 'percent': 0.36},
      {'class': 'Class 6', 'count': 11, 'percent': 0.22},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
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
                    Text('Overdue by Class', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 4),
                    Text('Distribution of overdue invoices', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    const Icon(LucideIcons.trendingUp, size: 14, color: Color(0xFFF43F5E)),
                    const SizedBox(width: 4),
                    Text('126 total', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFF43F5E))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...overdueData.map((data) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data['class'] as String, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
                        Row(
                          children: [
                            Text('${data['count']}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                            Text(' overdue', style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: data['percent'] as double,
                      backgroundColor: const Color(0xFFF3F4F6),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF43F5E)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _primary,
        unselectedItemColor: _muted,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
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
}


