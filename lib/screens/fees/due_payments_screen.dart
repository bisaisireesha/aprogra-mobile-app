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

class DuePaymentsScreen extends StatefulWidget {
  const DuePaymentsScreen({super.key});

  @override
  State<DuePaymentsScreen> createState() => _DuePaymentsScreenState();
}

class _DuePaymentsScreenState extends State<DuePaymentsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedSort = 'Oldest First';
  String _selectedClass = 'All Classes';
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> _dues = [
    {'name': 'Meera Nair', 'class': 'Class 10B', 'id': 'STU-028', 'amount': 41200, 'daysOverdue': 42, 'type': 'Tuition Fee', 'phone': '+91 98765 43210', 'reminded': false},
    {'name': 'Rohan Verma', 'class': 'Class 9B', 'id': 'STU-045', 'amount': 32500, 'daysOverdue': 28, 'type': 'Hostel Fee', 'phone': '+91 87654 32109', 'reminded': true},
    {'name': 'Ishaan Patel', 'class': 'Class 8C', 'id': 'STU-012', 'amount': 27400, 'daysOverdue': 15, 'type': 'Tuition Fee', 'phone': '+91 76543 21098', 'reminded': false},
    {'name': 'Anaya Bose', 'class': 'Class 7A', 'id': 'STU-067', 'amount': 18750, 'daysOverdue': 21, 'type': 'Transport Fee', 'phone': '+91 65432 10987', 'reminded': true},
    {'name': 'Aditya Reddy', 'class': 'Class 6A', 'id': 'STU-089', 'amount': 15800, 'daysOverdue': 9, 'type': 'Exam Fee', 'phone': '+91 54321 09876', 'reminded': false},
    {'name': 'Kavya Singh', 'class': 'Class 11C', 'id': 'STU-103', 'amount': 28000, 'daysOverdue': 35, 'type': 'Tuition Fee', 'phone': '+91 43210 98765', 'reminded': false},
    {'name': 'Vijay Kumar', 'class': 'Class 12A', 'id': 'STU-118', 'amount': 5600, 'daysOverdue': 7, 'type': 'Misc', 'phone': '+91 32109 87654', 'reminded': true},
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _dues.where((d) {
      final classMatch = _selectedClass == 'All Classes' || d['class'] == _selectedClass;
      final searchMatch = _searchController.text.isEmpty ||
        d['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
        d['id'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      return classMatch && searchMatch;
    }).toList();

    list.sort((a, b) => _selectedSort == 'Oldest First'
        ? (b['daysOverdue'] as int).compareTo(a['daysOverdue'] as int)
        : (a['amount'] as int).compareTo(b['amount'] as int));
    return list;
  }

  int get _totalDue => _dues.fold(0, (sum, d) => sum + (d['amount'] as int));
  int get _criticalCount => _dues.where((d) => (d['daysOverdue'] as int) > 30).length;

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
                const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 0), child: CommonAppBar(showMenu: false)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildSummaryCards(),
                        const SizedBox(height: 20),
                        _buildFilters(),
                        const SizedBox(height: 16),
                        ..._filtered.asMap().entries.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDueCard(e.value, e.key),
                        )),
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
        Text('Due Payments', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        Text('Students with overdue fees requiring follow-up', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
      ])),
      GestureDetector(
        onTap: _sendBulkReminders,
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(LucideIcons.bell, size: 14, color: Color(0xFFF59E0B)),
            const SizedBox(width: 6),
            Text('Remind All', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFF59E0B))),
          ])),
      ),
    ]);
  }

  void _sendBulkReminders() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(LucideIcons.bell, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        Text('Reminders sent to all ${_dues.length} students!', style: GoogleFonts.figtree(color: Colors.white)),
      ]),
      backgroundColor: const Color(0xFFF59E0B),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Widget _buildSummaryCards() {
    return Row(children: [
      Expanded(child: _summaryCard('Total Outstanding', '₹${(_totalDue / 100000).toStringAsFixed(2)}L', LucideIcons.alertCircle, const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
      const SizedBox(width: 12),
      Expanded(child: _summaryCard('Students Overdue', '${_dues.length}', LucideIcons.users, const Color(0xFFF59E0B), const Color(0xFFFFF7ED))),
      const SizedBox(width: 12),
      Expanded(child: _summaryCard('Critical (>30d)', '$_criticalCount', LucideIcons.alertTriangle, const Color(0xFFDC2626), const Color(0xFFFEF2F2))),
    ]);
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: color)),
        const SizedBox(height: 10),
        Text(value, style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _muted), maxLines: 2),
      ]),
    );
  }

  Widget _buildFilters() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
        child: TextField(controller: _searchController, onChanged: (_) => setState(() {}), style: GoogleFonts.figtree(fontSize: 14, color: _dark),
          decoration: InputDecoration(hintText: 'Search student or ID...', hintStyle: GoogleFonts.figtree(fontSize: 13, color: _muted), prefixIcon: const Icon(LucideIcons.search, size: 16, color: _muted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _filterDropdown(_selectedClass, ['All Classes', 'Class 6A', 'Class 7A', 'Class 8C', 'Class 9B', 'Class 10B', 'Class 11C', 'Class 12A'], (v) => setState(() => _selectedClass = v))),
        const SizedBox(width: 10),
        Expanded(child: _filterDropdown(_selectedSort, ['Oldest First', 'Amount'], (v) => setState(() => _selectedSort = v))),
      ]),
    ]);
  }

  Widget _filterDropdown(String value, List<String> items, ValueChanged<String> onChanged) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 8),
          ...items.map((item) => ListTile(title: Text(item, style: GoogleFonts.figtree(fontSize: 14, color: item == value ? _primary : _dark, fontWeight: item == value ? FontWeight.w600 : FontWeight.normal)),
            trailing: item == value ? Icon(LucideIcons.check, size: 16, color: _primary) : null, onTap: () { onChanged(item); Navigator.pop(context); })),
          const SizedBox(height: 16),
        ])),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
        child: Row(children: [
          Expanded(child: Text(value, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500, color: _dark), overflow: TextOverflow.ellipsis)),
          const Icon(LucideIcons.chevronDown, size: 12, color: _muted),
        ])),
    );
  }

  Widget _buildDueCard(Map<String, dynamic> due, int idx) {
    final days = due['daysOverdue'] as int;
    final isCritical = days > 30;
    final isWarning = days > 14;
    final cardColor = isCritical ? const Color(0xFFEF4444) : isWarning ? const Color(0xFFF59E0B) : const Color(0xFF22C55E);
    final cardBg = isCritical ? const Color(0xFFFEF2F2) : isWarning ? const Color(0xFFFFF7ED) : const Color(0xFFF0FDF4);
    bool reminded = due['reminded'] as bool;

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: cardColor.withValues(alpha: 0.25)),
        boxShadow: [BoxShadow(color: cardColor.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))]),
      child: Column(children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), decoration: BoxDecoration(color: cardColor, borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(isCritical ? LucideIcons.alertTriangle : LucideIcons.clock, size: 11, color: Colors.white),
            const SizedBox(width: 4),
            Text(isCritical ? 'CRITICAL — $days days overdue' : '$days days overdue', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
          ])),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 20, backgroundColor: cardBg,
                child: Text(due['name'].toString().substring(0, 1), style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: cardColor))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(due['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
                Text('${due['class']} · ${due['id']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                Text(due['type'], style: GoogleFonts.figtree(fontSize: 11, color: cardColor, fontWeight: FontWeight.w500)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('₹${(due['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                Text('Due Amount', style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
              ]),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: StatefulBuilder(builder: (ctx, ss) => GestureDetector(
                onTap: () {
                  ss(() => due['reminded'] = true);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Reminder sent to ${due['name']}', style: GoogleFonts.figtree(color: Colors.white)),
                    backgroundColor: const Color(0xFFF59E0B), behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: due['reminded'] ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8), border: Border.all(color: due['reminded'] ? const Color(0xFF22C55E).withValues(alpha: 0.3) : const Color(0xFFF59E0B).withValues(alpha: 0.3))),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(due['reminded'] ? LucideIcons.checkCircle : LucideIcons.bell, size: 13, color: due['reminded'] ? const Color(0xFF22C55E) : const Color(0xFFF59E0B)),
                    const SizedBox(width: 5),
                    Text(due['reminded'] ? 'Reminded' : 'Send Reminder', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: due['reminded'] ? const Color(0xFF22C55E) : const Color(0xFFF59E0B))),
                  ]),
                ),
              ))),
              const SizedBox(width: 8),
              Expanded(child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: _primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: _primary.withValues(alpha: 0.3))),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(LucideIcons.wallet, size: 13, color: _primary),
                  const SizedBox(width: 5),
                  Text('Collect Fee', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _primary)),
                ]),
              )),
            ]),
          ]),
        ),
      ]),
    );
  }
}
