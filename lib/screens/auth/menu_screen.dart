import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide SizeExtension;

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../routes/app_routes.dart';

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
    if (_isOverviewGroup(widget.activeScreen)) {
      _activeGroup = 'Overview';
    } else if (_isAcademicsGroup(widget.activeScreen)) {
      _activeGroup = 'Academics';
    } else if (_isStaffGroup(widget.activeScreen)) {
      _activeGroup = 'StaffManagement';
    } else if (_isFeesGroup(widget.activeScreen)) {
      _activeGroup = 'Fees';
    } else if (_isEventsGroup(widget.activeScreen)) {
      _activeGroup = 'Events';
    } else if (_isHostelGroup(widget.activeScreen)) {
      _activeGroup = 'Hostel';
    } else if (_isTransportGroup(widget.activeScreen)) {
      _activeGroup = 'Transport';
    } else if (widget.activeScreen == 'Messages') {
      _activeGroup = 'Messages';
    } else if (widget.activeScreen == 'Notifications') {
      _activeGroup = 'Notifications';
    } else {
      _activeGroup = 'Overview';
    }
  }

  bool _isTransportGroup(String screen) {
    const transportScreens = [
      'Transport Dashboard',
      'Routes',
      'Vehicles',
      'Drivers',
      'Student Allocation',
      'Live Tracking',
      'Maintenance',
      'Transport Reports',
    ];
    return transportScreens.contains(screen);
  }

  bool _isOverviewGroup(String screen) {
    const overviewScreens = [
      'Main Dashboard',
      'Action Center',
      'Activity Feed',
      'Student Insights',
      'Admissions Insights',
      'Financial Summary',
      'Teacher Insights',
      'Non Teaching Staff',
      'Transport Insights',
      'Hostel Insights',
      'Daycare Insights',
      'CCTV Cameras',
      'Library Insights',
      'Inventory Insights',
      'Settings',
      'Support',
    ];
    return overviewScreens.contains(screen);
  }

  bool _isEventsGroup(String screen) {
    const eventsScreens = ['Calendar', 'Categories', 'PTM Slot Booking'];
    return eventsScreens.contains(screen);
  }

  bool _isHostelGroup(String screen) {
    const hostelScreens = [
      'Hostel Dashboard',
      'Blocks',
      'Room Allocations',
      'Wardens',
      'Hostel Attendance',
      'Mess Dashboard',
      'Mess Menu',
      'Inventory',
      'Vendors',
      'Hostel Reports',
    ];
    return hostelScreens.contains(screen);
  }

  bool _isStaffGroup(String screen) {
    const staffScreens = [
      'Staff Overview',
      'Teaching Staff',
      'Non-Teaching Staff',
      'Departments',
      'Attendance',
      'Leaves',
      'Workload',
      'Payroll',
      'Documents',
      'Staff Reports',
      'Staff',
    ];
    return staffScreens.contains(screen);
  }

  bool _isAcademicsGroup(String screen) {
    const academicsScreens = [
      'Academics',
      'Classes',
      'Subjects',
      'Students',
      'Timetables',
      'Teachers',
      'Homework',
      'Assignments',
      'Student Attendance',
      'Teacher Attendance',
      'Exams',
      'Grade Scales',
      'Marks Entry',
      'Report Cards',
      'Learning Resources',
      'Transfer Certificates',
      'Bonafide Certificates',
      'Custom Certificates',
    ];
    return academicsScreens.contains(screen);
  }

  bool _isFeesGroup(String screen) {
    const feesScreens = [
      'Fees & Invoices',
      'Fee Dashboard',
      'Collect Fee',
      'Invoices',
      'Fee Structure',
      'Due Payments',
      'Payments & Receipts',
      'Fee Defaulters',
      'Receipts',
      'Schemes',
      'Payment Reminders',
      'Discounts & Scholarships',
      'Fee Reports',
    ];
    return feesScreens.contains(screen);
  }

  void _navigateToRoute(BuildContext context, String routeName) {
    Navigator.pop(context); // Close drawer
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == routeName) return;
    AppRoutes.replace(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    const isDark = false;
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
    const isDark = false;
    return Container(
      width: 72.w,
      margin: EdgeInsets.only(left: 10.w, right: 4.w, top: 4.h, bottom: 4.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: Offset(4.w, 0),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // [Responsive Fix]: Ensure rail icons don't overflow on extremely short landscape screens
          return SingleChildScrollView(
            physics: constraints.maxHeight < 500
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
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
                        color: isDark
                            ? const Color(0xFF312E81)
                            : AppColors.purpleLight,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Center(
                        child: Container(
                          width: 14.w,
                          height: 14.w,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF818CF8)
                                : AppColors.purple,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ), // Reduced gap to align graduationCap with "Main Dashboard" list
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildRailIcon(
                              context,
                              LucideIcons.layoutGrid,
                              _activeGroup == 'Overview',
                              () {
                                setState(() {
                                  _activeGroup = 'Overview';
                                });
                              },
                            ),
                            _buildRailIcon(
                              context,
                              LucideIcons.graduationCap,
                              _activeGroup == 'Academics',
                              () {
                                setState(() {
                                  _activeGroup = 'Academics';
                                });
                              },
                            ),
                            _buildRailIcon(
                              context,
                              LucideIcons.briefcase,
                              _activeGroup == 'StaffManagement',
                              () {
                                setState(() {
                                  _activeGroup = 'StaffManagement';
                                });
                              },
                            ),
                            _buildRailIcon(
                              context,
                              LucideIcons.creditCard,
                              _activeGroup == 'Fees' ||
                                  widget.activeScreen == 'Financial Summary',
                              () {
                                setState(() {
                                  _activeGroup = 'Fees';
                                });
                              },
                            ),
                            _buildRailIcon(
                              context,
                              LucideIcons.calendar,
                              _activeGroup == 'Events' ||
                                  widget.activeScreen == 'Calendar' ||
                                  widget.activeScreen == 'PTM Slot Booking',
                              () {
                                setState(() {
                                  _activeGroup = 'Events';
                                });
                              },
                            ),
                            _buildRailIcon(
                              context,
                              LucideIcons.bedDouble,
                              _activeGroup == 'Hostel',
                              () {
                                setState(() {
                                  _activeGroup = 'Hostel';
                                });
                              },
                            ),
                            _buildRailIcon(
                              context,
                              LucideIcons.messageSquare,
                              _activeGroup == 'Messages',
                              () {
                                setState(() {
                                  _activeGroup = 'Messages';
                                });
                                _navigateToRoute(context, AppRoutes.messages);
                              },
                              hasBadge: true,
                            ),

                            _buildRailIcon(
                              context,
                              LucideIcons.bus,
                              _activeGroup == 'Transport',
                              () {
                                setState(() {
                                  _activeGroup = 'Transport';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildRailIcon(
                      context,
                      LucideIcons.bell,
                      _activeGroup == 'Notifications',
                      () {
                        setState(() {
                          _activeGroup = 'Notifications';
                        });
                        _navigateToRoute(context, AppRoutes.notifications);
                      },
                    ),
                    SizedBox(height: 16.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150&h=150',
                        width: 48.r,
                        height: 48.r,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 48.r,
                          height: 48.r,
                          color: AppColors.purpleLight,
                          child: Icon(
                            LucideIcons.user,
                            color: AppColors.purple,
                            size: 20.r,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRailIcon(
    BuildContext context,
    IconData icon,
    bool isActive,
    VoidCallback onTap, {
    bool hasBadge = false,
  }) {
    const isDark = false;
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
              color: isActive
                  ? Colors.white
                  : (isDark ? const Color(0xFF94A3B8) : AppColors.iconDefault),
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
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      width: 1.5.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPane(BuildContext context) {
    const isDark = false;
    if (_activeGroup == 'Academics') {
      return _buildAcademicsRightPane(context);
    }
    if (_activeGroup == 'StaffManagement') {
      return _buildStaffManagementRightPane(context);
    }
    if (_activeGroup == 'Fees') {
      return _buildFeesRightPane(context);
    }
    if (_activeGroup == 'Events') {
      return _buildEventsRightPane(context);
    }
    if (_activeGroup == 'Hostel') {
      return _buildHostelRightPane(context);
    }
    if (_activeGroup == 'Transport') {
      return _buildTransportRightPane(context);
    }

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
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
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.textSecondary,
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
                  _buildMenuItem(
                    context,
                    'Main Dashboard',
                    LucideIcons.layoutDashboard,
                    AppRoutes.dashboard,
                  ),
                  _buildMenuItem(
                    context,
                    'Action Center',
                    LucideIcons.activity,
                    AppRoutes.actionCenter,
                  ),
                  _buildMenuItem(
                    context,
                    'Activity Feed',
                    LucideIcons.fileText,
                    AppRoutes.activityFeed,
                  ),
                  _buildSectionTitle('ACADEMICS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Student Insights',
                    LucideIcons.pieChart,
                    AppRoutes.studentInsights,
                  ),
                  _buildSectionTitle('BUSINESS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Admissions Insights',
                    LucideIcons.trendingUp,
                    AppRoutes.admissionsInsights,
                  ),
                  _buildMenuItem(
                    context,
                    'Financial Summary',
                    LucideIcons.creditCard,
                    AppRoutes.financialSummary,
                  ),
                  _buildSectionTitle('OPERATIONS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Teacher Insights',
                    LucideIcons.monitor,
                    AppRoutes.teacherInsights,
                  ),
                  _buildMenuItem(
                    context,
                    'Non Teaching Staff',
                    LucideIcons.briefcase,
                    AppRoutes.staffInsights,
                  ),
                  _buildMenuItem(
                    context,
                    'Transport Insights',
                    LucideIcons.bus,
                    AppRoutes.transportInsights,
                  ),
                  _buildMenuItem(
                    context,
                    'Hostel Insights',
                    LucideIcons.bedDouble,
                    AppRoutes.hostelInsights,
                  ),
                  _buildMenuItem(
                    context,
                    'Daycare Insights',
                    LucideIcons.baby,
                    AppRoutes.daycareInsights,
                  ),
                  _buildMenuItem(
                    context,
                    'CCTV Cameras',
                    LucideIcons.video,
                    AppRoutes.cctvCameras,
                  ),
                  _buildSectionTitle('SERVICES', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Library Insights',
                    LucideIcons.bookOpen,
                    AppRoutes.libraryInsights,
                  ),
                  _buildMenuItem(
                    context,
                    'Inventory Insights',
                    LucideIcons.package,
                    AppRoutes.inventoryInsights,
                  ),
                  _buildSectionTitle('SYSTEM', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Settings',
                    LucideIcons.settings,
                    AppRoutes.settings,
                  ),
                  _buildMenuItem(
                    context,
                    'Support',
                    LucideIcons.messageSquare,
                    AppRoutes.support,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicsRightPane(BuildContext context) {
    const isDark = false;
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
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
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.textSecondary,
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
                  _buildMenuItem(
                    context,
                    'Classes',
                    LucideIcons.graduationCap,
                    AppRoutes.classes,
                  ),
                  _buildMenuItem(
                    context,
                    'Subjects',
                    LucideIcons.bookOpen,
                    AppRoutes.subjects,
                  ),
                  _buildMenuItem(
                    context,
                    'Students',
                    LucideIcons.users,
                    AppRoutes.students,
                  ),

                  _buildSectionTitle('TEACHING', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Timetables',
                    LucideIcons.calendar,
                    AppRoutes.timetables,
                  ),
                  _buildMenuItem(
                    context,
                    'Teachers',
                    LucideIcons.monitor,
                    AppRoutes.teachers,
                  ),
                  _buildMenuItem(
                    context,
                    'Homework',
                    LucideIcons.notebookPen,
                    AppRoutes.homework,
                  ),
                  _buildMenuItem(
                    context,
                    'Assignments',
                    LucideIcons.clipboardList,
                    AppRoutes.assignments,
                  ),
                  _buildSectionTitle('ATTENDANCE', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Student Attendance',
                    LucideIcons.calendarCheck,
                    AppRoutes.studentAttendance,
                  ),
                  _buildMenuItem(
                    context,
                    'Staff Attendance',
                    LucideIcons.userCheck,
                    AppRoutes.staffAttendance,
                  ),

                  _buildSectionTitle('ASSESSMENTS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Exams',
                    LucideIcons.clipboard,
                    AppRoutes.exams,
                  ),
                  _buildMenuItem(
                    context,
                    'Grade Scales',
                    LucideIcons.barChart,
                    AppRoutes.gradeScales,
                  ),
                  _buildMenuItem(
                    context,
                    'Marks Entry',
                    LucideIcons.edit,
                    AppRoutes.marksEntry,
                  ),
                  _buildMenuItem(
                    context,
                    'Report Cards',
                    LucideIcons.fileText,
                    AppRoutes.reportCards,
                  ),

                  _buildSectionTitle('LEARNING', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Learning Resources',
                    LucideIcons.book,
                    AppRoutes.learningResources,
                  ),

                  _buildSectionTitle('CERTIFICATES', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Transfer Certificates',
                    LucideIcons.fileMinus,
                    AppRoutes.transferCertificates,
                  ),
                  _buildMenuItem(
                    context,
                    'Bonafide Certificates',
                    LucideIcons.shieldCheck,
                    AppRoutes.bonafideCertificates,
                  ),
                  _buildMenuItem(
                    context,
                    'Custom Certificates',
                    LucideIcons.award,
                    AppRoutes.customCertificates,
                  ),

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
    const isDark = false;
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text(
              'Fees',
              style: GoogleFonts.figtree(
                fontSize: 28.sp,
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
              'Manage fees, invoices and collections',
              style: GoogleFonts.figtree(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  _buildMenuItem(
                    context,
                    'Fee Dashboard',
                    LucideIcons.layoutDashboard,
                    AppRoutes.fees,
                  ),
                  _buildMenuItem(
                    context,
                    'Collect Fee',
                    LucideIcons.wallet,
                    AppRoutes.collectFee,
                  ),
                  _buildMenuItem(
                    context,
                    'Invoices',
                    LucideIcons.fileText,
                    AppRoutes.invoices,
                  ),
                  _buildMenuItem(
                    context,
                    'Fee Structure',
                    LucideIcons.layoutGrid,
                    AppRoutes.feeStructure,
                  ),
                  _buildSectionTitle('COLLECTIONS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Due Payments',
                    LucideIcons.alertCircle,
                    AppRoutes.feeDues,
                  ),
                  _buildMenuItem(
                    context,
                    'Fee Defaulters',
                    LucideIcons.alertCircle,
                    AppRoutes.feeDefaulters,
                  ),
                  _buildMenuItem(
                    context,
                    'Payments & Receipts',
                    LucideIcons.receiptText,
                    AppRoutes.feePayments,
                  ),
                  _buildMenuItem(
                    context,
                    'Receipts',
                    LucideIcons.receiptText,
                    AppRoutes.feeReceipts,
                  ),
                  _buildMenuItem(
                    context,
                    'Discounts & Scholarships',
                    LucideIcons.award,
                    AppRoutes.feeDiscounts,
                  ),
                  _buildMenuItem(
                    context,
                    'Schemes',
                    LucideIcons.award,
                    AppRoutes.feeSchemes,
                  ),
                  _buildMenuItem(
                    context,
                    'Payment Reminders',
                    LucideIcons.messageSquare,
                    AppRoutes.feeReminders,
                  ),
                  _buildSectionTitle('INSIGHTS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Fee Reports',
                    LucideIcons.barChart2,
                    AppRoutes.feeReports,
                  ),
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
    const isDark = false;
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
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
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.textSecondary,
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
                  _buildMenuItem(
                    context,
                    'Staff Overview',
                    LucideIcons.layoutGrid,
                    AppRoutes.staff,
                  ),
                  _buildMenuItem(
                    context,
                    'Teaching Staff',
                    LucideIcons.presentation,
                    AppRoutes.staffTeaching,
                  ),
                  _buildMenuItem(
                    context,
                    'Non-Teaching Staff',
                    LucideIcons.users,
                    AppRoutes.staffNonTeaching,
                  ),
                  _buildMenuItem(
                    context,
                    'Departments',
                    LucideIcons.layoutDashboard,
                    AppRoutes.staffDepartments,
                  ),

                  _buildSectionTitle('OPERATIONS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Attendance',
                    LucideIcons.calendarCheck,
                    AppRoutes.staffAttendanceRoute,
                  ),
                  _buildMenuItem(
                    context,
                    'Leaves',
                    LucideIcons.calendarOff,
                    AppRoutes.staffLeaves,
                  ),
                  _buildMenuItem(
                    context,
                    'Workload',
                    LucideIcons.clipboardList,
                    AppRoutes.staffWorkload,
                  ),
                  _buildMenuItem(
                    context,
                    'Payroll',
                    LucideIcons.wallet,
                    AppRoutes.staffPayroll,
                  ),

                  _buildSectionTitle('RECORDS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Documents',
                    LucideIcons.fileText,
                    AppRoutes.staffDocuments,
                  ),
                  _buildMenuItem(
                    context,
                    'Staff Reports',
                    LucideIcons.barChart2,
                    AppRoutes.staffReports,
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsRightPane(BuildContext context) {
    const isDark = false;
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text(
              'Events & Calendar',
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
              'Manage school events and schedules',
              style: GoogleFonts.figtree(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('EVENTS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Calendar',
                    LucideIcons.calendar,
                    AppRoutes.events,
                  ),
                  _buildMenuItem(
                    context,
                    'Categories',
                    LucideIcons.layoutGrid,
                    AppRoutes.eventCategories,
                  ),
                  _buildMenuItem(
                    context,
                    'PTM Slot Booking',
                    LucideIcons.userCheck,
                    AppRoutes.ptmSlots,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostelRightPane(BuildContext context) {
    const isDark = false;
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text(
              'Hostel',
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
              'Manage hostels, rooms, and mess',
              style: GoogleFonts.figtree(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('HOSTEL', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Hostel Dashboard',
                    LucideIcons.layoutGrid,
                    AppRoutes.hostelMess,
                  ),
                  _buildMenuItem(
                    context,
                    'Blocks',
                    LucideIcons.layoutGrid,
                    AppRoutes.hostelBlocks,
                  ),
                  _buildMenuItem(
                    context,
                    'Room Allocations',
                    LucideIcons.users,
                    AppRoutes.hostelAllocations,
                  ),
                  _buildMenuItem(
                    context,
                    'Wardens',
                    LucideIcons.user,
                    AppRoutes.hostelWardens,
                  ),
                  _buildMenuItem(
                    context,
                    'Hostel Attendance',
                    LucideIcons.calendarCheck,
                    AppRoutes.hostelAttendance,
                  ),
                  _buildSectionTitle('MESS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Mess Dashboard',
                    LucideIcons.layoutGrid,
                    AppRoutes.messDashboard,
                  ),
                  _buildMenuItem(
                    context,
                    'Mess Menu',
                    LucideIcons.bookOpen,
                    AppRoutes.messMenu,
                  ),
                  _buildMenuItem(
                    context,
                    'Inventory',
                    LucideIcons.package,
                    AppRoutes.hostelInventory,
                  ),
                  _buildMenuItem(
                    context,
                    'Vendors',
                    LucideIcons.briefcase,
                    AppRoutes.hostelVendors,
                  ),
                  _buildSectionTitle('INSIGHTS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Hostel Reports',
                    LucideIcons.barChart2,
                    AppRoutes.hostelReports,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportRightPane(BuildContext context) {
    const isDark = false;
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      padding: EdgeInsets.only(left: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w, right: 16.w, bottom: 2.h),
            child: Text(
              'Transport',
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
              'Manage fleet, routes, and student allocation',
              style: GoogleFonts.figtree(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(right: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('TRANSPORT', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Transport Dashboard',
                    LucideIcons.layoutDashboard,
                    AppRoutes.transport,
                  ),
                  _buildMenuItem(
                    context,
                    'Routes',
                    LucideIcons.layoutGrid,
                    AppRoutes.transportRoutes,
                  ),
                  _buildMenuItem(
                    context,
                    'Vehicles',
                    LucideIcons.bus,
                    AppRoutes.transportVehicles,
                  ),
                  _buildMenuItem(
                    context,
                    'Drivers',
                    LucideIcons.user,
                    AppRoutes.transportDrivers,
                  ),
                  _buildSectionTitle('OPERATIONS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Student Allocation',
                    LucideIcons.users,
                    AppRoutes.transportStudents,
                  ),
                  _buildMenuItem(
                    context,
                    'Live Tracking',
                    LucideIcons.activity,
                    AppRoutes.transportTracking,
                  ),
                  _buildMenuItem(
                    context,
                    'Maintenance',
                    LucideIcons.package,
                    AppRoutes.transportMaintenance,
                  ),
                  _buildSectionTitle('INSIGHTS', topPadding: 20.h),
                  _buildMenuItem(
                    context,
                    'Transport Reports',
                    LucideIcons.barChart2,
                    AppRoutes.transportReports,
                  ),
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
    const isDark = false;
    return Padding(
      padding: EdgeInsets.only(
        left: 8.w,
        bottom: 10.h,
        top: topPadding > 0 ? topPadding : 16.h,
      ),
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

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    String routeName,
  ) {
    const isDark = false;
    final isActive =
        widget.activeScreen == title ||
        (widget.activeScreen == 'Main Dashboard' && title == 'Main Dashboard');
    return GestureDetector(
      onTap: () => _navigateToRoute(context, routeName),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 18.h,
        ), // Taller active card: 60-64px height
        decoration: isActive
            ? BoxDecoration(
                color: isDark
                    ? const Color(0xFF7F61EA).withValues(alpha: 0.15)
                    : const Color(0xFFF4F1FD),
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
                  color: isDark
                      ? const Color(0xFFA78BFA)
                      : const Color(0xFF7F61EA),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Icon(
                  icon,
                  size: 18.w, // Size: 18px
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : AppColors.iconDefault,
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
                      ? (isDark
                            ? const Color(0xFFA78BFA)
                            : const Color(0xFF7F61EA))
                      : (isDark
                            ? const Color(0xFF94A3B8)
                            : AppColors.textSecondary),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isActive)
              Icon(
                LucideIcons.chevronRight,
                color: isDark
                    ? const Color(0xFFA78BFA)
                    : const Color(0xFF7F61EA),
                size: 18.w,
              ),
          ],
        ),
      ),
    );
  }
}
