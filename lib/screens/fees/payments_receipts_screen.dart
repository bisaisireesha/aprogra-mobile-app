import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

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

class _PaymentsReceiptsScreenState extends State<PaymentsReceiptsScreen> {
  @override
  void initState() {
    super.initState();
    _loadPaymentmodes();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _paymentModes = [
    {
      'mode': 'UPI',
      'amount': '₹22.4L',
      'percent': 46,
      'icon': LucideIcons.smartphone,
      'color': const Color(0xFF22C55E),
      'bg': const Color(0xFFF0FDF4),
    },
    {
      'mode': 'Card',
      'amount': '₹14.1L',
      'percent': 29,
      'icon': LucideIcons.creditCard,
      'color': const Color(0xFF0EA5E9),
      'bg': const Color(0xFFF0F9FF),
    },
    {
      'mode': 'Cash',
      'amount': '₹8.2L',
      'percent': 17,
      'icon': LucideIcons.banknote,
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFFBEB),
    },
    {
      'mode': 'Bank Transfer',
      'amount': '₹3.9L',
      'percent': 8,
      'icon': LucideIcons.building2,
      'color': const Color(0xFF8B5CF6),
      'bg': const Color(0xFFF3E8FF),
    },
  ];

  final List<Map<String, dynamic>> _receipts = [
    {
      'id': 'RCT-2025-3401',
      'date': '15 May 2025',
      'student': 'Aryan Reddy',
      'class': 'Class 6A',
      'invoice': 'INV-2025-0841',
      'mode': 'UPI',
      'amount': '₹24,500',
      'status': 'Paid',
      'modeColor': const Color(0xFF22C55E),
      'modeBg': const Color(0xFFF0FDF4),
    },
    {
      'id': 'RCT-2025-3402',
      'date': '15 May 2025',
      'student': 'Ishita Kapoor',
      'class': 'Class 7C',
      'invoice': 'INV-2025-0839',
      'mode': 'Card',
      'amount': '₹22,000',
      'status': 'Paid',
      'modeColor': const Color(0xFF0EA5E9),
      'modeBg': const Color(0xFFF0F9FF),
    },
    {
      'id': 'RCT-2025-3403',
      'date': '14 May 2025',
      'student': 'Meera Nair',
      'class': 'Class 4A',
      'invoice': 'INV-2025-0836',
      'mode': 'Cash',
      'amount': '₹18,500',
      'status': 'Paid',
      'modeColor': const Color(0xFFF59E0B),
      'modeBg': const Color(0xFFFFFBEB),
    },
    {
      'id': 'RCT-2025-3404',
      'date': '14 May 2025',
      'student': 'Kabir Sharma',
      'class': 'Class 8B',
      'invoice': 'INV-2025-0832',
      'mode': 'Bank Transfer',
      'amount': '₹14,100',
      'status': 'Paid',
      'modeColor': const Color(0xFF8B5CF6),
      'modeBg': const Color(0xFFF3E8FF),
    },
    {
      'id': 'RCT-2025-3405',
      'date': '13 May 2025',
      'student': 'Saanvi Iyer',
      'class': 'Class 9B',
      'invoice': 'INV-2025-0828',
      'mode': 'UPI',
      'amount': '₹6,800',
      'status': 'Paid',
      'modeColor': const Color(0xFF22C55E),
      'modeBg': const Color(0xFFF0FDF4),
    },
    {
      'id': 'RCT-2025-3406',
      'date': '13 May 2025',
      'student': 'Vihaan Joshi',
      'class': 'Class 10B',
      'invoice': 'INV-2025-0825',
      'mode': 'UPI',
      'amount': '₹4,500',
      'status': 'Paid',
      'modeColor': const Color(0xFF22C55E),
      'modeBg': const Color(0xFFF0FDF4),
    },
  ];

