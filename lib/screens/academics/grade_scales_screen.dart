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

class GradeScalesScreen extends StatefulWidget {
  const GradeScalesScreen({super.key});

  @override
  State<GradeScalesScreen> createState() => _GradeScalesScreenState();
}

class _GradeScalesScreenState extends State<GradeScalesScreen> {
  String _activeScale = 'Primary Scholastic';

  final List<Map<String, dynamic>> _scales = [
    {
      'name': 'Primary Scholastic',
      'level': 'Class 1 - 5',
      'status': 'Active',
      'bands': [
        ['A+', '91-100', Color(0xFF22C55E)],
        ['A', '81-90', Color(0xFF16A34A)],
        ['B+', '71-80', Color(0xFF6366F1)],
        ['B', '61-70', Color(0xFF8B5CF6)],
        ['C', '50-60', Color(0xFFF97316)],
      ],
    },
    {
      'name': 'Secondary Board Prep',
      'level': 'Class 6 - 12',
      'status': 'Draft',
      'bands': [
        ['A1', '91-100', Color(0xFF22C55E)],
        ['A2', '81-90', Color(0xFF16A34A)],
        ['B1', '71-80', Color(0xFF6366F1)],
        ['B2', '61-70', Color(0xFF8B5CF6)],
        ['C1', '51-60', Color(0xFFF97316)],
      ],
    },
    {
      'name': 'Pre-Primary Skills',
      'level': 'Nursery - UKG',
      'status': 'Active',
      'bands': [
        ['E', 'Excellent', Color(0xFF22C55E)],
        ['G', 'Good', Color(0xFF6366F1)],
        ['D', 'Developing', Color(0xFFF97316)],
        ['N', 'Needs support', Color(0xFFEF4444)],
      ],
    },
  ];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  Map<String, dynamic> get _selectedScale => _scales.firstWhere(
    (scale) => scale['name'] == _activeScale,
    orElse: () => _scales.first,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Grade Scales'),
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
                        _buildScaleSelector(),
                        const SizedBox(height: 20),
                        _buildSelectedScale(),
                        const SizedBox(height: 20),
                        _buildUsagePanel(),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grade Scales',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Configure grading bands used by marks entry and reports.',
                style: GoogleFonts.figtree(color: _muted, fontSize: 14),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: _addScale,
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Add'),
          style: FilledButton.styleFrom(backgroundColor: _primary),
        ),
      ],
    );
  }

  Widget _buildScaleSelector() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _scales.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final scale = _scales[index];
          final selected = scale['name'] == _activeScale;
          return GestureDetector(
            onTap: () => setState(() => _activeScale = scale['name'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: _isTablet ? 260 : 228,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected ? _primary : _card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? _primary : _border,
                  width: selected ? 0 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.18)
                          : const Color(0xFFF1EDFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      LucideIcons.award,
                      color: selected ? Colors.white : _accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          scale['name'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.figtree(
                            color: selected ? Colors.white : _dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          scale['level'] as String,
                          style: GoogleFonts.figtree(
                            color: selected
                                ? Colors.white.withValues(alpha: 0.78)
                                : _muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedScale() {
    final bands = _selectedScale['bands'] as List<List<dynamic>>;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _selectedScale['name'] as String,
                  style: GoogleFonts.figtree(
                    color: _dark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _StatusPill(label: _selectedScale['status'] as String),
            ],
          ),
          const SizedBox(height: 14),
          ...bands.map((band) => _GradeBandRow(band: band)),
        ],
      ),
    );
  }

  Widget _buildUsagePanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Used In',
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          _UsageRow('Marks Entry', 'Applied while entering subject scores'),
          _UsageRow('Report Cards', 'Converted into final grades'),
          _UsageRow('Parent Portal', 'Visible after publishing reports'),
        ],
      ),
    );
  }

  void _addScale() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New grade-scale draft created')),
    );
  }
}

class _GradeBandRow extends StatelessWidget {
  const _GradeBandRow({required this.band});

  final List<dynamic> band;

  @override
  Widget build(BuildContext context) {
    final color = band[2] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              band[0] as String,
              style: GoogleFonts.figtree(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              band[1] as String,
              style: GoogleFonts.figtree(
                color: _dark,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(LucideIcons.edit, color: _muted, size: 17),
        ],
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1EDFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.checkCircle2,
              color: _accent,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.figtree(
                    color: _dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.figtree(color: _muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final color = label == 'Active' ? const Color(0xFF22C55E) : _primary;
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
