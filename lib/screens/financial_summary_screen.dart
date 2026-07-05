import 'package:aprogra/screens/auth/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import '../widgets/common_app_bar.dart';
import '../widgets/app_bottom_nav.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);

class FinancialSummaryScreen extends StatefulWidget {
  const FinancialSummaryScreen({super.key});

  @override
  State<FinancialSummaryScreen> createState() => _FinancialSummaryScreenState();
}

class _FinancialSummaryScreenState extends State<FinancialSummaryScreen> {
  String _manageListSelected = 'Students';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Financial Summary'),
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
                  child: CommonAppBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildKPIs(isTablet),
                        const SizedBox(height: 32),
                        _buildQuickActions(isTablet),
                        const SizedBox(height: 48),

                        _buildSectionTitle(
                          'Outstanding Dues',
                          'Students with pending fee',
                          LucideIcons.search,
                        ),
                        const SizedBox(height: 24),
                        _buildOutstandingDues(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Payment Overview'),
                        const SizedBox(height: 24),
                        _buildPaymentOverview(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Ages & Trends'),
                        const SizedBox(height: 24),
                        _buildAgesAndTrends(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Revenue & Expenses'),
                        const SizedBox(height: 24),
                        _buildRevenueAndExpenses(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Manage Lists'),
                        const SizedBox(height: 24),
                        _buildManageLists(),
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

  // --- Shared Section Title ---
  Widget _buildSectionTitle(
    String title, [
    String? subtitle,
    IconData? actionIcon,
  ]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.figtree(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
                ),
              ],
            ],
          ),
        ),
        if (actionIcon != null) Icon(actionIcon, size: 20, color: _textDark),
      ],
    );
  }

  // --- Header ---
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(
                    LucideIcons.menu,
                    size: 24,
                    color: _textDark,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Financial Summary',
                  style: GoogleFonts.figtree(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.calendarDays,
                    size: 16,
                    color: Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '2025-26',
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Overview of fee collection, expenses and\nnet balance for the academic year.',
          style: GoogleFonts.figtree(
            fontSize: 14,
            color: _textMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDropdown('2025-26')),
            const SizedBox(width: 12),
            Expanded(child: _buildDropdown('All')),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(LucideIcons.filter, size: 20, color: _textDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
          const Icon(LucideIcons.chevronDown, size: 16, color: _textMuted),
        ],
      ),
    );
  }

  // --- KPIs ---
  Widget _buildKPIs(bool isTablet) {
    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildKPICard(
          title: 'TOTAL FEE COLLECTED',
          value: '₹40.80L',
          trend: '12.4% vs last',
          isPositive: true,
          iconBg: const Color(0xFFEEF2FF),
          iconColor: const Color(0xFF6366F1),
          icon: LucideIcons.wallet,
          sparklineColor: const Color(0xFF6366F1),
          data: [1, 2, 2.5, 3, 3.5, 4, 4.2],
        ),
        _buildKPICard(
          title: 'PENDING DUES',
          value: '₹1.44L',
          trend: '6 students vs last',
          isPositive: false,
          iconBg: const Color(0xFFFFF7ED),
          iconColor: const Color(0xFFF59E0B),
          icon: LucideIcons.alertCircle,
          sparklineColor: const Color(0xFFF59E0B),
          data: [4, 3.8, 3.5, 3.6, 3.2, 3.0, 3.1],
        ),
        _buildKPICard(
          title: 'MONTHLY EXPENSES',
          value: '₹3.04L',
          trend: '4.2% vs last',
          isPositive: false, // Down is good for expenses, but styled red
          iconBg: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFEF4444),
          icon: LucideIcons.fileText,
          sparklineColor: const Color(0xFFEF4444),
          data: [3, 2.8, 3.1, 2.9, 3.5, 3.2, 3.0],
        ),
        _buildKPICard(
          title: 'NET BALANCE',
          value: '₹15.90L',
          trend: 'Surplus vs last',
          isPositive: true,
          iconBg: const Color(0xFFF0FDF4),
          iconColor: const Color(0xFF22C55E),
          icon: LucideIcons.pieChart,
          sparklineColor: const Color(0xFF22C55E),
          data: [2, 2.2, 2.5, 2.4, 2.8, 3.0, 3.5],
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required Color sparklineColor,
    required List<double> data,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: _textMuted,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _textDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                size: 12,
                color: isPositive
                    ? const Color(0xFF22C55E)
                    : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  trend,
                  style: GoogleFonts.figtree(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPositive
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 30,
            width: double.infinity,
            child: CustomPaint(
              painter: _SparklinePainter(data: data, color: sparklineColor),
            ),
          ),
        ],
      ),
    );
  }

  // --- Quick Actions ---
  Widget _buildQuickActions(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: isTablet ? 3 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildActionCard(
              'Collect Fee',
              LucideIcons.wallet,
              const Color(0xFF6366F1),
              const Color(0xFFEEF2FF),
            ),
            _buildActionCard(
              'Create Invoice',
              LucideIcons.filePlus,
              const Color(0xFF3B82F6),
              const Color(0xFFEFF6FF),
            ),
            _buildActionCard(
              'Record Expense',
              LucideIcons.fileMinus,
              const Color(0xFFEF4444),
              const Color(0xFFFEF2F2),
            ),
            _buildActionCard(
              'Payment History',
              LucideIcons.history,
              const Color(0xFFF59E0B),
              const Color(0xFFFFF7ED),
            ),
            _buildActionCard(
              'Generate Report',
              LucideIcons.fileSpreadsheet,
              const Color(0xFF10B981),
              const Color(0xFFE8FDF3),
            ),
            _buildActionCard(
              'Fee Settings',
              LucideIcons.settings,
              const Color(0xFF6B7280),
              const Color(0xFFF3F4F6),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    Color bgColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Open',
                        style: GoogleFonts.figtree(
                          fontSize: 10,
                          color: _textMuted,
                        ),
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

  // --- Outstanding Dues ---
  Widget _buildOutstandingDues() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Student', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Class', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Amount', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Due Date', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Action',
                    style: _tableHeaderStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildDueRow(
            'Rohan Verma',
            '10-A',
            '₹12,420',
            '07 Days',
            const Color(0xFFF59E0B),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildDueRow(
            'Anaya Singh',
            '11-B',
            '₹9,870',
            '10 Days',
            const Color(0xFFF59E0B),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildDueRow(
            'Ishaan Patel',
            '12-C',
            '₹7,230',
            '12 Days',
            const Color(0xFFF59E0B),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildDueRow(
            'Neha Nair',
            'X-A',
            '₹4,520',
            '02 Days',
            const Color(0xFFEF4444),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildDueRow(
            'Aditya Reddy',
            '11-A',
            '₹3,560',
            '5 Days',
            const Color(0xFF10B981),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildDueRow(
            'Priya Gupta',
            '9-A',
            '₹2,870',
            '7 Days',
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: _textMuted,
  );
  TextStyle _tableDataStyle() => GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: _textDark,
  );

  Widget _buildDueRow(
    String student,
    String cls,
    String amount,
    String due,
    Color dueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(student, style: _tableDataStyle())),
          Expanded(
            flex: 2,
            child: Text(
              cls,
              style: _tableDataStyle().copyWith(
                color: _textMuted,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(amount, style: _tableDataStyle())),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: dueColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: dueColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  due,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: dueColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Remind',
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Payment Overview ---
  Widget _buildPaymentOverview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Mode Breakdown',
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Total ₹40.80L',
                  style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildModeBar(
                  'Online',
                  '₹24.52L',
                  '(60%)',
                  0.60,
                  const Color(0xFF6366F1),
                ),
                const SizedBox(height: 16),
                _buildModeBar(
                  'Cash',
                  '₹11.10L',
                  '(27%)',
                  0.27,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 16),
                _buildModeBar(
                  'Bank Transfer',
                  '₹3.28L',
                  '(8%)',
                  0.08,
                  const Color(0xFF10B981),
                ),
                const SizedBox(height: 16),
                _buildModeBar(
                  'Card',
                  '₹1.64L',
                  '(4%)',
                  0.04,
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),
                _buildModeBar(
                  'UPI',
                  '₹0.26L',
                  '(1%)',
                  0.01,
                  const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Payments',
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                Text(
                  'View all',
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Student', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Class', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Mode', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Amount', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Date',
                    style: _tableHeaderStyle(),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPaymentRow(
            'Rohan Verma',
            '10-A',
            'Online',
            '₹12,420',
            'Nov 24',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPaymentRow('Anaya Singh', '11-B', 'Card', '₹9,870', 'Nov 24'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPaymentRow(
            'Ishaan Patel',
            '12-C',
            'Online',
            '₹7,230',
            'Nov 23',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPaymentRow('Neha Nair', 'X-A', 'UPI', '₹4,520', 'Nov 23'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPaymentRow('Aditya Reddy', '11-A', 'Cash', '₹3,560', 'Nov 22'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPaymentRow('Priya Gupta', '9-A', 'Online', '₹2,870', 'Nov 22'),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildModeBar(
    String label,
    String amount,
    String percentStr,
    double percent,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            Row(
              children: [
                Text(
                  amount,
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  percentStr,
                  style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentRow(
    String student,
    String cls,
    String mode,
    String amount,
    String date,
  ) {
    Color modeColor;
    switch (mode) {
      case 'Online':
        modeColor = const Color(0xFF6366F1);
        break;
      case 'Card':
        modeColor = const Color(0xFFF59E0B);
        break;
      case 'UPI':
        modeColor = const Color(0xFFEF4444);
        break;
      case 'Cash':
        modeColor = const Color(0xFF3B82F6);
        break;
      default:
        modeColor = _textMuted;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(student, style: _tableDataStyle())),
          Expanded(
            flex: 2,
            child: Text(
              cls,
              style: _tableDataStyle().copyWith(
                color: _textMuted,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: modeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  mode,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: modeColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(amount, style: _tableDataStyle())),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: _tableDataStyle().copyWith(
                color: _textMuted,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // --- Ages & Trends ---
  Widget _buildAgesAndTrends() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Ages of Dues',
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildModeBar(
                  '0-30 Days',
                  '₹0.58L',
                  '(40%)',
                  0.40,
                  const Color(0xFF10B981),
                ),
                const SizedBox(height: 16),
                _buildModeBar(
                  '31-60 Days',
                  '₹0.81L',
                  '(42%)',
                  0.42,
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),
                _buildModeBar(
                  '60+ Days',
                  '₹0.25L',
                  '(18%)',
                  0.18,
                  const Color(0xFFEF4444),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Collection Trend (Last 7 Days)',
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total ₹8.32L',
                  style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 150,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) => const FlLine(
                          color: Color(0xFFF3F4F6),
                          strokeWidth: 1,
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
                            reservedSize: 22,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: _textMuted,
                                fontSize: 10,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('May 10', style: style);
                                  break;
                                case 1:
                                  text = const Text('May 11', style: style);
                                  break;
                                case 2:
                                  text = const Text('May 12', style: style);
                                  break;
                                case 3:
                                  text = const Text('May 13', style: style);
                                  break;
                                case 4:
                                  text = const Text('May 14', style: style);
                                  break;
                                case 5:
                                  text = const Text('May 15', style: style);
                                  break;
                                case 6:
                                  text = const Text('May 16', style: style);
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
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}L',
                                style: const TextStyle(
                                  color: _textMuted,
                                  fontSize: 10,
                                ),
                              );
                            },
                            reservedSize: 28,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: 3,
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 1.8),
                            FlSpot(1, 2.2),
                            FlSpot(2, 2.0),
                            FlSpot(3, 2.4),
                            FlSpot(4, 2.3),
                            FlSpot(5, 2.2),
                            FlSpot(6, 2.8),
                          ],
                          isCurved: true,
                          color: const Color(0xFF6366F1),
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 3,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: const Color(0xFF6366F1),
                                ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF6366F1).withValues(alpha: 0.2),
                                const Color(0xFF6366F1).withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Revenue & Expenses ---
  Widget _buildRevenueAndExpenses() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revenue vs Expenses',
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monthly comparison - 2025-26',
                  style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 8,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              const style = TextStyle(
                                color: _textMuted,
                                fontSize: 10,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('Apr', style: style);
                                  break;
                                case 1:
                                  text = const Text('May', style: style);
                                  break;
                                case 2:
                                  text = const Text('Jun', style: style);
                                  break;
                                case 3:
                                  text = const Text('Jul', style: style);
                                  break;
                                case 4:
                                  text = const Text('Aug', style: style);
                                  break;
                                case 5:
                                  text = const Text('Sep', style: style);
                                  break;
                                case 6:
                                  text = const Text('Oct', style: style);
                                  break;
                                case 7:
                                  text = const Text('Nov', style: style);
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
                            reservedSize: 28,
                            interval: 2,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}L',
                              style: const TextStyle(
                                color: _textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) => const FlLine(
                          color: Color(0xFFF3F4F6),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        _makeGroupData(0, 4.5, 3.8),
                        _makeGroupData(1, 4.8, 4.0),
                        _makeGroupData(2, 5.5, 4.5),
                        _makeGroupData(3, 5.2, 4.2),
                        _makeGroupData(4, 6.0, 4.8),
                        _makeGroupData(5, 5.8, 4.6),
                        _makeGroupData(6, 6.5, 5.0),
                        _makeGroupData(7, 6.8, 5.2),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('Revenue', const Color(0xFF6366F1)),
                    const SizedBox(width: 24),
                    _buildLegendItem('Expenses', const Color(0xFFC7D2FE)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collection by Fee Type',
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Share of total revenue',
                  style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 150,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            startDegreeOffset: 270,
                            sections: [
                              PieChartSectionData(
                                color: const Color(0xFF6366F1),
                                value: 61,
                                title: '',
                                radius: 25,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFF3B82F6),
                                value: 16,
                                title: '',
                                radius: 25,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFF10B981),
                                value: 12,
                                title: '',
                                radius: 25,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFFF59E0B),
                                value: 7,
                                title: '',
                                radius: 25,
                              ),
                              PieChartSectionData(
                                color: const Color(0xFF6B7280),
                                value: 4,
                                title: '',
                                radius: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDonutLegendItem(
                            'Tuition',
                            '61%',
                            const Color(0xFF6366F1),
                          ),
                          _buildDonutLegendItem(
                            'Transport',
                            '16%',
                            const Color(0xFF3B82F6),
                          ),
                          _buildDonutLegendItem(
                            'Hostel',
                            '12%',
                            const Color(0xFF10B981),
                          ),
                          _buildDonutLegendItem(
                            'Exam',
                            '7%',
                            const Color(0xFFF59E0B),
                          ),
                          _buildDonutLegendItem(
                            'Other',
                            '4%',
                            const Color(0xFF6B7280),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: const Color(0xFF6366F1),
          width: 8,
          borderRadius: BorderRadius.circular(2),
        ),
        BarChartRodData(
          toY: y2,
          color: const Color(0xFFC7D2FE),
          width: 8,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
        ),
      ],
    );
  }

  Widget _buildDonutLegendItem(String label, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  color: _textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            percent,
            style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
          ),
        ],
      ),
    );
  }

  // --- Manage Lists ---
  Widget _buildManageLists() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildManageSegmentButton('Students')),
                  Expanded(child: _buildManageSegmentButton('Expenses')),
                  Expanded(child: _buildManageSegmentButton('Other')),
                ],
              ),
            ),
          ),
          _buildManageListItem(
            LucideIcons.users,
            'Student List',
            'View all students',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildManageListItem(
            LucideIcons.layers,
            'Class Wise Dues',
            'Dues summary by class',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildManageListItem(
            LucideIcons.fileText,
            'Student Fee Ledger',
            'Individual fee transactions',
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildManageListItem(
            LucideIcons.award,
            'Concession List',
            'Scholarships & concessions',
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildManageSegmentButton(String label) {
    final isActive = _manageListSelected == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _manageListSelected = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildManageListItem(IconData icon, String title, String subtitle) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF6366F1)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Sparkline Painter ---
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final minData = data.reduce(math.min);
    final maxData = data.reduce(math.max);
    final range = maxData - minData == 0 ? 1 : maxData - minData;
    final path = Path();
    final xStep = size.width / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - (((data[i] - minData) / range) * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
