import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _primary = Color(0xFF3B82F6); // Blue for transport

class TransportInsightsScreen extends StatefulWidget {
  const TransportInsightsScreen({super.key});

  @override
  State<TransportInsightsScreen> createState() => _TransportInsightsScreenState();
}

class _TransportInsightsScreenState extends State<TransportInsightsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Transport Insights'),
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

                        _buildSectionTitle('Live Fleet Tracking', 'Current status of buses.'),
                        const SizedBox(height: 24),
                        _buildLiveTracking(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Maintenance Alerts', '2 active', null, const Color(0xFFEF4444)),
                        const SizedBox(height: 24),
                        _buildMaintenanceAlerts(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Rider Attendance', 'Student tap-in data'),
                        const SizedBox(height: 24),
                        _buildAttendanceStatus(),
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
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
              child: Text(
                'FLEET ACTIVE - MORNING ROUTE',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6), letterSpacing: 0.5),
              ),
            ),
            const Spacer(),
            const Icon(LucideIcons.bell, size: 20, color: _textDark),
          ],
        ),
        const SizedBox(height: 16),
        Text('Transport Insights', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text('Monitor fleet, routes, rider\nattendance & alerts.', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted, height: 1.4)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              const Icon(LucideIcons.search, size: 18, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 12),
              Expanded(child: Text('Search buses, routes...', style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF9CA3AF)))),
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
        _buildSmallKPI(LucideIcons.bus, const Color(0xFFEFF6FF), const Color(0xFF3B82F6), '12', 'Active\nBuses'),
        _buildSmallKPI(LucideIcons.map, const Color(0xFFF4F1FD), const Color(0xFF8463E9), '24', 'Active\nRoutes'),
        _buildSmallKPI(LucideIcons.users, const Color(0xFFE8FDF3), const Color(0xFF10B981), '856', 'Students\nRiding'),
        _buildSmallKPI(LucideIcons.clock, const Color(0xFFFFF7ED), const Color(0xFFF59E0B), '3', 'Delayed\nTrips'),
        _buildSmallKPI(LucideIcons.wrench, const Color(0xFFFEF2F2), const Color(0xFFEF4444), '2', 'Buses in\nMaint.'),
        _buildSmallKPI(LucideIcons.shieldCheck, const Color(0xFFF0FDF4), const Color(0xFF22C55E), '100%', 'Drivers\nVerified'),
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

  // --- Live Tracking ---
  Widget _buildLiveTracking() {
    return Column(
      children: [
        _buildTrackingCard('Bus 01 (DL 1P 1234)', 'Route: North City Campus', 45, 42, 'On Time', const Color(0xFF10B981)),
        const SizedBox(height: 16),
        _buildTrackingCard('Bus 05 (DL 1P 5678)', 'Route: South Suburbs', 50, 48, 'Delayed 10m', const Color(0xFFF59E0B)),
      ],
    );
  }

  Widget _buildTrackingCard(String name, String route, int capacity, int students, String status, Color statusColor) {
    final occupancy = students / capacity;
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
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(LucideIcons.bus, size: 20, color: statusColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    Text(route, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Text(status, style: GoogleFonts.figtree(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor), textAlign: TextAlign.center),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBlockStat('$capacity', 'Capacity'),
              _buildBlockStat('$students', 'Boarded'),
              _buildBlockStat('12', 'Stops Left'),
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
                child: Container(height: 6, decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(3))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Live Map', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
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

  // --- Maintenance Alerts ---
  Widget _buildMaintenanceAlerts() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        children: [
          _buildAlertItem(LucideIcons.alertTriangle, const Color(0xFFEF4444), const Color(0xFFFEF2F2), 'Engine check required', 'Bus 08 • Needs servicing\nToday', 'Schedule'),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildAlertItem(LucideIcons.wrench, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), 'Routine Maintenance', 'Bus 11 • Due in 2 days', 'View'),
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
              Expanded(child: _buildAttendanceCard(LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFE8FDF3), '856', 'Boarded')),
              const SizedBox(width: 12),
              Expanded(child: _buildAttendanceCard(LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFFF7ED), '45', 'Pending\nPickup')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildAttendanceCard(LucideIcons.xCircle, const Color(0xFFEF4444), const Color(0xFFFEF2F2), '12', 'Absent\nToday')),
            ],
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
}
