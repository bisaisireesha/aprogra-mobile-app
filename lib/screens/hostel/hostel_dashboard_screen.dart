import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../auth/menu_screen.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgColor = Color(0xFFF9F9FB);
const _primary = Color(0xFF6366F1);

class HostelDashboardScreen extends StatelessWidget {
  const HostelDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Hostel Dashboard'),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CommonAppBar(),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'HOSTEL OPEN • DAY WATCH',
                              style: GoogleFonts.inter(
                                color: Colors.green[700],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Hostel Dashboard',
                        style: GoogleFonts.figtree(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF181821),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showNewAllocationBottomSheet(context),
                    icon: const Icon(LucideIcons.plus, size: 18),
                    label: const Text('New Allocation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.15,
                      children: [
                        _buildStatCard(
                          'Blocks',
                          '6 blocks',
                          '185 rooms',
                          LucideIcons.building,
                          const Color(0xFF8B5CF6),
                          const Color(0xFFEDE9FE),
                        ),
                        _buildStatCard(
                          'Rooms',
                          '324 residents',
                          '92 rooms',
                          LucideIcons.users,
                          const Color(0xFF8B5CF6),
                          const Color(0xFFEDE9FE),
                        ),
                        _buildStatCard(
                          'Wardens',
                          '6 wardens',
                          '4 on duty',
                          LucideIcons.user,
                          const Color(0xFF10B981),
                          const Color(0xFFD1FAE5),
                        ),
                        _buildStatCard(
                          'Attendance',
                          '319/324',
                          'checked in',
                          LucideIcons.calendarCheck,
                          const Color(0xFF3B82F6),
                          const Color(0xFFDBEAFE),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildReportCard(),
                    const SizedBox(height: 16),
                    _buildQuickActionsCard(),
                    const SizedBox(height: 16),
                    _buildTodaysScheduleCard(),
                    const SizedBox(height: 16),
                    _buildPendingTasksCard(),
                    const SizedBox(height: 16),
                    _buildMaintenanceCard(),
                    const SizedBox(height: 16),
                    _buildNoticesCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String subtitle1,
    String subtitle2,
    IconData icon,
    Color iconColor,
    Color iconBgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF181821),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle1,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF595973),
            ),
          ),
          Text(
            subtitle2,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF595973),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.fileText,
              color: Color(0xFFF59E0B),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reports',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Occupancy •',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
                Text(
                  'Weekly • Monthly',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Quick Actions',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF181821),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildQuickActionBtn(
                        'Allocate\nRoom',
                        LucideIcons.userPlus,
                        const Color(0xFF6366F1),
                        const Color(0xFFEEF2FF),
                      ),
                    ),
                    Expanded(
                      child: _buildQuickActionBtn(
                        'Mark\nCheck-in',
                        LucideIcons.logIn,
                        const Color(0xFF10B981),
                        const Color(0xFFD1FAE5),
                      ),
                    ),
                    Expanded(
                      child: _buildQuickActionBtn(
                        'Issue\nOutpass',
                        LucideIcons.key,
                        const Color(0xFF3B82F6),
                        const Color(0xFFDBEAFE),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(
                    height: 1,
                    color: Colors.grey.withValues(alpha: 0.05),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildQuickActionBtn(
                        'Room\nTransfer',
                        LucideIcons.arrowLeftRight,
                        const Color(0xFF8B5CF6),
                        const Color(0xFFEDE9FE),
                      ),
                    ),
                    Expanded(
                      child: _buildQuickActionBtn(
                        'Log\nMaintenance',
                        LucideIcons.wrench,
                        const Color(0xFFF59E0B),
                        const Color(0xFFFEF3C7),
                      ),
                    ),
                    Expanded(
                      child: _buildQuickActionBtn(
                        'Post\nNotice',
                        LucideIcons.bell,
                        const Color(0xFFEF4444),
                        const Color(0xFFFEE2E2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionBtn(
    String title,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF181821),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysScheduleCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.calendar,
                    color: Color(0xFF0EA5E9),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Schedule',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                      Text(
                        'Rounds, checks and cutoffs',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF595973),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Wed • 13 Jun',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          _buildScheduleItem(
            '06:30 AM',
            LucideIcons.clipboardCheck,
            const Color(0xFF0EA5E9),
            const Color(0xFFE0F2FE),
            'Wake-up & roll call',
            'All blocks',
            'DONE',
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildScheduleItem(
            '08:00 AM',
            LucideIcons.shieldCheck,
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            'Warden round · Boys A',
            'Mr. Verma',
            'DONE',
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildScheduleItem(
            '11:00 AM',
            LucideIcons.clipboard,
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            'Room inspection · Girls B',
            'Ms. Iyer',
            'NOW',
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildScheduleItem(
            '04:30 PM',
            LucideIcons.logOut,
            const Color(0xFF8B5CF6),
            const Color(0xFFEDE9FE),
            'Outpass return cutoff',
            '12 students',
            'UPCOMING',
            const Color(0xFF64748B),
            const Color(0xFFF1F5F9),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildScheduleItem(
            '09:30 PM',
            LucideIcons.calendarClock,
            const Color(0xFF0EA5E9),
            const Color(0xFFE0F2FE),
            'Night attendance lock',
            'All blocks',
            'UPCOMING',
            const Color(0xFF64748B),
            const Color(0xFFF1F5F9),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildScheduleItem(
            '10:30 PM',
            LucideIcons.shieldAlert,
            const Color(0xFFEF4444),
            const Color(0xFFFEE2E2),
            'Lights out · curfew check',
            'Security',
            'UPCOMING',
            const Color(0xFF64748B),
            const Color(0xFFF1F5F9),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String time,
    IconData icon,
    Color iconColor,
    Color iconBg,
    String title,
    String subtitle,
    String status,
    Color statusColor,
    Color statusBg,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              time,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF595973),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTasksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.clipboardList,
                    color: Color(0xFFF59E0B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Tasks',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                      Text(
                        'Items awaiting your action',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF595973),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '6',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          _buildPendingTaskItem(
            LucideIcons.userPlus,
            const Color(0xFF0EA5E9),
            const Color(0xFFE0F2FE),
            'Pending allocations',
            '3 students\nAwaiting block assignment',
            'Allocate',
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildPendingTaskItem(
            LucideIcons.arrowLeftRight,
            const Color(0xFF8B5CF6),
            const Color(0xFFEDE9FE),
            'Transfer requests',
            '2 requests\nBoys A → Boys B',
            'Review',
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildPendingTaskItem(
            LucideIcons.logOut,
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            'Vacating requests',
            '1 request\nEffective 18 Jun',
            'Approve',
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildPendingTaskItem(
            LucideIcons.clipboard,
            const Color(0xFFEF4444),
            const Color(0xFFFEE2E2),
            'Attendance not closed',
            'Girls A\nLast entry 09:12 PM',
            'Verify',
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildPendingTaskItem(
            LucideIcons.fileCheck,
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            'Documents to verify',
            '5 students\nID proof pending',
            'Open',
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildPendingTaskItem(
            LucideIcons.messageSquare,
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            'Complaints open',
            '4 tickets\n2 over 24 hrs',
            'Resolve',
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTaskItem(
    IconData icon,
    Color iconColor,
    Color iconBg,
    String title,
    String subtitle,
    String actionText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            actionText,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6366F1), // Primary purple/blue
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.wrench,
                    color: Color(0xFFF59E0B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maintenance Tickets',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                      Text(
                        'Open work in residential blocks',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF595973),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Log ticket',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          _buildMaintenanceItem(
            LucideIcons.flame,
            const Color(0xFFEF4444),
            const Color(0xFFFEE2E2),
            'Plumbing leak under fix',
            'Boys B · Room 402',
            'Today',
            'HIGH',
            const Color(0xFFEF4444),
            const Color(0xFFFEE2E2),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildMaintenanceItem(
            LucideIcons.zap,
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            'Electrical socket replacement',
            'Girls B · Room 405',
            'Today',
            'MED',
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildMaintenanceItem(
            LucideIcons.paintbrush,
            const Color(0xFF0EA5E9),
            const Color(0xFFE0F2FE),
            'Deep cleaning scheduled',
            'Junior · Room 210',
            'Tomorrow',
            'LOW',
            const Color(0xFF0EA5E9),
            const Color(0xFFE0F2FE),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildMaintenanceItem(
            LucideIcons.wrench,
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            'Tubelight replacement',
            'Boys A · Corridor',
            'Today',
            'MED',
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceItem(
    IconData icon,
    Color iconColor,
    Color iconBg,
    String title,
    String subtitle,
    String time,
    String status,
    Color statusColor,
    Color statusBg,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF595973),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: statusColor,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.bell,
                    color: Color(0xFF8B5CF6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hostel Notices',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                      Text(
                        'Latest announcements',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF595973),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Post',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          _buildNoticeItem(
            LucideIcons.sparkles,
            const Color(0xFF8B5CF6),
            'Parents\' visiting day rescheduled',
            'Hostel Office · 10 min ago',
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildNoticeItem(
            LucideIcons.sparkles,
            const Color(0xFF0EA5E9),
            'Curfew time extended for class XII (exam week)',
            'Principal · 2 hrs ago',
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
          _buildNoticeItem(
            LucideIcons.sparkles,
            const Color(0xFFF59E0B),
            'Block A water tank cleaning · Saturday 7-9 AM',
            'Maintenance · Yesterday',
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(
    IconData icon,
    Color iconColor,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showNewAllocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Room Allocation',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF181821),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x, color: Color(0xFF595973)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInputField(
                'Student Name or ID',
                'Search student...',
                LucideIcons.search,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDropdownField('Block', 'Select Block')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField('Room Type', 'e.g. AC / Non-AC'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField('Room No.', 'Select Room'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdownField('Bed', 'Select Bed')),
                ],
              ),
              const SizedBox(height: 16),
              _buildInputField(
                'Date of Allocation',
                'DD/MM/YYYY',
                LucideIcons.calendar,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Confirm Allocation',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
            prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hint,
                style: GoogleFonts.inter(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14,
                ),
              ),
              const Icon(
                LucideIcons.chevronDown,
                size: 18,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
