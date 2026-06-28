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

class FeeStructureScreen extends StatefulWidget {
  const FeeStructureScreen({super.key});

  @override
  State<FeeStructureScreen> createState() => _FeeStructureScreenState();
}

class _FeeStructureScreenState extends State<FeeStructureScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedClass = 'Class 6';
  String _selectedYear = '2025-26';
  bool _showAddForm = false;

  final List<String> _classes = ['Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'];
  final Map<String, List<Map<String, dynamic>>> _feeStructure = {
    'Class 6': [
      {'type': 'Tuition Fee', 'amount': 24500, 'frequency': 'Quarterly', 'dueDay': 10, 'icon': LucideIcons.graduationCap, 'color': const Color(0xFF6366F1)},
      {'type': 'Library Fee', 'amount': 1500, 'frequency': 'Annual', 'dueDay': 1, 'icon': LucideIcons.bookOpen, 'color': const Color(0xFF3B82F6)},
      {'type': 'Exam Fee', 'amount': 2000, 'frequency': 'Per Term', 'dueDay': 15, 'icon': LucideIcons.clipboardList, 'color': const Color(0xFF8B5CF6)},
      {'type': 'Activity Fee', 'amount': 800, 'frequency': 'Annual', 'dueDay': 1, 'icon': LucideIcons.zap, 'color': const Color(0xFFF59E0B)},
      {'type': 'Transport Fee', 'amount': 4500, 'frequency': 'Monthly', 'dueDay': 5, 'icon': LucideIcons.bus, 'color': const Color(0xFF10B981)},
    ],
    'Class 10': [
      {'type': 'Tuition Fee', 'amount': 28000, 'frequency': 'Quarterly', 'dueDay': 10, 'icon': LucideIcons.graduationCap, 'color': const Color(0xFF6366F1)},
      {'type': 'Lab Fee', 'amount': 3000, 'frequency': 'Annual', 'dueDay': 1, 'icon': LucideIcons.beaker, 'color': const Color(0xFF3B82F6)},
      {'type': 'Exam Fee', 'amount': 2500, 'frequency': 'Per Term', 'dueDay': 15, 'icon': LucideIcons.clipboardList, 'color': const Color(0xFF8B5CF6)},
      {'type': 'Activity Fee', 'amount': 1000, 'frequency': 'Annual', 'dueDay': 1, 'icon': LucideIcons.zap, 'color': const Color(0xFFF59E0B)},
    ],
  };

  List<Map<String, dynamic>> get _currentFees {
    return _feeStructure[_selectedClass] ?? _feeStructure['Class 6']!;
  }

  int get _totalAnnual {
    return _currentFees.fold(0, (sum, fee) {
      final amt = fee['amount'] as int;
      switch (fee['frequency']) {
        case 'Monthly': return sum + amt * 12;
        case 'Quarterly': return sum + amt * 4;
        case 'Per Term': return sum + amt * 3;
        default: return sum + amt;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Fees & Invoices'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(20, 16, 20, 0), child: CommonAppBar(showMenu: false)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildClassSelector(),
                        const SizedBox(height: 20),
                        _buildAnnualSummary(),
                        const SizedBox(height: 20),
                        if (_showAddForm) _buildAddFeeForm(),
                        if (!_showAddForm) ...[
                          _buildFeeList(),
                          const SizedBox(height: 20),
                          _buildLateFeeConfig(),
                          const SizedBox(height: 20),
                          _buildConcessionConfig(),
                        ],
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
    return Row(children: [
      GestureDetector(
        onTap: () {
          if (canPop) {
            Navigator.pop(context);
          } else {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
          child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 18, color: _dark))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fee Structure', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        Text('Configure class-wise fee structure for $_selectedYear', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
      ])),
      GestureDetector(
        onTap: () => setState(() => _showAddForm = !_showAddForm),
        child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: _showAddForm ? Colors.white : _primary, borderRadius: BorderRadius.circular(8), border: _showAddForm ? Border.all(color: _border) : null, boxShadow: _showAddForm ? null : [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(_showAddForm ? LucideIcons.x : LucideIcons.plus, size: 14, color: _showAddForm ? _dark : Colors.white),
            const SizedBox(width: 6),
            Text(_showAddForm ? 'Cancel' : 'Add Fee', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _showAddForm ? _dark : Colors.white)),
          ])),
      ),
    ]);
  }

  Widget _buildClassSelector() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _classes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cls = _classes[i];
          final selected = _selectedClass == cls;
          return GestureDetector(
            onTap: () => setState(() => _selectedClass = cls),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: selected ? _primary : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: selected ? _primary : _border),
                boxShadow: selected ? [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 3))] : null),
              child: Text(cls, style: GoogleFonts.figtree(fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.normal, color: selected ? Colors.white : _dark)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnnualSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$_selectedClass Annual Total', style: GoogleFonts.figtree(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
          const SizedBox(height: 4),
          Text('₹${_totalAnnual.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
            style: GoogleFonts.figtree(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('AY $_selectedYear', style: GoogleFonts.figtree(fontSize: 11, color: Colors.white.withValues(alpha: 0.7))),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Text('${_currentFees.length} fee types', style: GoogleFonts.figtree(fontSize: 12, color: Colors.white))),
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(LucideIcons.pencil, size: 12, color: Colors.white),
              const SizedBox(width: 4),
              Text('Edit Structure', style: GoogleFonts.figtree(fontSize: 12, color: Colors.white)),
            ])),
        ]),
      ]),
    );
  }

  Widget _buildFeeList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fee Components', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 12),
        ..._currentFees.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildFeeItem(e.value),
        )),
      ],
    );
  }

  Widget _buildFeeItem(Map<String, dynamic> fee) {
    final color = fee['color'] as Color;
    final freqLabels = {'Monthly': 'x12', 'Quarterly': 'x4', 'Per Term': 'x3', 'Annual': 'x1'};
    final multiplier = {'Monthly': 12, 'Quarterly': 4, 'Per Term': 3, 'Annual': 1}[fee['frequency']] ?? 1;
    final annual = (fee['amount'] as int) * multiplier;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(fee['icon'] as IconData, size: 18, color: color)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(fee['type'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
          Row(children: [
            Container(margin: const EdgeInsets.only(top: 3), padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(fee['frequency'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: color))),
            const SizedBox(width: 6),
            Text('Due: ${fee['dueDay']}th of month', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
          ]),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('₹${(fee['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
            style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
          Text('${freqLabels[fee['frequency']]} = ₹${annual.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} pa',
            style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
        ]),
        const SizedBox(width: 8),
        const Icon(LucideIcons.pencil, size: 14, color: _muted),
      ]),
    );
  }

  Widget _buildLateFeeConfig() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFFFF7ED), shape: BoxShape.circle),
            child: const Icon(LucideIcons.clock, size: 16, color: Color(0xFFF59E0B))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Late Fee Configuration', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
            Text('Auto-apply after due date', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
          ])),
          Switch(value: true, onChanged: (_) {}, activeColor: const Color(0xFFF59E0B)),
        ]),
        const SizedBox(height: 14),
        const Divider(color: _border),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: _configItem('Grace Period', '3 days')),
          Container(width: 1, height: 40, color: _border),
          Expanded(child: _configItem('Late Fee %', '2% per month')),
          Container(width: 1, height: 40, color: _border),
          Expanded(child: _configItem('Max Late Fee', '₹500')),
        ]),
      ]),
    );
  }

  Widget _configItem(String label, String value) {
    return Column(children: [
      Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark), textAlign: TextAlign.center),
      Text(label, style: GoogleFonts.figtree(fontSize: 11, color: _muted), textAlign: TextAlign.center),
    ]);
  }

  Widget _buildConcessionConfig() {
    final concessions = [
      {'type': 'Sibling Discount', 'discount': '10%', 'applies': 'Tuition Only', 'color': const Color(0xFF22C55E)},
      {'type': 'Staff Ward', 'discount': '50%', 'applies': 'All Fees', 'color': const Color(0xFF6366F1)},
      {'type': 'Merit Scholarship', 'discount': '25%', 'applies': 'Tuition Only', 'color': const Color(0xFF3B82F6)},
      {'type': 'Need-Based', 'discount': 'Variable', 'applies': 'Case by Case', 'color': const Color(0xFFF59E0B)},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(LucideIcons.gift, size: 16, color: _primary),
          const SizedBox(width: 8),
          Text('Discounts & Scholarships', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
        ]),
        const SizedBox(height: 14),
        ...concessions.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: c['color'] as Color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Expanded(child: Text(c['type'] as String, style: GoogleFonts.figtree(fontSize: 13, color: _dark))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (c['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(c['discount'] as String, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: c['color'] as Color))),
            const SizedBox(width: 8),
            Text(c['applies'] as String, style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
          ]),
        )),
      ]),
    );
  }

  Widget _buildAddFeeForm() {
    final frequencies = ['Monthly', 'Quarterly', 'Per Term', 'Annual'];
    String sel = 'Quarterly';
    return StatefulBuilder(builder: (ctx, ss) => Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _primary.withValues(alpha: 0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Add New Fee Type', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 16),
        _formField('Fee Type Name', LucideIcons.tag),
        const SizedBox(height: 12),
        _formField('Amount (₹)', LucideIcons.indianRupee, keyboard: TextInputType.number),
        const SizedBox(height: 12),
        Text('Payment Frequency', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w500, color: _muted)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: frequencies.map((f) => GestureDetector(
          onTap: () => ss(() => sel = f),
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: sel == f ? _primary.withValues(alpha: 0.1) : _bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: sel == f ? _primary : _border, width: sel == f ? 1.5 : 1)),
            child: Text(f, style: GoogleFonts.figtree(fontSize: 12, fontWeight: sel == f ? FontWeight.w600 : FontWeight.normal, color: sel == f ? _primary : _dark))),
        )).toList()),
        const SizedBox(height: 12),
        _formField('Due Day of Month', LucideIcons.calendar, keyboard: TextInputType.number),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: Container(
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))]),
          child: Material(color: Colors.transparent, child: InkWell(onTap: () => setState(() => _showAddForm = false), borderRadius: BorderRadius.circular(12),
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(LucideIcons.plus, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text('Add Fee Type', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ])))),
        )),
      ]),
    ));
  }

  Widget _formField(String label, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500, color: _muted)),
      const SizedBox(height: 6),
      Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: _border), color: const Color(0xFFFAFAFC)),
        child: TextField(keyboardType: keyboard, style: GoogleFonts.figtree(fontSize: 14, color: _dark),
          decoration: InputDecoration(prefixIcon: Icon(icon, size: 16, color: _muted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12)))),
    ]);
  }
}
