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

class CollectFeeScreen extends StatefulWidget {
  const CollectFeeScreen({super.key});

  @override
  State<CollectFeeScreen> createState() => _CollectFeeScreenState();
}

class _CollectFeeScreenState extends State<CollectFeeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  String _selectedPaymentMode = 'UPI';
  bool _receiptGenerated = false;
  bool _showSummary = false;
  final _upiController = TextEditingController();
  final _txnRefController = TextEditingController();
  final _noteController = TextEditingController();
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
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 16, 20, _selectedStudent == null ? 80 : 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedStudent == null) ...[
                              _buildHeader(context),
                              const SizedBox(height: 20),
                              _buildCollectionAnalytics(),
                              const SizedBox(height: 16),
                              _buildSearchStudent(),
                              const SizedBox(height: 16),
                              _buildStudentList(),
                            ],
                            if (_selectedStudent != null && !_showSummary && !_receiptGenerated) ...[
                              _buildCollectionDetailsHeader(),
                              const SizedBox(height: 16),
                              _buildStudentInformationCard(),
                              const SizedBox(height: 16),
                              _buildOutstandingInvoicesCard(),
                              const SizedBox(height: 16),
                              _buildPaymentModeCard(),
                            ],
                            if (_selectedStudent != null && _showSummary && !_receiptGenerated) ...[
                              _buildSummaryHeader(),
                              const SizedBox(height: 16),
                              _buildPaymentSummaryCard(),
                              const SizedBox(height: 16),
                              _buildApplyDiscountCard(),
                              const SizedBox(height: 16),
                              _buildPaymentNoteCard(),
                            ],
                            if (_selectedStudent != null && _receiptGenerated) ...[
                              _buildReceiptView(),
                            ],
                          ],
                        ),
                      ),
                      if (_selectedStudent == null)
                        Positioned(
                          bottom: 0, left: 0, right: 0,
                          child: _buildStickyBottomBar(),
                        ),
                      if (_selectedStudent != null && !_showSummary && !_receiptGenerated)
                        Positioned(
                          bottom: 0, left: 0, right: 0,
                          child: _buildDetailsStickyBar(),
                        ),
                      if (_selectedStudent != null && _showSummary && !_receiptGenerated)
                        Positioned(
                          bottom: 0, left: 0, right: 0,
                          child: _buildSummaryStickyBar(),
                        ),
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
    return Column(
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
                  Text(
                    'Collect Fee',
                    style: GoogleFonts.figtree(fontSize: 28, fontWeight: FontWeight.bold, color: _dark, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Search student and collect fee payment securely.',
                    style: GoogleFonts.figtree(fontSize: 14, color: _muted, height: 1.4),
                  ),
                ],
              ),
            ),
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
        ),
      ],
    );
  }

  Widget _buildCollectionAnalytics() {
    final kpis = [
      {
        'label': 'Today\'s Collection', 'value': '₹1,24,500', 'trend': '↗ +₹18,200', 'sub': 'vs yesterday',
        'icon': LucideIcons.indianRupee, 'color': const Color(0xFF6366F1), 'bg': const Color(0xFFEEF2FF), 'trendColor': const Color(0xFF22C55E)
      },
      {
        'label': 'Pending Today', 'value': '₹86,400', 'trend': '— 34 invoices', 'sub': '',
        'icon': LucideIcons.clock, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFEF3C7), 'trendColor': const Color(0xFFEF4444)
      },
      {
        'label': 'Collections This Month', 'value': '₹18.6L', 'trend': '↗ 84.3% of target', 'sub': '',
        'icon': LucideIcons.trendingUp, 'color': const Color(0xFF22C55E), 'bg': const Color(0xFFDCFCE7), 'trendColor': const Color(0xFF22C55E)
      },
      {
        'label': 'Pending Students', 'value': '248', 'trend': '— 32 overdue', 'sub': '',
        'icon': LucideIcons.users, 'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEE2E2), 'trendColor': const Color(0xFFEF4444)
      },
    ];

    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: kpis.map((k) => _buildModernKPICard(k)).toList(),
    );
  }

  Widget _buildModernKPICard(Map<String, dynamic> k) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: k['bg'], borderRadius: BorderRadius.circular(12)),
                child: Icon(k['icon'] as IconData, size: 24, color: k['color']),
              ),
              Icon(LucideIcons.barChart2, size: 20, color: k['color'].withValues(alpha: 0.5)),
            ],
          ),
          const Spacer(),
          Text(k['label'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: _muted)),
          const SizedBox(height: 4),
          Text(k['value'], style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(k['trend'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: k['trendColor']), overflow: TextOverflow.ellipsis, maxLines: 1),
              ),
              if ((k['sub'] as String).isNotEmpty) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(k['sub'], style: GoogleFonts.figtree(fontSize: 11, color: k['trendColor']), overflow: TextOverflow.ellipsis, maxLines: 1),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildSearchStudent() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.figtree(fontSize: 14, color: _dark),
              decoration: InputDecoration(
                hintText: 'Search student by name, ID or class...',
                hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted),
                prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() { _selectedStudent = null; });
                        },
                        child: const Icon(LucideIcons.x, size: 16, color: _muted))
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            // Filter functionality for collect fee screen
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filter functionality to be implemented')));
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: const Icon(LucideIcons.filter, size: 20, color: _dark),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(10)),
                child: const Icon(LucideIcons.wallet, size: 20, color: _primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total Outstanding', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  Text('₹2,67,100', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text('Showing 12 of 12', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _border), borderRadius: BorderRadius.circular(6)),
                child: const Icon(LucideIcons.chevronUp, size: 16, color: _dark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final list = _filteredStudents;
    if (list.isEmpty) return Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('No students found', style: GoogleFonts.figtree(fontSize: 14, color: _muted))));
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('12 students found', style: GoogleFonts.figtree(fontSize: 13, color: _muted), overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatusChip('4 Overdue', const Color(0xFFEF4444), LucideIcons.alertCircle),
                  const SizedBox(width: 8),
                  _buildStatusChip('4 Partial', const Color(0xFF22C55E), LucideIcons.checkCircle2),
                ],
              )
            ],
          ),
        ),
        ...list.map((s) => _buildNewStudentCard(s)),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildNewStudentCard(Map<String, dynamic> s) {
    final initials = s['name'].toString().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
    final name = s['name'].toString();
    String status = 'Pending';
    Color statusColor = const Color(0xFFF59E0B);
    Color statusBg = const Color(0xFFFEF3C7);
    String overdueText = '';
    
    if (name.contains('Aarav') || name.contains('Ananya')) {
      status = 'Overdue';
      statusColor = const Color(0xFFEF4444);
      statusBg = const Color(0xFFFEE2E2);
      overdueText = '12d overdue';
    } else if (name.contains('Kabir') || name.contains('Saanvi')) {
      status = 'Partial';
      statusColor = const Color(0xFF0EA5E9);
      statusBg = const Color(0xFFE0F2FE);
    }
    
    final avatarColors = [const Color(0xFFEEF2FF), const Color(0xFFFEF3C7), const Color(0xFFE0F2FE), const Color(0xFFF3E8FF)];
    final avatarTextColor = [const Color(0xFF6366F1), const Color(0xFFF59E0B), const Color(0xFF0EA5E9), const Color(0xFF9333EA)];
    final colorIdx = name.length % avatarColors.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: avatarColors[colorIdx],
                child: Text(initials, style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: avatarTextColor[colorIdx])),
              ),
              const SizedBox(width: 16),
              
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 4),
                    Text(s['id'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    const SizedBox(height: 12),
                    Text(s['class'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                  ],
                ),
              ),
              
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Due', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                    const SizedBox(height: 4),
                    Text('₹${(s['totalDue'] as int).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 4),
                    Text('Due: 30 Apr 2025', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                    if (overdueText.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(overdueText, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFFEF4444))),
                    ],
                  ],
                ),
              ),
              
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                      child: Text(status, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => setState(() { _selectedStudent = s; _receiptGenerated = false; }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.indianRupee, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('Collect', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Positioned(
            right: 0,
            top: 0,
            child: Icon(Icons.more_horiz, size: 20, color: _muted),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionDetailsHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() { _selectedStudent = null; _showSummary = false; _receiptGenerated = false; }),
          child: const Icon(LucideIcons.arrowLeft, size: 24, color: Colors.black87),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Collection Details', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
            Text('Review, apply discounts and record payment', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ],
        ),
      ],
    );
  }

  Widget _buildStudentInformationCard() {
    final s = _selectedStudent!;
    final initials = s['name'].toString().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
    return Container(
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
            children: [
              Text('Student Information', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                child: Text('Active', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: _primary)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEEF2FF),
                child: Text(initials, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _primary)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['name'], style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                  const SizedBox(height: 4),
                  Text(s['class'] ?? 'Class', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
                  Text('Roll No. ${s['roll']}', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _infoRow(LucideIcons.hash, 'Admission No.', s['id']),
          const SizedBox(height: 16),
          _infoRow(LucideIcons.graduationCap, 'Academic Year', 'AY 2025–26'),
          const SizedBox(height: 16),
          _infoRow(LucideIcons.user, 'Parent / Guardian', 'Rajesh Sharma'),
          const SizedBox(height: 16),
          _infoRow(LucideIcons.phone, 'Contact', '+91 98210 44312'),
          const SizedBox(height: 16),
          _infoRow(LucideIcons.mail, 'Email', 'rajesh.sharma@gmail.com'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: _muted),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
              const SizedBox(height: 2),
              Text(value, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark), overflow: TextOverflow.ellipsis, maxLines: 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOutstandingInvoicesCard() {
    final s = _selectedStudent!;
    final items = (s['dueItems'] as List<dynamic>?) ?? [];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Outstanding Invoices', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
              Text('${items.length} selected', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Select invoices to include in this collection.', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          const SizedBox(height: 20),
          ...items.map((item) {
            final status = item['status'] ?? 'Pending';
            final id = item['id'] ?? 'INV-2025-0881';
            final due = item['due'] ?? '10 Apr 2025';
            
            Color statusColor = const Color(0xFF22C55E);
            Color statusBg = const Color(0xFFDCFCE7);
            if (status == 'Pending') { statusColor = const Color(0xFFF59E0B); statusBg = const Color(0xFFFEF3C7); }
            else if (status == 'Partial') { statusColor = const Color(0xFF0EA5E9); statusBg = const Color(0xFFE0F2FE); }
            else if (status == 'Overdue') { statusColor = const Color(0xFFEF4444); statusBg = const Color(0xFFFEE2E2); }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 20, height: 20,
                    decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(6)),
                    child: const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['type'] ?? 'Fee', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
                        const SizedBox(height: 2),
                        Text(id, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${((item['amount'] ?? 0) as int).toStringAsFixed(2).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]},")}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                        child: Text(status, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                      ),
                      const SizedBox(height: 4),
                      Text('Due: $due', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                    ],
                  ),
                ],
              ),
            );
          }),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('View all invoices', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
                Icon(LucideIcons.chevronRight, size: 16, color: _dark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentModeCard() {
    final modes = ['Cash', 'UPI', 'Card', 'Bank\nTransfer', 'Cheque'];
    final displayModes = ['Cash', 'UPI', 'Card', 'Bank Transfer', 'Cheque'];
    final icons = [LucideIcons.banknote, LucideIcons.smartphone, LucideIcons.creditCard, LucideIcons.building2, LucideIcons.fileText];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Mode', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: modes.length,
            itemBuilder: (context, i) {
              final sel = _selectedPaymentMode == displayModes[i];
              return GestureDetector(
                onTap: () => setState(() => _selectedPaymentMode = displayModes[i]),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFEEF2FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: sel ? _primary : _border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[i], size: 20, color: sel ? _primary : _muted),
                      const SizedBox(height: 6),
                      Text(
                        displayModes[i],
                        style: GoogleFonts.figtree(fontSize: 11, fontWeight: sel ? FontWeight.w600 : FontWeight.normal, color: sel ? _primary : _dark),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_selectedPaymentMode == 'UPI') ...[
            const SizedBox(height: 20),
            _buildInputField('UPI ID / VPA', 'e.g. 9821044312@ybl', _upiController),
            const SizedBox(height: 16),
            _buildInputField('Transaction Reference ID (Optional)', 'e.g. T2505121024XYZ', _txnRefController),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment Date', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('12/05/2025', style: GoogleFonts.figtree(fontSize: 14, color: _dark)),
                      Icon(LucideIcons.calendar, size: 16, color: _dark),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: GoogleFonts.figtree(fontSize: 14, color: _dark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsStickyBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _border))),
      child: GestureDetector(
        onTap: () => setState(() => _showSummary = true),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          child: Text('Continue to Summary', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showSummary = false),
          child: const Icon(LucideIcons.arrowLeft, size: 24, color: Colors.black87),
        ),
        const SizedBox(width: 16),
        Text('Payment Summary', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
      ],
    );
  }

  Widget _buildPaymentSummaryCard() {
    final s = _selectedStudent!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Summary', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
              Row(
                children: [
                  Icon(LucideIcons.smartphone, size: 14, color: _primary),
                  const SizedBox(width: 6),
                  Text(_selectedPaymentMode, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _muted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _summaryRow('Student', s['name']),
          _summaryRow('Class', s['class'] ?? 'Class'),
          _summaryRow('Invoices', '4 selected'),
          _summaryRow('Subtotal', '₹27,200.00'),
          _summaryRow('Discount', '–'),
          _summaryRow('Late Fee', '+ ₹250.00', isAdd: true),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Payable', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                Text('₹27,450.00', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isAdd = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
          Text(value, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: isAdd ? const Color(0xFFEF4444) : _dark)),
        ],
      ),
    );
  }

  Widget _buildApplyDiscountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Apply Discount', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(LucideIcons.tag, size: 14, color: _primary),
              const SizedBox(width: 8),
              Text('Discount Scheme', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('None', style: GoogleFonts.figtree(fontSize: 14, color: _dark)),
                Icon(LucideIcons.chevronDown, size: 16, color: _muted),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _summaryRow('Subtotal (selected invoices)', '₹27,200.00'),
                _summaryRow('Discount', '–'),
                _summaryRow('Late Fee (overdue invoices)', '+ ₹250.00', isAdd: true),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Payable', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
                    Text('₹27,450.00', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _primary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFEF9C3), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFEF08A))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.info, size: 16, color: Color(0xFFCA8A04)),
                const SizedBox(width: 8),
                Expanded(child: Text('A late fee of ₹250 has been applied for the overdue invoices.', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFFA16207)))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentNoteCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Payment Note', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(width: 4),
              Text('(Optional)', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            maxLines: 4,
            style: GoogleFonts.figtree(fontSize: 14, color: _dark),
            decoration: InputDecoration(
              hintText: 'Add a note...',
              hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primary)),
            ),
          ),
          const SizedBox(height: 8),
          Align(alignment: Alignment.centerRight, child: Text('0/150', style: GoogleFonts.figtree(fontSize: 11, color: _muted))),
        ],
      ),
    );
  }

  Widget _buildSummaryStickyBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _border))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Payable', style: GoogleFonts.figtree(fontSize: 12, color: _dark)),
              Text('₹27,450.00', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
            ],
          ),
          GestureDetector(
            onTap: () => setState(() => _receiptGenerated = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(12)),
              child: Text('Collect Payment', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptView() {
    final s = _selectedStudent!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFDCFCE7))),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                child: const Icon(LucideIcons.check, size: 24, color: Color(0xFF16A34A)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Successful', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _dark)),
                  Text('Receipt saved to student records.', style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sunrise Academy', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                    Text('Fee Receipt', style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
                  ],
                ),
                const SizedBox(height: 24),
                _receiptRow('Receipt No.', 'RCPT-2025-3847', isBold: true),
                _receiptRow('Student', s['name'], isBold: true),
                _receiptRow('Class', s['class'] ?? 'Class', isBold: true),
                _receiptRow('Amount Paid', '₹27,450.00', isBold: true, isAmount: true),
                _receiptRow('Mode', _selectedPaymentMode, isBold: true),
                _receiptRow('Date', '12 May 2025', isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _receiptActionBtn(LucideIcons.download, 'Download')),
              const SizedBox(width: 12),
              Expanded(child: _receiptActionBtn(LucideIcons.printer, 'Print')),
              const SizedBox(width: 12),
              Expanded(child: _receiptActionBtn(LucideIcons.share2, 'Share')),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => setState(() { _selectedStudent = null; _showSummary = false; _receiptGenerated = false; }),
            child: Text('Back to Collect Fees', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _primary)),
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isBold = false, bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
          Text(value, style: GoogleFonts.figtree(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: isAmount ? _primary : _dark)),
        ],
      ),
    );
  }

  Widget _receiptActionBtn(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: _dark),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
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
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF595973),
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