  Future<void> _loadPaymentmodes() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__paymentModes_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _paymentModes = decoded.map((item) {
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

  Future<void> _savePaymentmodes() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _paymentModes.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__paymentModes_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Payments & Receipts'),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildSummaryCards(),
                        const SizedBox(height: 32),
                        _buildPaymentModes(),
                        const SizedBox(height: 32),
                        _buildReceiptsListSection(),
                        SizedBox(height: 12.h),
                        _buildInfoFooter(),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (canPop) {
              Navigator.pop(context);
            } else {
              _scaffoldKey.currentState?.openDrawer();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: Icon(
              canPop ? LucideIcons.arrowLeft : LucideIcons.menu,
              size: 24,
              color: _dark,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payments & Receipts',
                style: GoogleFonts.figtree(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Browse collected payments, download receipts, and reconcile transactions.',
                style: GoogleFonts.figtree(fontSize: 13, color: _muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Exporting receipts...')),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                const Icon(LucideIcons.download, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  'Export Receipts',
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final kpis = [
      {
        'label': 'Total Received',
        'value': '₹48.6L',
        'sub': 'May 2025',
        'icon': LucideIcons.trendingUp,
        'color': const Color(0xFF6366F1),
        'bg': const Color(0xFFEEEDFD),
      },
      {
        'label': 'Receipts Issued',
        'value': '1,284',
        'sub': '+62 this week',
        'icon': LucideIcons.receipt,
        'color': const Color(0xFF22C55E),
        'bg': const Color(0xFFF0FDF4),
      },
      {
        'label': 'Avg Payment',
        'value': '₹3,787',
        'sub': 'per receipt',
        'icon': LucideIcons.wallet,
        'color': const Color(0xFF0EA5E9),
        'bg': const Color(0xFFF0F9FF),
      },
      {
        'label': 'Refunds',
        'value': '₹18,400',
        'sub': '6 transactions',
        'icon': LucideIcons.refreshCw,
        'color': const Color(0xFFEF4444),
        'bg': const Color(0xFFFEF2F2),
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

  Widget _kpiCard(Map<String, dynamic> k, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: k['bg'] as Color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                k['icon'] as IconData,
                size: 18,
                color: k['color'] as Color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              k['value'] as String,
              style: GoogleFonts.figtree(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _dark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              k['label'] as String,
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _dark,
              ),
            ),
            Text(
              k['sub'] as String,
              style: GoogleFonts.figtree(fontSize: 12, color: _muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'By Payment Mode',
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _dark,
          ),
        ),
        const SizedBox(height: 16),

        // All Modes
        // All Modes
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _primary),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.walletCards,
                  size: 18,
                  color: _primary,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'All Modes',
                style: GoogleFonts.figtree(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _dark,
                ),
              ),
              const Spacer(),
              Text(
                '₹48.6L',
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(LucideIcons.chevronRight, size: 18, color: _muted),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // Payment Mode List
        ..._paymentModes.map((m) => _buildPaymentModeCard(m)),
      ],
    );
  }

  Widget _buildPaymentModeCard(Map<String, dynamic> m) {
    final color = m['color'] as Color;
    final percent = m['percent'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: m['bg'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(m['icon'] as IconData, size: 18, color: color),
              ),
              const SizedBox(width: 16),
              Text(
                m['mode'] as String,
                style: GoogleFonts.figtree(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _dark,
                ),
              ),
              const Spacer(),
              Text(
                m['amount'] as String,
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _dark,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(LucideIcons.chevronRight, size: 18, color: _muted),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      widthFactor: percent / 100.0,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFA5B4FC),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$percent% of total',
                  style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.info, size: 16, color: _primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment mode distribution is based on received amount.',
                  style: GoogleFonts.figtree(fontSize: 12, color: _primary),
                ),
                Text(
                  'Data updates every 30 minutes.',
                  style: GoogleFonts.figtree(fontSize: 12, color: _primary),
                ),
              ],
            ),
          ),
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

  Widget _buildReceiptsListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Receipts ',
                      style: GoogleFonts.figtree(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _dark,
                      ),
                    ),
                    TextSpan(
                      text: '(${_receipts.length})',
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _primary.withValues(alpha: 0.2)),
              ),
              child: const Icon(LucideIcons.filter, size: 18, color: _primary),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: TextField(
            style: GoogleFonts.figtree(fontSize: 14, color: _dark),
            decoration: InputDecoration(
              hintText: 'Search receipt # or student...',
              hintStyle: GoogleFonts.figtree(
                fontSize: 14,
                color: _muted.withValues(alpha: 0.6),
              ),
              prefixIcon: const Icon(
                LucideIcons.search,
                size: 18,
                color: _muted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _datePicker('dd/mm/yyyy')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('-', style: GoogleFonts.figtree(color: _muted)),
            ),
            Expanded(child: _datePicker('dd/mm/yyyy')),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _border),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.filter, size: 14, color: _dark),
                  const SizedBox(width: 6),
                  Text(
                    'More Filters',
                    style: GoogleFonts.figtree(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _dark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ..._receipts.map((r) => _buildReceiptCard(r)),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            'Showing ${_receipts.length} of ${_receipts.length} receipts',
            style: GoogleFonts.figtree(fontSize: 12, color: _muted),
          ),
        ),
      ],
    );
  }

  Widget _datePicker(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(LucideIcons.calendar, size: 14, color: _muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hint,
              style: GoogleFonts.figtree(fontSize: 12, color: _dark),
            ),
          ),
          const Icon(LucideIcons.calendar, size: 14, color: _dark),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.receipt,
                    size: 20,
                    color: _primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['id'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _dark,
                        ),
                      ),
                      Text(
                        r['date'] as String,
                        style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        r['student'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _dark,
                        ),
                      ),
                      Text(
                        r['class'] as String,
                        style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r['invoice'] as String,
                        style: GoogleFonts.figtree(fontSize: 11, color: _muted),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: r['modeBg'] as Color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            r['mode'] as String,
                            style: GoogleFonts.figtree(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: r['modeColor'] as Color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          r['amount'] as String,
                          style: GoogleFonts.figtree(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        r['status'] as String,
                        style: GoogleFonts.figtree(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF22C55E),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          Row(
            children: [
              _actionBtn(LucideIcons.eye, 'View', const Color(0xFF595973)),
              Container(width: 1, height: 20, color: _border),
              _actionBtn(LucideIcons.mail, 'Email', const Color(0xFF595973)),
              Container(width: 1, height: 20, color: _border),
              _actionBtn(LucideIcons.printer, 'Print', const Color(0xFF595973)),
              Container(width: 1, height: 20, color: _border),
              _actionBtn(LucideIcons.download, 'Download', _primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$label clicked')));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
