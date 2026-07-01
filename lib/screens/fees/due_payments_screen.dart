import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'defaulters_list_screen.dart';

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


  
  @override
  void initState() {
    super.initState();
    _loadBuckets();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _buckets = [
    {
      'label': '0 – 7 Days',
      'sub': 'Newly overdue',
      'students': 28,
      'amount': '₹1.24L',
      'percent': '14%',
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFF7ED),
    },
    {
      'label': '8 – 15 Days',
      'sub': 'Follow-up needed',
      'students': 34,
      'amount': '₹1.88L',
      'percent': '22%',
      'color': const Color(0xFFF59E0B),
      'bg': const Color(0xFFFFF7ED),
    },
    {
      'label': '16 – 30 Days',
      'sub': 'High priority',
      'students': 22,
      'amount': '₹2.18L',
      'percent': '25%',
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEF2F2),
    },
    {
      'label': '30+ Days',
      'sub': 'Critical — escalate',
      'students': 22,
      'amount': '₹3.44L',
      'percent': '39%',
      'color': const Color(0xFFEF4444),
      'bg': const Color(0xFFFEF2F2),
    },
  ];

  final List<Map<String, dynamic>> _defaulters = [
    {
      'name': 'Rohan Mehta', 'initials': 'RM', 'class': 'Class 10A', 'parent': 'Mr. Mehta', 'phone': '+91 98765 43210',
      'amount': '₹32,400', 'days': '38 days', 'date': '12 Apr 2025',
      'avatarColor': const Color(0xFF6366F1), 'avatarBg': const Color(0xFFEEEDFD), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
    {
      'name': 'Anaya Verma', 'initials': 'AV', 'class': 'Class 5A', 'parent': 'Mrs. Verma', 'phone': '+91 98765 11122',
      'amount': '₹19,800', 'days': '32 days', 'date': '18 Apr 2025',
      'avatarColor': const Color(0xFFF97316), 'avatarBg': const Color(0xFFFFF7ED), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
    {
      'name': 'Saanvi Iyer', 'initials': 'SI', 'class': 'Class 9B', 'parent': 'Mr. Iyer', 'phone': '+91 98700 33344',
      'amount': '₹12,600', 'days': '18 days', 'date': '01 May 2025',
      'avatarColor': const Color(0xFFF59E0B), 'avatarBg': const Color(0xFFFFFBEB), 'tagColor': const Color(0xFFF59E0B), 'tagBg': const Color(0xFFFFFBEB)
    },
    {
      'name': 'Kabir Sharma', 'initials': 'KS', 'class': 'Class 8B', 'parent': 'Mrs. Sharma', 'phone': '+91 98700 55667',
      'amount': '₹24,300', 'days': '14 days', 'date': '05 May 2025',
      'avatarColor': const Color(0xFF22C55E), 'avatarBg': const Color(0xFFF0FDF4), 'tagColor': const Color(0xFFF59E0B), 'tagBg': const Color(0xFFFFFBEB)
    },
    {
      'name': 'Vihaan Joshi', 'initials': 'VJ', 'class': 'Class 10B', 'parent': 'Mr. Joshi', 'phone': '+91 99000 12345',
      'amount': '₹9,500', 'days': '9 days', 'date': '10 May 2025',
      'avatarColor': const Color(0xFF0EA5E9), 'avatarBg': const Color(0xFFF0F9FF), 'tagColor': const Color(0xFFF59E0B), 'tagBg': const Color(0xFFFFFBEB)
    },
    {
      'name': 'Meera Nair', 'initials': 'MN', 'class': 'Class 4A', 'parent': 'Mrs. Nair', 'phone': '+91 99887 76655',
      'amount': '₹7,200', 'days': '6 days', 'date': '13 May 2025',
      'avatarColor': const Color(0xFF8B5CF6), 'avatarBg': const Color(0xFFF3E8FF), 'tagColor': const Color(0xFF0EA5E9), 'tagBg': const Color(0xFFE0F2FE)
    },
    {
      'name': 'Priya Krishnan', 'initials': 'PK', 'class': 'Class 11A', 'parent': 'Mr. Krishnan', 'phone': '+91 98881 22334',
      'amount': '₹34,500', 'days': '41 days', 'date': '08 Apr 2025',
      'avatarColor': const Color(0xFFEF4444), 'avatarBg': const Color(0xFFFEF2F2), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
    {
      'name': 'Aditya Rao', 'initials': 'AR', 'class': 'Class 12B', 'parent': 'Mrs. Rao', 'phone': '+91 97777 44556',
      'amount': '₹36,000', 'days': '35 days', 'date': '11 Apr 2025',
      'avatarColor': const Color(0xFFF59E0B), 'avatarBg': const Color(0xFFFFFBEB), 'tagColor': const Color(0xFFEF4444), 'tagBg': const Color(0xFFFEF2F2)
    },
  ];

  
  Future<void> _loadBuckets() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__buckets_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _buckets = decoded.map((item) {
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

  Future<void> _saveBuckets() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _buckets.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__buckets_data', jsonEncode(serialized));
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildSummaryCards(),
                        const SizedBox(height: 30),
                        _buildAgingBuckets(),
                        const SizedBox(height: 32),
                        _buildDefaultersSection(),
                        const SizedBox(height: 16),
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
            child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 24, color: _dark),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Due Payments', style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(height: 4),
              Text('Track pending dues, overdue invoices, and defaulters; follow up instantly.', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _sendBulkReminders,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.bellRing, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text('Send Bulk Reminder', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _sendBulkReminders() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(LucideIcons.bell, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        Text('Bulk Reminders sent successfully!', style: GoogleFonts.figtree(color: Colors.white)),
      ]),
      backgroundColor: _primary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Widget _buildSummaryCards() {
    final kpis = [
      {'label': 'Total Pending Dues', 'value': '₹8.74L', 'icon': LucideIcons.indianRupee, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFFF7ED)},
      {'label': 'Overdue Invoices', 'value': '126', 'icon': LucideIcons.alertCircle, 'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEF2F2)},
      {'label': 'Defaulters', 'value': '84', 'icon': LucideIcons.users, 'color': const Color(0xFF8B5CF6), 'bg': const Color(0xFFF3E8FF)},
      {'label': 'Avg Days Overdue', 'value': '21d', 'icon': LucideIcons.clock, 'color': const Color(0xFF0EA5E9), 'bg': const Color(0xFFE0F2FE)},
    ];

    return Column(
      children: [
        Row(children: [Expanded(child: _kpiCard(kpis[0])), const SizedBox(width: 12), Expanded(child: _kpiCard(kpis[1]))]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: _kpiCard(kpis[2], onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DefaultersListScreen()));
            }),
          ),
          const SizedBox(width: 12),
          Expanded(child: _kpiCard(kpis[3])),
        ]),
      ],
    );
  }

  Widget _kpiCard(Map<String, dynamic> k, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: k['bg'] as Color, borderRadius: BorderRadius.circular(10)),
              child: Icon(k['icon'] as IconData, size: 18, color: k['color'] as Color),
            ),
            const SizedBox(height: 16),
            Text(k['value'] as String, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _dark)),
            const SizedBox(height: 2),
            Text(k['label'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ],
        ),
      ),
    );
  }

  Widget _buildAgingBuckets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Aging Buckets', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
            Text('Breakdown of overdue amounts by age', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ],
        ),
        const SizedBox(height: 16),
        ..._buckets.map((b) => _buildBucketCard(b)),
      ],
    );
  }

  Widget _buildBucketCard(Map<String, dynamic> b) {
    final color = b['color'] as Color;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DefaultersListScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: b['bg'] as Color, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.3))),
        child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(color == const Color(0xFFEF4444) ? LucideIcons.alertCircle : LucideIcons.clock, size: 16, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b['label'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
                          Text(b['sub'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                        ],
                      ),
                    ),
                    Icon(LucideIcons.chevronRight, size: 18, color: _muted),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _bucketStat(b['students'].toString(), 'students')),
                    Container(width: 1, height: 30, color: color.withValues(alpha: 0.2)),
                    Expanded(child: _bucketStat(b['amount'] as String, 'amount')),
                    Container(width: 1, height: 30, color: color.withValues(alpha: 0.2)),
                    Expanded(child: _bucketStat(b['percent'] as String, 'of total dues')),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12, left: 16, right: 16,
            child: Stack(
              children: [
                Container(height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2))),
                FractionallySizedBox(
                  widthFactor: double.parse((b['percent'] as String).replaceAll('%', '')) / 100.0,
                  child: Container(height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _bucketStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
      ],
    );
  }

  Widget _buildInfoFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.info, size: 16, color: _primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amounts are based on overdue invoices.', style: GoogleFonts.figtree(fontSize: 12, color: _primary)),
                Text('Data updates every 30 minutes.', style: GoogleFonts.figtree(fontSize: 12, color: _primary)),
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
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Fees'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }

  Widget _buildDefaultersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Defaulters List ', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                    TextSpan(text: '(${_defaulters.length})', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _muted)),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
              child: const Icon(LucideIcons.filter, size: 18, color: _dark),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
          child: TextField(
            style: GoogleFonts.figtree(fontSize: 14, color: _dark),
            decoration: InputDecoration(
              hintText: 'Search defaulter by name...',
              hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted.withValues(alpha: 0.6)),
              prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._defaulters.map((d) => _buildDefaulterCard(d)),
        const SizedBox(height: 16),
        Center(
          child: Text('Showing ${_defaulters.length} of ${_defaulters.length} defaulters', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        ),
      ],
    );
  }

  Widget _buildDefaulterCard(Map<String, dynamic> d) {
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
                CircleAvatar(
                  radius: 22,
                  backgroundColor: d['avatarBg'] as Color,
                  child: Text(d['initials'] as String, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: d['avatarColor'] as Color)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d['name'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                      Text(d['class'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                      const SizedBox(height: 6),
                      Text(d['parent'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _dark)),
                      Text(d['phone'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(d['amount'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: d['tagBg'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(d['days'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: d['tagColor'] as Color)),
                    ),
                    const SizedBox(height: 4),
                    Text(d['date'] as String, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${d['parent']}...')));
                    },
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.phone, size: 14, color: Color(0xFF22C55E)),
                          const SizedBox(width: 6),
                          Text('Call', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF22C55E))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: _border),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notification sent to ${d['parent']}!')));
                    },
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.send, size: 14, color: _primary),
                          const SizedBox(width: 6),
                          Text('Notify', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _primary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
