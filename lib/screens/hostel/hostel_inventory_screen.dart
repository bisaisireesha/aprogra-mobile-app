import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../widgets/app_bottom_nav.dart';
import '../auth/menu_screen.dart';

class HostelInventoryScreen extends StatelessWidget {
  const HostelInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Inventory'),
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
                  _buildInventoryList(),
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
          'Inventory',
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
          '12',
          'Total Items',
          LucideIcons.package,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          true,
        ),
        _buildStatCard(
          '5',
          'In Stock',
          LucideIcons.packageCheck,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          false,
        ),
        _buildStatCard(
          '5',
          'Low Stock',
          LucideIcons.alertTriangle,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          false,
        ),
        _buildStatCard(
          '2',
          'Out of Stock',
          LucideIcons.xCircle,
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
        color: const Color(0xFFF8F5FF), // Light purple background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
          const SizedBox(width: 12),
          Text(
            'Search item, category or vendor',
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
          'Showing 12 items',
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

  Widget _buildInventoryList() {
    return Column(
      children: [
        _buildInventoryItem(
          'Basmati Rice',
          'Grains',
          '240 kg',
          '100%',
          1.0,
          'In Stock',
          LucideIcons.wheat,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildInventoryItem(
          'Wheat Flour',
          'Grains',
          '60 kg',
          '30%',
          0.3,
          'Low Stock',
          LucideIcons.box,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
        _buildInventoryItem(
          'Toor Dal',
          'Pulses',
          '45 kg',
          '56%',
          0.56,
          'In Stock',
          LucideIcons.bean,
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildInventoryItem(
          'Moong Dal',
          'Pulses',
          '12 kg',
          '20%',
          0.2,
          'Low Stock',
          LucideIcons.bean,
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
        _buildInventoryItem(
          'Potato',
          'Vegetables',
          '90 kg',
          '90%',
          0.9,
          'In Stock',
          LucideIcons.gem,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildInventoryItem(
          'Onion',
          'Vegetables',
          '35 kg',
          '44%',
          0.44,
          'Low Stock',
          LucideIcons.droplet,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
        _buildInventoryItem(
          'Tomato',
          'Vegetables',
          '0 kg',
          '0%',
          0.0,
          'Out of Stock',
          LucideIcons.aperture,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFFEF4444),
          const Color(0xFFFEE2E2),
        ),
        _buildInventoryItem(
          'Milk',
          'Dairy',
          '120 litre',
          '75%',
          0.75,
          'In Stock',
          LucideIcons.milk,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildInventoryItem(
          'Paneer',
          'Dairy',
          '8 kg',
          '40%',
          0.4,
          'Low Stock',
          LucideIcons.package,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
        _buildInventoryItem(
          'Curd',
          'Dairy',
          '15 kg',
          '60%',
          0.6,
          'In Stock',
          LucideIcons.shoppingBasket,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildInventoryItem(
          'Green Chilli',
          'Vegetables',
          '5 kg',
          '25%',
          0.25,
          'Low Stock',
          LucideIcons.leaf,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
        _buildInventoryItem(
          'Cooking Oil',
          'Essentials',
          '18 litre',
          '36%',
          0.36,
          'Low Stock',
          LucideIcons.flaskConical,
          const Color(0xFF595973),
          const Color(0xFFF1F5F9),
          const Color(0xFF595973),
          const Color(0xFFF1F5F9),
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
      ],
    );
  }

  Widget _buildInventoryItem(
    String title,
    String category,
    String quantity,
    String percentText,
    double percent,
    String status,
    IconData icon,
    Color iconColor,
    Color iconBg,
    Color catColor,
    Color catBg,
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
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
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
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF181821),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                quantity,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF181821),
                                ),
                              ),
                              Text(
                                ' • $percentText',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF595973),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percent,
                            backgroundColor: const Color(0xFFF1F5F9),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              statusColor,
                            ), // Match progress color to status
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
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
          ),
        ],
      ),
    );
  }
}
