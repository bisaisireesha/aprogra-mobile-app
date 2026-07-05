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

class ReportCardsScreen extends StatefulWidget {
  const ReportCardsScreen({super.key});

  @override
  State<ReportCardsScreen> createState() => _ReportCardsScreenState();
}

class _ReportCardsScreenState extends State<ReportCardsScreen> {
  String _exam = 'Term 1';
  String _level = 'Primary';

  final List<Map<String, dynamic>> _classes = [
    {
      'class': 'Class 1',
      'teacher': 'Kavita Menon',
      'students': 67,
      'completed': 60,
      'pending': 7,
      'status': 'Review',
      'progress': 0.90,
      'color': Color(0xFF6366F1),
    },
    {
      'class': 'Class 2',
      'teacher': 'Sunita Reddy',
      'students': 64,
      'completed': 57,
      'pending': 7,
      'status': 'Review',
      'progress': 0.89,
      'color': Color(0xFF8B5CF6),
    },
    {
      'class': 'Class 3',
      'teacher': 'Sneha Das',
      'students': 58,
      'completed': 52,
      'pending': 6,
      'status': 'Ready',
      'progress': 0.92,
      'color': Color(0xFF22C55E),
    },
    {
      'class': 'Class 5',
      'teacher': 'Vikram Singh',
      'students': 61,
      'completed': 44,
      'pending': 17,
      'status': 'Needs marks',
      'progress': 0.72,
      'color': Color(0xFFF97316),
    },
  ];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  int get _totalStudents =>
      _classes.fold(0, (sum, item) => sum + (item['students'] as int));

  int get _completed =>
      _classes.fold(0, (sum, item) => sum + (item['completed'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Report Cards'),
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
                        const SizedBox(height: 18),
                        _buildControls(),
                        const SizedBox(height: 20),
                        _buildSummaryGrid(),
                        const SizedBox(height: 20),
                        _buildClassList(),
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
          child: const Icon(LucideIcons.fileText, color: _accent, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report Cards',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Review marks, publish cards, and track parent visibility.',
                style: GoogleFonts.figtree(
                  color: _muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (_isTablet)
          FilledButton.icon(
            onPressed: _publishReadyCards,
            icon: const Icon(LucideIcons.checkCircle2, size: 17),
            label: const Text('Publish Ready'),
            style: FilledButton.styleFrom(backgroundColor: _primary),
          ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: _isTablet
          ? Row(children: _controlFields())
          : Column(children: _controlFields(spacing: 12)),
    );
  }

  List<Widget> _controlFields({double spacing = 0}) {
    final fields = [
      Expanded(
        child: _DropdownField(
          label: 'Exam',
          value: _exam,
          values: const ['Term 1', 'Half Yearly', 'Annual'],
          onChanged: (value) => setState(() => _exam = value),
        ),
      ),
      Expanded(
        child: _DropdownField(
          label: 'Level',
          value: _level,
          values: const ['Pre-Primary', 'Primary', 'Secondary'],
          onChanged: (value) => setState(() => _level = value),
        ),
      ),
    ];

    if (_isTablet) {
      return [fields[0], const SizedBox(width: 12), fields[1]];
    }
    return [fields[0], SizedBox(height: spacing), fields[1]];
  }

  Widget _buildSummaryGrid() {
    final completion = (_completed / _totalStudents * 100).round();
    final items = [
      _MetricData('Students', '$_totalStudents', 'included in $_exam'),
      _MetricData('Completed', '$_completed', '$completion% ready'),
      _MetricData(
        'Pending',
        '${_totalStudents - _completed}',
        'need marks review',
      ),
      _MetricData('Published', '148', 'visible to parents'),
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
      itemBuilder: (context, index) => _MetricCard(data: items[index]),
    );
  }

  Widget _buildClassList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Class Review Queue',
          style: GoogleFonts.figtree(
            color: _dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        ..._classes.map(_buildClassCard),
        if (!_isTablet) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _publishReadyCards,
              icon: const Icon(LucideIcons.checkCircle2, size: 17),
              label: const Text('Publish Ready Cards'),
              style: FilledButton.styleFrom(backgroundColor: _primary),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildClassCard(Map<String, dynamic> item) {
    final color = item['color'] as Color;
    final progress = item['progress'] as double;
    final pending = item['pending'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(LucideIcons.graduationCap, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['class'] as String,
                      style: GoogleFonts.figtree(
                        color: _dark,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${item['teacher']} - ${item['students']} students',
                      style: GoogleFonts.figtree(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _StatusPill(
                label: item['status'] as String,
                color: pending == 0 ? const Color(0xFF22C55E) : color,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFF0F2F7),
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(progress * 100).round()}%',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Completed',
                  value: '${item['completed']}',
                  color: const Color(0xFF22C55E),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'Pending',
                  value: '$pending',
                  color: pending > 10
                      ? const Color(0xFFEF4444)
                      : const Color(0xFFF97316),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showClassReview(item),
                  icon: const Icon(LucideIcons.eye, size: 16),
                  label: const Text('Review'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _dark,
                    side: const BorderSide(color: _border),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _downloadReport,
                  icon: const Icon(LucideIcons.download, size: 16),
                  label: const Text('Export'),
                  style: FilledButton.styleFrom(backgroundColor: _primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClassReview(Map<String, dynamic> item) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item['class']} Report Card Review',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              _ReviewRow('Class teacher', item['teacher'] as String),
              _ReviewRow('Completed cards', '${item['completed']}'),
              _ReviewRow('Pending cards', '${item['pending']}'),
              _ReviewRow('Selected exam', _exam),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(backgroundColor: _primary),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _publishReadyCards() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ready report cards queued for publishing')),
    );
  }

  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report-card export prepared')),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _border),
        ),
      ),
      items: values
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(growable: false),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final String note;

  const _MetricData(this.label, this.value, this.note);
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricData data;

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.figtree(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.figtree(color: _muted, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.figtree(
              color: _dark,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
