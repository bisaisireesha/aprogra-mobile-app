import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

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
  bool _isRefreshing = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data refreshed successfully', style: GoogleFonts.figtree()),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: _primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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

                        if (isTablet)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: _buildWelfareAlertsSection()),
                              const SizedBox(width: 24),
                              Expanded(flex: 2, child: _buildAttendanceStatusSection()),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildWelfareAlertsSection(),
                              const SizedBox(height: 48),
                              _buildAttendanceStatusSection(),
                            ],
                          ),
                        const SizedBox(height: 48),

                        _buildRoomStatusHeader(),
                        const SizedBox(height: 24),
                        _buildRoomStatusBoard(),
                        const SizedBox(height: 48),

                        _buildRoomAllocation(),
                        const SizedBox(height: 48),

                        _buildMessStatusSection(),
                        const SizedBox(height: 48),

                        _buildStaffStatus(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Maintenance & Facilities', 'Open requests by room / area', 'New Request'),
                        const SizedBox(height: 24),
                        _buildMaintenance(),
                        const SizedBox(height: 48),

                        _buildSectionTitle('Activity Feed', null, 'View all'),
                        const SizedBox(height: 24),
                        _buildActivityFeed(),
                        const SizedBox(height: 48),

                        _buildSafetyCenter(),
                        const SizedBox(height: 48),

                        _buildTodayHighlights(),
                        const SizedBox(height: 60),
                      ],
                    ),
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

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filter Operations', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(LucideIcons.x, size: 20, color: _textMuted)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Block / Area', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textMuted)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('All Blocks', true),
                _buildFilterChip('Boys Hostel A', false),
                _buildFilterChip('Girls Hostel A', false),
                _buildFilterChip('Mess Area', false),
              ],
            ),
            const SizedBox(height: 24),
            Text('Status', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textMuted)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('Critical', true),
                _buildFilterChip('Pending', true),
                _buildFilterChip('Resolved', false),
              ],
            ),
            const SizedBox(height: 24),
            Text('Issue Type', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textMuted)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('Plumbing', false),
                _buildFilterChip('Electrical', false),
                _buildFilterChip('Cleaning', true),
                _buildFilterChip('IT & Wifi', false),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Filters applied', style: GoogleFonts.figtree()), backgroundColor: _primary, behavior: SnackBarBehavior.floating)
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Apply Filters', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? _primary.withValues(alpha: 0.1) : Colors.transparent,
        border: Border.all(color: isSelected ? _primary : const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.figtree(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? _primary : _textMuted,
        ),
      ),
    );
  }

  void _showSettingsModal() {
    bool pushEnabled = true;
    bool autoAllocEnabled = false;
    bool digestEnabled = true;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hostel Settings', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                    GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(LucideIcons.x, size: 20, color: _textMuted)),
                  ],
                ),
                const SizedBox(height: 24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Push Notifications', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
                  subtitle: Text('Alerts for incidents & maintenance', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  value: pushEnabled,
                  onChanged: (v) {
                    setModalState(() {
                      pushEnabled = v;
                    });
                  },
                  activeThumbColor: _primary,
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Automated Room Allocation', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
                  subtitle: Text('Enable auto-assignment algorithm', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  value: autoAllocEnabled,
                  onChanged: (v) {
                    setModalState(() {
                      autoAllocEnabled = v;
                    });
                  },
                  activeThumbColor: _primary,
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Daily Digest Emails', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
                  subtitle: Text('Receive summary of hostel operations', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  value: digestEnabled,
                  onChanged: (v) {
                    setModalState(() {
                      digestEnabled = v;
                    });
                  },
                  activeThumbColor: _primary,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Settings saved', style: GoogleFonts.figtree()), backgroundColor: _primary, behavior: SnackBarBehavior.floating)
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Save Preferences', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Header & KPIs ---
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hostel Insights', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text('Monitor operations, rooms, welfare\n& daily activities.', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted, height: 1.4)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Row(
            children: [
              const Icon(LucideIcons.search, size: 18, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search rooms, students...',
                    hintStyle: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF9CA3AF)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
                  onChanged: (val) {
                    // Search functionality wire-up
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: _showFilterModal,
                borderRadius: BorderRadius.circular(12),
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
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: _handleRefresh,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isRefreshing)
                        const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: _textDark))
                      else
                        const Icon(LucideIcons.refreshCw, size: 16, color: _textDark),
                      const SizedBox(width: 8),
                      Text('Refresh', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: _showSettingsModal,
                borderRadius: BorderRadius.circular(12),
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPIs(bool isTablet) {
    return GridView.count(
      crossAxisCount: isTablet ? 3 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: [
        _buildSmallKPI(LucideIcons.users, const Color(0xFFE0F2FE), const Color(0xFF0EA5E9), '324', 'Hostel Students', 'Currently Residing'),
        _buildSmallKPI(LucideIcons.doorClosed, const Color(0xFFF4F1FD), const Color(0xFF8B5CF6), '118', 'Occupied Rooms', 'Rooms Occupied'),
        _buildSmallKPI(LucideIcons.bedDouble, const Color(0xFFDCFCE7), const Color(0xFF22C55E), '22', 'Available Rooms', 'Ready for Allocation'),
        _buildSmallKPI(LucideIcons.clipboardCheck, const Color(0xFFDCFCE7), const Color(0xFF10B981), '319/324', 'Attendance Verified', 'Students Verified'),
        _buildSmallKPI(LucideIcons.alertTriangle, const Color(0xFFFEF3C7), const Color(0xFFF59E0B), '2', 'Open Incidents', 'Require Review'),
        _buildSmallKPI(LucideIcons.stethoscope, const Color(0xFFFEE2E2), const Color(0xFFEF4444), '1', 'Medical Cases', 'Under Observation'),
      ],
    );
  }

  Widget _buildSmallKPI(IconData icon, Color bg, Color iconColor, String value, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
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
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 6, right: 2),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark, height: 1.2)),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted, height: 1.2)),
        ],
      ),
    );
  }

  // --- Live Block Monitoring ---
  Widget _buildLiveBlockMonitoring() {
    return GridView.extent(
      maxCrossAxisExtent: 400,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      mainAxisExtent: 270,
      children: [
        _buildBlockCard('Boys Hostel A', 'Warden - Mr. Verma', 40, 38, 2, 102, 0.98, 'Boys', 'Operating Normally', const Color(0xFF10B981), const Color(0xFFDCFCE7)),
        _buildBlockCard('Boys Hostel B', 'Warden - Mr. Khanna', 38, 30, 8, 72, 0.76, 'Boys', 'Operating Normally', const Color(0xFF10B981), const Color(0xFFDCFCE7)),
        _buildBlockCard('Girls Hostel A', 'Warden - Ms. Rao', 35, 35, 0, 96, 1.0, 'Girls', 'Near Capacity', const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
        _buildBlockCard('Girls Hostel B', 'Warden - Ms. Iyer', 28, 22, 6, 60, 0.83, 'Girls', 'Operating Normally', const Color(0xFF10B981), const Color(0xFFDCFCE7)),
        _buildBlockCard('Junior Hostel', 'Warden - Ms. Pillai', 20, 18, 2, 54, 0.90, 'Mixed', 'Operating Normally', const Color(0xFF10B981), const Color(0xFFDCFCE7)),
        _buildBlockCard('Senior Boys Wing', 'Warden - Mr. Bose', 24, 20, 4, 48, 0.86, 'Boys', 'Partial Maintenance', const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
      ],
    );
  }

  Widget _buildBlockCard(
    String name,
    String warden,
    int rooms,
    int occupied,
    int vacant,
    int students,
    double occupancy,
    String gender,
    String status,
    Color statusColor,
    Color bgStatusColor,
  ) {
    final pctStr = '${(occupancy * 100).toInt()}%';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: bgStatusColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(LucideIcons.building, size: 20, color: statusColor),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: bgStatusColor, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(status, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBlockStat('$rooms', 'ROOMS'),
              _buildBlockStat('$occupied', 'OCCUPIED'),
              _buildBlockStat('$vacant', 'VACANT', const Color(0xFF10B981)),
              _buildBlockStat('$students', 'STUDENTS'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Occupancy', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              Text(pctStr, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
            ],
          ),
          const SizedBox(height: 6),
          Stack(
            children: [
              Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(3))),
              FractionallySizedBox(
                widthFactor: occupancy,
                child: Container(height: 6, decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(3))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(gender, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              Row(
                children: [
                  Text('View Rooms', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.chevronRight, size: 14, color: _textDark),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBlockStat(String value, String label, [Color? valueColor]) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: valueColor ?? _textDark)),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted, letterSpacing: 0.5)),
      ],
    );
  }

  // --- Welfare Alerts & Attendance ---
  Widget _buildWelfareAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFECACA), width: 1.5),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.alertTriangle, size: 18, color: Color(0xFFEF4444)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Student Welfare Alerts', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                          Text('Medical · discipline · check-in · follow-ups', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                        ],
                      ),
                    ),
                    Text('4 active', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFFECACA)),
              _buildAlertItem(LucideIcons.heartPulse, const Color(0xFFEF4444), const Color(0xFFFEF2F2), 'Student reported sick', 'Rahul Sharma - Room 204\nReported 08:15 AM - Fever 100.4°F', 'Resolve'),
              const Divider(height: 1, color: Color(0xFFFECACA)),
              _buildAlertItem(LucideIcons.clipboardCheck, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Hostel attendance missing', 'Aman Patel - Room 311\nVerification pending since 07:30 AM', 'Resolve'),
              const Divider(height: 1, color: Color(0xFFFECACA)),
              _buildAlertItem(LucideIcons.bellRing, const Color(0xFF8B5CF6), const Color(0xFFF3E8FF), 'Parent requested follow-up', 'Aisha Khan - Room 122\nCounselling check-in requested', 'Resolve'),
              const Divider(height: 1, color: Color(0xFFFECACA)),
              _buildAlertItem(LucideIcons.shieldAlert, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Discipline note logged', 'Karan Mehta - Room 218\nCurfew breach - review pending', 'Resolve'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertItem(IconData icon, Color color, Color bg, String title, String subtitle, String action) {
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
                const SizedBox(height: 4),
                Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted, height: 1.4)),
              ],
            ),
          ),
          Text(action, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF8B5CF6))),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatusSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hostel Attendance Status', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 4),
                Text('Student accountability for the day', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildAttendanceCard(LucideIcons.checkCircle2, const Color(0xFF10B981), const Color(0xFFDCFCE7), '319', 'Checked In')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildAttendanceCard(LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), '5', 'Pending Verification')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildAttendanceCard(LucideIcons.logOut, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), '12', 'Weekend Leave')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildAttendanceCard(LucideIcons.user, const Color(0xFF8B5CF6), const Color(0xFFF3E8FF), '8', 'Authorized Outing')),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
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
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(IconData icon, Color color, Color bg, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB), width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 16),
          Text(value, style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
        ],
      ),
    );
  }

  // --- Room Status Board ---
  Widget _buildRoomStatusHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 650;
        
        Widget legendWrap = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLegendItem(const Color(0xFF10B981), 'Full'),
              const SizedBox(width: 12),
              _buildLegendItem(const Color(0xFFF59E0B), 'Partial'),
              const SizedBox(width: 12),
              _buildLegendItem(const Color(0xFF0EA5E9), 'Vacant'),
              const SizedBox(width: 12),
              _buildLegendItem(const Color(0xFFEF4444), 'Maintenance'),
              const SizedBox(width: 12),
              _buildLegendItem(const Color(0xFF8B5CF6), 'Isolation'),
            ],
          ),
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ROOM STATUS BOARD', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text('Room-level monitoring', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 4),
              Text('Snapshot of occupied, partial, vacant and out-of-service rooms.', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              const SizedBox(height: 16),
              legendWrap,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ROOM STATUS BOARD', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Text('Room-level monitoring', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 4),
                  Text('Snapshot of occupied, partial, vacant and out-of-service rooms.', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Flexible(child: legendWrap),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted)),
      ],
    );
  }

  Widget _buildRoomStatusBoard() {
    return GridView.extent(
      maxCrossAxisExtent: 300,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      mainAxisExtent: 155,
      children: [
        _buildRoomStatusCard('Room 203', 'Boys A', 4, 4, 'Full', const Color(0xFF10B981), const Color(0xFFDCFCE7), null),
        _buildRoomStatusCard('Room 204', 'Boys A', 3, 4, 'Medical Isolation', const Color(0xFF8B5CF6), const Color(0xFFF3E8FF), '1 student sick'),
        _buildRoomStatusCard('Room 305', 'Girls A', 2, 4, 'Vacancies', const Color(0xFFF59E0B), const Color(0xFFFEF3C7), null),
        _buildRoomStatusCard('Room 311', 'Boys B', 3, 3, 'Full', const Color(0xFF10B981), const Color(0xFFDCFCE7), null),
        _buildRoomStatusCard('Room 402', 'Boys B', 0, 4, 'Maintenance', const Color(0xFFEF4444), const Color(0xFFFEE2E2), 'Plumbing', true),
        _buildRoomStatusCard('Room 405', 'Girls B', 0, 4, 'Maintenance', const Color(0xFFEF4444), const Color(0xFFFEE2E2), 'Electrical', true),
        _buildRoomStatusCard('Room 112', 'Junior', 1, 4, 'Vacancies', const Color(0xFFF59E0B), const Color(0xFFFEF3C7), null),
        _buildRoomStatusCard('Room 210', 'Junior', 0, 4, 'Vacant', const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), 'Deep clean scheduled'),
      ],
    );
  }

  Widget _buildRoomStatusCard(
      String room, String block, int occupied, int capacity, String badge, Color color, Color bg, String? extraText, [bool isMaintenance = false]) {
    
    List<Widget> segments = [];
    for (int i = 0; i < capacity; i++) {
      Color segColor;
      if (isMaintenance) {
        segColor = bg; 
      } else {
        segColor = i < occupied ? color : bg;
      }
      segments.add(
        Expanded(
          child: Container(
            height: 6,
            margin: EdgeInsets.only(right: i < capacity - 1 ? 4 : 0),
            decoration: BoxDecoration(color: segColor, borderRadius: BorderRadius.circular(3)),
          ),
        ),
      );
    }
    
    String occStr = isMaintenance ? 'Unavailable' : '$occupied / $capacity occupied';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(LucideIcons.bedDouble, size: 18, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                    Text(block, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
                  ],
                ),
              ),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 4, right: 2),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const Spacer(),
          Row(children: segments),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(occStr, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted), overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: bg.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4)),
                child: Text(badge, style: GoogleFonts.figtree(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
          if (extraText != null) ...[
            const SizedBox(height: 6),
            Text(extraText, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted, fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }

  // --- Room Allocation ---
  Widget _buildRoomAllocation() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Room Allocation Center', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('Pending operational actions', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildAllocationItem(LucideIcons.userPlus, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), 'Pending Allocation', '3 Students', 'Allocate'),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildAllocationItem(LucideIcons.arrowRightLeft, const Color(0xFF8B5CF6), const Color(0xFFF3E8FF), 'Room Transfer Requests', '2 Pending', 'Review'),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildAllocationItem(LucideIcons.logOut, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Vacating Requests', '1 Pending', 'Approve'),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildAllocationItem(LucideIcons.bedDouble, const Color(0xFF10B981), const Color(0xFFDCFCE7), 'New Hostel Admissions', '4 This Week', 'View'),
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
  Widget _buildMessStatusSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(LucideIcons.utensils, size: 18, color: Color(0xFFF59E0B)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mess & Dining Status', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                      Text('Daily mess operations', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.extent(
              maxCrossAxisExtent: 300,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 140,
              children: [
                _buildMessCard(LucideIcons.utensils, const Color(0xFF10B981), const Color(0xFFDCFCE7), '312 Students', 'Breakfast Served', 'Completed 08:30 AM'),
                _buildMessCard(LucideIcons.clock, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), '1:00 PM', 'Lunch Scheduled', 'Menu: Veg thali - Curd rice'),
                _buildMessCard(LucideIcons.heartPulse, const Color(0xFF8B5CF6), const Color(0xFFF3E8FF), '5 Students', 'Special Diet Requests', 'Lactose - Jain - Diabetic'),
                _buildMessCard(LucideIcons.alertCircle, const Color(0xFFEF4444), const Color(0xFFFEE2E2), '1 Open Issue', 'Food Complaint', 'Dinner spice level - Block B'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessCard(IconData icon, Color color, Color bg, String value, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 18, color: color),
              ),
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 4, right: 2),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const Spacer(),
          Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 2),
          Text(title, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  // --- Today's Highlights ---
  Widget _buildTodayHighlights() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.trophy, size: 20, color: Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                Text('Today\'s Highlights', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHighlightCard(LucideIcons.users, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), '324', 'Students Residing'),
                const SizedBox(height: 12),
                _buildHighlightCard(LucideIcons.clipboardCheck, const Color(0xFF10B981), const Color(0xFFDCFCE7), '99%', 'Attendance Verified'),
                const SizedBox(height: 12),
                _buildHighlightCard(LucideIcons.bedDouble, const Color(0xFF8B5CF6), const Color(0xFFF3E8FF), '22', 'Rooms Available'),
                const SizedBox(height: 12),
                _buildHighlightCard(LucideIcons.stethoscope, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), '1', 'Medical Case'),
                const SizedBox(height: 12),
                _buildHighlightCard(LucideIcons.shieldCheck, const Color(0xFF10B981), const Color(0xFFDCFCE7), '0', 'Major Incidents'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(IconData icon, Color color, Color bg, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 2),
                Text(label, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          const Icon(LucideIcons.sparkles, size: 16, color: Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  // --- Maintenance & Facilities ---
  Widget _buildMaintenance() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(LucideIcons.wrench, size: 18, color: Color(0xFFF59E0B)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Maintenance & Facilities', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                      Text('Open requests by room / area', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                ),
                Text('New Request', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _primary)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildMaintenanceItem(LucideIcons.plug, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Room 405', 'Electrical repair pending', 'Today'),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildMaintenanceItem(LucideIcons.droplet, const Color(0xFFEF4444), const Color(0xFFFEE2E2), 'Room 402', 'Plumbing leak under fix', 'In 1 day'),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildMaintenanceItem(LucideIcons.paintbrush, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), 'Room 210', 'Deep cleaning scheduled', 'Tomorrow'),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildMaintenanceItem(LucideIcons.wrench, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Block B Corridor', 'Tubelight replacement', 'Today'),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.shieldAlert, size: 20, color: Color(0xFFEF4444)),
                const SizedBox(width: 8),
                Text('Emergency & Safety Center', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                _buildSafetyItem(LucideIcons.flame, const Color(0xFF10B981), const Color(0xFFDCFCE7), 'Fire Safety Checks', 'Last drill · 4 days ago', 'On Schedule', const Color(0xFF10B981)),
                const SizedBox(height: 12),
                _buildSafetyItem(LucideIcons.phone, const Color(0xFFEF4444), const Color(0xFFFEE2E2), 'Emergency Contact Missing', '2 Students', 'Update Required', const Color(0xFFEF4444)),
                const SizedBox(height: 12),
                _buildSafetyItem(LucideIcons.shieldAlert, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Incident Under Review', '1 Case', 'Investigating', const Color(0xFFF59E0B)),
                const SizedBox(height: 12),
                _buildSafetyItem(LucideIcons.shieldCheck, const Color(0xFF10B981), const Color(0xFFDCFCE7), 'Security Round', 'Completed 02:00 AM', 'Verified', const Color(0xFF10B981)),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSafetyItem(IconData icon, Color color, Color bg, String title, String subtitle, String badge, Color badgeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(badge, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: badgeColor)),
          ),
        ],
      ),
    );
  }

  // --- Staff Status ---
  Widget _buildStaffStatus() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hostel Staff Status', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                Text('On-duty staffing snapshot', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildStaffItem(LucideIcons.shield, const Color(0xFF10B981), const Color(0xFFDCFCE7), 'Wardens', '3 / 3 present', const Color(0xFF10B981)),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildStaffItem(LucideIcons.paintbrush, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Housekeeping', '5 / 6 present · short staffed', const Color(0xFFF59E0B)),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildStaffItem(LucideIcons.shieldCheck, const Color(0xFF10B981), const Color(0xFFDCFCE7), 'Security', '4 / 4 present', const Color(0xFF10B981)),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildStaffItem(LucideIcons.users, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), 'Caretakers', '6 / 7 present · short staffed', const Color(0xFFF59E0B)),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildStaffItem(LucideIcons.stethoscope, const Color(0xFF10B981), const Color(0xFFDCFCE7), 'Medical Staff', '1 / 1 present', const Color(0xFF10B981)),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          _buildStaffItem(LucideIcons.utensils, const Color(0xFF10B981), const Color(0xFFDCFCE7), 'Mess Staff', '8 / 8 present', const Color(0xFF10B981)),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.activity, size: 20, color: Color(0xFF4B5563)),
                const SizedBox(width: 8),
                Text('Hostel Activity Feed', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF3F4F6), thickness: 1.5),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimelineItem('07:00 AM', 'Morning attendance completed', const Color(0xFF10B981), true),
                _buildTimelineItem('08:15 AM', 'Medical case reported · Room 204', const Color(0xFFEF4444), true),
                _buildTimelineItem('08:30 AM', 'Breakfast service completed', const Color(0xFF0EA5E9), true),
                _buildTimelineItem('10:30 AM', 'Room 305 vacated', const Color(0xFFF59E0B), true),
                _buildTimelineItem('11:10 AM', 'Warden inspection · Girls Hostel A', const Color(0xFF8B5CF6), true),
                _buildTimelineItem('12:15 PM', 'Mess inspection completed', const Color(0xFF10B981), true),
                _buildTimelineItem('02:00 PM', 'New student allocated to Room 112', const Color(0xFF0EA5E9), false),
              ],
            ),
          ),
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
              if (hasLine) Expanded(child: Container(width: 1, color: const Color(0xFFE5E7EB))),
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
