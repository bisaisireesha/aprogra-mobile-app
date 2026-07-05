import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);

class FinancialSummaryScreen extends StatefulWidget {
  const FinancialSummaryScreen({super.key});

  @override
  State<FinancialSummaryScreen> createState() => _FinancialSummaryScreenState();
}

class _FinancialSummaryScreenState extends State<FinancialSummaryScreen> {
  String _selectedYear = '2025-26';
  String _selectedFilter = 'All';

  Map<String, String> _getKPIValues() {
    switch (_selectedFilter) {
      case 'Tuition': return {'fee': '₹28.2L', 'dues': '₹0.8L', 'exp': '₹1.1L', 'net': '₹27.1L'};
      case 'Transport': return {'fee': '₹4.2L', 'dues': '₹0.1L', 'exp': '₹2.8L', 'net': '₹1.4L'};
      case 'Hostel': return {'fee': '₹8.5L', 'dues': '₹0.5L', 'exp': '₹5.2L', 'net': '₹3.3L'};
      case 'Exam': return {'fee': '₹2.1L', 'dues': '₹0.0L', 'exp': '₹0.8L', 'net': '₹1.3L'};
      case 'Misc': return {'fee': '₹0.8L', 'dues': '₹0.0L', 'exp': '₹0.3L', 'net': '₹0.5L'};
      default: return {'fee': '₹40.80L', 'dues': '₹1.44L', 'exp': '₹3.04L', 'net': '₹15.90L'};
    }
  }

  Map<String, double> _getPaymentStatusValues() {
    switch (_selectedFilter) {
      case 'Tuition': return {'paid': 0.60, 'pending': 0.35, 'overdue': 0.05};
      case 'Transport': return {'paid': 0.85, 'pending': 0.10, 'overdue': 0.05};
      case 'Hostel': return {'paid': 0.70, 'pending': 0.20, 'overdue': 0.10};
      default: return {'paid': 0.46, 'pending': 0.46, 'overdue': 0.08};
    }
  }

  List<Map<String, dynamic>> _getExpenseBreakdownValues() {
    if (_selectedFilter == 'Transport') {
      return [
        {'title': 'Fuel', 'amount': '₹1.2L', 'pct': '57%', 'val': 0.57, 'color': const Color(0xFF6366F1)},
        {'title': 'Maintenance', 'amount': '₹0.6L', 'pct': '28%', 'val': 0.28, 'color': const Color(0xFF3B82F6)},
        {'title': 'Salaries', 'amount': '₹0.3L', 'pct': '15%', 'val': 0.15, 'color': const Color(0xFF10B981)},
      ];
    }
    if (_selectedFilter == 'Hostel') {
      return [
        {'title': 'Food', 'amount': '₹3.1L', 'pct': '60%', 'val': 0.60, 'color': const Color(0xFF6366F1)},
        {'title': 'Maintenance', 'amount': '₹1.0L', 'pct': '19%', 'val': 0.19, 'color': const Color(0xFF3B82F6)},
        {'title': 'Salaries', 'amount': '₹1.1L', 'pct': '21%', 'val': 0.21, 'color': const Color(0xFF10B981)},
      ];
    }
    return [
      {'title': 'Salaries', 'amount': '₹14.80L', 'pct': '59%', 'val': 0.59, 'color': const Color(0xFF6366F1)},
      {'title': 'Utilities', 'amount': '₹3.20L', 'pct': '13%', 'val': 0.13, 'color': const Color(0xFF3B82F6)},
      {'title': 'Maintenance', 'amount': '₹2.40L', 'pct': '10%', 'val': 0.10, 'color': const Color(0xFF10B981)},
      {'title': 'Transport', 'amount': '₹2.10L', 'pct': '8%', 'val': 0.08, 'color': const Color(0xFFF59E0B)},
      {'title': 'Supplies', 'amount': '₹1.50L', 'pct': '6%', 'val': 0.06, 'color': const Color(0xFFEF4444)},
      {'title': 'Misc', 'amount': '₹0.90L', 'pct': '4%', 'val': 0.04, 'color': const Color(0xFF6B7280)},
    ];
  }

