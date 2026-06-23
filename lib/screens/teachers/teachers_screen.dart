import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';
import 'teacher_details_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);

class TeacherInsightsScreen extends StatefulWidget {
  const TeacherInsightsScreen({super.key});

  @override
  State<TeacherInsightsScreen> createState() => _TeacherInsightsScreenState();
}

class _TeacherInsightsScreenState extends State<TeacherInsightsScreen> {
  String _selectedDeptFilter = 'All';
  String _selectedStatusFilter = 'All';

  final List<String> _departmentFilters = [
    'All', 'Math', 'Science', 'English', 'Hindi', 'Social Sci.', 'Computer', 'Arts', 'Phys. Ed.'
  ];
  
  final List<String> _statusFilters = [
    'All', 'Present', 'On Leave', 'Free Period', 'Substitute'
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Teacher Insights'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildKPIs(isTablet),
                        const SizedBox(height: 48),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Teacher Status Board', 'Live view of every teacher\'s availability today.', showReset: true),
                                    const SizedBox(height: 20),
                                    _buildFilterChips(),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: Color(0xFFE5E7EB)),
                              _buildTeacherList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 48),

                        if (isTablet)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildExamResponsibilities()),
                              const SizedBox(width: 24),
                              Expanded(child: _buildSyllabusProgress()),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildExamResponsibilities(),
                              const SizedBox(height: 32),
                              _buildSyllabusProgress(),
                            ],
                          ),
                        const SizedBox(height: 48),


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

  // --- Header ---
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Teacher Insights',
              style: GoogleFonts.figtree(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _textDark,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            const Icon(LucideIcons.bell, size: 20, color: _textDark),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Daily teaching operations — availability,\nclasses, free periods and substitutions.',
          style: GoogleFonts.figtree(
            fontSize: 14,
            color: _textMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // --- Shared Section Title ---
  Widget _buildSectionTitle(String title, String subtitle, {bool showReset = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.figtree(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  color: _textMuted,
                ),
              ),
            ],
          ),
        ),
        if (showReset)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.rotateCcw, size: 12, color: Color(0xFF6366F1)),
                const SizedBox(width: 4),
                Text(
                  'Reset',
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // --- KPIs ---
  Widget _buildKPIs(bool isTablet) {
    return GridView.count(
      crossAxisCount: isTablet ? 3 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isTablet ? 1.3 : 1.2,
      children: [
        _buildKPICard('Total Teachers', '124', 'Active on roll', const Color(0xFFEEF2FF), const Color(0xFF6366F1), LucideIcons.users),
        _buildKPICard('Present Today', '110', '89% attendance', const Color(0xFFE8FDF3), const Color(0xFF10B981), LucideIcons.userCheck),
        _buildKPICard('On Leave', '14', 'Approved & informed', const Color(0xFFFEF2F2), const Color(0xFFEF4444), LucideIcons.userMinus),
        _buildKPICard('Assigned Classes', '222', 'Today', const Color(0xFFF4F1FD), const Color(0xFF8463E9), LucideIcons.bookOpen),
        _buildKPICard('Free Periods', '40', 'Available slots', const Color(0xFFFFF7ED), const Color(0xFFF59E0B), LucideIcons.clock),
        _buildKPICard('Substitutions', '6', 'Arranged today', const Color(0xFFF0FDF4), const Color(0xFF22C55E), LucideIcons.refreshCw),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String subtitle, Color iconBg, Color iconColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.25), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF4B5563)), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.figtree(fontSize: 26, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
          const SizedBox(height: 6),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 11, color: const Color(0xFF6B7280)), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // --- Filter Chips ---
  Widget _buildFilterChips() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statusFilters.map((filter) => _buildChip(filter, _selectedStatusFilter == filter)).toList(),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => _showFilterBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(LucideIcons.listFilter, size: 20, color: _textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    String tempDept = _selectedDeptFilter;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filters', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 20, color: _textMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Department', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _departmentFilters.map((filter) {
                      final isSelected = tempDept == filter;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            tempDept = filter;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB)),
                          ),
                          child: Text(
                            filter,
                            style: GoogleFonts.figtree(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : _textDark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              tempDept = 'All';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFFE5E7EB)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Reset', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedDeptFilter = tempDept;
                            });
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text('Save', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Teacher List Table ---
  Widget _buildTeacherList() {
    final allTeachers = [
      {'initials': 'PS', 'name': 'Priya Sharma', 'grades': 'Grades 8-10', 'subject': 'Mathematics', 'icon': LucideIcons.layoutTemplate, 'status': 'Present', 'color': const Color(0xFF6366F1), 'classes': '5', 'note': '9A -\nPeriod 4'},
      {'initials': 'RK', 'name': 'Rakesh Kumar', 'grades': 'Grade 9', 'subject': 'Science', 'icon': LucideIcons.flaskConical, 'status': 'Present', 'color': const Color(0xFF8B5CF6), 'classes': '4', 'note': 'Period 5'},
      {'initials': 'AS', 'name': 'Anita Shah', 'grades': 'Grades 6-8', 'subject': 'Mathematics', 'icon': LucideIcons.layoutTemplate, 'status': 'Free Period', 'color': const Color(0xFF6366F1), 'classes': '3', 'note': 'Period 6'},
      {'initials': 'VI', 'name': 'Vikram Iyer', 'grades': 'Grades 7-9', 'subject': 'English', 'icon': LucideIcons.bookOpen, 'status': 'Present', 'color': const Color(0xFF3B82F6), 'classes': '4', 'note': 'Period 4'},
      {'initials': 'RP', 'name': 'Ravi Pashi', 'grades': 'Grades 10-12', 'subject': 'Social Sci.', 'icon': LucideIcons.users, 'status': 'On Leave', 'color': const Color(0xFF6366F1), 'classes': '0', 'note': 'Mon'},
      {'initials': 'NK', 'name': 'Neha Kapoor', 'grades': 'Grades 4-6', 'subject': 'Arts', 'icon': LucideIcons.palette, 'status': 'Present', 'color': const Color(0xFF6366F1), 'classes': '3', 'note': 'Period 5'},
      {'initials': 'AV', 'name': 'Aman Verma', 'grades': 'Grades 8-10', 'subject': 'Computer', 'icon': LucideIcons.monitor, 'status': 'Present', 'color': const Color(0xFF6366F1), 'classes': '5', 'note': '9C -\nPeriod 4'},
      {'initials': 'SM', 'name': 'Shruti Menon', 'grades': 'Grades 5-7', 'subject': 'Hindi', 'icon': LucideIcons.book, 'status': 'Free Period', 'color': const Color(0xFF6366F1), 'classes': '3', 'note': '6B -\nPeriod 6'},
      {'initials': 'KB', 'name': 'Karan Bhatia', 'grades': 'All Grades', 'subject': 'Phys. Ed.', 'icon': LucideIcons.dumbbell, 'status': 'Present', 'color': const Color(0xFF6366F1), 'classes': '4', 'note': 'Field -\nPeriod 5'},
    ];

    final filtered = allTeachers.where((t) {
      bool statusMatch = _selectedStatusFilter == 'All' || t['status'] == _selectedStatusFilter;
      String filterDept = _selectedDeptFilter == 'Math' ? 'Mathematics' : _selectedDeptFilter;
      bool deptMatch = _selectedDeptFilter == 'All' || t['subject'] == filterDept;
      return statusMatch && deptMatch;
    }).toList();

    if (filtered.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE5E7EB))),
        child: Column(
          children: [
            const Icon(LucideIcons.inbox, size: 48, color: Color(0xFF9CA3AF)),
            const SizedBox(height: 16),
            Text('No teachers found', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
            const SizedBox(height: 8),
            Text('Try adjusting your filters', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: filtered.asMap().entries.map((entry) {
          int idx = entry.key;
          var t = entry.value;
          return Column(
            children: [
              _buildTeacherRow(
                t['initials'] as String, t['name'] as String, t['grades'] as String, t['subject'] as String, 
                t['status'] as String, t['color'] as Color, t['classes'] as String, t['note'] as String
              ),
              if (idx < filtered.length - 1)
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTeacherRow(String initials, String name, String grades, String subject, String status, Color avatarColor, String classes, String nextNote) {
    Color statusBg, statusColor;
    if (status == 'Present') {
      statusBg = const Color(0xFFE8FDF3); statusColor = const Color(0xFF10B981);
    } else if (status == 'Free Period') {
      statusBg = const Color(0xFFEEF2FF); statusColor = const Color(0xFF6366F1);
    } else if (status == 'On Leave') {
      statusBg = const Color(0xFFFFF7ED); statusColor = const Color(0xFFF59E0B);
    } else { // Substitute
      statusBg = const Color(0xFFEEF2FF); statusColor = const Color(0xFF6366F1);
    }

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => TeacherDetailsScreen(
            initials: initials,
            name: name,
            grades: grades,
            subject: subject,
            avatarColor: avatarColor,
            status: status,
            classesToday: classes,
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(initials, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1.0)),
            ),
            const SizedBox(width: 8),
            // Name & Grades
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                  const SizedBox(height: 1),
                  Text(grades, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted, letterSpacing: -0.2)),
                ],
              ),
            ),
            // Subject & Status
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject, 
                    style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark, letterSpacing: -0.2),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            status,
                            style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Classes
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Classes', style: GoogleFonts.figtree(fontSize: 10, color: _textMuted)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(classes, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Next / Note
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Next / Note', style: GoogleFonts.figtree(fontSize: 10, color: _textMuted)),
                  const SizedBox(height: 4),
                  Text(nextNote, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
                ],
              ),
            ),
            // Arrow
            const Icon(LucideIcons.chevronRight, size: 16, color: _textMuted),
          ],
        ),
      ),
    );
  }



  Widget _buildExamResponsibilities() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Examination Responsibilities', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text('Grading, evaluation and invigilation status.', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildExamCard(LucideIcons.clipboardSignature, '6', 'Marks Pending', 'Rakesh K. - Sanjay M. - Anita S. - +3')),
              const SizedBox(width: 16),
              Expanded(child: _buildExamCard(LucideIcons.fileText, '12', 'Results Published', 'Priya S. - Vikram I. - Aman V. - +9')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildExamCard(LucideIcons.clipboardCheck, '9', 'Paper Evaluation', 'Divya R. - Ravi P. - Neha K. - +6')),
              const SizedBox(width: 16),
              Expanded(child: _buildExamCard(LucideIcons.calendarCheck, '18', 'Exam Duty Assigned', 'Ravi P. - Divya R. - Karan B. - +15')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(IconData icon, String count, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF6366F1)),
              ),
              Text(count, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildSyllabusProgress() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Syllabus Progress Monitor', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 4),
                    Text('Teachers grouped by coverage status.', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  ],
                ),
              ),
              const Icon(LucideIcons.layers, size: 20, color: Color(0xFF6366F1)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSyllabusItem(LucideIcons.checkCircle, 'On Track', '7', '7 teachers', ['Mathematics', 'English', 'Computer']),
          const SizedBox(height: 12),
          _buildSyllabusItem(LucideIcons.clock, 'Needs Review', '2', '2 teachers', ['Science', 'Hindi']),
          const SizedBox(height: 12),
          _buildSyllabusItem(LucideIcons.alertTriangle, 'Behind Schedule', '3', '3 teachers', ['Social Science', 'Arts']),
        ],
      ),
    );
  }

  Widget _buildSyllabusItem(IconData icon, String title, String count, String subtitle, List<String> subjects) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFEEF2FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: const Color(0xFF6366F1)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                    Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ),
              Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFEEF2FF),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(count, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF6366F1))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subjects.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(s, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

