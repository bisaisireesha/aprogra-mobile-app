import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'create_invoice_modal.dart';
import 'invoice_details_modal.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/app_bottom_nav.dart';

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

class _InvoicesScreenState extends State<InvoicesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();

  String _selectedClass = 'All Classes';
  String _selectedStatus = 'All Status';
  String _selectedTab = 'All';
  int _currentPage = 1;
  static const _pageSize = 10;

  List<Map<String, dynamic>> _invoices = [
    {
      'id': 'INV-2025-1041',
      'student': 'Aryan Reddy',
      'class': 'Class 6A',
      'type': 'Tuition Fee',
      'issued': '01 Apr 2025',
      'due': '10 May 2025',
      'amount': 24500,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1042',
      'student': 'Saanvi Iyer',
      'class': 'Class 9B',
      'type': 'Hostel Fee',
      'issued': '02 Apr 2025',
      'due': '12 May 2025',
      'amount': 6800,
      'status': 'Pending',
    },
    {
      'id': 'INV-2025-1043',
      'student': 'Rohan Mehta',
      'class': 'Class 10A',
      'type': 'Transport',
      'issued': '28 Mar 2025',
      'due': '28 Apr 2025',
      'amount': 3200,
      'status': 'Overdue',
    },
    {
      'id': 'INV-2025-1044',
      'student': 'Ishita Kapoor',
      'class': 'Class 7C',
      'type': 'Exam Fee',
      'issued': '03 Apr 2025',
      'due': '15 May 2025',
      'amount': 22000,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1045',
      'student': 'Kabir Sharma',
      'class': 'Class 8B',
      'type': 'Tuition Fee',
      'issued': '01 Apr 2025',
      'due': '02 May 2025',
      'amount': 38400,
      'status': 'Pending',
    },
    {
      'id': 'INV-2025-1046',
      'student': 'Anaya Verma',
      'class': 'Class 5A',
      'type': 'Library Fee',
      'issued': '25 Mar 2025',
      'due': '30 Apr 2025',
      'amount': 19800,
      'status': 'Overdue',
    },
    {
      'id': 'INV-2025-1047',
      'student': 'Vihaan Joshi',
      'class': 'Class 10B',
      'type': 'Misc',
      'issued': '05 Apr 2025',
      'due': '18 May 2025',
      'amount': 4500,
      'status': 'Draft',
    },
    {
      'id': 'INV-2025-1048',
      'student': 'Meera Nair',
      'class': 'Class 4A',
      'type': 'Tuition Fee',
      'issued': '06 Apr 2025',
      'due': '20 May 2025',
      'amount': 21000,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1049',
      'student': 'Arjun Singh',
      'class': 'Class 3B',
      'type': 'Transport',
      'issued': '10 Apr 2025',
      'due': '25 May 2025',
      'amount': 2200,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1050',
      'student': 'Divya Menon',
      'class': 'Class 4A',
      'type': 'Hostel Fee',
      'issued': '12 Apr 2025',
      'due': '10 May 2025',
      'amount': 18000,
      'status': 'Overdue',
    },
    {
      'id': 'INV-2025-1051',
      'student': 'Sneha Patel',
      'class': 'Class 5A',
      'type': 'Tuition Fee',
      'issued': '14 Apr 2025',
      'due': '28 May 2025',
      'amount': 20000,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1052',
      'student': 'Kiran Nair',
      'class': 'Class 9B',
      'type': 'Exam Fee',
      'issued': '15 Apr 2025',
      'due': '30 May 2025',
      'amount': 2000,
      'status': 'Pending',
    },
    {
      'id': 'INV-2025-1053',
      'student': 'Meera Gupta',
      'class': 'Class 11A',
      'type': 'Tuition Fee',
      'issued': '16 Apr 2025',
      'due': '01 Jun 2025',
      'amount': 28000,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1054',
      'student': 'Aditya Kumar',
      'class': 'Class 12B',
      'type': 'Misc',
      'issued': '17 Apr 2025',
      'due': '05 Jun 2025',
      'amount': 1200,
      'status': 'Overdue',
    },
    {
      'id': 'INV-2025-1055',
      'student': 'Priya Sharma',
      'class': 'Class 8B',
      'type': 'Hostel Fee',
      'issued': '18 Apr 2025',
      'due': '10 Jun 2025',
      'amount': 18000,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1056',
      'student': 'Rahul Verma',
      'class': 'Class 7C',
      'type': 'Tuition Fee',
      'issued': '19 Apr 2025',
      'due': '15 Jun 2025',
      'amount': 24500,
      'status': 'Pending',
    },
    {
      'id': 'INV-2025-1057',
      'student': 'Anita Das',
      'class': 'Class 6A',
      'type': 'Transport',
      'issued': '20 Apr 2025',
      'due': '20 Jun 2025',
      'amount': 4500,
      'status': 'Paid',
    },
    {
      'id': 'INV-2025-1058',
      'student': 'Ravi Shankar',
      'class': 'Class 3B',
      'type': 'Library Fee',
      'issued': '21 Apr 2025',
      'due': '25 Jun 2025',
      'amount': 800,
      'status': 'Paid',
    },
  ];

  final _avatarColors = const [
    Color(0xFFEEF2FF),
    Color(0xFFFEF3C7),
    Color(0xFFFEE2E2),
    Color(0xFFE0F2FE),
    Color(0xFFDCFCE7),
    Color(0xFFF3E8FF),
  ];
  final _avatarTextColors = const [
    Color(0xFF6366F1),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF0EA5E9),
    Color(0xFF22C55E),
    Color(0xFFA855F7),
  ];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
    if (widget.showCreate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showCreateModal());
    }
  }

  void _showCreateModal() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(ctx).padding.top + 20),
        child: const CreateInvoiceModal(),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _invoices.insert(0, result);
        _saveInvoices();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    return _invoices.where((inv) {
      final q = _searchController.text.toLowerCase();
      final matchSearch =
          q.isEmpty ||
          inv['student'].toString().toLowerCase().contains(q) ||
          inv['id'].toString().toLowerCase().contains(q);
      final matchClass =
          _selectedClass == 'All Classes' || inv['class'] == _selectedClass;
      final matchStatus =
          _selectedStatus == 'All Status' || inv['status'] == _selectedStatus;
      return matchSearch && matchClass && matchStatus;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginated {
    final f = _filtered;
    final start = (_currentPage - 1) * _pageSize;
    final end = (start + _pageSize).clamp(0, f.length);
    return f.sublist(start.clamp(0, f.length), end);
  }

  int get _totalPages => ((_filtered.length) / _pageSize).ceil().clamp(1, 99);

  Future<void> _loadInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__invoices_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _invoices = decoded.map((item) {
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

  Future<void> _saveInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _invoices.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__invoices_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Invoices'),
      bottomNavigationBar: const AppBottomNav(),
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
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildKPIs(),
                        const SizedBox(height: 20),
                        _buildSearchRow(),
                        const SizedBox(height: 16),
                        _buildTabsRow(),
                        const SizedBox(height: 16),
                        _buildCountStatusRow(),
                        const SizedBox(height: 12),
                        _buildInvoiceContainer(),
                        const SizedBox(height: 16),
                        _buildPagination(),
                        const SizedBox(height: 24),
                        _buildStatusBreakdown(),
                        const SizedBox(height: 24),
                        _buildQuickStats(),
                        const SizedBox(height: 24),
                        _buildCollectionTrend(),
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

  // ── Header: title left | Export + Create right, description below
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invoices',
                  style: GoogleFonts.figtree(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage and track fee invoices for all students',
                  style: GoogleFonts.figtree(fontSize: 16, color: _muted),
                ),
              ],
            ),
            Row(
              children: [
                // Export
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.download,
                          size: 14,
                          color: _muted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Export',
                          style: GoogleFonts.figtree(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Create Invoice
                GestureDetector(
                  onTap: _showCreateModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: _primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: _primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.plus,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Create Invoice',
                          style: GoogleFonts.figtree(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Browse, filter, and manage all student invoices across classes and terms.',
          style: GoogleFonts.figtree(fontSize: 13, color: _muted),
        ),
      ],
    );
  }

  // ── 2×2 KPI
  Widget _buildKPIs() {
    final total = _invoices.length;
    final paid = _invoices.where((i) => i['status'] == 'Paid').length;
    final pending = _invoices.where((i) => i['status'] == 'Pending').length;
    final overdue = _invoices.where((i) => i['status'] == 'Overdue').length;
    final kpis = [
      {
        'label': 'Total Invoices',
        'value': '$total',
        'icon': LucideIcons.fileText,
        'color': const Color(0xFF6366F1),
        'bg': const Color(0xFFEEEDFD),
      },
      {
        'label': 'Paid',
        'value': '$paid',
        'icon': LucideIcons.checkCircle2,
        'color': const Color(0xFF22C55E),
        'bg': const Color(0xFFEAF8F0),
      },
      {
        'label': 'Pending',
        'value': '$pending',
        'icon': LucideIcons.clock,
        'color': const Color(0xFFF59E0B),
        'bg': const Color(0xFFFEF3E1),
      },
      {
        'label': 'Overdue',
        'value': '$overdue',
        'icon': LucideIcons.alertCircle,
        'color': const Color(0xFFEF4444),
        'bg': const Color(0xFFFDE8E8),
      },
    ];
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _kpiCard(kpis[0])),
            const SizedBox(width: 12),
            Expanded(child: _kpiCard(kpis[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _kpiCard(kpis[2])),
            const SizedBox(width: 12),
            Expanded(child: _kpiCard(kpis[3])),
          ],
        ),
      ],
    );
  }

  Widget _kpiCard(Map<String, dynamic> k) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: k['bg'] as Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              k['icon'] as IconData,
              size: 20,
              color: k['color'] as Color,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                k['value'] as String,
                style: GoogleFonts.figtree(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              Text(
                k['label'] as String,
                style: GoogleFonts.figtree(fontSize: 12, color: _muted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search + filter icon
  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() => _currentPage = 1),
              style: GoogleFonts.figtree(fontSize: 14, color: _dark),
              decoration: InputDecoration(
                hintText: 'Search by name, admission no. or phone...',
                hintStyle: GoogleFonts.figtree(fontSize: 13, color: _muted),
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(LucideIcons.search, size: 16, color: _muted),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _showFilterModal,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: const Icon(LucideIcons.filter, size: 18, color: _muted),
          ),
        ),
      ],
    );
  }

  // ── Tabs row
  Widget _buildTabsRow() {
    final tabs = ['All', 'Paid', 'Pending', 'Overdue', 'Cancelled', 'Draft'];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.map((t) {
          final isActive = _selectedTab == t;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = t;
                  _selectedStatus = t == 'All' ? 'All Status' : t;
                  _currentPage = 1;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFEEF2FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  t,
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive ? _primary : _muted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              24,
              24,
              MediaQuery.of(ctx).padding.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Invoices',
                      style: GoogleFonts.figtree(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _dark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Class',
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
                const SizedBox(height: 6),
                _dropdownBtn(_selectedClass, _classOptions, (v) {
                  setState(() {
                    _selectedClass = v;
                    _currentPage = 1;
                  });
                  setModalState(() {});
                }),
                const SizedBox(height: 16),
                Text(
                  'Status',
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
                const SizedBox(height: 6),
                _dropdownBtn(_selectedStatus, _statusOptions, (v) {
                  setState(() {
                    _selectedStatus = v;
                    _selectedTab = v == 'All Status' ? 'All' : v;
                    _currentPage = 1;
                  });
                  setModalState(() {});
                }),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_selectedClass != 'All Classes' ||
                    _selectedStatus != 'All Status') ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedClass = 'All Classes';
                          _selectedStatus = 'All Status';
                          _selectedTab = 'All';
                          _currentPage = 1;
                        });
                        setModalState(() {});
                        Navigator.pop(ctx);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Clear Filters',
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dropdownBtn(
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    final isActive = options.first != value;
    return GestureDetector(
      onTap: () => _showPicker(value, options, onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive ? _primary : _border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                value,
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? _primary : _dark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              LucideIcons.chevronDown,
              size: 14,
              color: isActive ? _primary : _muted,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(
    String current,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: _border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          ...options.map(
            (o) => ListTile(
              onTap: () {
                onChanged(o);
                Navigator.pop(context);
              },
              title: Text(
                o,
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: o == current
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: o == current ? _primary : _dark,
                ),
              ),
              trailing: o == current
                  ? const Icon(LucideIcons.check, size: 16, color: _primary)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Count row + status chips
  Widget _buildCountStatusRow() {
    final all = _filtered;
    final overdue = all.where((i) => i['status'] == 'Overdue').length;
    final paid = all.where((i) => i['status'] == 'Paid').length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${all.length} invoices found',
          style: GoogleFonts.figtree(fontSize: 13, color: _muted),
        ),
        Row(
          children: [
            if (overdue > 0) ...[
              _statusChip(
                '$overdue Overdue',
                const Color(0xFFEF4444),
                LucideIcons.alertCircle,
              ),
              const SizedBox(width: 8),
            ],
            if (paid > 0)
              _statusChip(
                '$paid Paid',
                const Color(0xFF22C55E),
                LucideIcons.checkCircle2,
              ),
          ],
        ),
      ],
    );
  }

  Widget _statusChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Invoice list container
  Widget _buildInvoiceContainer() {
    final list = _paginated;
    if (list.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        alignment: Alignment.center,
        child: Text(
          'No invoices found',
          style: GoogleFonts.figtree(fontSize: 14, color: _muted),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: list.asMap().entries.map((e) {
          final isLast = e.key == list.length - 1;
          return Column(
            children: [
              _buildInvoiceRow(e.value),
              if (!isLast) const Divider(height: 1, color: Color(0xFFF1F5F9)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInvoiceRow(Map<String, dynamic> inv) {
    final idx = _invoices.indexOf(inv) % _avatarColors.length;
    final nameParts = (inv['student'] as String).split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'
        : (inv['student'] as String).substring(0, 2).toUpperCase();

    Color statusColor;
    Color statusBg;
    switch (inv['status']) {
      case 'Paid':
        statusColor = const Color(0xFF16A34A);
        statusBg = const Color(0xFFDCFCE7);
        break;
      case 'Overdue':
        statusColor = const Color(0xFFDC2626);
        statusBg = const Color(0xFFFEE2E2);
        break;
      case 'Draft':
        statusColor = const Color(0xFF0EA5E9);
        statusBg = const Color(0xFFE0F2FE);
        break;
      default:
        statusColor = const Color(0xFFD97706);
        statusBg = const Color(0xFFFEF3C7);
    }
    final isOverdue = inv['status'] == 'Overdue';
    final amtStr = (inv['amount'] as int)
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: _avatarColors[idx],
            child: Text(
              initials,
              style: GoogleFonts.figtree(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _avatarTextColors[idx],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Invoice ID + name + class
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inv['id'],
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  inv['student'],
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
                Text(
                  inv['class'],
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Issue + Due dates
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Issue: ${inv['issued']}',
                  style: GoogleFonts.figtree(fontSize: 12, color: _muted),
                ),
                const SizedBox(height: 3),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.figtree(fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Due: ',
                        style: TextStyle(
                          color: isOverdue ? const Color(0xFFEF4444) : _muted,
                        ),
                      ),
                      TextSpan(
                        text: inv['due'],
                        style: TextStyle(
                          color: isOverdue ? const Color(0xFFEF4444) : _muted,
                          fontWeight: isOverdue
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Amount + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹$amtStr',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  inv['status'],
                  style: GoogleFonts.figtree(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Eye icon
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(ctx).padding.top + 20,
                  ),
                  child: InvoiceDetailsModal(invoice: inv),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                LucideIcons.eye,
                size: 18,
                color: _muted.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pagination
  Widget _buildPagination() {
    final total = _filtered.length;
    final start = (_currentPage - 1) * _pageSize + 1;
    final end = (_currentPage * _pageSize).clamp(0, total);
    if (total == 0) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing $start–$end of $total',
          style: GoogleFonts.figtree(fontSize: 13, color: _muted),
        ),
        Row(
          children: [
            // Prev
            GestureDetector(
              onTap: _currentPage > 1
                  ? () => setState(() => _currentPage--)
                  : null,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _border),
                ),
                child: Icon(
                  LucideIcons.chevronLeft,
                  size: 16,
                  color: _currentPage > 1
                      ? _dark
                      : _muted.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Page numbers
            ...List.generate(_totalPages.clamp(0, 5), (i) {
              final page = i + 1;
              final isCurrent = page == _currentPage;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: GestureDetector(
                  onTap: () => setState(() => _currentPage = page),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isCurrent ? _primary : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isCurrent ? _primary : _border),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$page',
                      style: GoogleFonts.figtree(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isCurrent ? Colors.white : _dark,
                      ),
                    ),
                  ),
                ),
              );
            }),
            // Next
            GestureDetector(
              onTap: _currentPage < _totalPages
                  ? () => setState(() => _currentPage++)
                  : null,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _border),
                ),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: _currentPage < _totalPages
                      ? _dark
                      : _muted.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static const _classOptions = [
    'All Classes',
    'Nursery',
    'LKG',
    'UKG',
    'Class 1',
    'Class 2',
    'Class 3A',
    'Class 3B',
    'Class 4A',
    'Class 5A',
    'Class 6A',
    'Class 7C',
    'Class 8B',
    'Class 9B',
    'Class 10A',
    'Class 10B',
    'Class 11A',
    'Class 12B',
  ];
  static const _statusOptions = [
    'All Status',
    'Paid',
    'Pending',
    'Overdue',
    'Draft',
  ];

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
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Fees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBreakdown() {
    final List<Map<String, dynamic>> items = [
      {
        'label': 'Paid',
        'count': '7',
        'percent': '39%',
        'val': 0.39,
        'color': const Color(0xFF22C55E),
      },
      {
        'label': 'Pending',
        'count': '4',
        'percent': '22%',
        'val': 0.22,
        'color': const Color(0xFFF59E0B),
      },
      {
        'label': 'Overdue',
        'count': '4',
        'percent': '22%',
        'val': 0.22,
        'color': const Color(0xFFEF4444),
      },
      {
        'label': 'Cancelled',
        'count': '1',
        'percent': '6%',
        'val': 0.06,
        'color': const Color(0xFF94A3B8),
      },
      {
        'label': 'Draft',
        'count': '2',
        'percent': '11%',
        'val': 0.11,
        'color': const Color(0xFF0EA5E9),
      },
    ];

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
          Text(
            'Status Breakdown',
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
          const SizedBox(height: 20),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['label'],
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _dark,
                        ),
                      ),
                      Text(
                        '${item['count']} · ${item['percent']}',
                        style: GoogleFonts.figtree(fontSize: 13, color: _muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: item['val'] as double,
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: item['color'] as Color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
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
          Text(
            'Quick Stats',
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _dark,
            ),
          ),
          const SizedBox(height: 16),
          _quickStatRow('Total Invoiced', '₹3,84,000'),
          const SizedBox(height: 12),
          _quickStatRow('Total Collected', '₹1,86,500'),
          const SizedBox(height: 12),
          _quickStatRow('Total Pending', '₹1,57,000'),
        ],
      ),
    );
  }

  Widget _quickStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
        Text(
          value,
          style: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionTrend() {
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
              Text(
                'Collection Trend',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const Icon(LucideIcons.trendingUp, size: 18, color: _primary),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Invoiced vs Collected · last 6 months (₹L)',
            style: GoogleFonts.figtree(fontSize: 13, color: _muted),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: _border,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                  getDrawingVerticalLine: (value) => const FlLine(
                    color: _border,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Color(0xFF595973),
                          fontSize: 12,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('Nov', style: style);
                            break;
                          case 1:
                            text = const Text('Dec', style: style);
                            break;
                          case 2:
                            text = const Text('Jan', style: style);
                            break;
                          case 3:
                            text = const Text('Feb', style: style);
                            break;
                          case 4:
                            text = const Text('Mar', style: style);
                            break;
                          case 5:
                            text = const Text('Apr', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(meta: meta, child: text);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 30,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Color(0xFF595973),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: _muted),
                    left: BorderSide.none,
                    right: BorderSide.none,
                    top: BorderSide.none,
                  ),
                ),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 120,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 78),
                      FlSpot(1, 88),
                      FlSpot(2, 92),
                      FlSpot(3, 100),
                      FlSpot(4, 105),
                      FlSpot(5, 112),
                    ],
                    isCurved: true,
                    color: _primary,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: _primary.withValues(alpha: 0.1),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 65),
                      FlSpot(1, 75),
                      FlSpot(2, 80),
                      FlSpot(3, 85),
                      FlSpot(4, 88),
                      FlSpot(5, 95),
                    ],
                    isCurved: true,
                    color: const Color(0xFF22C55E),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _legendItem('Invoiced', _primary),
              const SizedBox(width: 16),
              _legendItem('Collected', const Color(0xFF22C55E)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
      ],
    );
  }
}