  List<FlSpot> _getMonthlyCollectionSpots() {
    final base = [4.2, 4.5, 5.1, 4.8, 5.4, 5.7, 5.2, 5.9];
    double mult = _selectedFilter == 'Transport' ? 0.8 : _selectedFilter == 'Tuition' ? 1.2 : _selectedFilter == 'Hostel' ? 0.9 : 1.0;
    return List.generate(8, (i) => FlSpot(i.toDouble(), base[i] * mult));
  }

  List<BarChartGroupData> _getRevenueVsExpensesGroups() {
    final baseRev = [4.2, 4.5, 5.1, 4.8, 5.4, 5.7, 5.2, 5.9];
    final baseExp = [2.6, 2.8, 3.0, 2.9, 3.2, 3.3, 3.1, 3.4];
    double mult = _selectedFilter == 'Transport' ? 0.8 : _selectedFilter == 'Tuition' ? 1.2 : _selectedFilter == 'Hostel' ? 0.9 : 1.0;
    return List.generate(8, (i) => _makeGroupData(i, baseRev[i] * mult, baseExp[i] * mult));
  }

  List<Map<String, dynamic>> _getCollectionFeeTypeValues() {
    if (_selectedFilter == 'Transport') {
      return [{'title': 'Transport', 'pct': '100%', 'val': 100.0, 'color': const Color(0xFF3B82F6)}];
    }
    if (_selectedFilter == 'Tuition') {
      return [{'title': 'Tuition', 'pct': '100%', 'val': 100.0, 'color': const Color(0xFF6366F1)}];
    }
    if (_selectedFilter == 'Hostel') {
      return [{'title': 'Hostel', 'pct': '100%', 'val': 100.0, 'color': const Color(0xFF10B981)}];
    }
    if (_selectedFilter == 'Exam') {
      return [{'title': 'Exam', 'pct': '100%', 'val': 100.0, 'color': const Color(0xFFF59E0B)}];
    }
    if (_selectedFilter == 'Misc') {
      return [{'title': 'Misc', 'pct': '100%', 'val': 100.0, 'color': const Color(0xFF9CA3AF)}];
    }
    return [
      {'title': 'Tuition', 'pct': '62%', 'val': 62.0, 'color': const Color(0xFF6366F1)},
      {'title': 'Transport', 'pct': '14%', 'val': 14.0, 'color': const Color(0xFF3B82F6)},
      {'title': 'Hostel', 'pct': '12%', 'val': 12.0, 'color': const Color(0xFF10B981)},
      {'title': 'Exam', 'pct': '7%', 'val': 7.0, 'color': const Color(0xFFF59E0B)},
      {'title': 'Misc', 'pct': '5%', 'val': 5.0, 'color': const Color(0xFF9CA3AF)},
    ];
  }

  List<Map<String, String>> _getRecentPaymentsValues() {
    final all = [
      {'inv': 'INV-3201', 'name': 'Aarav Mehta', 'cls': 'VIII-B', 'mode': 'UPI', 'amt': '₹24,500', 'date': 'Nov 24'},
      {'inv': 'INV-3200', 'name': 'Diya Sharma', 'cls': 'X-A', 'mode': 'Card', 'amt': '₹31,200', 'date': 'Nov 24'},
      {'inv': 'INV-3199', 'name': 'Kabir Khan', 'cls': 'VI-C', 'mode': 'Bank', 'amt': '₹18,900', 'date': 'Nov 23'},
      {'inv': 'INV-3198', 'name': 'Saanvi Iyer', 'cls': 'IX-A', 'mode': 'UPI', 'amt': '₹27,800', 'date': 'Nov 23'},
      {'inv': 'INV-3197', 'name': 'Vivaan Gupta', 'cls': 'VII-B', 'mode': 'Cash', 'amt': '₹21,500', 'date': 'Nov 22'},
      {'inv': 'INV-3196', 'name': 'Anaya Bose', 'cls': 'VII-A', 'mode': 'UPI', 'amt': '₹12,500', 'date': 'Nov 22'},
      {'inv': 'INV-3195', 'name': 'Ishaan Patel', 'cls': 'VIII-C', 'mode': 'Card', 'amt': '₹9,800', 'date': 'Nov 21'},
    ];
    if (_selectedFilter == 'Transport') return all.sublist(2, 5);
    if (_selectedFilter == 'Tuition') return all.sublist(0, 4);
    if (_selectedFilter == 'Hostel') return [all[1], all[3], all[6]];
    return all;
  }

