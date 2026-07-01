import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Set<String> _collectedStudentIds = {};

  List<Map<String, dynamic>> _students = [
    {'name': 'Aarav Sharma', 'class': 'Class 5A', 'id': 'ADM-2025-0112', 'roll': '01', 'totalDue': 18500, 'status': 'Overdue', 'due': '30 Apr 2025', 'overdueDays': '12d overdue', 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 18000, 'period': 'Q3 2025-26', 'status': 'Overdue', 'id': 'INV-2025-0881', 'due': '30 Apr 2025'},
      {'type': 'Library Fee', 'amount': 500, 'period': 'Annual', 'status': 'Overdue', 'id': 'INV-2025-0882', 'due': '30 Apr 2025'},
    ]},
    {'name': 'Diya Nair', 'class': 'Class 8B', 'id': 'ADM-2025-0287', 'roll': '09', 'totalDue': 24000, 'status': 'Pending', 'due': '15 May 2025', 'overdueDays': '', 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 24000, 'period': 'Q3 2025-26', 'status': 'Pending', 'id': 'INV-2025-0910', 'due': '15 May 2025'},
    ]},
    {'name': 'Kabir Singh', 'class': 'Class 10A', 'id': 'ADM-2025-0341', 'roll': '14', 'totalDue': 32000, 'status': 'Partial', 'due': '01 May 2025', 'overdueDays': '', 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 20000, 'period': 'Q3 2025-26', 'status': 'Partial', 'id': 'INV-2025-0920', 'due': '01 May 2025'},
      {'type': 'Transport Fee', 'amount': 12000, 'period': 'Annual', 'status': 'Partial', 'id': 'INV-2025-0921', 'due': '01 May 2025'},
    ]},
    {'name': 'Ananya Reddy', 'class': 'Class 7C', 'id': 'ADM-2025-0198', 'roll': '03', 'totalDue': 9800, 'status': 'Overdue', 'due': '28 Apr 2025', 'overdueDays': '14d overdue', 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 9800, 'period': 'Q3 2025-26', 'status': 'Overdue', 'id': 'INV-2025-0884', 'due': '28 Apr 2025'},
    ]},
    {'name': 'Rohan Mehta', 'class': 'Class 9B', 'id': 'ADM-2025-0455', 'roll': '21', 'totalDue': 28500, 'status': 'Pending', 'due': '10 May 2025', 'overdueDays': '', 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 28500, 'period': 'Q3 2025-26', 'status': 'Pending', 'id': 'INV-2025-0955', 'due': '10 May 2025'},
    ]},
    {'name': 'Saanvi Iyer', 'class': 'Class 6A', 'id': 'ADM-2025-0523', 'roll': '17', 'totalDue': 7200, 'status': 'Partial', 'due': '12 May 2025', 'overdueDays': '', 'dueItems': [
      {'type': 'Tuition Fee', 'amount': 7200, 'period': 'Q3 2025-26', 'status': 'Partial', 'id': 'INV-2025-0971', 'due': '12 May 2025'},
    ]},
  ];

  String _selectedClass = 'All Classes';
  String _selectedStatus = 'All Status';

  List<Map<String, dynamic>> get _filteredStudents {
    return _students.where((s) {
      final matchSearch = _searchController.text.isEmpty ||
        s['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
        s['id'].toString().toLowerCase().contains(_searchController.text.toLowerCase());
      final matchClass = _selectedClass == 'All Classes' || s['class'].toString().contains(_selectedClass);
      final matchStatus = _selectedStatus == 'All Status' || s['status'] == _selectedStatus;
      return matchSearch && matchClass && matchStatus;
    }).toList();
  }

  
  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  
  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__students_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _students = decoded.map((item) {
          final map = Map<String, dynamic>.from(item);
          for (final key in map.keys.toList()) {
            if (key.toLowerCase().contains('color') && map[key] is int) {
              map[key] = Color(map[key] as int);
            }
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _students.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__students_data', jsonEncode(serialized));
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildCollectionAnalytics(),
                        const SizedBox(height: 16),
                        _buildSearchStudent(),
                        const SizedBox(height: 16),
                        _buildStudentList(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Collect Fee',
                style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(height: 4),
              Text('Search students with outstanding dues and record fee collections instantly.',
                style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(LucideIcons.indianRupee, size: 14, color: Colors.white),
              const SizedBox(width: 6),
              Text('Quick Collect',
                style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            ]),
          ),
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
    final hasFilter = _selectedClass != 'All Classes' || _selectedStatus != 'All Status';
    return Column(
      children: [
        // Search bar — full width, no button
        Container(
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
              hintText: 'Search by name, admission no...',
              hintStyle: GoogleFonts.figtree(fontSize: 13, color: _muted),
              prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () { _searchController.clear(); setState(() {}); },
                      child: const Icon(LucideIcons.x, size: 16, color: _muted))
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Compact dropdowns row
        Row(
          children: [
            Expanded(child: _buildCompactDropdown(
              value: _selectedClass,
              items: ['All Classes', 'Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'],
              onChanged: (v) => setState(() => _selectedClass = v!),
            )),
            const SizedBox(width: 8),
            Expanded(child: _buildCompactDropdown(
              value: _selectedStatus,
              items: ['All Status', 'Overdue', 'Pending', 'Partial'],
              onChanged: (v) => setState(() => _selectedStatus = v!),
            )),
            if (hasFilter) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() { _selectedClass = 'All Classes'; _selectedStatus = 'All Status'; }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(LucideIcons.x, size: 13, color: Color(0xFFEF4444)),
                    const SizedBox(width: 4),
                    Text('Clear', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
                  ]),
                ),
              ),
            ],
          ],

        ),
      ],
    );
  }

  // Compact height dropdown
  Widget _buildCompactDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    final isActive = value != items.first;
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFEEF2FF) : Colors.white,
        border: Border.all(color: isActive ? _primary.withValues(alpha: 0.5) : _border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          icon: Icon(LucideIcons.chevronDown, size: 14, color: isActive ? _primary : _muted),
          style: GoogleFonts.figtree(fontSize: 12, color: isActive ? _primary : _dark, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.figtree(fontSize: 12, color: _dark)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Filter bottom sheet
  void _showFilterSheet(BuildContext context) {
    String tempClass = _selectedClass;
    String tempStatus = _selectedStatus;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(4)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter Students', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                  GestureDetector(
                    onTap: () => setSheet(() { tempClass = 'All Classes'; tempStatus = 'All Status'; }),
                    child: Text('Clear All', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Class', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: ['All Classes', 'Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'].map((c) {
                  final sel = tempClass == c;
                  return GestureDetector(
                    onTap: () => setSheet(() => tempClass = c),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: sel ? _primary : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(c, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : _muted)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text('Status', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['All Status', 'Overdue', 'Pending', 'Partial'].map((st) {
                  final sel = tempStatus == st;
                  Color chipColor = _primary;
                  if (st == 'Overdue') chipColor = const Color(0xFFEF4444);
                  else if (st == 'Pending') chipColor = const Color(0xFFF59E0B);
                  else if (st == 'Partial') chipColor = const Color(0xFF0EA5E9);
                  return GestureDetector(
                    onTap: () => setSheet(() => tempStatus = st),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: sel ? chipColor : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(st, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : _muted)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text('Cancel', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _muted)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() { _selectedClass = tempClass; _selectedStatus = tempStatus; });
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text('Apply Filters', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown, size: 16),
          style: GoogleFonts.figtree(fontSize: 13, color: _dark),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.figtree(fontSize: 13, color: _dark)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }


  Widget _buildStickyBottomBar() {
    final total = _students.fold<int>(0, (sum, s) => sum + (s['totalDue'] as int));
    final formatted = total.toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.figtree(fontSize: 13, color: _dark),
              children: [
                const TextSpan(text: 'Total outstanding: '),
                TextSpan(
                  text: '₹$formatted',
                  style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark),
                ),
              ],
            ),
          ),
          Text(
            'Showing ${_filteredStudents.length} of ${_students.length} students',
            style: GoogleFonts.figtree(fontSize: 13, color: _muted),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final list = _filteredStudents;
    final total = _students.fold<int>(0, (sum, s) => sum + (s['totalDue'] as int));
    final formatted = total.toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    final overdueCount = list.where((s) => s['status'] == 'Overdue').length;
    final partialCount = list.where((s) => s['status'] == 'Partial').length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Students with Outstanding Dues',
                    style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (overdueCount > 0) ...[
                      _buildStatusChip('$overdueCount overdue', const Color(0xFFEF4444), LucideIcons.xCircle),
                      const SizedBox(width: 6),
                    ],
                    if (partialCount > 0)
                      _buildStatusChip('$partialCount partial', const Color(0xFF22C55E), LucideIcons.checkCircle2),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          // ── Student cards
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(child: Text('No students found', style: GoogleFonts.figtree(fontSize: 14, color: _muted))),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: list.map((s) => _buildNewStudentCard(s)).toList(),
              ),
            ),
          // ── Total outstanding footer
          Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.indianRupee, size: 16, color: Color(0xFF6366F1)),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.figtree(fontSize: 13, color: _dark),
                        children: [
                          const TextSpan(text: 'Total outstanding: '),
                          TextSpan(
                            text: '₹$formatted',
                            style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_filteredStudents.length} of ${_students.length} students',
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
        ],
      ),
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
    final status = s['status'] as String? ?? 'Pending';

    Color statusColor = const Color(0xFFF59E0B);
    Color statusBg = const Color(0xFFFFF8E6);
    if (status == 'Overdue') {
      statusColor = const Color(0xFFEF4444);
      statusBg = const Color(0xFFFEE2E2);
    } else if (status == 'Partial') {
      statusColor = const Color(0xFF0EA5E9);
      statusBg = const Color(0xFFE0F2FE);
    }

    final avatarColors = [
      const Color(0xFFEEF2FF), const Color(0xFFFEF3C7), const Color(0xFFDCFCE7),
      const Color(0xFFFEE2E2), const Color(0xFFF3E8FF), const Color(0xFFE0F2FE),
    ];
    final avatarTextColors = [
      const Color(0xFF6366F1), const Color(0xFFF59E0B), const Color(0xFF22C55E),
      const Color(0xFFEF4444), const Color(0xFF9333EA), const Color(0xFF0EA5E9),
    ];
    final colorIdx = name.length % avatarColors.length;
    final amount = (s['totalDue'] as int)
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── 1. Avatar circle
            CircleAvatar(
              radius: 26,
              backgroundColor: avatarColors[colorIdx],
              child: Text(
                initials,
                style: GoogleFonts.figtree(
                    fontSize: 15, fontWeight: FontWeight.bold, color: avatarTextColors[colorIdx]),
              ),
            ),
            const SizedBox(width: 14),

            // ── 2. Name / Admission ID / Class (takes remaining space)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.figtree(
                          fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                  const SizedBox(height: 3),
                  Text(s['id'],
                      style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                  const SizedBox(height: 6),
                  Text(s['class'],
                      style: GoogleFonts.figtree(
                          fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // ── 3. Total Due label + ₹amount + status badge (center-right fixed)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Due',
                    style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                const SizedBox(height: 3),
                Text('₹$amount',
                    style: GoogleFonts.figtree(
                        fontSize: 19, fontWeight: FontWeight.bold, color: _dark)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.figtree(
                        fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // ── 4. ··· dots at top + Collect / Collected button below
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _showStudentOptions(context, s),
                  child: const Icon(Icons.more_horiz, size: 22, color: Color(0xFFB0B0C0)),
                ),
                const SizedBox(height: 12),
                if (_collectedStudentIds.contains(s['id']))
                  // Collected — green, non-interactive
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded, size: 15, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          'Collected',
                          style: GoogleFonts.figtree(
                              fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _showCollectBottomSheet(context, s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                          color: _primary, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Collect',
                        style: GoogleFonts.figtree(
                            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // ── Three-dot bottom sheet: View / Edit / Delete
  void _showStudentOptions(BuildContext context, Map<String, dynamic> s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFEEF2FF),
                    child: Text(
                      s['name'].toString().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                      style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                      Text('${s['id']}  •  ${s['class']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 8),
              // View option
              _optionTile(
                icon: LucideIcons.eye,
                label: 'View Details',
                color: _dark,
                onTap: () {
                  Navigator.pop(context);
                  _showCollectBottomSheet(context, s);
                },
              ),
              // Collect option
              _optionTile(
                icon: LucideIcons.indianRupee,
                label: 'Collect Fee',
                color: _primary,
                onTap: () {
                  Navigator.pop(context);
                  _showCollectBottomSheet(context, s);
                },
              ),
              // Edit option
              _optionTile(
                icon: LucideIcons.pencil,
                label: 'Edit Student',
                color: const Color(0xFFF59E0B),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Edit ${s['name']}', style: GoogleFonts.figtree()),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              // Delete option
              _optionTile(
                icon: LucideIcons.trash2,
                label: 'Delete Record',
                color: const Color(0xFFEF4444),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, s);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _optionTile({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      title: Text(label, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
      trailing: Icon(LucideIcons.chevronRight, size: 16, color: color.withValues(alpha: 0.5)),
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Record', style: GoogleFonts.figtree(fontWeight: FontWeight.bold, color: _dark)),
        content: Text(
          'Are you sure you want to delete the fee record for ${s['name']}? This action cannot be undone.',
          style: GoogleFonts.figtree(fontSize: 14, color: _muted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.figtree(color: _muted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${s['name']} record deleted', style: GoogleFonts.figtree()),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: GoogleFonts.figtree(fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Opens collection details as a modal bottom sheet popup
  void _showCollectBottomSheet(BuildContext context, Map<String, dynamic> student) {
    bool sheetShowSummary = false;
    bool sheetReceiptGenerated = false;
    String sheetPaymentMode = 'UPI';

    // Set selectedStudent so _buildPaymentSummaryCard / _buildApplyDiscountCard work
    setState(() => _selectedStudent = student);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(

        builder: (ctx, setSheet) {
          final s = student;
          final initials = s['name'].toString().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
          final amount = (s['totalDue'] as int).toStringAsFixed(0)
              .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
          final status = s['status'] as String? ?? 'Pending';
          Color statusColor = const Color(0xFFF59E0B);
          if (status == 'Overdue') statusColor = const Color(0xFFEF4444);
          if (status == 'Partial') statusColor = const Color(0xFF0EA5E9);

          return Container(
            height: MediaQuery.of(context).size.height * 0.92,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // ── Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4)),
                ),
                // ── Sheet header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (sheetReceiptGenerated || (!sheetShowSummary)) {
                            Navigator.pop(ctx);
                          } else {
                            setSheet(() => sheetShowSummary = false);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _border),
                          ),
                          child: const Icon(LucideIcons.arrowLeft, size: 18, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sheetReceiptGenerated ? 'Payment Receipt' : sheetShowSummary ? 'Payment Summary' : 'Collect Fee',
                              style: GoogleFonts.figtree(fontSize: 17, fontWeight: FontWeight.bold, color: _dark),
                            ),
                            Text(
                              sheetReceiptGenerated ? 'Receipt saved to student records' : sheetShowSummary ? 'Review and confirm payment' : 'Review dues and record payment',
                              style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                            ),
                          ],
                        ),
                      ),
                      // Student pill badge
                      if (!sheetReceiptGenerated)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(status, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                // ── Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [
                        if (sheetReceiptGenerated) ...[
                          // ── Receipt View
                          _sheetReceiptView(s, sheetPaymentMode, () {
                            Navigator.pop(ctx);
                          }),
                        ] else if (sheetShowSummary) ...[
                          // ── Summary
                          _sheetStudentInfoRow(s, initials, amount, statusColor, status),
                          const SizedBox(height: 16),
                          _buildPaymentSummaryCard(),
                          const SizedBox(height: 16),
                          _buildApplyDiscountCard(),
                          const SizedBox(height: 16),
                          _buildPaymentNoteCard(),
                          const SizedBox(height: 100),
                        ] else ...[
                          // ── Details
                          _sheetStudentInfoRow(s, initials, amount, statusColor, status),
                          const SizedBox(height: 16),
                          _buildOutstandingInvoicesCard(),
                          const SizedBox(height: 16),
                          _sheetPaymentModeCard(sheetPaymentMode, (v) => setSheet(() => sheetPaymentMode = v)),
                          const SizedBox(height: 100),
                        ],
                      ],
                    ),
                  ),
                ),
                // ── Bottom action bar
                if (!sheetReceiptGenerated)
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: _border)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, -4))],
                    ),
                    child: sheetShowSummary
                        ? Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Total Payable', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                                  Text('₹27,450', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _collectedStudentIds.add(s['id'] as String));
                                    setSheet(() => sheetReceiptGenerated = true);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(14)),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(LucideIcons.indianRupee, size: 16, color: Colors.white),
                                        const SizedBox(width: 6),
                                        Text('Collect Payment', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () => setSheet(() => sheetShowSummary = true),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(14)),
                              alignment: Alignment.center,
                              child: Text('Continue to Summary →', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                  ),
              ],
            ),
          );
        },
      ),
    ).then((_) {
      if (mounted) setState(() => _selectedStudent = null);
    });
  }


  // Small student summary row shown at top of both Details and Summary steps
  Widget _sheetStudentInfoRow(Map<String, dynamic> s, String initials, String amount, Color statusColor, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFEEF2FF),
            child: Text(initials, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                Text('${s['class']}  ·  ${s['id']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹$amount', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Payment mode selector for the sheet (stateless-friendly)
  Widget _sheetPaymentModeCard(String selectedMode, ValueChanged<String> onChanged) {
    final modes = ['Cash', 'UPI', 'Card', 'Bank Transfer', 'Cheque'];
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
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
            ),
            itemCount: modes.length,
            itemBuilder: (context, i) {
              final sel = selectedMode == modes[i];
              return GestureDetector(
                onTap: () => onChanged(modes[i]),
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
                      Text(modes[i], style: GoogleFonts.figtree(fontSize: 11, fontWeight: sel ? FontWeight.w600 : FontWeight.normal, color: sel ? _primary : _dark), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
          if (selectedMode == 'UPI') ...[
            const SizedBox(height: 20),
            _buildInputField('UPI ID / VPA', 'e.g. 9821044312@ybl', _upiController),
            const SizedBox(height: 16),
            _buildInputField('Transaction Reference (Optional)', 'e.g. T2505121024XYZ', _txnRefController),
          ],
        ],
      ),
    );
  }

  // Receipt view inside the sheet
  Widget _sheetReceiptView(Map<String, dynamic> s, String paymentMode, VoidCallback onDone) {
    return Column(
      children: [
        // Success banner
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, size: 28, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Successful!', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('Receipt saved to student records', style: GoogleFonts.figtree(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Receipt card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sunrise Academy', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                  Text('Fee Receipt', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
                ],
              ),
              const SizedBox(height: 20),
              _receiptRow('Receipt No.', 'RCPT-2025-3847'),
              _receiptRow('Student', s['name']),
              _receiptRow('Class', s['class'] ?? 'Class'),
              _receiptRow('Amount Paid', '₹27,450.00', isBold: true, isAmount: true),
              _receiptRow('Mode', paymentMode),
              _receiptRow('Date', '12 May 2025'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Action buttons
        Row(
          children: [
            Expanded(child: _receiptActionBtn(LucideIcons.download, 'Download')),
            const SizedBox(width: 10),
            Expanded(child: _receiptActionBtn(LucideIcons.printer, 'Print')),
            const SizedBox(width: 10),
            Expanded(child: _receiptActionBtn(LucideIcons.share2, 'Share')),
          ],
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onDone,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: Text('Done', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionDetailsHeader() {
    return const SizedBox.shrink();
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
            onTap: () => setState(() {
              _receiptGenerated = true;
              if (_selectedStudent != null) {
                _collectedStudentIds.add(_selectedStudent!['id'] as String);
              }
            }),
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
