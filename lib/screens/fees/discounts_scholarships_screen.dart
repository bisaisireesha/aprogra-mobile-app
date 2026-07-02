import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'schemes_list_screen.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class DiscountsScholarshipsScreen extends StatefulWidget {
  const DiscountsScholarshipsScreen({super.key});

  @override
  State<DiscountsScholarshipsScreen> createState() => _DiscountsScholarshipsScreenState();
}

class _DiscountsScholarshipsScreenState extends State<DiscountsScholarshipsScreen> {


  
  @override
  void initState() {
    super.initState();
    _loadSchemes();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _activeTab = 'All';

  List<Map<String, dynamic>> _schemes = [
    {'name': 'Sibling Discount', 'count': 132, 'max': 150, 'color': const Color(0xFF0EA5E9)},
    {'name': 'Need-based Aid', 'count': 64, 'max': 150, 'color': const Color(0xFFA855F7)},
    {'name': 'Merit Scholarship', 'count': 48, 'max': 150, 'color': const Color(0xFF7C3AED)},
    {'name': 'Early Bird', 'count': 28, 'max': 150, 'color': const Color(0xFFF97316)},
    {'name': 'Sports Excellence', 'count': 22, 'max': 150, 'color': const Color(0xFF10B981)},
    {'name': 'Staff Ward', 'count': 18, 'max': 150, 'color': const Color(0xFFC084FC)},
  ];

  final List<Map<String, dynamic>> _schemeDetails = [
    {
      'name': 'Merit Scholarship',
      'type': 'Scholarship',
      'status': 'Active',
      'eligibility': '≥ 90% marks',
      'award': '50% of Tuition',
      'beneficiaries': '48',
      'icon': LucideIcons.graduationCap,
    },
    {
      'name': 'Sibling Discount',
      'type': 'Discount',
      'status': 'Active',
      'eligibility': '2+ children enrolled',
      'award': '10% flat',
      'beneficiaries': '132',
      'icon': LucideIcons.tag,
    },
    {
      'name': 'Sports Excellence',
      'type': 'Scholarship',
      'status': 'Active',
      'eligibility': 'State-level player',
      'award': '₹15,000 fixed',
      'beneficiaries': '22',
      'icon': LucideIcons.trophy,
    },
    {
      'name': 'Staff Ward',
      'type': 'Discount',
      'status': 'Active',
      'eligibility': 'Children of staff',
      'award': '75% of Tuition',
      'beneficiaries': '18',
      'icon': LucideIcons.users,
    },
    {
      'name': 'Need-based Aid',
      'type': 'Scholarship',
      'status': 'Active',
      'eligibility': 'Annual income < 3L',
      'award': 'Up to 100%',
      'beneficiaries': '64',
      'icon': LucideIcons.heartHandshake,
    },
    {
      'name': 'Early Bird',
      'type': 'Discount',
      'status': 'Expired',
      'eligibility': 'Pay before May 1',
      'award': '5% flat',
      'beneficiaries': '28',
      'icon': LucideIcons.clock,
    },
  ];

  
  Future<void> _loadSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__schemes_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _schemes = decoded.map((item) {
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

  Future<void> _saveSchemes() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _schemes.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__schemes_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Discounts & Scholarships'),
      
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
                        const SizedBox(height: 24),
                        _buildSummaryCards(),
                        const SizedBox(height: 32),
                        _buildBeneficiariesByScheme(),
                        const SizedBox(height: 24),
                        _buildDonutChartCard(),
                        const SizedBox(height: 32),
                        _buildSchemesListSection(),
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
              Text('Discounts & Scholarships', style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(height: 4),
              Text('Configure award schemes, eligibility criteria, and track beneficiaries.', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemesListScreen()));
          },
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
                const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                const SizedBox(width: 6),
                Text('Add Scheme', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final kpis = [
      {'label': 'Active Schemes', 'value': '14', 'icon': LucideIcons.award, 'color': const Color(0xFF8B5CF6), 'bg': const Color(0xFFF3E8FF)},
      {'label': 'Beneficiaries', 'value': '312', 'icon': LucideIcons.users, 'color': const Color(0xFF22C55E), 'bg': const Color(0xFFF0FDF4)},
      {'label': 'Total Discount Given', 'value': '₹6.42L', 'icon': LucideIcons.percent, 'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFFFBEB)},
      {'label': 'Avg Award / Student', 'value': '₹2,057', 'icon': LucideIcons.indianRupee, 'color': const Color(0xFF0EA5E9), 'bg': const Color(0xFFF0F9FF)},
    ];

    return Column(
      children: [
        Row(children: [
          Expanded(
            child: _kpiCard(kpis[0], onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemesListScreen()));
            }),
          ),
          const SizedBox(width: 12),
          Expanded(child: _kpiCard(kpis[1])),
        ]),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: _kpiCard(kpis[2])), const SizedBox(width: 12), Expanded(child: _kpiCard(kpis[3]))]),
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
          SizedBox(height: 12.h),
          Text(k['value'] as String, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 2),
          Text(k['label'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _muted)),
        ],
      ),
    ),
    );
  }

  Widget _buildBeneficiariesByScheme() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Beneficiaries by Scheme', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 4),
          Text('Total 312 students across 6 schemes', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          const SizedBox(height: 20),
          ..._schemes.map((s) => _buildSchemeBar(s)),
        ],
      ),
    );
  }

  Widget _buildSchemeBar(Map<String, dynamic> s) {
    final count = s['count'] as int;
    final max = s['max'] as int;
    final color = s['color'] as Color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(s['name'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
              Text('$count', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(3))),
              FractionallySizedBox(
                widthFactor: count / max,
                child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scholarship vs Discount Split', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
          const SizedBox(height: 4),
          Text('Distribution of beneficiaries by award type', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          const SizedBox(height: 32),
          Row(
            children: [
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 45,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF7C3AED),
                        value: 43,
                        title: '',
                        radius: 20,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFF0EA5E9),
                        value: 57,
                        title: '',
                        radius: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(color: const Color(0xFF7C3AED), count: 134, label: 'Scholarship', percent: '43%'),
                    const SizedBox(height: 20),
                    _buildLegendItem(color: const Color(0xFF0EA5E9), count: 178, label: 'Discount', percent: '57%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required int count, required String label, required String percent}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$count', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
            Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            Text(percent, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ],
        ),
      ],
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

  Widget _buildSchemesListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: 'Schemes ', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                    TextSpan(text: '(${_schemeDetails.length})', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _muted)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
          child: Row(
            children: [
              _buildTab('All'),
              Container(width: 1, height: 24, color: _border),
              _buildTab('Scholarship'),
              Container(width: 1, height: 24, color: _border),
              _buildTab('Discount'),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
                child: TextField(
                  style: GoogleFonts.figtree(fontSize: 14, color: _dark),
                  decoration: InputDecoration(
                    hintText: 'Search schemes...',
                    hintStyle: GoogleFonts.figtree(fontSize: 14, color: _muted.withValues(alpha: 0.6)),
                    prefixIcon: const Icon(LucideIcons.search, size: 18, color: _muted),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: const Icon(LucideIcons.filter, size: 18, color: _dark),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ..._schemeDetails.map((s) => _buildSchemeCard(s)),
        SizedBox(height: 12.h),
        Center(
          child: Text('Showing ${_schemeDetails.length} of ${_schemeDetails.length} schemes', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
        ),
      ],
    );
  }

  Widget _buildTab(String label) {
    final isActive = _activeTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFF5F3FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? _primary : _muted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(Map<String, dynamic> s) {
    final isScholarship = s['type'] == 'Scholarship';
    final isActive = s['status'] == 'Active';

    final typeColor = isScholarship ? const Color(0xFF7C3AED) : const Color(0xFF0EA5E9);
    final typeBg = isScholarship ? const Color(0xFFF3E8FF) : const Color(0xFFE0F2FE);

    final statusColor = isActive ? const Color(0xFF22C55E) : const Color(0xFF64748B);
    final statusBg = isActive ? const Color(0xFFF0FDF4) : const Color(0xFFF1F5F9);

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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                      child: Icon(s['icon'] as IconData, size: 20, color: typeColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name'] as String, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: typeBg, borderRadius: BorderRadius.circular(12)),
                            child: Text(s['type'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: typeColor)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                      child: Text(s['status'] as String, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                    ),
                    const SizedBox(width: 12),
                    const Icon(LucideIcons.chevronRight, size: 18, color: _muted),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eligibility', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                          const SizedBox(height: 4),
                          Text(s['eligibility'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Award Value', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                          const SizedBox(height: 4),
                          Text(s['award'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Beneficiaries', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                          const SizedBox(height: 4),
                          Text(s['beneficiaries'] as String, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _border),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit ${s['name']}')));
                  },
                  child: const Icon(LucideIcons.pencil, size: 16, color: _muted),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete ${s['name']}')));
                  },
                  child: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
