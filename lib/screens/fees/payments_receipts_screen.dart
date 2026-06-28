import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class PaymentsReceiptsScreen extends StatefulWidget {
  const PaymentsReceiptsScreen({super.key});

  @override
  State<PaymentsReceiptsScreen> createState() => _PaymentsReceiptsScreenState();
}

class _PaymentsReceiptsScreenState extends State<PaymentsReceiptsScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  String _selectedMode = 'All Modes';
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _transactions = [
    {'id': 'RCP-2025-3201', 'student': 'Aarav Mehta', 'class': 'VIII-B', 'type': 'Tuition Fee', 'mode': 'UPI', 'amount': 24500, 'date': 'Nov 24, 2025', 'time': '10:42 AM', 'status': 'Success'},
    {'id': 'RCP-2025-3200', 'student': 'Diya Sharma', 'class': 'X-A', 'type': 'Hostel Fee', 'mode': 'Card', 'amount': 31200, 'date': 'Nov 24, 2025', 'time': '09:15 AM', 'status': 'Success'},
    {'id': 'RCP-2025-3199', 'student': 'Kabir Khan', 'class': 'VI-C', 'type': 'Transport', 'mode': 'Bank Transfer', 'amount': 4500, 'date': 'Nov 23, 2025', 'time': '03:30 PM', 'status': 'Success'},
    {'id': 'RCP-2025-3198', 'student': 'Saanvi Iyer', 'class': 'IX-A', 'type': 'Tuition Fee', 'mode': 'UPI', 'amount': 27800, 'date': 'Nov 23, 2025', 'time': '11:55 AM', 'status': 'Success'},
    {'id': 'RCP-2025-3197', 'student': 'Vivaan Gupta', 'class': 'VII-B', 'type': 'Exam Fee', 'mode': 'Cash', 'amount': 2000, 'date': 'Nov 22, 2025', 'time': '02:10 PM', 'status': 'Success'},
    {'id': 'RCP-2025-3196', 'student': 'Anaya Bose', 'class': 'VII-A', 'type': 'Tuition Fee', 'mode': 'UPI', 'amount': 24500, 'date': 'Nov 22, 2025', 'time': '08:45 AM', 'status': 'Refunded'},
    {'id': 'RCP-2025-3195', 'student': 'Ishaan Patel', 'class': 'VIII-C', 'type': 'Library Fee', 'mode': 'Card', 'amount': 1500, 'date': 'Nov 21, 2025', 'time': '04:00 PM', 'status': 'Success'},
    {'id': 'RCP-2025-3194', 'student': 'Meera Nair', 'class': 'X-B', 'type': 'Activity Fee', 'mode': 'Cash', 'amount': 800, 'date': 'Nov 21, 2025', 'time': '01:20 PM', 'status': 'Success'},
  ];

  List<Map<String, dynamic>> get _filtered {
    return _transactions.where((t) {
      final modeMatch = _selectedMode == 'All Modes' || t['mode'] == _selectedMode;
      final searchMatch = _searchController.text.isEmpty ||
        t['student'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
        t['id'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      return modeMatch && searchMatch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 0), child: CommonAppBar(showMenu: false)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 16),
                      _buildSummaryRow(),
                      const SizedBox(height: 14),
                      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                        child: TextField(controller: _searchController, onChanged: (_) => setState(() {}), style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                          decoration: InputDecoration(hintText: 'Search receipt, student name...', hintStyle: GoogleFonts.figtree(fontSize: 13, color: _muted), prefixIcon: const Icon(LucideIcons.search, size: 16, color: _muted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
                      const SizedBox(height: 10),
                      SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['All Modes', 'UPI', 'Cash', 'Card', 'Bank Transfer'].map((m) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedMode = m),
                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: _selectedMode == m ? _primary : Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _selectedMode == m ? _primary : _border)),
                            child: Text(m, style: GoogleFonts.figtree(fontSize: 12, fontWeight: _selectedMode == m ? FontWeight.w600 : FontWeight.normal, color: _selectedMode == m ? Colors.white : _dark))),
                        ),
                      )).toList())),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _buildReceiptCard(_filtered[i]),
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
        child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
          child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 18, color: _dark))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Payments & Receipts', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        Text('All payment transactions and receipts', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
      ])),
      Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(LucideIcons.download, size: 14, color: _dark),
          const SizedBox(width: 6),
          Text('Export', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
        ])),
    ]);
  }

  Widget _buildSummaryRow() {
    final total = _transactions.where((t) => t['status'] == 'Success').fold(0, (s, t) => s + (t['amount'] as int));
    final refunded = _transactions.where((t) => t['status'] == 'Refunded').fold(0, (s, t) => s + (t['amount'] as int));
    return Row(children: [
      Expanded(child: _summaryTile('Total Collected', '₹${(total / 1000).toStringAsFixed(1)}K', const Color(0xFF22C55E), const Color(0xFFF0FDF4))),
      const SizedBox(width: 10),
      Expanded(child: _summaryTile('Transactions', '${_transactions.length}', _primary, const Color(0xFFEEF2FF))),
      const SizedBox(width: 10),
      Expanded(child: _summaryTile('Refunded', '₹${(refunded / 1000).toStringAsFixed(1)}K', const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
    ]);
  }

  Widget _summaryTile(String label, String value, Color color, Color bg) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
      ]));
  }

  Widget _buildReceiptCard(Map<String, dynamic> t) {
    final isRefunded = t['status'] == 'Refunded';
    final modeColors = {'UPI': const Color(0xFF6366F1), 'Cash': const Color(0xFF22C55E), 'Card': const Color(0xFF3B82F6), 'Bank Transfer': const Color(0xFF8B5CF6)};
    final modeIcons = {'UPI': LucideIcons.smartphone, 'Cash': LucideIcons.banknote, 'Card': LucideIcons.creditCard, 'Bank Transfer': LucideIcons.building2};
    final modeColor = modeColors[t['mode']] ?? _primary;
    final modeIcon = modeIcons[t['mode']] ?? LucideIcons.wallet;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isRefunded ? const Color(0xFFEF4444).withValues(alpha: 0.2) : _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: modeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(modeIcon, size: 18, color: modeColor)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t['student'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
            Text('${t['class']} · ${t['type']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(isRefunded ? '-₹${(t['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}' : '+₹${(t['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: isRefunded ? const Color(0xFFEF4444) : const Color(0xFF22C55E))),
            Container(margin: const EdgeInsets.only(top: 3), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: isRefunded ? const Color(0xFFFEF2F2) : const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10)),
              child: Text(t['status'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: isRefunded ? const Color(0xFFDC2626) : const Color(0xFF16A34A)))),
          ]),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1, color: _border),
        const SizedBox(height: 8),
        Row(children: [
          Icon(LucideIcons.receipt, size: 11, color: _muted),
          const SizedBox(width: 4),
          Text(t['id'], style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _muted)),
          const Spacer(),
          Icon(LucideIcons.calendar, size: 11, color: _muted),
          const SizedBox(width: 4),
          Text('${t['date']} · ${t['time']}', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {},
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(6)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(LucideIcons.download, size: 10, color: _primary),
                const SizedBox(width: 4),
                Text('PDF', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _primary)),
              ])),
          ),
        ]),
      ]),
    );
  }
}
