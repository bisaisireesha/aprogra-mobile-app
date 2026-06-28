import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide SizeExtension;

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../dashboard/dashboard_screen.dart';
import '../transport/transport_screen.dart';
import '../settings/settings_screen.dart';
import '../dashboard/action_center_screen.dart';
import '../dashboard/activity_feed_screen.dart';
import '../coming_soon_screen.dart';
import '../students/students_list_screen.dart';
import '../students/students_screen.dart';
import '../dashboard/insights_dashboard_screen.dart';
import '../non_teaching/staff_insights_screen.dart';
import '../non_teaching/teaching_staff_screen.dart';
import '../non_teaching/non_teaching_staff_screen.dart';
import '../departments/departments_screen.dart';
import '../cctv/cctv_screen.dart';
import '../library/library_insights_screen.dart';
import '../inventory/inventory_insights_screen.dart';
import '../classes/classes_screen.dart';
import '../subjects/subjects_screen.dart';
import '../timetables/timetables_screen.dart';
import '../teachers/teachers_list_screen.dart';
import '../homework/homework_screen.dart';
import '../assignments/assignments_screen.dart';
import '../attendance/student_attendance_screen.dart';
import '../attendance/staff_attendance_screen.dart';
import '../exams/exams_screen.dart';
import '../learning_resources_screen.dart';
import '../non_teaching/staff_management_screen.dart';
import '../fees/fees_dashboard_screen.dart';
import '../fees/collect_fee_screen.dart';
import '../fees/invoices_screen.dart';
import '../fees/fee_structure_screen.dart';
import '../fees/due_payments_screen.dart';
import '../fees/payments_receipts_screen.dart';
import '../fees/payment_reminders_screen.dart';
import '../fees/discounts_scholarships_screen.dart';
import '../fees/fee_reports_screen.dart';
import '../calendar/calendar_screen.dart';

extension _MenuScreenSizeExtension on num {
  double get w => toDouble();
  double get h => toDouble();
  double get r => toDouble();
  double get sp => toDouble();
}

class MenuScreen extends StatefulWidget {
  final String activeScreen;

  const MenuScreen({super.key, required this.activeScreen});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late String _activeGroup;

  @override
  void initState() {
    super.initState();
    if (_isAcademicsGroup(widget.activeScreen)) {
      _activeGroup = 'Academics';
    } else if (_isStaffGroup(widget.activeScreen)) {
      _activeGroup = 'StaffManagement';
    } else if (_isFeesGroup(widget.activeScreen)) {
      _activeGroup = 'Fees';
    } else {
      _activeGroup = 'Overview';
    }
  }

  bool _isStaffGroup(String screen) {
    const staffScreens = [
      'Staff Overview', 'Teaching Staff', 'Non-Teaching Staff', 'Departments',
      'Attendance', 'Leaves', 'Workload', 'Payroll', 'Documents', 'Staff'
    ];
    return staffScreens.contains(screen);
  }

  bool _isAcademicsGroup(String screen) {
    const academicsScreens = [
      'Academics', 'Student Insights', 'Classes', 'Subjects', 'Students',
      'Timetables', 'Teachers', 'Homework', 'Assignments',
      'Student Attendance', 'Teacher Attendance', 'Exams', 'Grade Scales',
      'Marks Entry', 'Report Cards', 'Learning Resources', 'Transfer Certificates',
      'Bonafide Certificates', 'Custom Certificates'
    ];
    return academicsScreens.contains(screen);
  }

