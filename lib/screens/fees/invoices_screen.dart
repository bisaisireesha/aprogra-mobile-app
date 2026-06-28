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

class InvoicesScreen extends StatefulWidget {
  final bool showCreate;
  const InvoicesScreen({super.key, this.showCreate = false});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _showCreateForm = false;
  final _searchController = TextEditingController();
  String _selectedStatus = 'All';

  final List<Map<String, dynamic>> _invoices = [
    {'id': 'INV-2025-1041', 'student': 'Aryan Reddy', 'class': 'Class 6A', 'type': 'Tuition Fee', 'due': '10 May 2025', 'issued': '01 Apr 2025', 'amount': 24500, 'status': 'Paid', 'paidOn': '05 May 2025'},
    {'id': 'INV-2025-1040', 'student': 'Priya Sharma', 'class': 'Class 8B', 'type': 'Hostel Fee', 'due': '10 May 2025', 'issued': '01 Apr 2025', 'amount': 18000, 'status': 'Pending', 'paidOn': null},
    {'id': 'INV-2025-1039', 'student': 'Rohan Mehta', 'class': 'Class 10A', 'type': 'Transport', 'due': '05 May 2025', 'issued': '01 Apr 2025', 'amount': 4500, 'status': 'Overdue', 'paidOn': null},
    {'id': 'INV-2025-1038', 'student': 'Ananya Iyer', 'class': 'Class 7C', 'type': 'Tuition Fee', 'due': '10 May 2025', 'issued': '01 Apr 2025', 'amount': 24500, 'status': 'Paid', 'paidOn': '08 May 2025'},
    {'id': 'INV-2025-1037', 'student': 'Kiran Nair', 'class': 'Class 9B', 'type': 'Exam Fee', 'due': '15 May 2025', 'issued': '01 Apr 2025', 'amount': 2000, 'status': 'Pending', 'paidOn': null},
    {'id': 'INV-2025-1036', 'student': 'Meera Gupta', 'class': 'Class 11A', 'type': 'Tuition Fee', 'due': '10 May 2025', 'issued': '01 Apr 2025', 'amount': 28000, 'status': 'Paid', 'paidOn': '03 May 2025'},
    {'id': 'INV-2025-1035', 'student': 'Aditya Kumar', 'class': 'Class 12B', 'type': 'Misc', 'due': '01 May 2025', 'issued': '01 Apr 2025', 'amount': 1200, 'status': 'Overdue', 'paidOn': null},
    {'id': 'INV-2025-1034', 'student': 'Sneha Patel', 'class': 'Class 5A', 'type': 'Tuition Fee', 'due': '10 May 2025', 'issued': '01 Apr 2025', 'amount': 20000, 'status': 'Paid', 'paidOn': '09 May 2025'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    if (widget.showCreate) _showCreateForm = true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    final status = ['All', 'Paid', 'Pending', 'Overdue'][_tabController.index];
    return _invoices.where((inv) {
      final statusMatch = status == 'All' || inv['status'] == status;
      final searchMatch = _searchController.text.isEmpty ||
        inv['student'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
        inv['id'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      return statusMatch && searchMatch;
    }).toList();
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
                  child: _showCreateForm ? _buildCreateForm() : _buildInvoiceList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      _scaffoldKey.currentState?.openDrawer();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                    child: Icon(Navigator.canPop(context) ? LucideIcons.arrowLeft : LucideIcons.menu, size: 18, color: _dark),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text('Invoices', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark))),
                GestureDetector(
                  onTap: () => setState(() => _showCreateForm = true),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text('Create', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                    ])),
                ),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(LucideIcons.layers, size: 14, color: _dark),
                    const SizedBox(width: 6),
                    Text('Bulk', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                  ])),
              ]),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                  decoration: InputDecoration(
                    hintText: 'Search invoice, student or receipt no.',
                    hintStyle: GoogleFonts.figtree(fontSize: 13, color: _muted),
                    prefixIcon: const Icon(LucideIcons.search, size: 16, color: _muted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TabBar(
                controller: _tabController,
                onTap: (_) => setState(() {}),
                indicatorColor: _primary,
                labelColor: _primary,
                unselectedLabelColor: _muted,
                labelStyle: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.figtree(fontSize: 13),
                tabs: ['All', 'Paid', 'Pending', 'Overdue'].map((t) {
                  final count = t == 'All' ? _invoices.length : _invoices.where((i) => i['status'] == t).length;
                  return Tab(text: '$t ($count)');
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(4, (_) => _buildInvoiceListView()),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceListView() {
    final items = _filtered;
    if (items.isEmpty) return Center(child: Text('No invoices', style: GoogleFonts.figtree(fontSize: 14, color: _muted)));
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildInvoiceCard(items[i]),
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> inv) {
    Color statusColor;
    Color statusBg;
    IconData statusIcon;
    switch (inv['status']) {
      case 'Paid': statusColor = const Color(0xFF16A34A); statusBg = const Color(0xFFF0FDF4); statusIcon = LucideIcons.checkCircle; break;
      case 'Overdue': statusColor = const Color(0xFFDC2626); statusBg = const Color(0xFFFEF2F2); statusIcon = LucideIcons.alertCircle; break;
      default: statusColor = const Color(0xFFD97706); statusBg = const Color(0xFFFFFBEB); statusIcon = LucideIcons.clock;
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(inv['id'], style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _primary, letterSpacing: 0.3)),
            const SizedBox(height: 2),
            Text(inv['student'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
            Text('${inv['class']} · ${inv['type']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('₹${inv['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(statusIcon, size: 11, color: statusColor),
                const SizedBox(width: 4),
                Text(inv['status'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor)),
              ])),
          ]),
        ]),
        const SizedBox(height: 12),
        const Divider(height: 1, color: _border),
        const SizedBox(height: 10),
        Row(children: [
          Icon(LucideIcons.calendar, size: 12, color: _muted),
          const SizedBox(width: 4),
          Text('Due: ${inv['due']}', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
          const Spacer(),
          if (inv['status'] != 'Paid') ...[
            _actionChip('Send Reminder', LucideIcons.bell, const Color(0xFFF59E0B)),
            const SizedBox(width: 8),
            _actionChip('Collect', LucideIcons.wallet, _primary),
          ] else ...[
            _actionChip('View Receipt', LucideIcons.fileText, const Color(0xFF22C55E)),
            const SizedBox(width: 8),
            _actionChip('Download', LucideIcons.download, _muted),
          ],
        ]),
      ]),
    );
  }

  Widget _actionChip(String label, IconData icon, Color color) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ]));
  }

  Widget _buildCreateForm() {
    final feeTypes = ['Tuition Fee', 'Transport Fee', 'Hostel Fee', 'Exam Fee', 'Library Fee', 'Misc'];
    String selectedType = 'Tuition Fee';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: StatefulBuilder(builder: (ctx, ss) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          GestureDetector(onTap: () => setState(() => _showCreateForm = false),
            child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
              child: const Icon(LucideIcons.arrowLeft, size: 18, color: _dark))),
          const SizedBox(width: 12),
          Text('Create Invoice', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        ]),
        const SizedBox(height: 24),
        _formSection('Student Details', [
          _formField('Student Name / ID', LucideIcons.user),
          const SizedBox(height: 12),
          _formField('Class', LucideIcons.graduationCap),
        ]),
        const SizedBox(height: 20),
        _formSection('Fee Details', [
          Text('Fee Type', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w500, color: _dark)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: feeTypes.map((t) => GestureDetector(
            onTap: () => ss(() => selectedType = t),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: selectedType == t ? _primary.withValues(alpha: 0.1) : Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: selectedType == t ? _primary : _border, width: selectedType == t ? 1.5 : 1)),
              child: Text(t, style: GoogleFonts.figtree(fontSize: 12, fontWeight: selectedType == t ? FontWeight.w600 : FontWeight.normal, color: selectedType == t ? _primary : _dark))),
          )).toList()),
          const SizedBox(height: 12),
          _formField('Amount (₹)', LucideIcons.indianRupee, keyboard: TextInputType.number),
          const SizedBox(height: 12),
          _formField('Due Date', LucideIcons.calendar),
          const SizedBox(height: 12),
          _formField('Academic Period', LucideIcons.bookOpen),
        ]),
        const SizedBox(height: 20),
        _formSection('Additional Notes', [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
            child: TextField(maxLines: 3, style: GoogleFonts.figtree(fontSize: 14, color: _dark),
              decoration: InputDecoration(hintText: 'Optional remarks or notes...', hintStyle: GoogleFonts.figtree(fontSize: 13, color: _muted), border: InputBorder.none, contentPadding: const EdgeInsets.all(14))),
          ),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _showCreateForm = false),
            child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Text('Cancel', textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark))),
          )),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Container(
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Material(color: Colors.transparent, child: InkWell(onTap: () => setState(() => _showCreateForm = false), borderRadius: BorderRadius.circular(12),
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(LucideIcons.filePlus, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text('Generate Invoice', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ])))),
          )),
        ]),
        const SizedBox(height: 60),
      ])),
    );
  }

  Widget _formSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 14),
        ...children,
      ]),
    );
  }

  Widget _formField(String label, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500, color: _muted)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: _border), color: const Color(0xFFFAFAFC)),
        child: TextField(keyboardType: keyboard, style: GoogleFonts.figtree(fontSize: 14, color: _dark),
          decoration: InputDecoration(prefixIcon: Icon(icon, size: 16, color: _muted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12))),
      ),
    ]);
  }
}
