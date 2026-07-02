import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';

class HostelBlocksScreen extends StatelessWidget {
  const HostelBlocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Blocks'),
      
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _buildTopHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  SizedBox(height: 12.h),
                  _buildBlocksListHeader(),
                  SizedBox(height: 12.h),
                  _buildNewBlockCard(context, 'A', const Color(0xFFEDE9FE), const Color(0xFF6366F1), 'Aryabhata Block', 'Block A · 2 open tickets', 'Boys', 4, 60, 228, 240, 95, 'Active', const Color(0xFF10B981), const Color(0xFFD1FAE5), const Color(0xFFEF4444), 'Mr. R. Sharma', '+91 98xxxx 1023', 2, 'A'),
                  const SizedBox(height: 12),
                  _buildNewBlockCard(context, 'B', const Color(0xFFEDE9FE), const Color(0xFF6366F1), 'Bhaskara Block', 'Block B · 1 open ticket', 'Boys', 4, 60, 210, 240, 88, 'Active', const Color(0xFF10B981), const Color(0xFFD1FAE5), const Color(0xFFF59E0B), 'Mr. K. Iyer', '+91 98xxxx 2234', 1, 'B'),
                  const SizedBox(height: 12),
                  _buildNewBlockCard(context, 'C', const Color(0xFFEDE9FE), const Color(0xFF6366F1), 'Chandragupta', 'Block C', 'Boys', 3, 45, 175, 180, 97, 'Active', const Color(0xFF10B981), const Color(0xFFD1FAE5), const Color(0xFFEF4444), 'Mr. P. Verma', '+91 98xxxx 4412', 0, 'C'),
                  const SizedBox(height: 12),
                  _buildNewBlockCard(context, 'D', const Color(0xFFFEE2E2), const Color(0xFFEF4444), 'Draupadi Block', 'Block D · 3 open tickets', 'Girls', 4, 60, 232, 240, 97, 'Active', const Color(0xFF10B981), const Color(0xFFD1FAE5), const Color(0xFFEF4444), 'Mrs. S. Nair', '+91 98xxxx 9087', 3, 'D'),
                  const SizedBox(height: 12),
                  _buildNewBlockCard(context, 'E', const Color(0xFFEDE9FE), const Color(0xFF6366F1), 'Eklavya Block', 'Block E · 6 open tickets', 'Boys', 3, 45, 120, 180, 67, 'Maint.', const Color(0xFFF59E0B), const Color(0xFFFEF3C7), const Color(0xFF10B981), 'Mr. A. Khan', '+91 98xxxx 3321', 6, 'E'),
                  const SizedBox(height: 12),
                  _buildNewBlockCard(context, 'F', const Color(0xFFFEE2E2), const Color(0xFFEF4444), 'Ferozshah Block', 'Block F · 1 open ticket', 'Girls', 4, 60, 215, 240, 90, 'Active', const Color(0xFF10B981), const Color(0xFFD1FAE5), const Color(0xFFF59E0B), 'Mrs. M. Pillai', '+91 98xxxx 6543', 1, 'F'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blocks',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'All hostel blocks with capacity, occupancy, and warden in charge.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF595973),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.plus, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Add Block',
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
        _buildStatCard('6', 'Total Blocks', LucideIcons.layoutGrid, const Color(0xFF8B5CF6), const Color(0xFFEDE9FE), true),
        _buildStatCard('4', 'Boys Blocks', LucideIcons.bed, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), false),
        _buildStatCard('2', 'Girls Blocks', LucideIcons.bed, const Color(0xFFEF4444), const Color(0xFFFEE2E2), false),
        _buildStatCard('13', 'Maintenance', LucideIcons.wrench, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), false),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color iconColor, Color iconBg, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? iconColor.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.15),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
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
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF595973),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
          const SizedBox(width: 12),
          Text(
            'Search block, code or warden',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlocksListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 6 blocks',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF595973),
          ),
        ),
        const Icon(LucideIcons.listFilter, size: 18, color: Color(0xFF181821)),
      ],
    );
  }

  Widget _buildNewBlockCard(
    BuildContext context,
    String initial,
    Color initialBg,
    Color initialColor,
    String title,
    String subtitle,
    String type,
    int floors,
    int rooms,
    int occUsed,
    int occTotal,
    int occPercent,
    String status,
    Color statusColor,
    Color statusBg,
    Color progressColor,
    String wardenName,
    String wardenPhone,
    int openTickets,
    String blockCode,
  ) {
    return GestureDetector(
      onTap: () => _showBlockDetailsBottomSheet(
        context,
        initial,
        initialBg,
        initialColor,
        title,
        type,
        floors,
        rooms,
        occUsed,
        occTotal,
        occPercent,
        status,
        statusColor,
        statusBg,
        wardenName,
        wardenPhone,
        openTickets,
        blockCode,
      ),
      child: Container(
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: initialBg,
                  radius: 20,
                  child: Text(
                    initial,
                    style: GoogleFonts.inter(
                      color: initialColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
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
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: type == 'Boys' ? const Color(0xFFE0F2FE) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          type,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: type == 'Boys' ? const Color(0xFF0EA5E9) : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
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
                const SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      '$floors Floors',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF595973),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('·', style: TextStyle(color: Color(0xFF595973), fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(
                      '$rooms Rooms',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF595973),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                        children: [
                          TextSpan(text: '$occUsed/$occTotal'),
                          TextSpan(
                            text: '    $occPercent%',
                            style: const TextStyle(color: Color(0xFF595973), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          width: 100 * (occPercent / 100.0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: progressColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockDetailsBottomSheet(
    BuildContext context,
    String initial,
    Color initialBg,
    Color initialColor,
    String title,
    String type,
    int floors,
    int rooms,
    int occUsed,
    int occTotal,
    int occPercent,
    String status,
    Color statusColor,
    Color statusBg,
    String wardenName,
    String wardenPhone,
    int openTickets,
    String blockCode,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(LucideIcons.x, size: 24, color: Color(0xFF595973)),
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: initialBg,
                  radius: 24,
                  child: Text(
                    initial,
                    style: GoogleFonts.inter(
                      color: initialColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF181821),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius: BorderRadius.circular(8),
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
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Block $blockCode · $type Hostel',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF595973),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildPopStatCard(floors.toString(), 'Floors', LucideIcons.building2, const Color(0xFF8B5CF6), const Color(0xFFEDE9FE))),
                const SizedBox(width: 12),
                Expanded(child: _buildPopStatCard(rooms.toString(), 'Rooms', LucideIcons.bedDouble, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE))),
                const SizedBox(width: 12),
                Expanded(child: _buildPopStatCard('$occUsed/$occTotal', 'Occupancy', LucideIcons.users, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
                const SizedBox(width: 12),
                Expanded(child: _buildPopStatCard('$occPercent%', 'Occupancy %', LucideIcons.pieChart, const Color(0xFF10B981), const Color(0xFFD1FAE5))),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Warden',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(LucideIcons.user, size: 16, color: Color(0xFF6366F1)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wardenName,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF181821),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  wardenPhone,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF595973),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDE9FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.phone, color: Color(0xFF6366F1), size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow(LucideIcons.building, 'Type', type),
            SizedBox(height: 12.h),
            _buildDetailRow(LucideIcons.scan, 'Block Code', blockCode),
            SizedBox(height: 12.h),
            _buildDetailRow(LucideIcons.users, 'Total Capacity', occTotal.toString()),
            SizedBox(height: 12.h),
            _buildDetailRow(LucideIcons.user, 'Occupied', occUsed.toString()),
            SizedBox(height: 12.h),
            _buildDetailRow(LucideIcons.checkSquare, 'Open Tickets', openTickets.toString()),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F3FF),
                  foregroundColor: const Color(0xFF6366F1),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View Full Details',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPopStatCard(String value, String label, IconData icon, Color iconColor, Color iconBg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF181821),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF595973),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF595973)),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF595973),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
      ],
    );
  }
}
