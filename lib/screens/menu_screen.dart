import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import 'dashboard_screen.dart';
import 'action_center_screen.dart';
import 'activity_feed_screen.dart';
import 'coming_soon_screen.dart';
import 'login_screen.dart';

class MenuScreen extends StatelessWidget {
  final String activeScreen;

  const MenuScreen({super.key, required this.activeScreen});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background, 
      width: 1.sw, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Row(
          children: [
            _buildSideRail(context),
            Expanded(child: _buildRightPane(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSideRail(BuildContext context) {
    return Container(
      width: 72.w,
      margin: EdgeInsets.only(left: 10.w, right: 4.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(4.w, 0),
          )
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Top logo
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Container(
                width: 14.w, 
                height: 14.w,
                decoration: const BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h), // Reduced gap to align graduationCap with "Main Dashboard" list
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildRailIcon(context, LucideIcons.layoutGrid, activeScreen == 'Main Dashboard' || activeScreen == 'Action Center' || activeScreen == 'Activity Feed', const DashboardScreen()),
                  _buildRailIcon(context, LucideIcons.graduationCap, activeScreen == 'Academics' || activeScreen == 'Student Insights', const ComingSoonScreen(title: 'Academics')),
                  _buildRailIcon(context, LucideIcons.users, activeScreen == 'Staff' || activeScreen == 'Teacher Insights' || activeScreen == 'Non Teaching Staff', const ComingSoonScreen(title: 'Staff')),
                  _buildRailIcon(context, LucideIcons.creditCard, activeScreen == 'Financial Summary', const ComingSoonScreen(title: 'Financial Summary')),
                  _buildRailIcon(context, LucideIcons.calendar, activeScreen == 'Calendar', const ComingSoonScreen(title: 'Calendar')),
                  _buildRailIcon(context, LucideIcons.messageSquare, activeScreen == 'Messages', const ComingSoonScreen(title: 'Messages'), hasBadge: true),
                  _buildRailIcon(context, LucideIcons.home, activeScreen == 'Home' || activeScreen == 'Admissions Insights', const ComingSoonScreen(title: 'Home')),
                  _buildRailIcon(context, LucideIcons.bus, activeScreen == 'Transport', const ComingSoonScreen(title: 'Transport')),
                ],
              ),
            ),
          ),
          _buildRailIcon(context, LucideIcons.bell, activeScreen == 'Notifications', const ComingSoonScreen(title: 'Notifications')),
          SizedBox(height: 16.h),
          CircleAvatar(
            radius: 24.r, 
            backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150&h=150'),
            backgroundColor: AppColors.purpleLight,
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildRailIcon(BuildContext context, IconData icon, bool isActive, Widget? screen, {bool hasBadge = false}) {
    return GestureDetector(
      onTap: () {
        if (screen != null && !isActive) {
          _navigateTo(context, screen);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        width: 36.w,
        height: 36.w,
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF7F61EA), // solid purple active bg
                borderRadius: BorderRadius.circular(12.r),
              )
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : AppColors.iconDefault,
              size: 20.w,
            ),
            if (hasBadge)
              Positioned(
                right: 4.w,
                top: 4.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8505B), // notification badge red
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5.w),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPane(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, 
      ),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Header - stays at top, does not scroll
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text(
              'Dashboard',
              style: GoogleFonts.figtree(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF171A21),
                letterSpacing: -0.75,
                height: 1.2, // 36px line-height / 30px = 1.2
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 6.h),
            child: Text(
              'Platform overview & analytics',
              style: GoogleFonts.figtree(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Scrollable Menu List
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('OVERVIEW', topPadding: 20.h),
                  _buildMenuItem(context, 'Main Dashboard', LucideIcons.layoutDashboard, const DashboardScreen()),
                  _buildMenuItem(context, 'Action Center', LucideIcons.activity, const ActionCenterScreen()),
                  _buildMenuItem(context, 'Activity Feed', LucideIcons.fileText, const ActivityFeedScreen()),
                  _buildSectionTitle('ACADEMICS', topPadding: 20.h),
                  _buildMenuItem(context, 'Student Insights', LucideIcons.pieChart, const ComingSoonScreen(title: 'Student Insights')),
                  _buildSectionTitle('BUSINESS', topPadding: 20.h),
                  _buildMenuItem(context, 'Admissions Insights', LucideIcons.trendingUp, const ComingSoonScreen(title: 'Admissions Insights')),
                  _buildMenuItem(context, 'Financial Summary', LucideIcons.creditCard, const ComingSoonScreen(title: 'Financial Summary')),
                  _buildSectionTitle('OPERATIONS', topPadding: 20.h),
                  _buildMenuItem(context, 'Teacher Insights', LucideIcons.briefcase, const ComingSoonScreen(title: 'Teacher Insights')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {double? topPadding}) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 10.h, top: topPadding ?? 16.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFA5ADBA),
          letterSpacing: 0.88,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget screen) {
    final isActive = activeScreen == title || (activeScreen == 'Main Dashboard' && title == 'Main Dashboard');
    return GestureDetector(
      onTap: () => _navigateTo(context, screen),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h), 
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h), // Taller active card: 60-64px height
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFFF4F1FD), // #F4F1FD lighter active bg
                borderRadius: BorderRadius.circular(20.r), // Match pill shape in reference image
              )
            : null,
        child: Row(
          children: [
            if (isActive)
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.transparent, 
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 18.w,
                  color: const Color(0xFF7F61EA), // #7F61EA — active icon
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  icon,
                  size: 18.w, // Size: 18px
                  color: AppColors.iconDefault,
                ),
              ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.figtree(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700, // bold for all menu items
                  color: isActive
                      ? const Color(0xFF7F61EA) // #7F61EA — active/selected purple
                      : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isActive)
              Icon(LucideIcons.chevronRight, color: const Color(0xFF7F61EA), size: 18.w),
          ],
        ),
      ),
    );
  }
}
