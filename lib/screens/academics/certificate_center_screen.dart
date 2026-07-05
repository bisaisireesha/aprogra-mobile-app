import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/app_bottom_nav.dart';
import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';

const _bg = Color(0xFFF9F9FB);
const _card = Colors.white;
const _dark = Color(0xFF181821);
const _muted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);
const _accent = Color(0xFF8463E9);
const _border = Color(0xFFE7E9F2);

class CertificateCenterScreen extends StatefulWidget {
  const CertificateCenterScreen({
    super.key,
    required this.title,
    required this.activeScreen,
    required this.description,
  });

  final String title;
  final String activeScreen;
  final String description;

  @override
  State<CertificateCenterScreen> createState() =>
      _CertificateCenterScreenState();
}

class _CertificateCenterScreenState extends State<CertificateCenterScreen> {
  String _status = 'Pending';

  final List<Map<String, dynamic>> _requests = [
    {
      'student': 'Aarav Sharma',
      'class': 'Class 5A',
      'purpose': 'Admission to another school',
      'status': 'Pending',
      'date': '05 Jul 2026',
      'owner': 'Front Office',
    },
    {
      'student': 'Pari Joshi',
      'class': 'LKG A',
      'purpose': 'Address proof',
      'status': 'Approved',
      'date': '04 Jul 2026',
      'owner': 'Principal Office',
    },
    {
      'student': 'Rohan Gupta',
      'class': 'Class 8B',
      'purpose': 'Scholarship file',
      'status': 'Draft',
      'date': '03 Jul 2026',
      'owner': 'Admin Desk',
    },
  ];

  List<Map<String, dynamic>> get _filteredRequests {
    if (_status == 'All') return _requests;
    return _requests.where((item) => item['status'] == _status).toList();
  }

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: MenuScreen(activeScreen: widget.activeScreen),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      _isTablet ? 32 : 20,
                      20,
                      _isTablet ? 32 : 20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildSummaryGrid(),
                        const SizedBox(height: 20),
                        _buildStatusFilter(),
                        const SizedBox(height: 14),
                        _buildRequestList(),
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

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EDFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(LucideIcons.award, color: _accent, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.description,
                style: GoogleFonts.figtree(color: _muted, fontSize: 14),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _createCertificate,
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Issue'),
          style: FilledButton.styleFrom(backgroundColor: _primary),
        ),
      ],
    );
  }

  Widget _buildSummaryGrid() {
    final items = const [
      _SummaryData('Requests', '18', 'this month'),
      _SummaryData('Pending', '6', 'awaiting approval'),
      _SummaryData('Issued', '42', 'AY 2025-26'),
      _SummaryData('Templates', '5', 'approved formats'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 118,
      ),
      itemBuilder: (context, index) => _SummaryCard(data: items[index]),
    );
  }

  Widget _buildStatusFilter() {
    final statuses = ['All', 'Pending', 'Approved', 'Draft'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final status = statuses[index];
          final selected = _status == status;
          return ChoiceChip(
            label: Text(status),
            selected: selected,
            onSelected: (_) => setState(() => _status = status),
            selectedColor: _primary,
            labelStyle: GoogleFonts.figtree(
              color: selected ? Colors.white : _dark,
              fontWeight: FontWeight.w800,
            ),
            backgroundColor: _card,
            side: const BorderSide(color: _border),
          );
        },
      ),
    );
  }

  Widget _buildRequestList() {
    final requests = _filteredRequests;
    return Column(
      children: requests.map(_buildRequestCard).toList(growable: false),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    final status = request['status'] as String;
    final color = status == 'Approved'
        ? const Color(0xFF22C55E)
        : status == 'Draft'
        ? const Color(0xFF6366F1)
        : const Color(0xFFF97316);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: const Color(0xFFF1EDFF),
                child: Text(
                  _initials(request['student'] as String),
                  style: GoogleFonts.figtree(
                    color: _accent,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['student'] as String,
                      style: GoogleFonts.figtree(
                        color: _dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${request['class']} - ${request['owner']}',
                      style: GoogleFonts.figtree(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _StatusPill(label: status, color: color),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            request['purpose'] as String,
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            request['date'] as String,
            style: GoogleFonts.figtree(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _previewCertificate(request),
                  icon: const Icon(LucideIcons.eye, size: 16),
                  label: const Text('Preview'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _dark,
                    side: const BorderSide(color: _border),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _approveCertificate(request),
                  icon: const Icon(LucideIcons.checkCircle2, size: 16),
                  label: Text(status == 'Approved' ? 'Issued' : 'Approve'),
                  style: FilledButton.styleFrom(backgroundColor: _primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ');
    return parts.take(2).map((part) => part[0]).join();
  }

  void _createCertificate() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${widget.title} draft created')));
  }

  void _previewCertificate(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Previewing certificate for ${request['student']}'),
      ),
    );
  }

  void _approveCertificate(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${request['student']} moved to approval queue')),
    );
  }
}

class _SummaryData {
  final String label;
  final String value;
  final String note;

  const _SummaryData(this.label, this.value, this.note);
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final _SummaryData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            data.value,
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 27,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: GoogleFonts.figtree(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            data.note,
            style: GoogleFonts.figtree(
              color: _primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.figtree(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
