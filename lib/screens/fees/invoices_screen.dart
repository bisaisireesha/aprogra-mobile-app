import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'create_invoice_modal.dart';

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
  final _searchController = TextEditingController();

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
    if (widget.showCreate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showCreateInvoiceModal();
      });
    }
  }

  void _showCreateInvoiceModal() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: const CreateInvoiceModal(),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _invoices.insert(0, result);
      });
    }
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
                  child: _buildInvoiceList(),
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
            Text('Invoices', style: GoogleFonts.figtree(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF181821))),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.download, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 8),
                      Text('Export', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF475569))),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _showCreateInvoiceModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('Create Invoice', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Browse, filter, and manage all student invoices across classes and terms.', style: GoogleFonts.figtree(fontSize: 15, color: const Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildKPIs() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final kpis = [
          {'label': 'Total Invoices', 'value': '18', 'icon': LucideIcons.fileText, 'color': const Color(0xFF6366F1), 'bgColor': const Color(0xFFEEEDFD)},
          {'label': 'Paid', 'value': '7', 'icon': LucideIcons.checkCircle2, 'color': const Color(0xFF22C55E), 'bgColor': const Color(0xFFEAF8F0)},
          {'label': 'Pending', 'value': '4', 'icon': LucideIcons.clock, 'color': const Color(0xFFF59E0B), 'bgColor': const Color(0xFFFEF3E1)},
          {'label': 'Overdue', 'value': '4', 'icon': LucideIcons.alertCircle, 'color': const Color(0xFFEF4444), 'bgColor': const Color(0xFFFDE8E8)},
        ];

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildKPICard(kpis[0])),
                  const SizedBox(width: 12),
                  Expanded(child: _buildKPICard(kpis[1])),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildKPICard(kpis[2])),
                  const SizedBox(width: 12),
                  Expanded(child: _buildKPICard(kpis[3])),
                ],
              ),
            ],
          );
        }

        return Row(
          children: kpis.asMap().entries.map((e) {
            final idx = e.key;
            final k = e.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: idx < 3 ? 16.0 : 0),
                child: _buildKPICard(k),
              ),
            );
          }).toList(),
        );
      }
    );
  }

  Widget _buildKPICard(Map<String, dynamic> k) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: k['bgColor'] as Color, borderRadius: BorderRadius.circular(12)),
            child: Icon(k['icon'] as IconData, size: 24, color: k['color'] as Color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(k['value'] as String, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF181821))),
                const SizedBox(height: 4),
                Text(k['label'] as String, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF64748B))),
              ],
            ),
          ),
        ],
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
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildKPIs(),
              const SizedBox(height: 24),
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
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
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