  List<Map<String, dynamic>> _getOutstandingDuesValues() {
    final all = [
      {'name': 'Rohan Verma', 'cls': 'IX-B', 'amt': '₹32,500', 'days': '28 days', 'color': const Color(0xFFF59E0B)},
      {'name': 'Anaya Bose', 'cls': 'VII-A', 'amt': '₹18,750', 'days': '21 days', 'color': const Color(0xFFF59E0B)},
      {'name': 'Ishaan Patel', 'cls': 'VIII-C', 'amt': '₹27,400', 'days': '15 days', 'color': const Color(0xFFF59E0B)},
      {'name': 'Meera Nair', 'cls': 'X-B', 'amt': '₹41,200', 'days': '42 days', 'color': const Color(0xFFEF4444)},
      {'name': 'Aditya Reddy', 'cls': 'VI-A', 'amt': '₹15,800', 'days': '9 days', 'color': const Color(0xFF10B981)},
    ];
    if (_selectedFilter == 'Transport') return all.sublist(1, 3);
    if (_selectedFilter == 'Tuition') return all.sublist(0, 2);
    if (_selectedFilter == 'Hostel') return [all[0], all[3]];
    return all.sublist(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Financial Summary'),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildKPIs(isTablet),
                        const SizedBox(height: 32),
                        _buildQuickActions(isTablet),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Revenue vs Expenses'),
                        const SizedBox(height: 24),
                        _buildRevenueVsExpenses(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Collection Fee Type'),
                        const SizedBox(height: 24),
                        _buildCollectionFeeType(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Payments Status', 'Students with pending fee', LucideIcons.search),
                        const SizedBox(height: 24),
                        _buildPaymentsStatus(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Monthly Collection Fee'),
                        const SizedBox(height: 24),
                        _buildMonthlyCollectionFee(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Expense Breakdown'),
                        const SizedBox(height: 24),
                        _buildExpenseBreakdown(),
                        const SizedBox(height: 48),

                        _buildListFilters(),
                        SizedBox(height: 12.h),
                        _buildRecentPayments(),
                        const SizedBox(height: 48),

                        _buildOutstandingDues(),
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
  Widget _buildSectionTitle(String title, [String? subtitle, IconData? actionIcon]) {
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
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    color: _textMuted,
                  ),
                ),
              ]
            ],
          ),
        ),
        if (actionIcon != null)
          Icon(actionIcon, size: 20, color: _textDark),
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
            Text(
              'Financial Summary',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                value: _selectedYear,
                items: ['2024-25', '2025-26'],
                onChanged: (val) {
                  setState(() => _selectedYear = val);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDropdown(
                value: _selectedFilter,
                items: ['All', 'Tuition', 'Transport', 'Hostel', 'Exam', 'Misc'],
                onChanged: (val) {
                  setState(() => _selectedFilter = val);
                },
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedYear = '2025-26';
                  _selectedFilter = 'All';
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.rotateCcw, size: 16, color: _textDark),
                    const SizedBox(width: 6),
                    Text(
                      'Reset',
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData? _getIconForFilter(String filter) {
    switch (filter) {
      case 'All': return LucideIcons.layoutGrid;
      case 'Tuition': return LucideIcons.graduationCap;
      case 'Transport': return LucideIcons.bus;
      case 'Hostel': return LucideIcons.building;
      case 'Exam': return LucideIcons.clipboardList;
      case 'Misc': return LucideIcons.moreHorizontal;
      default: return LucideIcons.calendar;
    }
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownMenu<String>(
      key: ValueKey(value),
      initialSelection: value,
      enableFilter: true,
      requestFocusOnTap: true,
      expandedInsets: EdgeInsets.zero,
      onSelected: (val) {
        if (val != null) onChanged(val);
      },
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hoverColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6366F1)),
        ),
      ),
      textStyle: GoogleFonts.figtree(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: _textDark,
      ),
      dropdownMenuEntries: items.map((item) {
        final icon = _getIconForFilter(item);
        return DropdownMenuEntry<String>(
          value: item,
          label: item,
          leadingIcon: icon != null ? Icon(icon, size: 18, color: const Color(0xFF6366F1)) : null,
        );
      }).toList(),
    );
  }

