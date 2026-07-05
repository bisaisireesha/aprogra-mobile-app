import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../widgets/app_bottom_nav.dart';
import '../auth/menu_screen.dart';

class RoomAllocationsScreen extends StatelessWidget {
  const RoomAllocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Room Allocations'),
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
                  const SizedBox(height: 16),
                  _buildActionRow(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildListHeader(),
                  const SizedBox(height: 16),
                  _buildAllocationCard(
                    'AM',
                    'Aarav Mehta',
                    'ADM2024-101',
                    'Allocated',
                    const Color(0xFF10B981),
                    const Color(0xFFD1FAE5),
                    '9-A',
                    'Boys',
                    'Aryabhata',
                    'B2',
                    '12 Jun 2025',
                  ),
                  const SizedBox(height: 12),
                  _buildAllocationCard(
                    'DS',
                    'Diya Sharma',
                    'ADM2024-118',
                    'Allocated',
                    const Color(0xFF10B981),
                    const Color(0xFFD1FAE5),
                    '10-B',
                    'Girls',
                    'Draupadi',
                    'B1',
                    '12 Jun 2025',
                  ),
                  const SizedBox(height: 12),
                  _buildAllocationCard(
                    'KS',
                    'Kabir Singh',
                    'ADM2024-122',
                    'Allocated',
                    const Color(0xFF10B981),
                    const Color(0xFFD1FAE5),
                    '11-A',
                    'Boys',
                    'Bhaskara',
                    'B3',
                    '14 Jun 2025',
                  ),
                  const SizedBox(height: 12),
                  _buildAllocationCard(
                    'IR',
                    'Ishita Roy',
                    'ADM2025-008',
                    'Pending',
                    const Color(0xFFF59E0B),
                    const Color(0xFFFEF3C7),
                    '9-C',
                    'Girls',
                    'Ferozshah',
                    '--',
                    '',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Room Allocations',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Students assigned to hostel rooms\nand beds across all blocks.',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.4,
            color: const Color(0xFF595973),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.plus, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'New Allocation',
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
          'Total Records',
          LucideIcons.users,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          true,
        ),
        _buildStatCard(
          '5',
          'Allocated',
          LucideIcons.bedDouble,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          false,
        ),
        _buildStatCard(
          '2',
          'Pending Requests',
          LucideIcons.clipboardList,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          false,
        ),
        _buildStatCard(
          '1',
          'Checked Out',
          LucideIcons.doorOpen,
          const Color(0xFF64748B),
          const Color(0xFFF1F5F9),
          false,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
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
            'Search student, admission no, room or block',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Showing 8 records',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF595973),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.listFilter,
                size: 14,
                color: Color(0xFF181821),
              ),
              const SizedBox(width: 6),
              Text(
                'Filter',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF181821),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllocationCard(
    String initial,
    String name,
    String admNo,
    String status,
    Color statusColor,
    Color statusBg,
    String grade,
    String gender,
    String block,
    String room,
    String date,
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF181821),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      admNo,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF595973),
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
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade $grade',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF181821),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      block,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF181821),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gender,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF595973),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          room,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        if (date.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          const Text(
                            '·',
                            style: TextStyle(
                              color: Color(0xFF595973),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF595973),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
