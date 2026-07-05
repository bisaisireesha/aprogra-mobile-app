import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

class HostelVendorsScreen extends StatelessWidget {
  const HostelVendorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Vendors'),
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
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  SizedBox(height: 12.h),
                  _buildListHeader(),
                  const SizedBox(height: 8),
                  _buildVendorsList(),
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
          'Vendors',
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

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.25,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          '7',
          'Total Vendors',
          LucideIcons.briefcase,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          true,
        ),
        _buildStatCard(
          '6',
          'Active',
          LucideIcons.checkCircle2,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          false,
        ),
        _buildStatCard(
          '1',
          'On Hold',
          LucideIcons.alertCircle,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          false,
        ),
        _buildStatCard(
          '₹51,400',
          'Outstanding',
          LucideIcons.wallet,
          const Color(0xFFEF4444),
          const Color(0xFFFEE2E2),
          false,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color iconBgColor,
    bool isPrimary,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrimary
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.1),
          width: isPrimary ? 1.5 : 1,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF181821),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
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
        color: const Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
          const SizedBox(width: 12),
          Text(
            'Search vendor, contact or category',
            style: GoogleFonts.inter(
              fontSize: 14,
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
          'Showing 7 vendors',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF595973),
          ),
        ),
        Row(
          children: [
            const Icon(
              LucideIcons.arrowDownUp,
              size: 14,
              color: Color(0xFF6366F1),
            ),
            const SizedBox(width: 4),
            Text(
              'Sort',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6366F1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVendorsList() {
    return Column(
      children: [
        _buildVendorItem(
          'Sri Annapurna Traders',
          'Mr. Suresh K.',
          'Grains',
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          'Today',
          '₹24,500',
          'Today',
          'Active',
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildVendorItem(
          'Krishna Pulses',
          'Mr. Ramesh G.',
          'Pulses',
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
          '',
          '',
          '-',
          'Active',
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildVendorItem(
          'Green Farms',
          'Ms. Lakshmi',
          'Vegetables',
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          'Today',
          '₹8,600',
          '',
          'Active',
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildVendorItem(
          'Amul Dairy',
          'Mr. Patel',
          'Dairy',
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          'Today',
          '₹12,300',
          '',
          'Active',
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildVendorItem(
          'Patanjali Distributor',
          'Mr. Bhardwaj',
          'Oils & Spices',
          const Color(0xFFEF4444),
          const Color(0xFFFEE2E2),
          '3 days ago',
          '',
          '-',
          'Active',
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildVendorItem(
          'MTR Spices',
          'Ms. Anitha',
          'Oils & Spices',
          const Color(0xFFEF4444),
          const Color(0xFFFEE2E2),
          '1 week ago',
          '',
          '₹4,200',
          'On Hold',
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
        _buildVendorItem(
          'Parle Distributor',
          'Mr. Joshi',
          'Snacks',
          const Color(0xFF6366F1),
          const Color(0xFFE0E7FF),
          '4 days ago',
          '₹1,800',
          '',
          'Active',
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
      ],
    );
  }

  Widget _buildVendorItem(
    String title,
    String contact,
    String category,
    Color catColor,
    Color catBg,
    String topDate,
    String topAmount,
    String bottomText,
    String status,
    Color statusColor,
    Color statusBg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.briefcase,
              color: Color(0xFF6366F1),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      const SizedBox(height: 4),
                      Text(
                        contact,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF595973),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: catBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: catColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    if (topDate.isNotEmpty || topAmount.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (topDate.isNotEmpty)
                            Text(
                              topDate,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF595973),
                              ),
                            ),
                          if (topDate.isNotEmpty && topAmount.isNotEmpty)
                            const SizedBox(width: 12),
                          if (topAmount.isNotEmpty)
                            Text(
                              topAmount,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                        ],
                      )
                    else
                      SizedBox(height: 12.h),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (bottomText.isNotEmpty)
                          Text(
                            bottomText,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: bottomText.startsWith('₹')
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF595973),
                              fontWeight: bottomText.startsWith('₹')
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        if (bottomText.isNotEmpty) const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
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
                      ],
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
}
