import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'class_fee_details_screen.dart';
import 'add_fee_head_modal.dart';

const _bg = Color(0xFFF9F9FB);
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _border = Color(0xFFE5E7EB);

class FeeStructureScreen extends StatefulWidget {
  const FeeStructureScreen({super.key});

  
  @override
  void initState() {
    super.initState();
    _loadClassdatalist();
  }

  @override
  State<FeeStructureScreen> createState() => _FeeStructureScreenState();
}

class _FeeStructureScreenState extends State<FeeStructureScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTab = 'Classes';

  List<Map<String, dynamic>> _classDataList = [
    {
      'name': 'Class 5', 'subtitle': 'Section A-C · 96 students', 't1': '₹11,700', 't2': '₹11,700', 't3': '₹12,000', 'annual': '₹35,400',
      'breakdown': [
        {'title': 'Tuition', 't1': '₹8,000', 't2': '₹8,000', 't3': '₹8,000', 'ann': '₹24,000', 'icon': LucideIcons.book, 'color': const Color(0xFF6366F1)},
        {'title': 'Transport', 't1': '₹1,500', 't2': '₹1,500', 't3': '₹1,500', 'ann': '₹4,500', 'icon': LucideIcons.bus, 'color': const Color(0xFF0EA5E9)},
        {'title': 'Lab', 't1': '₹600', 't2': '₹600', 't3': '₹600', 'ann': '₹1,800', 'icon': LucideIcons.beaker, 'color': const Color(0xFF22C55E)},
      ]
    },
    {
      'name': 'Class 6', 'subtitle': 'Section A-C · 102 students', 't1': '₹12,400', 't2': '₹12,400', 't3': '₹12,700', 'annual': '₹37,500',
      'breakdown': [
        {'title': 'Tuition', 't1': '₹8,500', 't2': '₹8,500', 't3': '₹8,500', 'ann': '₹25,500', 'icon': LucideIcons.book, 'color': const Color(0xFF6366F1)},
        {'title': 'Transport', 't1': '₹1,800', 't2': '₹1,800', 't3': '₹1,800', 'ann': '₹5,400', 'icon': LucideIcons.bus, 'color': const Color(0xFF0EA5E9)},
        {'title': 'Lab', 't1': '₹800', 't2': '₹800', 't3': '₹800', 'ann': '₹2,400', 'icon': LucideIcons.beaker, 'color': const Color(0xFF22C55E)},
        {'title': 'Library', 't1': '₹200', 't2': '₹200', 't3': '₹200', 'ann': '₹600', 'icon': LucideIcons.library, 'color': const Color(0xFFF59E0B)},
        {'title': 'Sports', 't1': '₹400', 't2': '₹400', 't3': '₹400', 'ann': '₹1,200', 'icon': LucideIcons.award, 'color': const Color(0xFFEF4444)},
        {'title': 'Exam', 't1': '₹500', 't2': '₹500', 't3': '₹800', 'ann': '₹1,800', 'icon': LucideIcons.fileText, 'color': const Color(0xFF8B5CF6)},
        {'title': 'Misc', 't1': '₹200', 't2': '₹200', 't3': '₹200', 'ann': '₹600', 'icon': LucideIcons.moreHorizontal, 'color': const Color(0xFF64748B)},
      ]
    },
    {
      'name': 'Class 7', 'subtitle': 'Section A-C · 98 students', 't1': '₹13,500', 't2': '₹13,500', 't3': '₹13,800', 'annual': '₹40,800',
      'breakdown': [
        {'title': 'Tuition', 't1': '₹9,500', 't2': '₹9,500', 't3': '₹9,500', 'ann': '₹28,500', 'icon': LucideIcons.book, 'color': const Color(0xFF6366F1)},
      ]
    },
    {
      'name': 'Class 8', 'subtitle': 'Section A-B · 84 students', 't1': '₹14,300', 't2': '₹14,300', 't3': '₹14,700', 'annual': '₹43,300',
      'breakdown': [
        {'title': 'Tuition', 't1': '₹10,500', 't2': '₹10,500', 't3': '₹10,500', 'ann': '₹31,500', 'icon': LucideIcons.book, 'color': const Color(0xFF6366F1)},
      ]
    },
  ];

  
  Future<void> _loadClassdatalist() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__classDataList_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _classDataList = decoded.map((item) {
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

  Future<void> _saveClassdatalist() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _classDataList.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__classDataList_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Fee Structure'),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 0), child: CommonAppBar(showMenu: true)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildKPIs(),
                        const SizedBox(height: 24),
                        _buildTabs(),
                        const SizedBox(height: 16),
                        _buildClassesList(),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fee Structure', style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(height: 4),
              Text(
                'Configure class-wise fee heads, term-wise amounts, discounts and late fee rules.',
                style: GoogleFonts.figtree(fontSize: 13, color: _muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(children: [
              // Add Fee Head
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: const AddFeeHeadModal(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(LucideIcons.plus, size: 14, color: _muted),
                    const SizedBox(width: 6),
                    Text('Add Fee Head', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _muted)),
                  ]),
                ),
              ),
              const SizedBox(width: 8),
              // Add Class
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text('Add Class', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ]),
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _buildKPIs() {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      int crossAxisCount = w > 800 ? 4 : 2;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: w > 800 ? 2.5 : 2.0,
        children: [
          _kpiCard('Active Classes', '8', LucideIcons.layoutGrid, const Color(0xFF8B5CF6), const Color(0xFFF3E8FF)),
          _kpiCard('Fee Heads', '7', LucideIcons.tag, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
          _kpiCard('Total Annual Value', '₹3,79,700', LucideIcons.indianRupee, const Color(0xFF22C55E), const Color(0xFFDCFCE7)),
          _kpiCard('Avg per Student', '₹549', LucideIcons.users, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
        ],
      );
    });
  }

  Widget _kpiCard(String label, String value, IconData icon, Color iconColor, Color iconBg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
              const SizedBox(height: 2),
              Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Classes', 'Fee Heads', 'Discount Rules', 'Late Fee Policy'];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _border)),
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((t) {
            final isActive = _selectedTab == t;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFF3E8FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  t,
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive ? _primary : _muted,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildClassesList() {
    return Column(
      children: _classDataList.map((cls) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassFeeDetailsScreen(classData: cls)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(LucideIcons.layers, size: 20, color: Color(0xFF8B5CF6)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cls['name'], style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _dark)),
                            const SizedBox(height: 2),
                            Text(cls['subtitle'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight, size: 18, color: _muted),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(child: _termSummary('TERM 1', cls['t1'])),
                      Expanded(child: _termSummary('TERM 2', cls['t2'])),
                      Expanded(child: _termSummary('TERM 3', cls['t3'])),
                      Expanded(child: _termSummary('ANNUAL TOTAL', cls['annual'], isAnnual: true)),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _termSummary(String label, String amount, {bool isAnnual = false}) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: _muted)),
        const SizedBox(height: 4),
        Text(amount, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: isAnnual ? _primary : _dark)),
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
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF595973),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),                   activeIcon: Icon(Icons.home),                   label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined),                 activeIcon: Icon(Icons.school),                 label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Fees'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline),                  activeIcon: Icon(Icons.people),                 label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline),             activeIcon: Icon(Icons.chat_bubble),            label: 'Messages'),
        ],
      ),
    );
  }
}
