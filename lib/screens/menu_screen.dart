import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dashboard_screen.dart';
import 'action_center_screen.dart';
import 'activity_feed_screen.dart';
import 'coming_soon_screen.dart';
import 'login_screen.dart';

const _textDark     = Color(0xFF181821);
const _textMuted    = Color(0xFF4A4A5A);
const _textVeryMuted = Color(0xFFA1A1AA);
const _textLightGray = Color(0xFF9CA3AF); // Menu item text color
const _newAccent    = Color(0xFF6D4AFF); // Updated explicit purple
const _accentLight  = Color(0xFFF3F0FF); // Keeping original for other elements if needed

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
      backgroundColor: const Color(0xFFF9F9FB), 
      width: 1.sw, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      width: 56.w,
      margin: EdgeInsets.only(left: 10.w, right: 4.w, top: 8.h, bottom: 8.h), // Reduced margin
      decoration: BoxDecoration(
        color: Colors.white,
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
          SizedBox(height: 8.h), // Reduced top padding
          // Top logo
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: _newAccent.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Container(
                width: 14.w, 
                height: 14.w,
                decoration: const BoxDecoration(
                  color: _newAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h), // Reduced gap between logo and icons
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
          SizedBox(height: 8.h), // Reduced down padding
          CircleAvatar(
            radius: 16.r, 
            backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150&h=150'),
            backgroundColor: _newAccent.withOpacity(0.08),
          ),
          SizedBox(height: 8.h), // Reduced down padding
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
        margin: EdgeInsets.symmetric(vertical: 2.h), // gap: 2px between items to reduce up/down space
        width: 36.w,
        height: 36.w,
        decoration: isActive
            ? BoxDecoration(
                color: _newAccent.withOpacity(0.08), // subtle purple
                borderRadius: BorderRadius.circular(12.r),
              )
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? _newAccent : _textLightGray, // Color: #9CA3AF
              size: 18.w, // Size: 18px
            ),
            if (hasBadge)
              Positioned(
                right: 4.w,
                top: 4.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8505B),
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
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 0, // Dashboard title starts perfectly from the top
          bottom: 16.h, 
          left: 0, 
          right: 16.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
              child: Text(
                'Dashboard',
                style: GoogleFonts.inter(
                  fontSize: 26.sp, 
                  fontWeight: FontWeight.w700, 
                  color: _textDark,
                  letterSpacing: -1.0,
                  height: 1.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w, bottom: 12.h), 
              child: Text(
                'Platform overview & analytics',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: _textLightGray,
                  letterSpacing: -0.14,
                ),
              ),
            ),
            // Menu List
            _buildSectionTitle('OVERVIEW'),
            _buildMenuItem(context, 'Main Dashboard', LucideIcons.layoutDashboard, const DashboardScreen()),
            _buildMenuItem(context, 'Action Center', LucideIcons.activity, const ActionCenterScreen()),
            _buildMenuItem(context, 'Activity Feed', LucideIcons.fileText, const ActivityFeedScreen()),
            _buildSectionTitle('ACADEMICS'),
            _buildMenuItem(context, 'Student Insights', LucideIcons.pieChart, const ComingSoonScreen(title: 'Student Insights')),
            _buildSectionTitle('BUSINESS'),
            _buildMenuItem(context, 'Admissions Insights', LucideIcons.trendingUp, const ComingSoonScreen(title: 'Admissions Insights')),
            _buildMenuItem(context, 'Financial Summary', LucideIcons.creditCard, const ComingSoonScreen(title: 'Financial Summary')),
            _buildSectionTitle('OPERATIONS'),
            _buildMenuItem(context, 'Teacher Insights', LucideIcons.briefcase, const ComingSoonScreen(title: 'Teacher Insights')),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 8.h, top: 20.h), 
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11.sp, 
          fontWeight: FontWeight.w700,
          color: _textLightGray, 
          letterSpacing: 1.2, 
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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h), // Increased padding to match image
        decoration: isActive
            ? BoxDecoration(
                color: _newAccent.withOpacity(0.06), 
                borderRadius: BorderRadius.circular(12.r), 
              )
            : null,
        child: Row(
          children: [
            if (isActive)
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: _newAccent.withOpacity(0.15), 
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  size: 18.w, 
                  color: _newAccent, 
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Icon(
                  icon,
                  size: 20.w, 
                  color: _textLightGray, 
                ),
              ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp, 
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500, 
                  color: isActive ? _newAccent : _textMuted, 
                  letterSpacing: -0.2, 
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isActive)
              Icon(LucideIcons.chevronRight, color: _newAccent.withOpacity(0.5), size: 18.w),
          ],
        ),
      ),
    );
  }
}
