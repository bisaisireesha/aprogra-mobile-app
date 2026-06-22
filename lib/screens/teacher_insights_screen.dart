import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:math' as math;

import '../widgets/common_app_bar.dart';
import 'menu_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);

class TeacherInsightsScreen extends StatefulWidget {
  const TeacherInsightsScreen({super.key});

  @override
  State<TeacherInsightsScreen> createState() => _TeacherInsightsScreenState();
}

class _TeacherInsightsScreenState extends State<TeacherInsightsScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All', 'Mathematics', 'Science', 'English', 'Hindi', 'Computer', 
    'Social Sci.', 'Arts', 'Phys. Ed.', 'Present', 'On Leave', 
    'Free Period', 'Substituting'
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
                        _buildSearchBar(),
                        const SizedBox(height: 24),
                        _buildKPIs(isTablet),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Teacher Status Board', 'Live view of every teacher\'s availability today.', showReset: true),
                        const SizedBox(height: 16),
                        _buildFilterChips(),
                        const SizedBox(height: 24),
                        _buildTeacherList(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Featured Teacher Details', 'Deep dive into schedule and availability.'),
                        const SizedBox(height: 24),
                        _buildTeacherDetails(),
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

  // --- Header ---
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(LucideIcons.menu, size: 24, color: _textDark),
            ),
            const SizedBox(width: 12),
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

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.search, size: 18, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Search teacher, dept, subject...',
                    style: GoogleFonts.figtree(
                      fontSize: 14,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Icon(LucideIcons.filter, size: 20, color: _textDark),
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
      crossAxisCount: isTablet ? 6 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.85,
      children: [
        _buildKPICard('Total Teachers', '124', 'Active on roll', const Color(0xFFEEF2FF), const Color(0xFF6366F1), LucideIcons.users, const Color(0xFF6366F1), [1, 1.2, 1.5, 1.3, 1.6, 1.8, 2]),
        _buildKPICard('Present Today', '110', '89% attendance', const Color(0xFFE8FDF3), const Color(0xFF10B981), LucideIcons.userCheck, const Color(0xFF10B981), [2, 1.8, 2.2, 2.4, 2.1, 2.6, 2.8]),
        _buildKPICard('On Leave', '14', 'Approved & informed', const Color(0xFFFEF2F2), const Color(0xFFEF4444), LucideIcons.userMinus, const Color(0xFFEF4444), [1, 0.8, 1.2, 0.9, 1.1, 1.3, 1]),
        _buildKPICard('Assigned Classes', '222', 'Today', const Color(0xFFF4F1FD), const Color(0xFF8463E9), LucideIcons.bookOpen, const Color(0xFF8463E9), [1.5, 1.6, 1.8, 1.7, 1.9, 2.1, 2.2]),
        _buildKPICard('Free Periods', '40', 'Available slots', const Color(0xFFFFF7ED), const Color(0xFFF59E0B), LucideIcons.clock, const Color(0xFFF59E0B), [2.5, 2.3, 2.6, 2.2, 2.8, 2.9, 3]),
        _buildKPICard('Substitutions', '6', 'Arranged today', const Color(0xFFF0FDF4), const Color(0xFF22C55E), LucideIcons.refreshCw, const Color(0xFF22C55E), [0.5, 0.8, 0.6, 1.0, 0.9, 1.2, 1.1]),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String subtitle, Color iconBg, Color iconColor, IconData icon, Color sparklineColor, List<double> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.inter(fontSize: 11, color: _textMuted)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
          const Spacer(),
          SizedBox(
            height: 24,
            width: double.infinity,
            child: CustomPaint(painter: _SparklinePainter(data: data, color: sparklineColor)),
          ),
        ],
      ),
    );
  }

  // --- Filter Chips ---
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
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
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Teacher List ---
  Widget _buildTeacherList() {
    return Column(
      children: [
        _buildTeacherCard('PS', 'Priya Sharma', 'Grades 8-10', 'Mathematics', 'Present', const Color(0xFF6366F1), '5', '1', '9A', 'Period 4'),
        const SizedBox(height: 16),
        _buildTeacherCard('RK', 'Rakesh Kumar', 'Grade 9', 'Physics', 'Present', const Color(0xFF8B5CF6), '4', '2', '9B', 'Period 5'),
        const SizedBox(height: 16),
        _buildTeacherCard('AS', 'Anita Shah', 'Grades 6-8', 'Mathematics', 'Free Period', const Color(0xFF6366F1), '3', '3', '7A', 'Period 6'),
        const SizedBox(height: 16),
        _buildTeacherCard('VI', 'Vikram Iyer', 'Grades 7-9', 'English', 'Present', const Color(0xFF3B82F6), '4', '2', '8C', 'Period 4'),
        const SizedBox(height: 16),
        _buildTeacherCard('MJ', 'Meera Joshi', 'Grades 6-7', 'Social Sci.', 'On Leave', const Color(0xFF6366F1), '0', '0', 'Returns', 'Mon'),
        const SizedBox(height: 16),
        _buildTeacherCard('RP', 'Ravi Patel', 'Grades 10-12', 'Science', 'Substituting', const Color(0xFF6366F1), '6', '0', '10B', 'Period 4'),
        const SizedBox(height: 16),
        _buildTeacherCard('NK', 'Neha Kapoor', 'Grades 4-6', 'Arts', 'Present', const Color(0xFF6366F1), '3', '3', '5A', 'Period 5'),
        const SizedBox(height: 16),
        _buildTeacherCard('AV', 'Aman Verma', 'Grades 8-10', 'Computer', 'Present', const Color(0xFF6366F1), '5', '1', '9C', 'Period 4'),
        const SizedBox(height: 16),
        _buildTeacherCard('SM', 'Shruti Menon', 'Grades 5-7', 'Hindi', 'Free Period', const Color(0xFF6366F1), '3', '3', '6B', 'Period 6'),
      ],
    );
  }

  Widget _buildTeacherCard(String initials, String name, String grades, String subject, String status, Color avatarColor, String classes, String free, String nextClass, String nextTime) {
    Color statusBg, statusColor;
    if (status == 'Present') {
      statusBg = const Color(0xFFE8FDF3); statusColor = const Color(0xFF10B981);
    } else if (status == 'Free Period') {
      statusBg = const Color(0xFFEEF2FF); statusColor = const Color(0xFF6366F1);
    } else if (status == 'On Leave') {
      statusBg = const Color(0xFFFFF7ED); statusColor = const Color(0xFFF59E0B);
    } else { // Substituting
      statusBg = const Color(0xFFEEF2FF); statusColor = const Color(0xFF6366F1);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: avatarColor, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(initials, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 2),
                    Text('$grades • $subject', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(status, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeacherStat(LucideIcons.bookOpen, classes, 'Today'),
              _buildTeacherStat(LucideIcons.clock, free, 'Free'),
              _buildTeacherStat(LucideIcons.calendarDays, nextClass, nextTime),
              const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFF9CA3AF)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherStat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF8463E9)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted)),
          ],
        ),
      ],
    );
  }

  // --- Detailed Profile Section ---
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
                  decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('PS', style: GoogleFonts.figtree(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                Text('Priya Sharma', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 4),
                Text('Mathematics Department', style: GoogleFonts.figtree(fontSize: 13, color: _textDark.withValues(alpha: 0.8))),
                Text('Grades 8-10', style: GoogleFonts.figtree(fontSize: 13, color: _textDark.withValues(alpha: 0.8))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('Present Today', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
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
                    _buildDetailStatCard(LucideIcons.bookOpen, '5', 'Classes\nToday'),
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
                _buildTimelineItem('Period 1', '8:00 – 8:45 AM', '8A - Mathematics', true),
                _buildTimelineItem('Period 2', '8:45 – 9:30 AM', '8B - Mathematics', true),
                _buildTimelineItem('Period 3', '9:50 – 10:35 AM', '9A - Mathematics', true),
                _buildTimelineItem('Period 4', '10:35 – 11:20 AM', 'Free Period', false),
                _buildTimelineItem('Period 5', '11:40 – 12:25 PM', '9B - Mathematics', true, isLast: true),
                
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

                _buildInfoSection('Department', 'Mathematics'),
                _buildInfoSection('Qualification', 'M.Sc., B.Ed.'),
                _buildContactSection(),
                
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
                            Text('8C Mathematics (Period 2)', style: GoogleFonts.figtree(fontSize: 13, color: _textDark)),
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

  Widget _buildTimelineItem(String period, String time, String subject, bool isClass, {bool isLast = false}) {
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
                      subject,
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

  Widget _buildContactSection() {
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
            Text('priya.sharma@school.edu', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
          ],
        ),
      ],
    );
  }
}

// --- Sparkline Painter ---
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final minData = data.reduce(math.min);
    final maxData = data.reduce(math.max);
    final range = maxData - minData == 0 ? 1 : maxData - minData;
    final path = Path();
    final xStep = size.width / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - (((data[i] - minData) / range) * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
