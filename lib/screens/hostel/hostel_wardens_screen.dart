import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';

class HostelWardensScreen extends StatelessWidget {
  const HostelWardensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Wardens'),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.bedDouble), label: 'Hostel'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Settings'),
        ],
        currentIndex: 1,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
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
                  _buildSearchAndFilterRow(),
                  const SizedBox(height: 16),
                  _buildWardenCard('RS', 'Mr. R. Sharma', 'Boys hostel', 'Aryabhata Block', 'Block A', 'Morning', 'On Duty'),
                  const SizedBox(height: 12),
                  _buildWardenCard('KI', 'Mr. K. Iyer', 'Boys hostel', 'Bhaskara Block', 'Block B', 'Evening', 'On Duty'),
                  const SizedBox(height: 12),
                  _buildWardenCard('PV', 'Mr. P. Verma', 'Boys hostel', 'Chandragupta', 'Block C', 'Night', 'Off Duty'),
                  const SizedBox(height: 12),
                  _buildWardenCard('SN', 'Mrs. S. Nair', 'Girls hostel', 'Draupadi Block', 'Block D', 'Morning', 'On Duty'),
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
                'Wardens',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'All hostel wardens with assigned blocks, shifts, and on-duty status.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF595973),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
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
                'Add Warden',
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
        _buildStatCard('6', 'Total Wardens', LucideIcons.users, const Color(0xFF8B5CF6), const Color(0xFFEDE9FE), true),
        _buildStatCard('4', 'On Duty', LucideIcons.shieldCheck, const Color(0xFF10B981), const Color(0xFFD1FAE5), false),
        _buildStatCard('1', 'Off Duty', LucideIcons.userMinus, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE), false),
        _buildStatCard('1', 'On Leave', LucideIcons.userX, const Color(0xFFF59E0B), const Color(0xFFFEF3C7), false),
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
          color: isActive ? iconColor.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.15),
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
              const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search warden, block or phone',
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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Showing 6 wardens',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF595973),
              ),
            ),
            const Icon(LucideIcons.listFilter, size: 18, color: Color(0xFF181821)),
          ],
        ),
      ],
    );
  }

  Widget _buildWardenCard(
    String initial,
    String name,
    String type,
    String blockName,
    String blockCode,
    String shift,
    String status,
  ) {
    Color shiftColor;
    Color shiftBg;
    if (shift == 'Morning') {
      shiftColor = const Color(0xFFF59E0B);
      shiftBg = const Color(0xFFFEF3C7);
    } else if (shift == 'Evening') {
      shiftColor = const Color(0xFF0EA5E9);
      shiftBg = const Color(0xFFE0F2FE);
    } else {
      shiftColor = const Color(0xFF8B5CF6);
      shiftBg = const Color(0xFFEDE9FE);
    }

    Color statusColor;
    Color statusBg;
    if (status == 'On Duty') {
      statusColor = const Color(0xFF10B981);
      statusBg = const Color(0xFFD1FAE5);
    } else if (status == 'Off Duty') {
      statusColor = const Color(0xFF64748B);
      statusBg = const Color(0xFFF1F5F9);
    } else {
      statusColor = const Color(0xFFF59E0B);
      statusBg = const Color(0xFFFEF3C7);
    }

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
                      type,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF595973),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.moreVertical, size: 20, color: Color(0xFF595973)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blockName,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF181821),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    blockCode,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: shiftBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      shift,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: shiftColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
            ],
          ),
        ],
      ),
    );
  }
}
