import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const Color _textDark = Color(0xFF1E293B);
const Color _textMuted = Color(0xFF64748B);

class TeacherDetailsScreen extends StatelessWidget {
  final String initials;
  final String name;
  final String grades;
  final String subject;
  final Color avatarColor;
  final String status;
  final String classesToday;

  const TeacherDetailsScreen({
    super.key,
    required this.initials,
    required this.name,
    required this.grades,
    required this.subject,
    required this.avatarColor,
    required this.status,
    required this.classesToday,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textDark),
        title: Text('Teacher Details', style: GoogleFonts.figtree(color: _textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildTeacherDetails(),
      ),
    );
  }

  Widget _buildTeacherDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          // Gradient Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 60),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC7D2FE), Color(0xFFE0E7FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [Icon(LucideIcons.moreVertical, color: _textDark)],
                ),
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(initials, style: GoogleFonts.figtree(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                Text(name, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 4),
                Text('$subject Department', style: GoogleFonts.figtree(fontSize: 13, color: _textDark.withValues(alpha: 0.8))),
                Text(grades, style: GoogleFonts.figtree(fontSize: 13, color: _textDark.withValues(alpha: 0.8))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8, height: 8, 
                        decoration: BoxDecoration(
                          color: status == 'Present' ? const Color(0xFF10B981) : const Color(0xFF6366F1), 
                          shape: BoxShape.circle
                        )
                      ),
                      const SizedBox(width: 6),
                      Text(status, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: status == 'Present' ? const Color(0xFF10B981) : const Color(0xFF6366F1))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Overlapping Stats Card
          Transform.translate(
            offset: const Offset(0, -30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailStatCard(LucideIcons.bookOpen, classesToday, 'Classes\nToday'),
                    _buildDetailStatCard(LucideIcons.clock, '1', 'Free\nPeriod'),
                    _buildDetailStatCard(LucideIcons.calendarDays, '9A', 'Next Class\nPeriod 4'),
                    _buildDetailStatCard(LucideIcons.checkCircle, '89%', 'Attendance\nThis Month'),
                  ],
                ),
              ),
            ),
          ),

          // Schedule & Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Schedule', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 24),
                
                // Timeline
                _buildTimelineItem('Period 1', '8:00 – 8:45 AM', '8A - $subject', true),
                _buildTimelineItem('Period 2', '8:45 – 9:30 AM', '8B - $subject', true),
                _buildTimelineItem('Period 3', '9:50 – 10:35 AM', '9A - $subject', true),
                _buildTimelineItem('Period 4', '10:35 – 11:20 AM', 'Free Period', false),
                _buildTimelineItem('Period 5', '11:40 – 12:25 PM', '9B - $subject', true, isLast: true),
                
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('View full schedule', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                    const Icon(LucideIcons.chevronRight, size: 18, color: _textMuted),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 24),

                _buildInfoSection('Department', subject),
                _buildInfoSection('Qualification', 'M.Sc., B.Ed.'),
                _buildContactSection(name),
                
                const SizedBox(height: 32),
                
                // Substitutions Assigned
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Substitutions Assigned', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: Text('1', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF6366F1))),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.calendarDays, size: 20, color: Color(0xFF6366F1)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nov 24', style: GoogleFonts.figtree(fontSize: 12, color: _textDark, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('8C $subject (Period 2)', style: GoogleFonts.figtree(fontSize: 13, color: _textDark)),
                            const SizedBox(height: 2),
                            Text('Substituting for: Rakesh Kumar', style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStatCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6366F1)),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildTimelineItem(String period, String time, String subjectLine, bool isClass, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFE5E7EB), shape: BoxShape.circle)),
              if (!isLast)
                Expanded(child: Container(width: 2, color: const Color(0xFFE5E7EB))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(period, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(width: 8),
                      Text('($time)', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isClass ? const Color(0xFFE8FDF3) : const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      subjectLine,
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isClass ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
        ],
      ),
    );
  }

  Widget _buildContactSection(String teacherName) {
    String formattedName = teacherName.toLowerCase().replaceAll(' ', '.');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(LucideIcons.phone, size: 14, color: _textMuted),
            const SizedBox(width: 8),
            Text('98765 43210', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(LucideIcons.mail, size: 14, color: _textMuted),
            const SizedBox(width: 8),
            Text('$formattedName@school.edu', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
          ],
        ),
      ],
    );
  }
}