  bool _isFeesGroup(String screen) {
    const feesScreens = [
      'Fees & Invoices', 'Collect Fee', 'Invoices', 'Fee Structure',
      'Due Payments', 'Payments & Receipts', 'Payment Reminders',
      'Discounts & Scholarships', 'Fee Reports', 'Fee Reports'
    ];
    return feesScreens.contains(screen);
  }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // [Responsive Fix]: Calculate screen width to constrain drawer on tablets/landscape
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTablet = screenWidth >= 600;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.background, 
      // [Responsive Fix]: Don't take up 100% width on tablets/landscape to prevent stretching
      width: isTablet ? 400 : screenWidth, 
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 72.w,
      margin: EdgeInsets.only(left: 10.w, right: 4.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(4.w, 0),
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // [Responsive Fix]: Ensure rail icons don't overflow on extremely short landscape screens
          return SingleChildScrollView(
            physics: constraints.maxHeight < 500 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
          // Top logo
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF312E81) : AppColors.purpleLight,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Container(
                width: 14.w, 
                height: 14.w,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF818CF8) : AppColors.purple,
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
                  _buildRailIcon(context, LucideIcons.layoutGrid, _activeGroup == 'Overview', () {
                    setState(() { _activeGroup = 'Overview'; });
                  }),
                  _buildRailIcon(context, LucideIcons.graduationCap, _activeGroup == 'Academics', () {
                    setState(() { _activeGroup = 'Academics'; });
                  }),
                  _buildRailIcon(context, LucideIcons.briefcase, _activeGroup == 'StaffManagement', () {
                    setState(() { _activeGroup = 'StaffManagement'; });
                  }),
                  _buildRailIcon(context, LucideIcons.creditCard, _activeGroup == 'Fees' || widget.activeScreen == 'Financial Summary', () {
                    setState(() { _activeGroup = 'Fees'; });
                  }),
                  _buildRailIcon(context, LucideIcons.calendar, widget.activeScreen == 'Calendar', () {
                    _navigateTo(context, const SchoolCalendarScreen());
                  }),
                  _buildRailIcon(context, LucideIcons.messageSquare, widget.activeScreen == 'Messages', () {
                    _navigateTo(context, const ComingSoonScreen(title: 'Messages'));
                  }, hasBadge: true),
                  _buildRailIcon(context, LucideIcons.home, widget.activeScreen == 'Home' || widget.activeScreen == 'Admissions Insights', () {
                    _navigateTo(context, const ComingSoonScreen(title: 'Home'));
                  }),
                  _buildRailIcon(context, LucideIcons.bus, widget.activeScreen == 'Transport', () {
                    _navigateTo(context, const ComingSoonScreen(title: 'Transport'));
                  }),
                ],
              ),
            ),
          ),
          _buildRailIcon(context, LucideIcons.bell, widget.activeScreen == 'Notifications', () {
            _navigateTo(context, const ComingSoonScreen(title: 'Notifications'));
          }),
                    SizedBox(height: 16.h),
                    CircleAvatar(
                      radius: 24.r, 
                      backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150&h=150'),
                      backgroundColor: AppColors.purpleLight,
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildRailIcon(BuildContext context, IconData icon, bool isActive, VoidCallback onTap, {bool hasBadge = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: isActive ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        width: 36.w,
        height: 36.w,
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFF7F61EA), // solid purple active bg
                borderRadius: BorderRadius.circular(14.r),
              )
            : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : (isDark ? const Color(0xFF94A3B8) : AppColors.iconDefault),
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
                    border: Border.all(color: isDark ? const Color(0xFF1E293B) : Colors.white, width: 1.5.w),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPane(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_activeGroup == 'Academics') {
      return _buildAcademicsRightPane(context);
    }
    if (_activeGroup == 'StaffManagement') {
      return _buildStaffManagementRightPane(context);
    }
    if (_activeGroup == 'Fees') {
      return _buildFeesRightPane(context);
    }
    
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
                color: isDark ? Colors.white : const Color(0xFF171A21),
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
                color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
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
                  _buildMenuItem(context, 'Student Insights', LucideIcons.pieChart, const StudentInsightsScreen()),
                  _buildSectionTitle('BUSINESS', topPadding: 20.h),
                  _buildMenuItem(context, 'Admissions Insights', LucideIcons.trendingUp, const InsightsDashboardScreen(initialIndex: 0)),
                  _buildMenuItem(context, 'Financial Summary', LucideIcons.creditCard, const InsightsDashboardScreen(initialIndex: 1)),
                  _buildSectionTitle('OPERATIONS', topPadding: 20.h),
                  _buildMenuItem(context, 'Teacher Insights', LucideIcons.monitor, const InsightsDashboardScreen(initialIndex: 2)),
                  _buildMenuItem(context, 'Non Teaching Staff', LucideIcons.briefcase, const StaffInsightsScreen()),
                  _buildMenuItem(context, 'Transport Insights', LucideIcons.bus, const TransportInsightsScreen()),
                  _buildMenuItem(context, 'Hostel Insights', LucideIcons.bedDouble, const InsightsDashboardScreen(initialIndex: 3)),
                  _buildMenuItem(context, 'Daycare Insights', LucideIcons.baby, const ComingSoonScreen(title: 'Daycare Insights')),
                  _buildMenuItem(context, 'CCTV Cameras', LucideIcons.video, const CCTVScreen()),
                  _buildSectionTitle('SERVICES', topPadding: 20.h),
                  _buildMenuItem(context, 'Library Insights', LucideIcons.bookOpen, const LibraryInsightsScreen()),
                  _buildMenuItem(context, 'Inventory Insights', LucideIcons.package, const InventoryInsightsScreen()),
                  _buildSectionTitle('SYSTEM', topPadding: 20.h),
                  _buildMenuItem(context, 'Settings', LucideIcons.settings, const SettingsScreen()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicsRightPane(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, 
      ),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Header
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text(
              'Academics',
              style: GoogleFonts.figtree(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF171A21),
                letterSpacing: -0.75,
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 6.h),
            child: Text(
              'Manage academic structure and learning',
              style: GoogleFonts.figtree(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
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
                  _buildSectionTitle('ACADEMIC STRUCTURE', topPadding: 20.h),
                  _buildMenuItem(context, 'Classes', LucideIcons.graduationCap, const ClassesScreen()),
                  _buildMenuItem(context, 'Subjects', LucideIcons.bookOpen, const SubjectsScreen()),
                  _buildMenuItem(context, 'Students', LucideIcons.users, const StudentsScreen()),
                  
                  _buildSectionTitle('TEACHING', topPadding: 20.h),
                  _buildMenuItem(context, 'Timetables', LucideIcons.calendar, const TimetablesScreen()),
                  _buildMenuItem(context, 'Teachers', LucideIcons.monitor, const TeachersListScreen()),
                  _buildMenuItem(context, 'Homework', LucideIcons.notebookPen, const HomeworkScreen()),
                  _buildMenuItem(context, 'Assignments', LucideIcons.clipboardList, const AssignmentsScreen()),
                  
                  _buildSectionTitle('ATTENDANCE', topPadding: 20.h),
                  _buildMenuItem(context, 'Student Attendance', LucideIcons.calendarCheck, const StudentAttendanceScreen()),
                  _buildMenuItem(context, 'Teacher Attendance', LucideIcons.userCheck, const StaffAttendanceScreen()),
                  
                  _buildSectionTitle('ASSESSMENTS', topPadding: 20.h),
                  _buildMenuItem(context, 'Exams', LucideIcons.clipboard, const ExamsScreen()),
                  _buildMenuItem(context, 'Grade Scales', LucideIcons.barChart, const ComingSoonScreen(title: 'Grade Scales')),
                  _buildMenuItem(context, 'Marks Entry', LucideIcons.edit, const ComingSoonScreen(title: 'Marks Entry')),
                  _buildMenuItem(context, 'Report Cards', LucideIcons.fileText, const ComingSoonScreen(title: 'Report Cards')),
                  
                  _buildSectionTitle('LEARNING', topPadding: 20.h),
                  _buildMenuItem(context, 'Learning Resources', LucideIcons.book, const LearningResourcesScreen()),
                  
                  _buildSectionTitle('CERTIFICATES', topPadding: 20.h),
                  _buildMenuItem(context, 'Transfer Certificates', LucideIcons.fileMinus, const ComingSoonScreen(title: 'Transfer Certificates')),
                  _buildMenuItem(context, 'Bonafide Certificates', LucideIcons.shieldCheck, const ComingSoonScreen(title: 'Bonafide Certificates')),
                  _buildMenuItem(context, 'Custom Certificates', LucideIcons.award, const ComingSoonScreen(title: 'Custom Certificates')),
                  
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeesRightPane(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text('Fees & Invoices', style: GoogleFonts.figtree(fontSize: 28.sp, fontWeight: FontWeight.w700, color: isDark ? Colors.white : const Color(0xFF171A21), letterSpacing: -0.75, height: 1.2)),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 6.h),
            child: Text('Manage fees, invoices and collections', style: GoogleFonts.figtree(fontSize: 14.sp, fontWeight: FontWeight.w400, color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary)),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('FEES & INVOICES', topPadding: 20.h),
                  _buildMenuItem(context, 'Fees & Invoices', LucideIcons.layoutDashboard, const FeesDashboardScreen()),
                  _buildMenuItem(context, 'Collect Fee', LucideIcons.wallet, const CollectFeeScreen()),
                  _buildMenuItem(context, 'Invoices', LucideIcons.fileText, const InvoicesScreen()),
                  _buildMenuItem(context, 'Fee Structure', LucideIcons.layoutGrid, const FeeStructureScreen()),
                  _buildSectionTitle('COLLECTIONS', topPadding: 20.h),
                  _buildMenuItem(context, 'Due Payments', LucideIcons.clock, const DuePaymentsScreen()),
                  _buildMenuItem(context, 'Payments & Receipts', LucideIcons.receipt, const PaymentsReceiptsScreen()),
                  _buildMenuItem(context, 'Discounts & Scholarships', LucideIcons.gift, const DiscountsScholarshipsScreen()),
                  _buildMenuItem(context, 'Payment Reminders', LucideIcons.bell, const PaymentRemindersScreen()),
                  _buildSectionTitle('INSIGHTS', topPadding: 20.h),
                  _buildMenuItem(context, 'Fee Reports', LucideIcons.barChart, const FeeReportsScreen()),
                  _buildMenuItem(context, 'Financial Summary', LucideIcons.pieChart, const InsightsDashboardScreen(initialIndex: 1)),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffManagementRightPane(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent, 
      ),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Header
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text(
              'Staff',
              style: GoogleFonts.figtree(
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF171A21),
                letterSpacing: -0.75,
                height: 1.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 6.h),
            child: Text(
              'Manage staff and operations',
              style: GoogleFonts.figtree(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
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
                  _buildSectionTitle('STAFF MANAGEMENT', topPadding: 20.h),
                  _buildMenuItem(context, 'Staff Overview', LucideIcons.layoutGrid, const StaffManagementScreen()),
                  _buildMenuItem(context, 'Teaching Staff', LucideIcons.presentation, const TeachingStaffScreen()),
                  _buildMenuItem(context, 'Non-Teaching Staff', LucideIcons.users, const NonTeachingStaffScreen()),
                  _buildMenuItem(context, 'Departments', LucideIcons.layoutDashboard, const DepartmentsScreen()),
                  
                  _buildSectionTitle('OPERATIONS', topPadding: 20.h),
                  _buildMenuItem(context, 'Attendance', LucideIcons.calendarCheck, const ComingSoonScreen(title: 'Attendance')),
                  _buildMenuItem(context, 'Leaves', LucideIcons.calendarOff, const ComingSoonScreen(title: 'Leaves')),
                  _buildMenuItem(context, 'Workload', LucideIcons.clipboardList, const ComingSoonScreen(title: 'Workload')),
                  _buildMenuItem(context, 'Payroll', LucideIcons.wallet, const ComingSoonScreen(title: 'Payroll')),
                  
                  _buildSectionTitle('RECORDS', topPadding: 20.h),
                  _buildMenuItem(context, 'Documents', LucideIcons.fileText, const ComingSoonScreen(title: 'Documents')),
                  
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {double topPadding = 0}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 10.h, top: topPadding > 0 ? topPadding : 16.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? const Color(0xFF64748B) : const Color(0xFFA5ADBA),
          letterSpacing: 0.88,
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget screen) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = widget.activeScreen == title || (widget.activeScreen == 'Main Dashboard' && title == 'Main Dashboard');
    return GestureDetector(
      onTap: () => _navigateTo(context, screen),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h), 
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h), // Taller active card: 60-64px height
        decoration: isActive
            ? BoxDecoration(
                color: isDark ? const Color(0xFF7F61EA).withValues(alpha: 0.15) : const Color(0xFFF4F1FD),
                borderRadius: BorderRadius.circular(100), // Perfect pill shape
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
                  color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7F61EA),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  icon,
                  size: 18.w, // Size: 18px
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.iconDefault,
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
                      ? (isDark ? const Color(0xFFA78BFA) : const Color(0xFF7F61EA))
                      : (isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isActive)
              Icon(LucideIcons.chevronRight, color: isDark ? const Color(0xFFA78BFA) : const Color(0xFF7F61EA), size: 18.w),
          ],
        ),
      ),
    );
  }
}