  // --- KPIs ---
  Widget _buildKPIs(bool isTablet) {
    final kpi = _getKPIValues();
    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.25,
      children: [
        _buildKPICard(
          title: 'TOTAL FEE COLLECTED',
          value: kpi['fee']!,
          trendValue: '+12.4%',
          trendLabel: 'vs last',
          trendIcon: LucideIcons.trendingUp,
          isPositive: true,
          iconBg: const Color(0xFFEEF2FF),
          iconColor: const Color(0xFF6366F1),
          icon: LucideIcons.wallet,
          sparklineColor: const Color(0xFF6366F1),
          data: [1, 2, 2.5, 3, 3.5, 4, 4.2],
        ),
        _buildKPICard(
          title: 'PENDING DUES',
          value: kpi['dues']!,
          trendValue: '6 students',
          trendLabel: 'vs last',
          trendIcon: LucideIcons.activity,
          isPositive: false,
          iconBg: const Color(0xFFFFF7ED),
          iconColor: const Color(0xFFF59E0B),
          icon: LucideIcons.alertCircle,
          sparklineColor: const Color(0xFFF59E0B),
          data: [4, 3.8, 3.5, 3.6, 3.2, 3.0, 3.1],
        ),
        _buildKPICard(
          title: 'MONTHLY EXPENSES',
          value: kpi['exp']!,
          trendValue: '+4.2%',
          trendLabel: 'vs last',
          trendIcon: LucideIcons.trendingUp,
          isPositive: false,
          iconBg: const Color(0xFFFEF2F2),
          iconColor: const Color(0xFFEF4444),
          icon: LucideIcons.fileText,
          sparklineColor: const Color(0xFFEF4444),
          data: [3, 2.8, 3.1, 2.9, 3.5, 3.2, 3.0],
        ),
        _buildKPICard(
          title: 'NET BALANCE',
          value: kpi['net']!,
          trendValue: 'Surplus',
          trendLabel: 'vs last',
          trendIcon: LucideIcons.trendingUp,
          isPositive: true,
          iconBg: const Color(0xFFF0FDF4),
          iconColor: const Color(0xFF22C55E),
          icon: LucideIcons.piggyBank,
          sparklineColor: const Color(0xFF22C55E),
          data: [2, 2.2, 2.5, 2.4, 2.8, 3.0, 3.5],
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String trendValue,
    required String trendLabel,
    required IconData trendIcon,
    required bool isPositive,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required Color sparklineColor,
    required List<double> data,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: iconColor.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 20, color: iconColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _textMuted,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          value,
                          style: GoogleFonts.figtree(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                trendIcon,
                                size: 14,
                                color: isPositive ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                trendValue,
                                style: GoogleFonts.figtree(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isPositive ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                trendLabel,
                                style: GoogleFonts.figtree(
                                  fontSize: 11,
                                  color: _textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: CustomPaint(
                painter: _SparklinePainter(data: data, color: sparklineColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Quick Actions ---
  Widget _buildQuickActions(bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
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
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            children: [
              _buildActionCard('Collect Fee', LucideIcons.wallet, const Color(0xFF6366F1), const Color(0xFFEEF2FF)),
              _buildActionCard('Create Invoice', LucideIcons.filePlus, const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
              _buildActionCard('Record Expense', LucideIcons.fileMinus, const Color(0xFFEF4444), const Color(0xFFFEF2F2)),
              _buildActionCard('Payment History', LucideIcons.history, const Color(0xFFF59E0B), const Color(0xFFFFF7ED)),
              _buildActionCard('Generate Report', LucideIcons.fileSpreadsheet, const Color(0xFF10B981), const Color(0xFFE8FDF3)),
              _buildActionCard('Fee Settings', LucideIcons.settings, const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, Color bgColor) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- Payments Status ---
  Widget _buildPaymentsStatus() {
    final status = _getPaymentStatusValues();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Status', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text('Across all invoices', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const SizedBox(height: 24),
            _buildStatusProgressRow('Paid', '${(status['paid']! * 100).toInt()}%', status['paid']!, const Color(0xFF10B981), LucideIcons.checkCircle),
            const SizedBox(height: 24),
            _buildStatusProgressRow('Pending', '${(status['pending']! * 100).toInt()}%', status['pending']!, const Color(0xFFF59E0B), LucideIcons.clock),
            const SizedBox(height: 24),
            _buildStatusProgressRow('Overdue', '${(status['overdue']! * 100).toInt()}%', status['overdue']!, const Color(0xFFEF4444), LucideIcons.xCircle),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusProgressRow(String title, String percent, double fraction, Color color, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: _textMuted), // the icons in the image are grey
                const SizedBox(width: 8),
                Text(title, style: GoogleFonts.figtree(fontSize: 13, color: _textDark, fontWeight: FontWeight.w500)),
              ],
            ),
            Text(percent, style: GoogleFonts.figtree(fontSize: 13, color: _textDark, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  // --- Expense Breakdown ---
  Widget _buildExpenseBreakdown() {
    final expenses = _getExpenseBreakdownValues();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Expense Breakdown', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text('Total ${expenses.isNotEmpty ? 'calculated' : ''}', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const SizedBox(height: 24),
            ...expenses.asMap().entries.map((e) {
              return Padding(
                padding: EdgeInsets.only(bottom: e.key == expenses.length - 1 ? 0 : 16),
                child: _buildExpenseBar(e.value['title'], e.value['amount'], e.value['pct'], e.value['val'], e.value['color']),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseBar(String label, String amount, String percentStr, double percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w500, color: _textDark)),
            Text('$amount · $percentStr', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(3))),
            FractionallySizedBox(
              widthFactor: percent,
              child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
            ),
          ],
        ),
      ],
    );
  }

  // --- Monthly Collection Fee ---
  Widget _buildMonthlyCollectionFee() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monthly Fee Collection Trend', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text('Last 8 months (₹L)', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: const Color(0xFFF3F4F6),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: _textMuted, fontSize: 10);
                          Widget text;
                          switch (value.toInt()) {
                            case 0: text = const Text('Apr', style: style); break;
                            case 1: text = const Text('May', style: style); break;
                            case 2: text = const Text('Jun', style: style); break;
                            case 3: text = const Text('Jul', style: style); break;
                            case 4: text = const Text('Aug', style: style); break;
                            case 5: text = const Text('Sep', style: style); break;
                            case 6: text = const Text('Oct', style: style); break;
                            case 7: text = const Text('Nov', style: style); break;
                            default: text = const Text('', style: style); break;
                          }
                          return SideTitleWidget(meta: meta, child: text);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}', style: const TextStyle(color: _textMuted, fontSize: 10));
                        },
                        reservedSize: 28,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Color(0xFFD1D5DB)),
                      bottom: BorderSide(color: Color(0xFFD1D5DB)),
                    ),
                  ),
                  minX: 0,
                  maxX: 7,
                  minY: 0,
                  maxY: 8,
                  lineTouchData: LineTouchData(
                    enabled: true,
                    getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          const FlLine(color: Color(0xFFD1D5DB), strokeWidth: 1),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: const Color(0xFF6366F1),
                            ),
                          ),
                        );
                      }).toList();
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => Colors.white,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          const months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
                          String xLabel = '';
                          if (spot.x >= 0 && spot.x < months.length) {
                            xLabel = months[spot.x.toInt()];
                          }
                          return LineTooltipItem(
                            '$xLabel\n',
                            GoogleFonts.figtree(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13),
                            children: [
                              TextSpan(
                                text: 'v : ${spot.y}',
                                style: GoogleFonts.figtree(color: const Color(0xFF6366F1), fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                            ],
                            textAlign: TextAlign.left,
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getMonthlyCollectionSpots(),
                      isCurved: true,
                      color: const Color(0xFF6366F1),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6366F1).withValues(alpha: 0.15),
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
    );
  }

