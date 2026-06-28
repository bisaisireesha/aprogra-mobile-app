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

class CollectFeeScreen extends StatefulWidget {
  const CollectFeeScreen({super.key});

  @override
  State<CollectFeeScreen> createState() => _CollectFeeScreenState();
}

class _CollectFeeScreenState extends State<CollectFeeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String _selectedPaymentMode = 'Online / UPI';
  String _selectedFeeType = 'Tuition Fee';
  bool _partialPayment = false;
  double _partialAmount = 0;
  bool _receiptGenerated = false;
  Map<String, dynamic>? _selectedStudent;

  final List<Map<String, dynamic>> _students = [
    {'name': 'Aryan Reddy', 'class': 'Class 6A', 'id': 'STU-001', 'roll': '06', 'totalDue': 24500, 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 18000, 'period': 'Q3 2025-26'},
      {'type': 'Library Fee', 'amount': 1500, 'period': 'Annual'},
      {'type': 'Exam Fee', 'amount': 5000, 'period': 'Mid-Term'},
    ]},
    {'name': 'Priya Sharma', 'class': 'Class 8B', 'id': 'STU-002', 'roll': '18', 'totalDue': 18000, 'dueItems': [
      {'type': 'Hostel Fee', 'amount': 15000, 'period': 'Q3 2025-26'},
      {'type': 'Mess Fee', 'amount': 3000, 'period': 'March 2025'},
    ]},
    {'name': 'Rohan Mehta', 'class': 'Class 10A', 'id': 'STU-003', 'roll': '12', 'totalDue': 4500, 'dueItems': [
      {'type': 'Transport Fee', 'amount': 4500, 'period': 'Q3 2025-26'},
    ]},
    {'name': 'Ananya Iyer', 'class': 'Class 7C', 'id': 'STU-004', 'roll': '03', 'totalDue': 24500, 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 24500, 'period': 'Q3 2025-26'},
    ]},
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchController.text.isEmpty) return _students;
    return _students.where((s) =>
      s['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
      s['id'].toString().toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        const SizedBox(height: 20),
                        _buildCollectionAnalytics(),
                        const SizedBox(height: 16),
                        if (_selectedStudent == null) ...[
                          _buildDuesChart(),
                          const SizedBox(height: 16),
                        ],
                        _buildSearchStudent(),
                        const SizedBox(height: 16),
                        if (_selectedStudent == null) _buildStudentList(),
                        if (_selectedStudent != null) ...[
                          _buildStudentCard(),
                          const SizedBox(height: 20),
                          _buildFeeSelectionCard(),
                          const SizedBox(height: 20),
                          _buildPaymentModeCard(),
                          const SizedBox(height: 20),
                          if (_receiptGenerated) _buildReceiptCard(),
                          if (!_receiptGenerated) _buildCollectButton(),
                          const SizedBox(height: 60),
                        ],
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
            child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 18, color: _dark),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Collect Fee', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
          Text('Search student and collect fee payment', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(LucideIcons.calendarDays, size: 14, color: _primary),
            const SizedBox(width: 6),
            Text('2025-26', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _primary)),
          ]),
        ),
      ],
    );
  }

  Widget _buildCollectionAnalytics() {
    return Row(
      children: [
        Expanded(child: _miniStatTile('Today\'s Pot', '₹1.24L', const Color(0xFF22C55E), LucideIcons.trendingUp)),
        const SizedBox(width: 10),
        Expanded(child: _miniStatTile('Remaining', '₹8.74L', const Color(0xFFF59E0B), LucideIcons.clock)),
        const SizedBox(width: 10),
        Expanded(child: _miniStatTile('Paid Invoices', '14', const Color(0xFF6366F1), LucideIcons.checkCheck)),
      ],
    );
  }

  Widget _miniStatTile(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
              Icon(icon, size: 12, color: color.withValues(alpha: 0.7)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDuesChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  Text('Outstanding Dues by Class', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                  Text('Distribution of remaining dues', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                ],
              ),
              const Icon(LucideIcons.barChart3, size: 16, color: _primary),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 6,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (v, _) => Text('₹${v.toInt()}L', style: GoogleFonts.inter(fontSize: 9, color: _muted)))),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                    final classes = ['C6', 'C7', 'C8', 'C9', 'C10', 'C11', 'C12'];
                    final idx = v.toInt();
                    return idx >= 0 && idx < classes.length ? Text(classes[idx], style: GoogleFonts.inter(fontSize: 9, color: _muted)) : const SizedBox();
                  })),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: _border.withValues(alpha: 0.5), strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _barGroup(0, 3.6, const Color(0xFF6366F1)),
                  _barGroup(1, 3.9, const Color(0xFF3B82F6)),
                  _barGroup(2, 4.4, const Color(0xFF10B981)),
                  _barGroup(3, 4.9, const Color(0xFFF59E0B)),
                  _barGroup(4, 5.8, const Color(0xFFEF4444)),
                  _barGroup(5, 5.2, const Color(0xFF8B5CF6)),
                  _barGroup(6, 5.6, const Color(0xFFEC4899)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildSearchStudent() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: GoogleFonts.figtree(fontSize: 14, color: _dark),
        decoration: InputDecoration(
          hintText: 'Search student by name, ID or class...',
          hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted),
          prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(onTap: () { _searchController.clear(); setState(() { _selectedStudent = null; }); },
                  child: const Icon(LucideIcons.x, size: 16, color: _muted))
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildStudentList() {
    final list = _filteredStudents;
    if (list.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('No students found', style: GoogleFonts.figtree(fontSize: 14, color: _muted))));
    return Column(
      children: list.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap: () => setState(() { _selectedStudent = s; _receiptGenerated = false; }),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
            child: Row(children: [
              CircleAvatar(radius: 22, backgroundColor: const Color(0xFFEEF2FF),
                child: Text(s['name'].toString().substring(0, 1), style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _primary))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
                Text('${s['class']} · Roll ${s['roll']} · ${s['id']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('₹${(s['totalDue'] as int).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                Text('Due', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
              ]),
              const SizedBox(width: 8),
              const Icon(LucideIcons.chevronRight, size: 16, color: _muted),
            ]),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildStudentCard() {
    final s = _selectedStudent!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(children: [
        CircleAvatar(radius: 26, backgroundColor: Colors.white.withValues(alpha: 0.2),
          child: Text(s['name'].toString().substring(0, 1), style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(s['name'], style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('${s['class']} · Roll ${s['roll']}', style: GoogleFonts.figtree(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
          Text(s['id'], style: GoogleFonts.figtree(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
        ])),
        GestureDetector(
          onTap: () => setState(() { _selectedStudent = null; _receiptGenerated = false; }),
          child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
            child: const Icon(LucideIcons.x, size: 16, color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _buildFeeSelectionCard() {
    final s = _selectedStudent!;
    final items = s['dueItems'] as List<Map<String, dynamic>>;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fee Items Due', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 4),
        Text('Select items to collect payment for', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        const SizedBox(height: 16),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: _primary, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item['type'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
              Text(item['period'], style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
            ])),
            Text('₹${item['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
          ]),
        )),
        const Divider(color: _border),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total Due', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          Text('₹${s['totalDue'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
            style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _primary)),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Switch(value: _partialPayment, onChanged: (v) => setState(() { _partialPayment = v; _partialAmount = 0; }), activeColor: _primary),
          const SizedBox(width: 8),
          Text('Partial Payment', style: GoogleFonts.figtree(fontSize: 13, color: _dark)),
        ]),
        if (_partialPayment) ...[
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (v) => setState(() => _partialAmount = double.tryParse(v) ?? 0),
            style: GoogleFonts.figtree(fontSize: 14, color: _dark),
            decoration: InputDecoration(
              hintText: 'Enter partial amount',
              hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted),
              prefixText: '₹ ',
              prefixStyle: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: _primary, width: 2)),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildPaymentModeCard() {
    final modes = ['Online / UPI', 'Cash', 'Cheque', 'Bank Transfer', 'Card'];
    final icons = [LucideIcons.smartphone, LucideIcons.banknote, LucideIcons.fileText, LucideIcons.building2, LucideIcons.creditCard];
    final colors = [const Color(0xFF6366F1), const Color(0xFF22C55E), const Color(0xFFF59E0B), const Color(0xFF3B82F6), const Color(0xFFEF4444)];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Payment Mode', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, children: List.generate(modes.length, (i) {
          final sel = _selectedPaymentMode == modes[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedPaymentMode = modes[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? colors[i].withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: sel ? colors[i] : _border, width: sel ? 1.5 : 1),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icons[i], size: 15, color: sel ? colors[i] : _muted),
                const SizedBox(width: 6),
                Text(modes[i], style: GoogleFonts.figtree(fontSize: 12, fontWeight: sel ? FontWeight.w600 : FontWeight.normal, color: sel ? colors[i] : _dark)),
              ]),
            ),
          );
        })),
      ]),
    );
  }

  Widget _buildCollectButton() {
    final s = _selectedStudent!;
    final amount = _partialPayment && _partialAmount > 0 ? _partialAmount : (s['totalDue'] as int).toDouble();
    return Column(children: [
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 5))],
        ),
        child: Material(color: Colors.transparent, child: InkWell(
          onTap: () => setState(() => _receiptGenerated = true),
          borderRadius: BorderRadius.circular(14),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(LucideIcons.wallet, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text('Collect ₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} via $_selectedPaymentMode',
              style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ])),
        )),
      ),
    ]);
  }

  Widget _buildReceiptCard() {
    final s = _selectedStudent!;
    final amount = _partialPayment && _partialAmount > 0 ? _partialAmount : (s['totalDue'] as int).toDouble();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Column(children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF22C55E), shape: BoxShape.circle),
            child: const Icon(LucideIcons.check, size: 20, color: Colors.white)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Payment Successful!', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF16A34A))),
            Text('Receipt generated automatically', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF15803D))),
          ])),
        ]),
        const SizedBox(height: 16),
        const Divider(color: Color(0xFF86EFAC)),
        const SizedBox(height: 12),
        _receiptRow('Receipt No.', 'RCP-2025-${DateTime.now().millisecond}'),
        _receiptRow('Student', s['name']),
        _receiptRow('Class', s['class']),
        _receiptRow('Amount', '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'),
        _receiptRow('Mode', _selectedPaymentMode),
        _receiptRow('Date', '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _receiptBtn('Print Receipt', LucideIcons.printer, Colors.white, const Color(0xFF16A34A))),
          const SizedBox(width: 10),
          Expanded(child: _receiptBtn('Send to Parent', LucideIcons.send, const Color(0xFF16A34A), Colors.white, outlined: true)),
        ]),
      ]),
    );
  }

  Widget _receiptRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF15803D))),
      Text(value, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF14532D))),
    ]),
  );

  Widget _receiptBtn(String label, IconData icon, Color fg, Color bg, {bool outlined = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : bg,
        borderRadius: BorderRadius.circular(10),
        border: outlined ? Border.all(color: fg) : null,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 15, color: outlined ? fg : bg == Colors.white ? const Color(0xFF16A34A) : Colors.white),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: outlined ? fg : bg == Colors.white ? const Color(0xFF16A34A) : Colors.white)),
      ]),
    );
  }
}
