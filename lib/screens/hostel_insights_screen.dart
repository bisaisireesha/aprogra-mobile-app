import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../widgets/common_app_bar.dart';
import 'menu_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _primary = Color(0xFF6366F1);

class HostelInsightsScreen extends StatefulWidget {
  const HostelInsightsScreen({super.key});

  @override
  State<HostelInsightsScreen> createState() => _HostelInsightsScreenState();
}

class _HostelInsightsScreenState extends State<HostelInsightsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Hostel Insights'),
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

                        _buildSectionTitle('Live Block Monitoring', 'Operational status across blocks.'),
                        const SizedBox(height: 24),
                        _buildLiveBlockMonitoring(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Welfare Alerts', '4 active', null, const Color(0xFFEF4444)),
                        const SizedBox(height: 24),
                        _buildWelfareAlerts(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Attendance Status', 'Student accountability for the day'),
                        const SizedBox(height: 24),
                        _buildAttendanceStatus(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Room Status Board', 'Room-level monitoring'),
                        const SizedBox(height: 16),
                        _buildRoomStatusLegend(),
                        const SizedBox(height: 16),
                        _buildRoomStatusBoard(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Room Allocation', 'Pending operational actions'),
                        const SizedBox(height: 24),
                        _buildRoomAllocation(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Mess & Dining Status', 'Daily mess operations'),
                        const SizedBox(height: 24),
                        _buildMessStatus(isTablet),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Maintenance & Facilities', 'Open requests by room / area', 'New Request'),
                        const SizedBox(height: 24),
                        _buildMaintenance(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Safety Center'),
                        const SizedBox(height: 24),
                        _buildSafetyCenter(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Staff Status', 'On-duty snapshot'),
                        const SizedBox(height: 24),
                        _buildStaffStatus(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Activity Feed', null, 'View all'),
                        const SizedBox(height: 24),
                        _buildActivityFeed(),
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

  // --- Shared Elements ---
  Widget _buildSectionTitle(String title, [String? subtitle, String? actionText, Color? actionColor]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.figtree(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: actionColor != null ? FontWeight.bold : FontWeight.normal,
                    color: actionColor ?? _textMuted,
                  ),
                ),
              ]
            ],
          ),
        ),
        if (actionText != null)
          Text(
            actionText,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _primary,
            ),
          ),
      ],
    );
  }

  // --- Header & KPIs ---
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE8FDF3), borderRadius: BorderRadius.circular(4)),
              child: Text(
                'HOSTEL OPEN - DAY WATCH',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF10B981), letterSpacing: 0.5),
              ),
            ),
            const Spacer(),
            const Icon(LucideIcons.bell, size: 20, color: _textDark),
          ],
        ),
        const SizedBox(height: 16),
        Text('Hostel Insights', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text('Monitor operations, rooms, welfare\n& daily activities.', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted, height: 1.4)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              const Icon(LucideIcons.search, size: 18, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 12),
              Expanded(child: Text('Search rooms, students...', style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF9CA3AF)))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.slidersHorizontal, size: 16, color: _textDark),
                    const SizedBox(width: 8),
                    Text('Filter', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.refreshCw, size: 16, color: _textDark),
                    const SizedBox(width: 8),
                    Text('Refresh', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.settings, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('Settings', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPIs(bool isTablet) {
    return GridView.count(
      crossAxisCount: isTablet ? 6 : 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: [
        _buildSmallKPI(LucideIcons.users, const Color(0xFFEEF2FF), const Color(0xFF6366F1), '324', 'Students\nResiding'),
        _buildSmallKPI(LucideIcons.lock, const Color(0xFFF4F1FD), const Color(0xFF8463E9), '118', 'Occupied\nRooms'),
        _buildSmallKPI(LucideIcons.doorOpen, const Color(0xFFE8FDF3), const Color(0xFF10B981), '22', 'Available\nRooms'),
        _buildSmallKPI(LucideIcons.checkCircle2, const Color(0xFFF0FDF4), const Color(0xFF22C55E), '319/324', 'Attendance\nVerified'),
        _buildSmallKPI(LucideIcons.alertTriangle, const Color(0xFFFFF7ED), const Color(0xFFF59E0B), '2', 'Open\nIncidents'),
        _buildSmallKPI(LucideIcons.activity, const Color(0xFFFEF2F2), const Color(0xFFEF4444), '1', 'Medical\nCases'),
      ],
    );
  }

  Widget _buildSmallKPI(IconData icon, Color bg, Color iconColor, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 14, color: iconColor),
          ),
          const Spacer(),
          Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted, height: 1.2)),
        ],
      ),
    );
  }

  // --- Live Block Monitoring ---
  Widget _buildLiveBlockMonitoring() {
    return Column(
      children: [
        _buildBlockCard('Boys Hostel A', 'Warden - Mr. Verma', 40, 38, 2, 102, 0.96),
        const SizedBox(height: 16),
        _buildBlockCard('Boys Hostel B', 'Warden - Mr. Khanna', 38, 30, 8, 72, 0.76),
      ],
    );
  }

  Widget _buildBlockCard(String name, String warden, int rooms, int occupied, int vacant, int students, double occupancy) {
    final pctStr = '${(occupancy * 100).toInt()}%';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFE8FDF3), borderRadius: BorderRadius.circular(10)),
                child: const Icon(LucideIcons.home, size: 20, color: Color(0xFF10B981)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text(warden, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8FDF3), borderRadius: BorderRadius.circular(12)),
                child: Text('Operating\nNormally', style: GoogleFonts.figtree(fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)), textAlign: TextAlign.center),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBlockStat('$rooms', 'Rooms'),
              _buildBlockStat('$occupied', 'Occupied'),
              _buildBlockStat('$vacant', 'Vacant'),
              _buildBlockStat('$students', 'Students'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(pctStr, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark))],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(3))),
              FractionallySizedBox(
                widthFactor: occupancy,
                child: Container(height: 6, decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(3))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('View Rooms', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
              const Icon(LucideIcons.chevronRight, size: 16, color: _textMuted),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBlockStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
        Text(label, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
      ],
    );
  }

  // --- Welfare Alerts ---
  Widget _buildWelfareAlerts() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildAlertItem(LucideIcons.heartPulse, const Color(0xFFEF4444), const Color(0xFFFEF2F2), 'Student reported sick', 'Rahul Sharma • Room 204\n08:15 AM • Fever 100.4°F', 'Resolve'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildAlertItem(LucideIcons.userX, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Hostel attendance missing', 'Aman Patel • Room 311\nSince 07:30 AM', 'Resolve'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildAlertItem(LucideIcons.users, const Color(0xFF6366F1), const Color(0xFFEEF2FF), 'Parent requested follow-up', 'Abha Khan • Room 122\nCounselling check-in', 'Resolve'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildAlertItem(LucideIcons.shieldAlert, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Discipline note logged', 'Karan Mehta • Room 218\nCurfew breach', 'Resolve'),
        ],
      ),
    );
  }

  Widget _buildAlertItem(IconData icon, Color color, Color bg, String title, String subtitle, String action) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted, height: 1.4)),
              ],
            ),
          ),
          Text(action, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _primary)),
        ],
      ),
    );
  }

  // --- Attendance Status ---
  Widget _buildAttendanceStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildAttendanceCard(LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFE8FDF3), '319', 'Checked In')),
              const SizedBox(width: 12),
              Expanded(child: _buildAttendanceCard(LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), '5', 'Pending\nVerification')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildAttendanceCard(LucideIcons.logOut, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), '12', 'Weekend Leave')),
              const SizedBox(width: 12),
              Expanded(child: _buildAttendanceCard(LucideIcons.user, const Color(0xFF8463E9), const Color(0xFFF4F1FD), '8', 'Authorized\nOuting')),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.clipboardList, size: 16, color: _textDark),
                const SizedBox(width: 8),
                Text('Run Roll Call', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(IconData icon, Color color, Color bg, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
        ],
      ),
    );
  }

  // --- Room Status Board ---
  Widget _buildRoomStatusLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLegendItem(const Color(0xFF10B981), 'Full'),
        _buildLegendItem(const Color(0xFF3B82F6), 'Partial'),
        _buildLegendItem(const Color(0xFFF59E0B), 'Vacant'),
        _buildLegendItem(const Color(0xFFEF4444), 'Maint.'),
        _buildLegendItem(const Color(0xFF8B5CF6), 'Isolation'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted)),
      ],
    );
  }

  Widget _buildRoomStatusBoard() {
    return Column(
      children: [
        _buildRoomStatusCard('Room 203', 'Boys A', '4 / 4 occupied', 'Full', const Color(0xFF10B981), [const Color(0xFF10B981), const Color(0xFF10B981), const Color(0xFF10B981), const Color(0xFF10B981)]),
        const SizedBox(height: 12),
        _buildRoomStatusCard('Room 204', 'Boys A', '3 / 4 occupied', 'Medical Isolation', const Color(0xFF8B5CF6), [const Color(0xFF8B5CF6), const Color(0xFF8B5CF6), const Color(0xFF8B5CF6), const Color(0xFFF3F4F6)]),
        const SizedBox(height: 12),
        _buildRoomStatusCard('Room 305', 'Girls A', '2 / 4 occupied', 'Vacancies', const Color(0xFFF59E0B), [const Color(0xFFF59E0B), const Color(0xFFF59E0B), const Color(0xFFF3F4F6), const Color(0xFFF3F4F6)]),
        const SizedBox(height: 12),
        _buildRoomStatusCard('Room 311', 'Boys B', '3 / 3 occupied', 'Full', const Color(0xFF10B981), [const Color(0xFF10B981), const Color(0xFF10B981), const Color(0xFF10B981)]),
      ],
    );
  }

  Widget _buildRoomStatusCard(String room, String block, String occStr, String badge, Color badgeColor, List<Color> segments) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(8)), // Using a generic light bg
            child: const Icon(LucideIcons.bedDouble, size: 20, color: Color(0xFF10B981)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(room, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(width: 4),
                        Text('($block)', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                      ],
                    ),
                    Text(badge, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(occStr, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                const SizedBox(height: 8),
                Row(
                  children: segments.map((color) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Room Allocation ---
  Widget _buildRoomAllocation() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildAllocationItem(LucideIcons.userPlus, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), 'Pending Allocation', '3 Students', 'Allocate'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildAllocationItem(LucideIcons.arrowRightLeft, const Color(0xFF8B5CF6), const Color(0xFFF5F3FF), 'Room Transfer Requests', '2 Pending', 'Review'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildAllocationItem(LucideIcons.logOut, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Vacating Requests', '1 Pending', 'Approve'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildAllocationItem(LucideIcons.home, const Color(0xFF10B981), const Color(0xFFE8FDF3), 'New Hostel Admissions', '4 This Week', 'View'),
        ],
      ),
    );
  }

  Widget _buildAllocationItem(IconData icon, Color color, Color bg, String title, String subtitle, String action) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          Text(action, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _primary)),
        ],
      ),
    );
  }

  // --- Mess Status ---
  Widget _buildMessStatus(bool isTablet) {
    return GridView.count(
      crossAxisCount: isTablet ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildMessCard(LucideIcons.coffee, const Color(0xFF10B981), const Color(0xFFE8FDF3), '312 Students', 'Breakfast Served', 'Completed 08:30 AM'),
        _buildMessCard(LucideIcons.clock, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), '1:00 PM', 'Lunch Scheduled', 'Veg thali - Curd rice'),
        _buildMessCard(LucideIcons.heart, const Color(0xFF8B5CF6), const Color(0xFFF5F3FF), '5 Students', 'Special Diet Requests', 'Lactose - Jain - Diabetic'),
        _buildMessCard(LucideIcons.alertCircle, const Color(0xFFEF4444), const Color(0xFFFEF2F2), '1 Open Issue', 'Food Complaint', 'Dinner spice level - Block B'),
      ],
    );
  }

  Widget _buildMessCard(IconData icon, Color color, Color bg, String value, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 14, color: color),
          ),
          const Spacer(),
          Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
          Text(title, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // --- Maintenance & Facilities ---
  Widget _buildMaintenance() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildMaintenanceItem(LucideIcons.zap, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Room 405', 'Electrical repair pending', 'Today'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildMaintenanceItem(LucideIcons.droplet, const Color(0xFFEF4444), const Color(0xFFFEF2F2), 'Room 402', 'Plumbing leak under fix', 'In 1 day'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildMaintenanceItem(LucideIcons.wind, const Color(0xFF3B82F6), const Color(0xFFEFF6FF), 'Room 210', 'Deep cleaning scheduled', 'Tomorrow'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildMaintenanceItem(LucideIcons.wrench, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Block B Corridor', 'Tubelight replacement', 'Today'),
        ],
      ),
    );
  }

  Widget _buildMaintenanceItem(IconData icon, Color color, Color bg, String title, String subtitle, String time) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          Text(time, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
        ],
      ),
    );
  }

  // --- Safety Center ---
  Widget _buildSafetyCenter() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildSafetyItem(LucideIcons.flame, const Color(0xFF10B981), const Color(0xFFE8FDF3), 'Fire Safety Checks', 'Last drill - 4 days ago', 'On Schedule', const Color(0xFF10B981)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildSafetyItem(LucideIcons.phoneCall, const Color(0xFFEF4444), const Color(0xFFFEF2F2), 'Emergency Contact Missing', '2 Students', 'Update Required', const Color(0xFFEF4444)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildSafetyItem(LucideIcons.shieldAlert, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Incident Under Review', '1 Case', 'Investigating', const Color(0xFFF59E0B)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildSafetyItem(LucideIcons.shieldCheck, const Color(0xFF10B981), const Color(0xFFE8FDF3), 'Security Round', 'Completed 02:00 AM', 'Verified', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(IconData icon, Color color, Color bg, String title, String subtitle, String badge, Color badgeColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(badge, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Staff Status ---
  Widget _buildStaffStatus() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildStaffItem(LucideIcons.shield, const Color(0xFF10B981), const Color(0xFFE8FDF3), 'Wardens', '3 / 3 present', const Color(0xFF10B981)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildStaffItem(LucideIcons.sprayCan, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Housekeeping', '5 / 8 present\nShort staffed', const Color(0xFFF59E0B)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildStaffItem(LucideIcons.shieldCheck, const Color(0xFF10B981), const Color(0xFFE8FDF3), 'Security', '4 / 4 present', const Color(0xFF10B981)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildStaffItem(LucideIcons.users, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Caretakers', '6 / 7 present\nShort staffed', const Color(0xFFF59E0B)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildStaffItem(LucideIcons.activity, const Color(0xFF10B981), const Color(0xFFE8FDF3), 'Medical Staff', '1 / 1 present', const Color(0xFF10B981)),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildStaffItem(LucideIcons.utensils, const Color(0xFF10B981), const Color(0xFFE8FDF3), 'Mess Staff', '8 / 8 present', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildStaffItem(IconData icon, Color color, Color bg, String title, String subtitle, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        ],
      ),
    );
  }

  // --- Activity Feed ---
  Widget _buildActivityFeed() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineItem('07:00 AM', 'Morning attendance completed', const Color(0xFF10B981), true),
          _buildTimelineItem('08:15 AM', 'Medical case reported\nRoom 204', const Color(0xFFEF4444), true),
          _buildTimelineItem('08:30 AM', 'Breakfast service completed', const Color(0xFF3B82F6), true),
          _buildTimelineItem('10:30 AM', 'Room 305 vacated', const Color(0xFFF59E0B), true),
          _buildTimelineItem('11:10 AM', 'Warden inspection\nGirls Hostel A', const Color(0xFF8B5CF6), true),
          _buildTimelineItem('12:15 PM', 'Mess inspection completed', const Color(0xFF10B981), true),
          _buildTimelineItem('02:00 PM', 'New student allocated\nto Room 112', const Color(0xFF3B82F6), false),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String time, String text, Color color, bool hasLine) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              if (hasLine) Expanded(child: Container(width: 2, color: const Color(0xFFE5E7EB))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textMuted)),
                  const SizedBox(height: 4),
                  Text(text, style: GoogleFonts.figtree(fontSize: 14, color: _textDark, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