  // --- Revenue vs Expenses ---
  Widget _buildRevenueVsExpenses() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Revenue vs Expenses', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text('Monthly comparison - 2025-26', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 8,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.white,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (rodIndex != 0) return null; // Show only one merged tooltip

                        const months = ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
                        String xLabel = '';
                        if (group.x >= 0 && group.x < months.length) {
                          xLabel = months[group.x.toInt()];
                        }
                        
                        final revY = group.barRods[0].toY;
                        final expY = group.barRods[1].toY;
                        
                        return BarTooltipItem(
                          '$xLabel\n',
                          GoogleFonts.figtree(color: _textDark, fontWeight: FontWeight.bold, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Revenue : $revY\n',
                              style: GoogleFonts.figtree(color: const Color(0xFF6366F1), fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            TextSpan(
                              text: 'Expenses : $expY',
                              style: GoogleFonts.figtree(color: const Color(0xFFC7D2FE), fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                          textAlign: TextAlign.left,
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(color: _textMuted, fontSize: 10);
                          Widget text;
                          switch (value.toInt()) {
                            case 0: text = const Text('Apr', style: style); break;
                            case 1: text = const Text('May', style: style); break;
                            case 2: text = const Text('Jun', style: style); break;
                            case 3: text = const Text('Jul', style: style); break;
                            case 4: text = const Text('Aug', style: style); break;
                            case 5: text = const Text('Sep', style: style); break;
                            case 6: text = const Text('Oct', style: style); break;
                            case 7: text = const Text('Nov', style: style); break;
                            default: text = const Text('', style: style); break;
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
                        getTitlesWidget: (value, meta) => Text('${value.toInt()}', style: const TextStyle(color: _textMuted, fontSize: 10)),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: const Color(0xFFF3F4F6),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(color: Color(0xFFD1D5DB)),
                      bottom: BorderSide(color: Color(0xFFD1D5DB)),
                    ),
                  ),
                  barGroups: _getRevenueVsExpensesGroups(),
                ),
              ),
            ),
            SizedBox(height: 12.h),
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
    );
  }

  // --- Collection Fee Type ---
  Widget _buildCollectionFeeType() {
    final fees = _getCollectionFeeTypeValues();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Collection by Fee Type', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text('Share of total revenue', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    startDegreeOffset: 270,
                    sections: fees.map((f) => PieChartSectionData(color: f['color'], value: f['val'], title: '', radius: 35)).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: fees.map((f) => _buildDonutLegendItem(f['title'] as String, f['pct'] as String, f['color'] as Color)).toList(),
            ),
          ],
        ),
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
          width: 12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: y2,
          color: const Color(0xFFC7D2FE),
          width: 12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
      ],
    );
  }

  Widget _buildDonutLegendItem(String label, String percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _textDark, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(percent, style: GoogleFonts.figtree(fontSize: 13, color: _textDark, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() => GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: _textMuted);
  TextStyle _tableDataStyle() => GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark);

  // --- List Filters ---
  Widget _buildListFilters() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.search, size: 20, color: _textMuted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search by student, class or invoice...',
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    color: _textMuted,
                  ),
                ),
              ),
              const Icon(LucideIcons.filter, size: 20, color: Color(0xFF6366F1)),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterPill('All', true),
              const SizedBox(width: 8),
              _buildFilterPill('Paid', false),
              const SizedBox(width: 8),
              _buildFilterPill('Pending', false),
              const SizedBox(width: 8),
              _buildFilterPill('Overdue', false),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.download, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Export Report',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPill(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB)),
      ),
      child: Text(
        label,
        style: GoogleFonts.figtree(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : _textDark,
        ),
      ),
    );
  }

  // --- Recent Payments ---
  Widget _buildRecentPayments() {
    final payments = _getRecentPaymentsValues();
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
                Text('Recent Payments', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 4),
                Text('${payments.length} transactions', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Invoice', style: _tableHeaderStyle())),
                const SizedBox(width: 8),
                Expanded(flex: 3, child: Text('Student', style: _tableHeaderStyle())),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: Text('Class', style: _tableHeaderStyle())),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: Text('Mode', style: _tableHeaderStyle())),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: Text('Amount', style: _tableHeaderStyle())),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: Text('Date', style: _tableHeaderStyle(), textAlign: TextAlign.right)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ...payments.map((p) => Column(
            children: [
              _buildRecentPaymentRow(p['inv']!, p['name']!, p['cls']!, p['mode']!, p['amt']!, p['date']!),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
            ],
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRecentPaymentRow(String invoice, String student, String cls, String mode, String amount, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(invoice, style: _tableDataStyle())),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text(student, style: _tableDataStyle())),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: Text(cls, style: _tableDataStyle().copyWith(color: _textMuted, fontWeight: FontWeight.normal))),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(mode, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: Text(amount, style: _tableDataStyle())),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: Text(date, style: _tableDataStyle().copyWith(color: _textMuted, fontWeight: FontWeight.normal), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  // --- Outstanding Dues ---
  Widget _buildOutstandingDues() {
    final dues = _getOutstandingDuesValues();
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
                Text('Outstanding Dues', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 4),
                Text('${dues.length} students pending', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('Student', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('Class', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('Amount', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('Overdue', style: _tableHeaderStyle())),
                Expanded(flex: 2, child: Text('Action', style: _tableHeaderStyle(), textAlign: TextAlign.right)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ...dues.map((d) => Column(
            children: [
              _buildOutstandingDuesRow(d['name'] as String, d['cls'] as String, d['amt'] as String, d['days'] as String, d['color'] as Color),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
            ],
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildOutstandingDuesRow(String student, String cls, String amount, String overdue, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(student, style: _tableDataStyle())),
          Expanded(flex: 2, child: Text(cls, style: _tableDataStyle().copyWith(color: _textMuted, fontWeight: FontWeight.normal))),
          Expanded(flex: 2, child: Text(amount, style: _tableDataStyle())),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.2)),
                ),
                child: Text(
                  overdue,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(LucideIcons.bell, size: 14, color: Color(0xFF6366F1)),
                const SizedBox(width: 4),
                Text('Remind', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
              ],
            ),
          ),
        ],
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
    
    final minData = data.reduce(math.min);
    final maxData = data.reduce(math.max);
    final range = maxData - minData == 0 ? 1 : maxData - minData;
    
    final path = Path();
    final xStep = size.width / (data.length - 1);
    
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      // Leaving a bit of space at the top and bottom
      final y = size.height - (((data[i] - minData) / range) * (size.height * 0.7)) - (size.height * 0.15);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = (i - 1) * xStep;
        final prevY = size.height - (((data[i - 1] - minData) / range) * (size.height * 0.7)) - (size.height * 0.15);
        final controlX1 = prevX + (x - prevX) / 2;
        final controlY1 = prevY;
        final controlX2 = prevX + (x - prevX) / 2;
        final controlY2 = y;
        path.cubicTo(controlX1, controlY1, controlX2, controlY2, x, y);
      }
    }
    
    // Draw gradient fill
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
    canvas.drawPath(fillPath, fillPaint);

    // Draw stroke line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
      
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
