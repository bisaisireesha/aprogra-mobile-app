import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

class HostelAttendanceScreen extends StatelessWidget {
  const HostelAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Hostel Attendance'),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                children: [
                  _buildHeader(),
                  SizedBox(height: 12.h),
                  _buildActionRow(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildSearchAndFilterRow(),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Showing 8 records',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF595973),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildAttendanceItem(
                          'AM',
                          'Aarav Mehta',
                          'ADM2024-101',
                          'Block A',
                          'Room A-204',
                          '21:42',
                          'Present',
                          'Mr. R. Sharma',
                          false,
                        ),
                        _buildAttendanceItem(
                          'DS',
                          'Diya Sharma',
                          'ADM2024-118',
                          'Block D',
                          'Room D-105',
                          '21:30',
                          'Present',
                          'Mrs. S. Nair',
                          false,
                        ),
                        _buildAttendanceItem(
                          'KS',
                          'Kabir Singh',
                          'ADM2024-122',
                          'Block B',
                          'Room B-312',
                          '22:18',
                          'Late',
                          'Mr. K. Iyer',
                          false,
                        ),
                        _buildAttendanceItem(
                          'RG',
                          'Rohan Gupta',
                          'ADM2024-135',
                          'Block C',
                          'Room C-210',
                          '—',
                          'Absent',
                          'Mr. P. Verma',
                          false,
                        ),
                        _buildAttendanceItem(
                          'SN',
                          'Saanvi Nair',
                          'ADM2024-091',
                          'Block F',
                          'Room F-118',
                          '—',
                          'On Leave',
                          'Mrs. M. Pillai',
                          false,
                        ),
                        _buildAttendanceItem(
                          'AI',
                          'Ananya Iyer',
                          'ADM2024-066',
                          'Block D',
                          'Room D-208',
                          '21:15',
                          'Present',
                          'Mrs. S. Nair',
                          true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Hostel Attendance',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Text(
                '29/06/2026',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF181821),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                LucideIcons.calendar,
                size: 16,
                color: Color(0xFF181821),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                LucideIcons.checkSquare,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Mark Attendance',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.15,
      children: [
        _buildStatCard(
          '8',
          'Total Residents',
          LucideIcons.users,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          true,
          null,
        ),
        _buildStatCard(
          '4',
          'Present',
          LucideIcons.checkCircle,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          false,
          '50%',
        ),
        _buildStatCard(
          '2',
          'Absent',
          LucideIcons.xCircle,
          const Color(0xFFEF4444),
          const Color(0xFFFEE2E2),
          false,
          '25%',
        ),
        _buildStatCard(
          '1',
          'Late',
          LucideIcons.clock,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          false,
          '13%',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color iconColor,
    Color iconBg,
    bool isActive,
    String? percentage,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? iconColor.withValues(alpha: 0.4)
              : Colors.grey.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              if (percentage != null)
                Text(
                  percentage,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF595973),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF181821),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF595973),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.search,
                size: 18,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search student, admission no or room',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('All blocks', true),
              _buildFilterChip('A', false),
              _buildFilterChip('B', false),
              _buildFilterChip('C', false),
              _buildFilterChip('D', false),
              _buildFilterChip('E', false),
              _buildFilterChip('F', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6366F1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF6366F1)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? Colors.white : const Color(0xFF595973),
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(
    String initial,
    String name,
    String admNo,
    String block,
    String room,
    String time,
    String status,
    String warden,
    bool isLast,
  ) {
    Color statusColor;
    Color statusBg;
    if (status == 'Present') {
      statusColor = const Color(0xFF10B981);
      statusBg = const Color(0xFFD1FAE5);
    } else if (status == 'Late') {
      statusColor = const Color(0xFFF59E0B);
      statusBg = const Color(0xFFFEF3C7);
    } else if (status == 'Absent') {
      statusColor = const Color(0xFFEF4444);
      statusBg = const Color(0xFFFEE2E2);
    } else {
      statusColor = const Color(0xFF0EA5E9);
      statusBg = const Color(0xFFE0F2FE);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFEDE9FE),
                    radius: 20,
                    child: Text(
                      initial,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6366F1),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          admNo,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF595973),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        block,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF595973),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        room,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      time,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF181821),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          warden,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF595973),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
      ],
    );
  }
}
