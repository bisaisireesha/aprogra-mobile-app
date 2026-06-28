import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StaffPayrollScreen extends StatefulWidget {
  const StaffPayrollScreen({super.key});

  @override
  State<StaffPayrollScreen> createState() => _StaffPayrollScreenState();
}

class _StaffPayrollScreenState extends State<StaffPayrollScreen> {
  int _bottomNavIndex = 3; // 'Staff' is index 3
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _payrollRecords = [
    {
      'name': 'Priya Sharma',
      'initials': 'PS',
      'department': 'Mathematics',
      'designation': 'Senior Teacher',
      'gross': '₹85,000',
      'deductions': '₹12,750',
      'net': '₹72,250',
      'date': '31 May 2025',
      'status': 'Paid',
    },
    {
      'name': 'Rajan Pillai',
      'initials': 'RP',
      'department': 'Science',
      'designation': 'Teacher',
      'gross': '₹72,000',
      'deductions': '₹10,800',
      'net': '₹61,200',
      'date': '31 May 2025',
      'status': 'Paid',
    },
    {
      'name': 'Meena Krishnamurthy',
      'initials': 'MK',
      'department': 'English',
      'designation': 'HOD',
      'gross': '₹98,000',
      'deductions': '₹14,700',
      'net': '₹83,300',
      'date': '31 May 2025',
      'status': 'Paid',
    },
    {
      'name': 'Suresh Kumar',
      'initials': 'SK',
      'department': 'Social Studies',
      'designation': 'Teacher',
      'gross': '₹68,000',
      'deductions': '₹10,200',
      'net': '₹57,800',
      'date': '31 May 2025',
      'status': 'Pending',
    },
    {
      'name': 'Anita Desai',
      'initials': 'AD',
      'department': 'Hindi',
      'designation': 'Teacher',
      'gross': '₹65,000',
      'deductions': '₹9,750',
      'net': '₹55,250',
      'date': '31 May 2025',
      'status': 'Paid',
    },
    {
      'name': 'Vikram Nair',
      'initials': 'VN',
      'department': 'Mathematics',
      'designation': 'Teacher',
      'gross': '₹74,000',
      'deductions': '₹11,100',
      'net': '₹62,900',
      'date': '31 May 2025',
      'status': 'Paid',
    },
    {
      'name': 'Deepa Iyer',
      'initials': 'DI',
      'department': 'Computer Sci',
      'designation': 'Senior Teacher',
      'gross': '₹80,000',
      'deductions': '₹12,000',
      'net': '₹68,000',
      'date': '31 May 2025',
      'status': 'Paid',
    },
    {
      'name': 'Sanjay Verma',
      'initials': 'SV',
      'department': 'Physics',
      'designation': 'HOD',
      'gross': '₹95,000',
      'deductions': '₹14,250',
      'net': '₹80,750',
      'date': '31 May 2025',
      'status': 'Pending',
    }
  ];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Payroll'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 40 : 16, 24, _isTablet ? 40 : 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildHeader()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildTopControls(),
                          const SizedBox(height: 24),
                          _buildStatsRow(),
                          const SizedBox(height: 16),
                          _buildFinancialSummaryRow(),
                          const SizedBox(height: 32),
                          _buildSalaryRegister(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(LucideIcons.menu, color: _textDark),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.notifications_none_rounded, color: Color(0xFF8F96A3), size: 24),
            const SizedBox(width: 16),
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150&h=150'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Home', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text('Staff', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text('Payroll', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        const SizedBox(height: 16),
        Text('Payroll', style: GoogleFonts.figtree(fontSize: _isTablet ? 32 : 28, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 8),
        Text(
          "Process monthly salary runs, review breakdowns, and track payment status.",
          style: GoogleFonts.figtree(fontSize: _isTablet ? 16 : 14, color: _textMuted),
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('May 2025', style: GoogleFonts.figtree(fontSize: 14, color: _textDark, fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              const Icon(LucideIcons.chevronDown, size: 16, color: _textMuted),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.playCircle, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text('Run Payroll', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: _isTablet ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: _isTablet ? 1.4 : 1.1,
          children: [
            _buildKpiCard('₹32.4L', 'Total Payroll (May)', LucideIcons.indianRupee, const Color(0xFF8463E9), const Color(0xFFF4F1FF)),
            _buildKpiCard('38', 'Paid', LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFD1FAE5)),
            _buildKpiCard('7', 'Pending', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
            _buildKpiCard('₹72,000', 'Avg Salary', LucideIcons.trendingUp, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(String value, String title, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.figtree(fontSize: 28, fontWeight: FontWeight.w900, color: _textDark, height: 1.0),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummaryRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: _isTablet ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: _isTablet ? 2.5 : 2.0,
          children: [
            _buildFinancialMiniCard('₹38.6L', 'Gross Earnings', const Color(0xFF10B981)),
            _buildFinancialMiniCard('₹6.2L', 'Total Deductions', const Color(0xFFEF4444)),
            _buildFinancialMiniCard('₹32.4L', 'Net Payout', const Color(0xFF8463E9)),
            _buildFinancialMiniCard('₹1.8L', 'Bonuses', const Color(0xFFF59E0B)),
          ],
        );
      },
    );
  }

  Widget _buildFinancialMiniCard(String value, String title, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.w900, color: valueColor, height: 1.0),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryRegister() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Department:', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Text('All', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                      const SizedBox(width: 8),
                      const Icon(LucideIcons.chevronDown, size: 14, color: _textMuted),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text('15 records', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (!_isTablet) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(LucideIcons.search, size: 16, color: Color(0xFF9CA3AF)),
                hintText: 'Search staff by name...',
                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSalaryList(),
        ] else
          _buildSalaryTable(),
      ],
    );
  }

  Widget _buildSalaryTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.indianRupee, size: 20, color: Color(0xFF8463E9)),
                    const SizedBox(width: 8),
                    Text('Salary Register ', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text('(15 staff)', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.download, size: 14, color: _textDark),
                      const SizedBox(width: 6),
                      Text('Export', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
              dataRowMinHeight: 64,
              dataRowMaxHeight: 64,
              columns: [
                DataColumn(label: Text('STAFF', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('DEPARTMENT', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('DESIGNATION', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('GROSS (₹)', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('DEDUCTIONS (₹)', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('NET (₹)', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('PAY DATE', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('STATUS', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
                DataColumn(label: Text('ACTIONS', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted))),
              ],
              rows: _payrollRecords.map((record) {
                final isPaid = record['status'] == 'Paid';
                return DataRow(
                  cells: [
                    DataCell(Text(record['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark))),
                    DataCell(Text(record['department'], style: GoogleFonts.figtree(fontSize: 14, color: _textMuted))),
                    DataCell(Text(record['designation'], style: GoogleFonts.figtree(fontSize: 14, color: _textMuted))),
                    DataCell(Text(record['gross'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark))),
                    DataCell(Text(record['deductions'], style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFFEF4444)))),
                    DataCell(Text(record['net'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)))),
                    DataCell(Text(record['date'], style: GoogleFonts.figtree(fontSize: 14, color: _textMuted))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPaid ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          record['status'],
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LucideIcons.eye, size: 14, color: _textMuted),
                          const SizedBox(width: 4),
                          Text('Payslip', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                          if (!isPaid) ...[
                            const SizedBox(width: 16),
                            Icon(LucideIcons.refreshCw, size: 14, color: _accent),
                            const SizedBox(width: 4),
                            Text('Reissue', style: GoogleFonts.figtree(fontSize: 13, color: _accent)),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryList() {
    return Column(
      children: _payrollRecords.map((record) => _buildSalaryMobileCard(record)).toList(),
    );
  }

  Widget _buildSalaryMobileCard(Map<String, dynamic> record) {
    final isPaid = record['status'] == 'Paid';
    
    Color avatarBgColor;
    Color avatarTextColor;
    if (record['initials'] == 'PS' || record['initials'] == 'VN') {
      avatarBgColor = const Color(0xFFFEE2E2); avatarTextColor = const Color(0xFFEF4444);
    } else if (record['initials'] == 'RP' || record['initials'] == 'AD') {
      avatarBgColor = const Color(0xFFE0F2FE); avatarTextColor = const Color(0xFF0EA5E9);
    } else if (record['initials'] == 'MK') {
      avatarBgColor = const Color(0xFFF4F1FF); avatarTextColor = const Color(0xFF8463E9);
    } else {
      avatarBgColor = const Color(0xFFFEF3C7); avatarTextColor = const Color(0xFFF59E0B);
    }

    return GestureDetector(
      onTap: () => _showPayslipDetails(context, record),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: avatarBgColor,
                  child: Text(record['initials'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: avatarTextColor)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(height: 2),
                      Text('${record['department']} • ${record['designation']}', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    record['status'],
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Net Salary', style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
                    const SizedBox(height: 2),
                    Text(record['net'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pay Date', style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
                    const SizedBox(height: 2),
                    Text(record['date'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                  ],
                ),
                const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF9CA3AF)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPayslipDetails(BuildContext context, Map<String, dynamic> record) {
    final isPaid = record['status'] == 'Paid';

    Color avatarBgColor;
    Color avatarTextColor;
    if (record['initials'] == 'PS' || record['initials'] == 'VN') {
      avatarBgColor = const Color(0xFFFEE2E2); avatarTextColor = const Color(0xFFEF4444);
    } else if (record['initials'] == 'RP' || record['initials'] == 'AD') {
      avatarBgColor = const Color(0xFFE0F2FE); avatarTextColor = const Color(0xFF0EA5E9);
    } else if (record['initials'] == 'MK') {
      avatarBgColor = const Color(0xFFF4F1FF); avatarTextColor = const Color(0xFF8463E9);
    } else {
      avatarBgColor = const Color(0xFFFEF3C7); avatarTextColor = const Color(0xFFF59E0B);
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: avatar + name + status + close
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: avatarBgColor,
                      child: Text(record['initials'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: avatarTextColor)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record['name'], style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                          const SizedBox(height: 2),
                          Text(record['designation'], style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPaid ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        record['status'],
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 20, color: _textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Detail rows
                _buildPayslipRow('Department', record['department']),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPayslipRow('Designation', record['designation']),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPayslipRow('Gross Salary', record['gross']),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPayslipRow('Deductions', record['deductions'], valueColor: const Color(0xFFEF4444)),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPayslipRow('Net Salary', record['net'], valueColor: const Color(0xFF10B981)),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPayslipRow('Pay Date', record['date']),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                _buildPayslipRow('Status', record['status'], valueColor: isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B)),
                const SizedBox(height: 24),
                // Action buttons
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // View payslip action
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.fileText, size: 18, color: _textDark),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('View Payslip', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 18, color: _textMuted),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading payslip for ${record['name']}...'),
                              backgroundColor: _textDark,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.download, size: 18, color: _textDark),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('Download Payslip', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                              ),
                              const Icon(LucideIcons.chevronRight, size: 18, color: _textMuted),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Mark as Paid button
                if (!isPaid)
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('Mark as Paid', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                if (isPaid)
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text('Mark as Paid', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPayslipRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? _textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }
}
