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

class MarksEntryScreen extends StatefulWidget {
  const MarksEntryScreen({super.key});

  @override
  State<MarksEntryScreen> createState() => _MarksEntryScreenState();
}

class _MarksEntryScreenState extends State<MarksEntryScreen> {
  String _exam = 'Term 1';
  String _className = 'Class 5A';
  String _subject = 'Mathematics';

  final List<Map<String, dynamic>> _students = [
    {'roll': '01', 'name': 'Aarav Sharma', 'marks': '86', 'grade': 'A'},
    {'roll': '02', 'name': 'Ayaan Nair', 'marks': '78', 'grade': 'B+'},
    {'roll': '03', 'name': 'Pari Joshi', 'marks': '92', 'grade': 'A+'},
    {'roll': '04', 'name': 'Rohan Gupta', 'marks': '', 'grade': 'Pending'},
    {'roll': '05', 'name': 'Vihaan Mehta', 'marks': '81', 'grade': 'A'},
  ];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  int get _completed =>
      _students.where((item) => (item['marks'] as String).isNotEmpty).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: const MenuScreen(activeScreen: 'Marks Entry'),
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
                        const SizedBox(height: 18),
                        _buildProgressCard(),
                        const SizedBox(height: 18),
                        _buildStudentList(),
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
          child: const Icon(
            LucideIcons.clipboardList,
            color: _accent,
            size: 23,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Marks Entry',
                style: GoogleFonts.figtree(
                  color: _dark,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Enter, validate, and lock assessment marks for report cards.',
                style: GoogleFonts.figtree(color: _muted, fontSize: 14),
              ),
            ],
          ),
        ),
        if (_isTablet)
          FilledButton.icon(
            onPressed: _saveMarks,
            icon: const Icon(LucideIcons.save, size: 17),
            label: const Text('Save'),
            style: FilledButton.styleFrom(backgroundColor: _primary),
          ),
      ],
    );
  }

  Widget _buildControls() {
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
          label: 'Class',
          value: _className,
          values: const ['Class 1A', 'Class 2A', 'Class 5A', 'Class 8A'],
          onChanged: (value) => setState(() => _className = value),
        ),
      ),
      Expanded(
        child: _DropdownField(
          label: 'Subject',
          value: _subject,
          values: const ['English', 'Mathematics', 'EVS', 'Hindi', 'Science'],
          onChanged: (value) => setState(() => _subject = value),
        ),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: _isTablet
          ? Row(
              children: [
                fields[0],
                const SizedBox(width: 12),
                fields[1],
                const SizedBox(width: 12),
                fields[2],
              ],
            )
          : Column(
              children: [
                fields[0],
                const SizedBox(height: 12),
                fields[1],
                const SizedBox(height: 12),
                fields[2],
              ],
            ),
    );
  }

  Widget _buildProgressCard() {
    final total = _students.length;
    final ratio = _completed / total;
    return Container(
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
              Expanded(
                child: Text(
                  '$_className - $_subject',
                  style: GoogleFonts.figtree(
                    color: _dark,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '$_completed/$total entered',
                style: GoogleFonts.figtree(
                  color: _primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: const Color(0xFFF0F2F7),
              color: _primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniStatus(
                  label: 'Highest',
                  value: '92',
                  color: const Color(0xFF22C55E),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStatus(
                  label: 'Average',
                  value: '84',
                  color: _primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStatus(
                  label: 'Pending',
                  value: '${total - _completed}',
                  color: const Color(0xFFF97316),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student Marks',
          style: GoogleFonts.figtree(
            color: _dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        ..._students.map(_buildStudentRow),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _saveMarks,
            icon: const Icon(LucideIcons.save, size: 17),
            label: const Text('Save Marks'),
            style: FilledButton.styleFrom(backgroundColor: _primary),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentRow(Map<String, dynamic> student) {
    final pending = (student['marks'] as String).isEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: pending
              ? const Color(0xFFF97316).withValues(alpha: 0.35)
              : _border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFF1EDFF),
            child: Text(
              student['roll'] as String,
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
                  student['name'] as String,
                  style: GoogleFonts.figtree(
                    color: _dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  pending ? 'Marks pending' : 'Grade ${student['grade']}',
                  style: GoogleFonts.figtree(
                    color: pending ? const Color(0xFFF97316) : _muted,
                    fontSize: 12,
                    fontWeight: pending ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            child: TextFormField(
              initialValue: student['marks'] as String,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '--',
                filled: true,
                fillColor: const Color(0xFFF8F9FC),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _border),
                ),
              ),
              onChanged: (value) {
                student['marks'] = value.trim();
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  void _saveMarks() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marks saved for $_className - $_subject')),
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

class _MiniStatus extends StatelessWidget {
  const _MiniStatus({
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.figtree(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
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
