import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'create_exam_bottom_sheet.dart';

class ExamDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> exam;

  const ExamDetailsScreen({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF181B20)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const CreateExamBottomSheet(),
              );
            },
            child: Text('Edit', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF8463E9))),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EXAM', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF8463E9), letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(exam['name'] ?? 'Rhyme Recitation', style: GoogleFonts.figtree(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildBadge(exam['type'] ?? 'Practical', const Color(0xFF8463E9), const Color(0xFFF4F1FF)),
                const SizedBox(width: 8),
                _buildBadge(exam['status'] ?? 'Scheduled', const Color(0xFF38BDF8), const Color(0xFFE0F2FE)),
              ],
            ),
            const SizedBox(height: 24),
            _buildGridDetails(),
            const SizedBox(height: 24),
            _buildInstructionsBox(),
            const SizedBox(height: 32),
            Text('Subject Papers', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
            const SizedBox(height: 16),
            ..._buildDynamicSubjectPapers(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDynamicSubjectPapers() {
    final papers = exam['subjectPapers'] as List<dynamic>?;

    if (papers == null || papers.isEmpty) {
      // Fallback if no papers are defined
      return [
        _buildSubjectPaperCard('1', 'General Paper', 'TBD', 'TBD', 'TBD', 'TBD', 'Syllabus not available', 'No notes provided', const Color(0xFF8463E9)),
      ];
    }

    return List.generate(papers.length, (index) {
      final p = papers[index];
      return Column(
        children: [
          _buildSubjectPaperCard(
            '${index + 1}',
            p['subject'] ?? 'Unknown Subject',
            p['date'] ?? 'TBD',
            p['time'] ?? 'TBD',
            p['invigilator'] ?? 'TBD',
            p['room'] ?? 'TBD',
            p['syllabus'] ?? 'Syllabus not available',
            p['notes'] ?? 'No notes provided',
            const Color(0xFF8463E9),
            marks: p['marks'],
            passMarks: p['passMarks'],
          ),
          if (index < papers.length - 1) const SizedBox(height: 16),
        ],
      );
    });
  }

  Widget _buildBadge(String text, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _buildGridDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildGridItem(LucideIcons.graduationCap, 'Class', exam['class'] ?? 'UKG A')),
            const SizedBox(width: 12),
            Expanded(child: _buildGridItem(LucideIcons.calendarDays, 'Schedule', exam['schedule'] ?? 'Jun 30 - Jul 02')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildGridItem(LucideIcons.fileText, 'Papers', '${exam['papers'] ?? 2}')),
            const SizedBox(width: 12),
            Expanded(child: _buildGridItem(LucideIcons.users, 'Invigilators', '2')),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF8F96A3)),
              const SizedBox(width: 6),
              Text(title.toUpperCase(), style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF8F96A3))),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
        ],
      ),
    );
  }

  Widget _buildInstructionsBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.info, size: 20, color: Color(0xFF8463E9)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Instructions', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
                const SizedBox(height: 4),
                Text('Reach the exam hall 15 minutes early. Mobiles are not permitted.', style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF595973))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPaperCard(String number, String subject, String date, String time, String invigilator, String room, String syllabus, String notes, Color primaryColor, {String? marks, String? passMarks}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12), topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                  ),
                  alignment: Alignment.center,
                  child: Text(number, style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(subject, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(marks ?? '25 marks', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF595973))),
                    Text('• pass ${passMarks ?? "10"}', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF8F96A3))),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(LucideIcons.calendar, 'Date', date),
                const SizedBox(height: 12),
                _buildInfoRow(LucideIcons.clock, 'Time', time),
                const SizedBox(height: 12),
                _buildInfoRow(LucideIcons.user, 'Invigilator', invigilator),
                const SizedBox(height: 12),
                _buildInfoRow(LucideIcons.doorOpen, 'Room', room),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Syllabus', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
                      const SizedBox(height: 4),
                      Text(syllabus, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF181B20))),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notes', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
                      const SizedBox(height: 4),
                      Text(notes, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF181B20))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8F96A3)),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF595973))),
        const Spacer(),
        Text(value, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF181B20))),
      ],
    );
  }
}
