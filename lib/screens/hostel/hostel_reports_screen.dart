import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';

class HostelReportsScreen extends StatelessWidget {
  const HostelReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Reports'),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.utensils), label: 'Mess'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.settings), label: 'Settings'),
        ],
        currentIndex: 0, // Since reports can be home/admin
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF94A3B8),
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
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildFilterBar(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildSearchAndCategoryFilters(),
                  const SizedBox(height: 16),
                  _buildReportsList(),
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
          'Reports',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF181821),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Pre-built reports for hostel operations, mess, inventory, and vendors.',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF595973),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(LucideIcons.calendar, size: 16, color: const Color(0xFF94A3B8)),
            ),
            _buildFilterButton('Week', false),
            _buildFilterButton('Month', true),
            _buildFilterButton('Term', false),
            _buildFilterButton('Year', false),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? Colors.white : const Color(0xFF595973),
        ),
      ),
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
        _buildStatCard('3', 'Hostel reports', LucideIcons.bedDouble, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
        _buildStatCard('2', 'Mess reports', LucideIcons.utensils, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
        _buildStatCard('2', 'Inventory reports', LucideIcons.package, const Color(0xFF10B981), const Color(0xFFD1FAE5)),
        _buildStatCard('1', 'Vendors reports', LucideIcons.briefcase, const Color(0xFF8B5CF6), const Color(0xFFEDE9FE)),
        _buildStatCard('1', 'Maintenance reports', LucideIcons.wrench, const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
      ],
    );
  }

  Widget _buildStatCard(String title, String subtitle, IconData icon, Color iconColor, Color iconBgColor) {
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

  Widget _buildSearchAndCategoryFilters() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.search, color: Color(0xFF94A3B8), size: 18),
              const SizedBox(width: 12),
              Text(
                'Search reports',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryFilter('All', '9', true),
              const SizedBox(width: 8),
              _buildCategoryFilter('Hostel', '3', false),
              const SizedBox(width: 8),
              _buildCategoryFilter('Mess', '2', false),
              const SizedBox(width: 8),
              _buildCategoryFilter('Inventory', '2', false),
              const SizedBox(width: 8),
              _buildCategoryFilter('Vendors', '1', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter(String name, String count, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6366F1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? const Color(0xFF6366F1) : Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? Colors.white : const Color(0xFF595973),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            count,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              color: isActive ? Colors.white : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsList() {
    return Column(
      children: [
        _buildReportCard(
          'Block Occupancy Summary', 'Capacity, occupied beds, and occupancy rate p...', 
          LucideIcons.fileText, const Color(0xFF595973), const Color(0xFFF1F5F9),
          'Hostel', const Color(0xFF0EA5E9), const Color(0xFFE0F2FE),
          'PDF', const Color(0xFFEF4444), const Color(0xFFFEE2E2),
          '6', 'Today, 09:12'
        ),
        _buildReportCard(
          'Room Allocation Register', 'Full list of students with their assigned room and...', 
          LucideIcons.fileText, const Color(0xFF595973), const Color(0xFFF1F5F9),
          'Hostel', const Color(0xFF0EA5E9), const Color(0xFFE0F2FE),
          'Excel', const Color(0xFF10B981), const Color(0xFFD1FAE5),
          '1,284', 'Today, 08:30'
        ),
        _buildReportCard(
          'Hostel Attendance Sheet', 'Day-wise check-in/out roll call across all blocks.', 
          LucideIcons.fileText, const Color(0xFF595973), const Color(0xFFF1F5F9),
          'Hostel', const Color(0xFF0EA5E9), const Color(0xFFE0F2FE),
          'PDF', const Color(0xFFEF4444), const Color(0xFFFEE2E2),
          '1,280', 'Yesterday'
        ),
        _buildReportCard(
          'Mess Attendance Report', 'Meal-wise headcount for breakfast, lunch, snack...', 
          LucideIcons.utensils, const Color(0xFFF59E0B), const Color(0xFFFEF3C7),
          'Mess', const Color(0xFFF59E0B), const Color(0xFFFEF3C7),
          'Excel', const Color(0xFF10B981), const Color(0xFFD1FAE5),
          '28', 'Yesterday'
        ),
        _buildReportCard(
          'Weekly Mess Menu', 'Approved 7-day menu with meal timings.', 
          LucideIcons.utensils, const Color(0xFFF59E0B), const Color(0xFFFEF3C7),
          'Mess', const Color(0xFFF59E0B), const Color(0xFFFEF3C7),
          'PDF', const Color(0xFFEF4444), const Color(0xFFFEE2E2),
          '28', '2 days ago'
        ),
      ],
    );
  }

  Widget _buildReportCard(
    String title, String subtitle, 
    IconData icon, Color iconColor, Color iconBg,
    String category, Color catColor, Color catBg,
    String format, Color formatColor, Color formatBg,
    String records, String date
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF595973),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: catBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: catColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: formatBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        format,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: formatColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    records,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF181821),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF595973),
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
