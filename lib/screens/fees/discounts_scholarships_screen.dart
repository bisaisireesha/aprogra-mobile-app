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

class DiscountsScholarshipsScreen extends StatefulWidget {
  const DiscountsScholarshipsScreen({super.key});

  @override
  State<DiscountsScholarshipsScreen> createState() =>
      _DiscountsScholarshipsScreenState();
}

class _DiscountsScholarshipsScreenState
    extends State<DiscountsScholarshipsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _showAddForm = false;
  String _formType = 'Scholarship';

  final List<Map<String, dynamic>> _scholarships = [
    {
      'name': 'Merit Scholarship',
      'type': 'Scholarship',
      'criteria': 'Top 5% in class',
      'discount': '25%',
      'discountVal': 0.25,
      'appliesTo': 'Tuition Fee',
      'recipients': 12,
      'totalBenefit': '₹73,500',
      'color': const Color(0xFF6366F1),
      'icon': LucideIcons.award,
      'status': 'Active',
      'approvedBy': 'Principal',
    },
    {
      'name': 'Need-Based Aid',
      'type': 'Scholarship',
      'criteria': 'Income < ₹3L/year',
      'discount': '40%',
      'discountVal': 0.40,
      'appliesTo': 'All Fees',
      'recipients': 8,
      'totalBenefit': '₹1,24,800',
      'color': const Color(0xFF10B981),
      'icon': LucideIcons.heart,
      'status': 'Active',
      'approvedBy': 'Management',
    },
    {
      'name': 'Sports Excellence',
      'type': 'Scholarship',
      'criteria': 'State/National level athlete',
      'discount': '30%',
      'discountVal': 0.30,
      'appliesTo': 'Tuition Fee',
      'recipients': 5,
      'totalBenefit': '₹36,750',
      'color': const Color(0xFFF59E0B),
      'icon': LucideIcons.trophy,
      'status': 'Active',
      'approvedBy': 'Principal',
    },
    {
      'name': 'Cultural Excellence',
      'type': 'Scholarship',
      'criteria': 'National level artist',
      'discount': '20%',
      'discountVal': 0.20,
      'appliesTo': 'Tuition Fee',
      'recipients': 3,
      'totalBenefit': '₹14,700',
      'color': const Color(0xFF8B5CF6),
      'icon': LucideIcons.music,
      'status': 'Pending Approval',
      'approvedBy': null,
    },
  ];

  final List<Map<String, dynamic>> _discounts = [
    {
      'name': 'Sibling Discount',
      'type': 'Discount',
      'criteria': '2nd+ child enrolled',
      'discount': '10%',
      'discountVal': 0.10,
      'appliesTo': 'Tuition Fee',
      'recipients': 34,
      'totalBenefit': '₹2,06,500',
      'color': const Color(0xFF3B82F6),
      'icon': LucideIcons.users,
      'status': 'Active',
      'approvedBy': 'Auto',
    },
    {
      'name': 'Staff Ward',
      'type': 'Discount',
      'criteria': 'Employee children',
      'discount': '50%',
      'discountVal': 0.50,
      'appliesTo': 'All Fees',
      'recipients': 18,
      'totalBenefit': '₹5,58,000',
      'color': const Color(0xFFEF4444),
      'icon': LucideIcons.badgeCheck,
      'status': 'Active',
      'approvedBy': 'Management',
    },
    {
      'name': 'Early Bird',
      'type': 'Discount',
      'criteria': 'Pay 30 days early',
      'discount': '5%',
      'discountVal': 0.05,
      'appliesTo': 'Tuition Fee',
      'recipients': 67,
      'totalBenefit': '₹2,04,750',
      'color': const Color(0xFF10B981),
      'icon': LucideIcons.clock,
      'status': 'Active',
      'approvedBy': 'Auto',
    },
    {
      'name': 'Annual Payment',
      'type': 'Discount',
      'criteria': 'Pay full year upfront',
      'discount': '8%',
      'discountVal': 0.08,
      'appliesTo': 'Tuition Fee',
      'recipients': 29,
      'totalBenefit': '₹3,55,200',
      'color': const Color(0xFF6366F1),
      'icon': LucideIcons.calendarDays,
      'status': 'Active',
      'approvedBy': 'Auto',
    },
  ];

  final List<Map<String, dynamic>> _applications = [
    {'student': 'Aarav Mehta', 'class': 'VIII-B', 'type': 'Need-Based Aid', 'requested': '40%', 'date': '20 May 2025', 'status': 'Pending'},
    {'student': 'Priya Nair', 'class': 'X-A', 'type': 'Merit Scholarship', 'requested': '25%', 'date': '18 May 2025', 'status': 'Approved'},
    {'student': 'Rohan Gupta', 'class': 'VII-C', 'type': 'Sports Excellence', 'requested': '30%', 'date': '15 May 2025', 'status': 'Pending'},
    {'student': 'Ananya Singh', 'class': 'IX-B', 'type': 'Cultural Excellence', 'requested': '20%', 'date': '12 May 2025', 'status': 'Rejected'},
    {'student': 'Kiran Sharma', 'class': 'VI-A', 'type': 'Need-Based Aid', 'requested': '40%', 'date': '10 May 2025', 'status': 'Approved'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                  child: CommonAppBar(showMenu: false),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 16),
                      _buildSummaryRow(),
                      const SizedBox(height: 12),
                      TabBar(
                        controller: _tabController,
                        indicatorColor: _primary,
                        labelColor: _primary,
                        unselectedLabelColor: _muted,
                        labelStyle: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600),
                        unselectedLabelStyle: GoogleFonts.figtree(fontSize: 13),
                        tabs: [
                          Tab(text: 'Scholarships (${_scholarships.length})'),
                          Tab(text: 'Discounts (${_discounts.length})'),
                          Tab(text: 'Applications (${_applications.length})'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _showAddForm
                      ? _buildAddForm()
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildScholarshipList(),
                            _buildDiscountList(),
                            _buildApplicationsList(),
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
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: _border)),
          child: Icon(canPop ? LucideIcons.arrowLeft : LucideIcons.menu, size: 18, color: _dark),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Discounts & Scholarships', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
        Text('Manage fee concessions and scholarship programs', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
      ])),
      GestureDetector(
        onTap: () => setState(() {
          _showAddForm = !_showAddForm;
          _formType = 'Scholarship';
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _showAddForm ? Colors.white : _primary,
            borderRadius: BorderRadius.circular(8),
            border: _showAddForm ? Border.all(color: _border) : null,
            boxShadow: _showAddForm ? null : [BoxShadow(color: _primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(_showAddForm ? LucideIcons.x : LucideIcons.plus, size: 14, color: _showAddForm ? _dark : Colors.white),
            const SizedBox(width: 6),
            Text(_showAddForm ? 'Cancel' : 'Add New', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _showAddForm ? _dark : Colors.white)),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildSummaryRow() {
    final totalRecipients = [..._scholarships, ..._discounts].fold(0, (s, i) => s + (i['recipients'] as int));
    final totalScholarshipBenefit = '₹2.49L';
    final totalDiscountBenefit = '₹13.24L';
    return Row(children: [
      Expanded(child: _summaryCard('Total Recipients', '$totalRecipients', LucideIcons.users, _primary, const Color(0xFFEEF2FF))),
      const SizedBox(width: 10),
      Expanded(child: _summaryCard('Scholarships', totalScholarshipBenefit, LucideIcons.award, const Color(0xFF8B5CF6), const Color(0xFFF5F3FF))),
      const SizedBox(width: 10),
      Expanded(child: _summaryCard('Discounts', totalDiscountBenefit, LucideIcons.tag, const Color(0xFF10B981), const Color(0xFFF0FDF4))),
    ]);
  }

  Widget _summaryCard(String label, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _muted)),
      ]),
    );
  }

  Widget _buildScholarshipList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _scholarships.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _buildConcessionCard(_scholarships[i]),
    );
  }

  Widget _buildDiscountList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _discounts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _buildConcessionCard(_discounts[i]),
    );
  }

  Widget _buildConcessionCard(Map<String, dynamic> item) {
    final color = item['color'] as Color;
    final isActive = item['status'] == 'Active';
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header gradient bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.06),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(item['icon'] as IconData, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _dark)),
              Text(item['criteria'], style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Text(item['discount'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFF0FDF4) : const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item['status'],
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: isActive ? const Color(0xFF16A34A) : const Color(0xFFD97706)),
                ),
              ),
            ]),
          ]),
        ),
        // Details
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              _detailChip(LucideIcons.fileText, 'Applies to: ${item['appliesTo']}', _muted),
              const Spacer(),
              _detailChip(LucideIcons.users, '${item['recipients']} students', _muted),
            ]),
            const SizedBox(height: 12),
            // Progress bar showing discount level
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Discount Level', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
                Text(item['discount'], style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: item['discountVal'] as double,
                  backgroundColor: const Color(0xFFF3F4F6),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            const Divider(height: 1, color: _border),
            const SizedBox(height: 10),
            Row(children: [
              Icon(LucideIcons.indianRupee, size: 12, color: _muted),
              const SizedBox(width: 4),
              Text('Total Benefit: ', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
              Text(item['totalBenefit'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
              const Spacer(),
              if (item['approvedBy'] != null) ...[
                Icon(LucideIcons.shieldCheck, size: 12, color: const Color(0xFF22C55E)),
                const SizedBox(width: 4),
                Text('by ${item['approvedBy']}', style: GoogleFonts.figtree(fontSize: 11, color: _muted)),
              ],
              const SizedBox(width: 10),
              _actionBtn('Edit', LucideIcons.pencil, color),
              const SizedBox(width: 8),
              _actionBtn('Assign', LucideIcons.userPlus, _primary),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _detailChip(IconData icon, String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(label, style: GoogleFonts.figtree(fontSize: 11, color: color)),
    ]);
  }

  Widget _actionBtn(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _buildApplicationsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _applications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildApplicationCard(_applications[i]),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> app) {
    Color statusColor;
    Color statusBg;
    IconData statusIcon;
    switch (app['status']) {
      case 'Approved':
        statusColor = const Color(0xFF16A34A); statusBg = const Color(0xFFF0FDF4); statusIcon = LucideIcons.checkCircle; break;
      case 'Rejected':
        statusColor = const Color(0xFFDC2626); statusBg = const Color(0xFFFEF2F2); statusIcon = LucideIcons.xCircle; break;
      default:
        statusColor = const Color(0xFFD97706); statusBg = const Color(0xFFFFFBEB); statusIcon = LucideIcons.clock;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEEF2FF),
            child: Text(app['student'].toString().substring(0, 1), style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _primary)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(app['student'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
            Text('${app['class']} · Applied: ${app['date']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(statusIcon, size: 11, color: statusColor),
              const SizedBox(width: 4),
              Text(app['status'], style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor)),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            Icon(LucideIcons.award, size: 14, color: _primary),
            const SizedBox(width: 8),
            Text(app['type'], style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _dark)),
            const Spacer(),
            Text('Requested: ${app['requested']}', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
          ]),
        ),
        if (app['status'] == 'Pending') ...[
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _approvalBtn('Approve', LucideIcons.check, const Color(0xFF16A34A), const Color(0xFFF0FDF4))),
            const SizedBox(width: 8),
            Expanded(child: _approvalBtn('Reject', LucideIcons.x, const Color(0xFFDC2626), const Color(0xFFFEF2F2))),
            const SizedBox(width: 8),
            Expanded(child: _approvalBtn('Review', LucideIcons.eye, _primary, const Color(0xFFEEF2FF))),
          ]),
        ],
      ]),
    );
  }

  Widget _approvalBtn(String label, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 5),
        Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }

  Widget _buildAddForm() {
    final types = ['Scholarship', 'Discount'];
    final appliesTo = ['Tuition Fee', 'Transport Fee', 'Hostel Fee', 'Exam Fee', 'All Fees'];
    String selApplies = 'Tuition Fee';

    return StatefulBuilder(builder: (ctx, ss) => SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Type selector
        Row(children: types.map((t) => Expanded(child: Padding(
          padding: EdgeInsets.only(right: t != types.last ? 10 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _formType = t),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _formType == t ? _primary : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _formType == t ? _primary : _border),
                boxShadow: _formType == t ? [BoxShadow(color: _primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))] : null,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(_formType == t ? (_formType == 'Scholarship' ? LucideIcons.award : LucideIcons.tag) : (_formType == 'Scholarship' ? LucideIcons.award : LucideIcons.tag), size: 15, color: _formType == t ? Colors.white : _muted),
                const SizedBox(width: 6),
                Text(t, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _formType == t ? Colors.white : _dark)),
              ]),
            ),
          ),
        ))).toList()),
        const SizedBox(height: 20),
        _formSection('Basic Details', [
          _formField('${_formType} Name', LucideIcons.tag),
          const SizedBox(height: 12),
          _formField('Eligibility Criteria', LucideIcons.clipboardList),
        ]),
        const SizedBox(height: 16),
        _formSection('Benefit Configuration', [
          _formField('Discount Percentage (%)', LucideIcons.percent, keyboard: TextInputType.number),
          const SizedBox(height: 12),
          Text('Applies To', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500, color: _muted)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: appliesTo.map((a) => GestureDetector(
            onTap: () => ss(() => selApplies = a),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: selApplies == a ? _primary.withValues(alpha: 0.1) : Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: selApplies == a ? _primary : _border, width: selApplies == a ? 1.5 : 1)),
              child: Text(a, style: GoogleFonts.figtree(fontSize: 12, fontWeight: selApplies == a ? FontWeight.w600 : FontWeight.normal, color: selApplies == a ? _primary : _dark)),
            ),
          )).toList()),
          const SizedBox(height: 12),
          _formField('Max Beneficiaries (optional)', LucideIcons.users, keyboard: TextInputType.number),
        ]),
        const SizedBox(height: 16),
        _formSection('Approval', [
          _formField('Approving Authority', LucideIcons.shieldCheck),
          const SizedBox(height: 12),
          _formField('Valid From', LucideIcons.calendar),
          const SizedBox(height: 12),
          _formField('Valid Until', LucideIcons.calendarOff),
        ]),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _showAddForm = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
              child: Text('Cancel', textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
            ),
          )),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Container(
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: _primary.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Material(color: Colors.transparent, child: InkWell(
              onTap: () => setState(() => _showAddForm = false),
              borderRadius: BorderRadius.circular(12),
              child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text('Create $_formType', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ])),
            )),
          )),
        ]),
        const SizedBox(height: 60),
      ]),
    ));
  }

  Widget _formSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _dark)),
        const SizedBox(height: 12),
        ...children,
      ]),
    );
  }

  Widget _formField(String label, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500, color: _muted)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: _border), color: const Color(0xFFFAFAFC)),
        child: TextField(
          keyboardType: keyboard,
          style: GoogleFonts.figtree(fontSize: 14, color: _dark),
          decoration: InputDecoration(prefixIcon: Icon(icon, size: 16, color: _muted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      ),
    ]);
  }
}
