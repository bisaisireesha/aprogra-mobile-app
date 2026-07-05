import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../../widgets/app_bottom_nav.dart';
import '../auth/menu_screen.dart';

class MessDashboardScreen extends StatelessWidget {
  const MessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Mess Dashboard'),
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
                  _buildStatusBadge(),
                  SizedBox(height: 12.h),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchAndActions(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildNavigationCards(),
                  const SizedBox(height: 32),
                  _buildServiceStatusSection(),
                  const SizedBox(height: 32),
                  _buildThisWeeksMenu(),
                  const SizedBox(height: 32),
                  _buildInventoryWatch(),
                  const SizedBox(height: 32),
                  _buildVendorsAndPayments(),
                  const SizedBox(height: 32),
                  _buildDinerFeedback(),
                  const SizedBox(height: 32),
                  _buildSafetyChecks(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'MESS OPEN · LUNCH SERVICE LIVE',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF10B981),
                letterSpacing: 0.5,
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
          'Mess Dashboard',
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

  Widget _buildSearchAndActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                        'Search items, menus, vendors...',
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
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: const Icon(
                LucideIcons.slidersHorizontal,
                size: 18,
                color: Color(0xFF181821),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                'Publish Menu',
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
      childAspectRatio: 0.85,
      children: [
        _buildStatCard(
          '603',
          "Today's Diners",
          'of 642 planned',
          LucideIcons.users,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
          '+4%',
          true,
          null,
        ),
        _buildStatCard(
          '1,206',
          'Meals Served Today',
          'Breakfast + Lunch',
          LucideIcons.utensilsCrossed,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
          '+2.1%',
          true,
          null,
        ),
        _buildStatCard(
          '₹42',
          'Plate Cost (avg)',
          'Target ≤ ₹45',
          LucideIcons.indianRupee,
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
          '-3%',
          false,
          const Color(0xFF0EA5E9),
        ),
        _buildStatCard(
          '6.2%',
          'Wastage',
          'Goal under 5%',
          LucideIcons.trendingDown,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
          '+0.8%',
          true,
          null,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label1,
    String label2,
    IconData icon,
    Color iconColor,
    Color iconBg,
    String trend,
    bool isTrendPositive,
    Color? trendOverrideColor,
  ) {
    Color trendColor =
        trendOverrideColor ??
        (isTrendPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444));
    Color trendBg = trendOverrideColor != null
        ? trendOverrideColor.withValues(alpha: 0.1)
        : (isTrendPositive ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2));
    IconData trendIcon = isTrendPositive
        ? LucideIcons.trendingUp
        : LucideIcons.trendingDown;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: trendBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(trendIcon, size: 12, color: trendColor),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: trendColor,
                      ),
                    ),
                  ],
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
            label1,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF595973),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label2,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildGridNavCard(
                'Mess Menu',
                'Weekly plan · live',
                LucideIcons.fileEdit,
                const Color(0xFF8B5CF6),
                const Color(0xFFEDE9FE),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGridNavCard(
                'Meal Attendance',
                'Track plate count',
                LucideIcons.clipboardCheck,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGridNavCard(
                'Inventory',
                'Stock · indents',
                LucideIcons.box,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGridNavCard(
                'Vendors',
                'Bills · contracts',
                LucideIcons.briefcase,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildHorizontalNavCard(
          'Reports',
          'Cost · wastage',
          LucideIcons.fileText,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
        ),
      ],
    );
  }

  Widget _buildGridNavCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color iconBg,
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
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF181821),
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildHorizontalNavCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color iconBg,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TODAY'S MEALS",
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service status by meal',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Planned vs. served plates and live menu.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Meal attendance',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 14,
                  color: Color(0xFF6366F1),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildMealCard(
                'Breakfast',
                '07:00 - 09:00',
                LucideIcons.coffee,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                'DONE',
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
                ['Poha', 'Boiled Eggs', 'Bread & Jam', 'Tea / Milk'],
                305,
                318,
                0.96,
                const Color(0xFFF59E0B),
              ),
              _buildMealCard(
                'Lunch',
                '12:30 - 02:00',
                LucideIcons.soup,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
                'LIVE',
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                ['Rajma', 'Jeera Rice', 'Roti', 'Salad', 'Curd'],
                298,
                322,
                0.93,
                const Color(0xFF10B981),
              ),
              _buildMealCard(
                'Evening Sna...',
                '04:30 - 05:30',
                LucideIcons.cookie,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
                'UPCOMING',
                const Color(0xFF64748B),
                const Color(0xFFF1F5F9),
                ['Veg Sandwich', 'Banana', 'Masala Chai'],
                0,
                320,
                0.0,
                const Color(0xFFE2E8F0),
              ),
              _buildMealCard(
                'Dinner',
                '08:00 - 09:30',
                LucideIcons.utensils, // Covered dish/plate icon
                const Color(0xFF8B5CF6),
                const Color(0xFFEDE9FE),
                'UPCOMING',
                const Color(0xFF64748B),
                const Color(0xFFF1F5F9),
                [
                  'Paneer Butter Masala',
                  'Roti',
                  'Dal Tadka',
                  'Rice',
                  'Gulab Jamun',
                ],
                0,
                320,
                0.0,
                const Color(0xFFE2E8F0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(
    String title,
    String time,
    IconData icon,
    Color iconColor,
    Color iconBg,
    String status,
    Color statusColor,
    Color statusBg,
    List<String> items,
    int served,
    int planned,
    double progress,
    Color progressColor,
  ) {
    return Container(
      width: 280,
      height: 250,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.15),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
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
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.clock,
                            size: 12,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF595973),
                  ),
                ),
              );
            }).toList(),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Served',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF595973),
                ),
              ),
              Text(
                '$served/$planned · ${(progress * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildThisWeeksMenu() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.fileEdit,
                        color: Color(0xFF8B5CF6),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "This Week's Menu",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        Text(
                          'Cycle 24 · Week of 10 Jun',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'Edit menu',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 48,
              horizontalMargin: 16,
              columnSpacing: 24,
              columns: [
                DataColumn(
                  label: Text(
                    'Day',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Breakfast',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Lunch',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Dinner',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ),
              ],
              rows: [
                _buildMenuRow(
                  'Mon',
                  'Idli · Sambar',
                  'Chole · Rice',
                  'Veg Pulao',
                  false,
                ),
                _buildMenuRow(
                  'Tue',
                  'Poha · Eggs',
                  'Rajma · Rice',
                  'Paneer · Roti',
                  false,
                ),
                _buildMenuRow(
                  'Wed',
                  'Paratha · Curd',
                  'Dal · Sabzi',
                  'Pasta · Soup',
                  true,
                ),
                _buildMenuRow(
                  'Thu',
                  'Upma · Banana',
                  'Kadhi · Rice',
                  'Egg Curry · Roti',
                  false,
                ),
                _buildMenuRow(
                  'Fri',
                  'Sandwich · Milk',
                  'Biryani · Raita',
                  'Chowmein · Manchurian',
                  false,
                ),
                _buildMenuRow(
                  'Sat',
                  'Dosa · Chutney',
                  'Special Thali',
                  'Pav Bhaji',
                  false,
                ),
                _buildMenuRow(
                  'Sun',
                  'Puri · Aloo',
                  'Chicken / Mushroom',
                  'Fried Rice · Dessert',
                  false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  DataRow _buildMenuRow(
    String day,
    String breakfast,
    String lunch,
    String dinner,
    bool isToday,
  ) {
    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        return isToday ? const Color(0xFFF8F5FF) : null;
      }),
      cells: [
        DataCell(
          Row(
            children: [
              Text(
                day,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF181821),
                ),
              ),
              if (isToday) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'TODAY',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        DataCell(
          Text(
            breakfast,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF595973),
            ),
          ),
        ),
        DataCell(
          Text(
            lunch,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF595973),
            ),
          ),
        ),
        DataCell(
          Text(
            dinner,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF595973),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryWatch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.box,
                        color: Color(0xFF0EA5E9),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Inventory Watch",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        Text(
                          'Critical & low stock',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'All stock',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
          _buildInventoryItem(
            'Rice (Basmati)',
            '120 kg on hand',
            'min 80 kg',
            LucideIcons.wheat,
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            'Healthy',
            0.8,
            false,
          ),
          _buildInventoryItem(
            'Wheat Flour',
            '45 kg on hand',
            'min 60 kg',
            LucideIcons.wheat,
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            'Low',
            0.4,
            false,
          ),
          _buildInventoryItem(
            'Cooking Oil',
            '28 L on hand',
            'min 20 L',
            LucideIcons.droplet,
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            'Healthy',
            0.6,
            false,
          ),
          _buildInventoryItem(
            'Toor Dal',
            '12 kg on hand',
            'min 25 kg',
            LucideIcons.leaf,
            const Color(0xFFEF4444),
            const Color(0xFFFEE2E2),
            'Critical',
            0.15,
            false,
          ),
          _buildInventoryItem(
            'Onions',
            '38 kg on hand',
            'min 30 kg',
            LucideIcons.leaf,
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            'Healthy',
            0.7,
            false,
          ),
          _buildInventoryItem(
            'LPG Cylinders',
            '2 pcs on hand',
            'min 3 pcs',
            LucideIcons.flame,
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            'Low',
            0.3,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(
    String name,
    String onHand,
    String minStock,
    IconData icon,
    Color color,
    Color bgColor,
    String status,
    double progress,
    bool isLast,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                status,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          onHand,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF595973),
                          ),
                        ),
                        Text(
                          minStock,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
      ],
    );
  }

  Widget _buildVendorsAndPayments() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.briefcase,
                        color: Color(0xFFF59E0B),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vendors & Payments",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        Text(
                          'Suppliers and outstanding dues',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'All vendors',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
          _buildVendorItem(
            'AG',
            'Annapurna Grains',
            'Rice · Flour · Pulses',
            '₹ 48,200',
            '4.6',
            'On-time',
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            false,
          ),
          _buildVendorItem(
            'FF',
            'Fresh Farms Co.',
            'Vegetables · Fruits',
            '₹ 12,750',
            '4.4',
            'Due Today',
            const Color(0xFF0EA5E9),
            const Color(0xFFE0F2FE),
            false,
          ),
          _buildVendorItem(
            'D',
            'DairyPure',
            'Milk · Curd · Paneer',
            '₹ 8,400',
            '4.8',
            'On-time',
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            false,
          ),
          _buildVendorItem(
            'GG',
            'GoldFlame Gas',
            'LPG · Fuel',
            '₹ 6,900',
            '4.1',
            'Overdue',
            const Color(0xFFEF4444),
            const Color(0xFFFEE2E2),
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildVendorItem(
    String initials,
    String name,
    String items,
    String amount,
    String rating,
    String status,
    Color statusColor,
    Color statusBg,
    bool isLast,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF1F5F9),
                radius: 20,
                child: Text(
                  initials,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF181821),
                    fontWeight: FontWeight.w700,
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
                      items,
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
                    amount,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF181821),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.star,
                        size: 12,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF595973),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
      ],
    );
  }

  Widget _buildDinerFeedback() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE9FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.soup,
                        color: Color(0xFF8B5CF6),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Diner Feedback",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        Text(
                          'Latest meal ratings',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  'View all',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
          _buildFeedbackItem(
            'Lunch · Rajma Chawal',
            '"Loved the rajma today, perfectly cooked."',
            'Boys A · 3 reviews',
            '4.5 / 5',
            const Color(0xFF10B981),
            const Color(0xFFD1FAE5),
            false,
          ),
          _buildFeedbackItem(
            'Breakfast · Poha',
            '"Poha was slightly dry, tea was great."',
            'Girls B · 5 reviews',
            '3.8 / 5',
            const Color(0xFFF59E0B),
            const Color(0xFFFEF3C7),
            false,
          ),
          _buildFeedbackItem(
            'Dinner · Pasta',
            '"Less seasoning, served cold."',
            'Boys B · 7 reviews',
            '2.9 / 5',
            const Color(0xFFEF4444),
            const Color(0xFFFEE2E2),
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(
    String title,
    String feedback,
    String details,
    String rating,
    Color color,
    Color bgColor,
    bool isLast,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(LucideIcons.star, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                        Text(
                          rating,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF181821),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      feedback,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF595973),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      details,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
      ],
    );
  }

  Widget _buildSafetyChecks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "KITCHEN & HYGIENE",
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Today's safety checks",
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Quick view of compliance status.",
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF595973),
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildSafetyCard(
                'Kitchen temp',
                '28°C',
                LucideIcons.thermometer,
                const Color(0xFF0EA5E9),
                const Color(0xFFE0F2FE),
                false,
              ),
              _buildSafetyCard(
                'Water test',
                'Passed · 09:10',
                LucideIcons.droplet,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
                true,
              ),
              _buildSafetyCard(
                'Chef hygiene check',
                'All 6 cleared',
                LucideIcons.chefHat,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
                true,
              ),
              _buildSafetyCard(
                'Open complaints',
                '2 active',
                LucideIcons.alertTriangle,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyCard(
    String title,
    String status,
    IconData icon,
    Color iconColor,
    Color iconBg,
    bool isGood,
  ) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF595973),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF181821),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Icon(
            LucideIcons.checkCircle2,
            size: 20,
            color: isGood ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
          ),
        ],
      ),
    );
  }
}
