import 'package:flutter/material.dart';

import '../screens/admissions/admissions_insights_screen.dart';
import '../screens/academics/certificate_center_screen.dart';
import '../screens/academics/grade_scales_screen.dart';
import '../screens/academics/marks_entry_screen.dart';
import '../screens/assignments/assignments_screen.dart';
import '../screens/attendance/staff_attendance_screen.dart';
import '../screens/attendance/staff_documents_screen.dart';
import '../screens/attendance/staff_leaves_screen.dart';
import '../screens/attendance/staff_payroll_screen.dart';
import '../screens/attendance/staff_reports_screen.dart';
import '../screens/attendance/staff_workload_screen.dart';
import '../screens/attendance/student_attendance_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/cctv/cctv_screen.dart';
import '../screens/classes/classes_screen.dart';
import '../screens/coming_soon_screen.dart';
import '../screens/dashboard/action_center_screen.dart';
import '../screens/dashboard/activity_feed_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/daycare/daycare_insights_screen.dart';
import '../screens/departments/departments_screen.dart';
import '../screens/exams/exams_screen.dart';
import '../screens/fees/collect_fee_screen.dart';
import '../screens/fees/defaulters_list_screen.dart';
import '../screens/fees/discounts_scholarships_screen.dart';
import '../screens/fees/due_payments_screen.dart';
import '../screens/fees/fee_structure_screen.dart';
import '../screens/fees/fees_dashboard_screen.dart';
import '../screens/fees/invoices_screen.dart';
import '../screens/fees/payment_reminders_screen.dart';
import '../screens/fees/payments_receipts_screen.dart';
import '../screens/fees/receipts_list_screen.dart';
import '../screens/fees/reports_screen.dart';
import '../screens/fees/schemes_list_screen.dart';
import '../screens/financial_summary_screen.dart';
import '../screens/homework/homework_screen.dart';
import '../screens/hostel/hostel_attendance_screen.dart';
import '../screens/hostel/hostel_blocks_screen.dart';
import '../screens/hostel/hostel_dashboard_screen.dart';
import '../screens/hostel/hostel_inventory_screen.dart';
import '../screens/hostel/hostel_reports_screen.dart';
import '../screens/hostel/hostel_screen.dart';
import '../screens/hostel/hostel_vendors_screen.dart';
import '../screens/hostel/hostel_wardens_screen.dart';
import '../screens/hostel/mess_dashboard_screen.dart';
import '../screens/hostel/mess_menu_screen.dart';
import '../screens/hostel/room_allocations_screen.dart';
import '../screens/inventory/inventory_insights_screen.dart';
import '../screens/learning_resources_screen.dart';
import '../screens/library/library_insights_screen.dart';
import '../screens/messages/messages_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/non_teaching/non_teaching_staff_screen.dart';
import '../screens/non_teaching/staff_insights_screen.dart';
import '../screens/non_teaching/staff_management_screen.dart';
import '../screens/non_teaching/teaching_staff_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/support/support_screen.dart';
import '../screens/reports/report_cards_screen.dart';
import '../screens/students/students_list_screen.dart';
import '../screens/students/students_screen.dart';
import '../screens/subjects/subjects_screen.dart';
import '../screens/teachers/teachers_list_screen.dart';
import '../screens/teachers/teachers_screen.dart';
import '../screens/timetables/timetables_screen.dart';
import '../screens/transport/drivers_screen.dart';
import '../screens/transport/live_tracking_screen.dart';
import '../screens/transport/maintenance_screen.dart';
import '../screens/transport/routes_screen.dart';
import '../screens/transport/student_allocation_screen.dart';
import '../screens/transport/transport_dashboard_screen.dart';
import '../screens/transport/transport_reports_screen.dart';
import '../screens/transport/transport_screen.dart';
import '../screens/transport/vehicles_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const dashboard = '/';
  static const actionCenter = '/action-center';
  static const activityFeed = '/activity-feed';
  static const studentInsights = '/student-insights';
  static const admissionsInsights = '/admissions-insights';
  static const financialSummary = '/financial-summary';
  static const teacherInsights = '/teacher-insights';
  static const staffInsights = '/staff-insights';
  static const transportInsights = '/transport-insights';
  static const hostelInsights = '/hostel-insights';
  static const daycareInsights = '/daycare-insights';
  static const cctvCameras = '/cctv-cameras';
  static const libraryInsights = '/library-insights';
  static const inventoryInsights = '/inventory-insights';
  static const settings = '/settings';
  static const support = '/support';
  static const notifications = '/notifications';

  static const academics = '/academics';
  static const classes = '/academics/classes';
  static const subjects = '/academics/subjects';
  static const students = '/academics/students';
  static const admitStudent = '/academics/students?action=create';
  static const timetables = '/academics/timetables';
  static const teachers = '/academics/teachers';
  static const homework = '/academics/homework';
  static const assignments = '/academics/assignments';
  static const studentAttendance = '/academics/student-attendance';
  static const staffAttendance = '/academics/staff-attendance';
  static const exams = '/academics/exams';
  static const gradeScales = '/academics/grade-scales';
  static const marksEntry = '/academics/marks-entry';
  static const reportCards = '/academics/report-cards';
  static const learningResources = '/academics/learning-resources';
  static const transferCertificates = '/academics/transfer-certificates';
  static const bonafideCertificates = '/academics/bonafide-certificates';
  static const customCertificates = '/academics/custom-certificates';
  static const attendanceInsights = '/attendance-insights';

  static const staff = '/staff';
  static const staffTeaching = '/staff/teaching';
  static const staffNonTeaching = '/staff/non-teaching';
  static const staffDepartments = '/staff/departments';
  static const staffAttendanceRoute = '/staff/attendance';
  static const staffLeaves = '/staff/leaves';
  static const staffWorkload = '/staff/workload';
  static const staffPayroll = '/staff/payroll';
  static const staffDocuments = '/staff/documents';
  static const staffReports = '/staff/reports';

  static const fees = '/fees';
  static const collectFee = '/fees/collect';
  static const invoices = '/fees/invoices';
  static const feeStructure = '/fees/structure';
  static const feeDues = '/fees/dues';
  static const feePayments = '/fees/payments';
  static const feeDiscounts = '/fees/discounts';
  static const feeReminders = '/fees/reminders';
  static const feeReports = '/fees/reports';
  static const feeDefaulters = '/fees/defaulters';
  static const feeSchemes = '/fees/schemes';
  static const feeReceipts = '/fees/receipts';

  static const events = '/events';
  static const eventCategories = '/events/categories';
  static const ptmSlots = '/events/ptm-slots';

  static const messages = '/messages';

  static const hostelMess = '/hostel-mess';
  static const hostelBlocks = '/hostel-mess/blocks';
  static const hostelAllocations = '/hostel-mess/allocations';
  static const hostelWardens = '/hostel-mess/wardens';
  static const hostelAttendance = '/hostel-mess/attendance';
  static const messDashboard = '/hostel-mess/mess';
  static const messMenu = '/hostel-mess/menu';
  static const hostelInventory = '/hostel-mess/inventory';
  static const hostelVendors = '/hostel-mess/vendors';
  static const hostelReports = '/hostel-mess/reports';

  static const transport = '/transport';
  static const transportRoutes = '/transport/routes';
  static const transportVehicles = '/transport/vehicles';
  static const transportDrivers = '/transport/drivers';
  static const transportStudents = '/transport/students';
  static const transportTracking = '/transport/tracking';
  static const transportMaintenance = '/transport/maintenance';
  static const transportReports = '/transport/reports';

  static String comingSoonFor(String feature) {
    return '/coming-soon?feature=${Uri.encodeQueryComponent(feature)}';
  }

  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String routeName,
  ) {
    return Navigator.of(context).pushNamed<T>(routeName);
  }

  static Future<T?> replace<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    TO? result,
  }) {
    return Navigator.of(
      context,
    ).pushReplacementNamed<T, TO>(routeName, result: result);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? dashboard;
    final uri = Uri.parse(name);
    final screen = _screenFor(uri);

    return MaterialPageRoute(
      settings: RouteSettings(name: name, arguments: settings.arguments),
      builder: (_) => screen,
    );
  }

  static Widget _screenFor(Uri uri) {
    final path = uri.path.isEmpty ? dashboard : uri.path;

    switch (path) {
      case login:
        return const LoginScreen();
      case home:
      case dashboard:
      case '/dashboard':
        return const DashboardScreen();
      case actionCenter:
        return const ActionCenterScreen();
      case activityFeed:
        return const ActivityFeedScreen();
      case studentInsights:
        return const StudentInsightsScreen();
      case admissionsInsights:
        return const AdmissionsInsightsScreen();
      case financialSummary:
        return const FinancialSummaryScreen();
      case teacherInsights:
        return const TeacherInsightsScreen();
      case staffInsights:
        return const StaffInsightsScreen();
      case transportInsights:
        return const TransportInsightsScreen();
      case hostelInsights:
        return const HostelInsightsScreen();
      case daycareInsights:
        return const DaycareInsightsScreen();
      case cctvCameras:
        return const CCTVScreen();
      case libraryInsights:
        return const LibraryInsightsScreen();
      case inventoryInsights:
        return const InventoryInsightsScreen();
      case settings:
        return const SettingsScreen();
      case support:
        return const SupportScreen();
      case notifications:
        return const NotificationsScreen();

      case academics:
      case classes:
        return const ClassesScreen();
      case subjects:
        return const SubjectsScreen();
      case students:
        return StudentsScreen(
          openCreateOnStart:
              uri.queryParameters['action'] == 'create' ||
              uri.queryParameters['action'] == 'add',
        );
      case timetables:
        return const TimetablesScreen();
      case teachers:
        return const TeachersListScreen();
      case homework:
        return const HomeworkScreen();
      case assignments:
        return const AssignmentsScreen();
      case studentAttendance:
      case attendanceInsights:
        return const StudentAttendanceScreen();
      case staffAttendance:
      case '/academics/teacher-attendance':
        return const StaffAttendanceScreen();
      case exams:
        return const ExamsScreen();
      case gradeScales:
        return const GradeScalesScreen();
      case marksEntry:
        return const MarksEntryScreen();
      case reportCards:
        return const ReportCardsScreen();
      case learningResources:
        return const LearningResourcesScreen();
      case transferCertificates:
        return const CertificateCenterScreen(
          title: 'Transfer Certificates',
          activeScreen: 'Transfer Certificates',
          description:
              'Prepare transfer requests, approvals, and issued certificates.',
        );
      case bonafideCertificates:
        return const CertificateCenterScreen(
          title: 'Bonafide Certificates',
          activeScreen: 'Bonafide Certificates',
          description:
              'Issue bonafide certificates with request tracking and approval.',
        );
      case customCertificates:
        return const CertificateCenterScreen(
          title: 'Custom Certificates',
          activeScreen: 'Custom Certificates',
          description:
              'Manage custom certificate templates, drafts, and issued copies.',
        );

      case staff:
        return const StaffManagementScreen();
      case staffTeaching:
        return const TeachingStaffScreen();
      case staffNonTeaching:
        return const NonTeachingStaffScreen();
      case staffDepartments:
        return const DepartmentsScreen();
      case staffAttendanceRoute:
        return const StaffAttendanceScreen();
      case staffLeaves:
        return const StaffLeavesScreen();
      case staffWorkload:
        return const StaffWorkloadScreen();
      case staffPayroll:
        return const StaffPayrollScreen();
      case staffDocuments:
        return const StaffDocumentsScreen();
      case staffReports:
        return const StaffReportsScreen();

      case fees:
        return const FeesDashboardScreen();
      case collectFee:
        return const CollectFeeScreen();
      case invoices:
        return const InvoicesScreen();
      case feeStructure:
        return const FeeStructureScreen();
      case feeDues:
        return const DuePaymentsScreen();
      case feePayments:
        return const PaymentsReceiptsScreen();
      case feeDiscounts:
        return const DiscountsScholarshipsScreen();
      case feeReminders:
        return const PaymentRemindersScreen();
      case feeReports:
        return const ReportsScreen();
      case feeDefaulters:
        return const DefaultersListScreen();
      case feeSchemes:
        return const SchemesListScreen();
      case feeReceipts:
        return const ReceiptsListScreen();

      case events:
        return SchoolCalendarScreen(initialTab: _eventTabFromQuery(uri));
      case eventCategories:
        return const SchoolCalendarScreen(initialTab: 1);
      case ptmSlots:
        return const SchoolCalendarScreen(initialTab: 2);

      case messages:
        return const MessagesScreen();

      case hostelMess:
        return const HostelDashboardScreen();
      case hostelBlocks:
        return const HostelBlocksScreen();
      case hostelAllocations:
        return const RoomAllocationsScreen();
      case hostelWardens:
        return const HostelWardensScreen();
      case hostelAttendance:
        return const HostelAttendanceScreen();
      case messDashboard:
        return const MessDashboardScreen();
      case messMenu:
        return const MessMenuScreen();
      case hostelInventory:
        return const HostelInventoryScreen();
      case hostelVendors:
        return const HostelVendorsScreen();
      case hostelReports:
        return const HostelReportsScreen();

      case transport:
        return const TransportDashboardScreen();
      case transportRoutes:
        return const RoutesScreen();
      case transportVehicles:
        return const VehiclesScreen();
      case transportDrivers:
        return const DriversScreen();
      case transportStudents:
        return const StudentAllocationScreen();
      case transportTracking:
        return const LiveTrackingScreen();
      case transportMaintenance:
        return const MaintenanceScreen();
      case transportReports:
        return const TransportReportsScreen();

      case '/coming-soon':
        final title = uri.queryParameters['feature'] ?? 'Feature';
        return _feature(title, activeScreen: title);
      default:
        return _feature(_titleFromPath(path), activeScreen: '');
    }
  }

  static int _eventTabFromQuery(Uri uri) {
    final view = uri.queryParameters['view'];
    if (view == 'categories') return 1;
    if (view == 'ptm' || view == 'ptm-slots') return 2;
    return 0;
  }

  static ComingSoonScreen _feature(
    String title, {
    required String activeScreen,
  }) {
    return ComingSoonScreen(title: title, activeScreen: activeScreen);
  }

  static String _titleFromPath(String path) {
    final parts = path.split('/').where((part) => part.isNotEmpty).toList();
    final last = parts.isEmpty ? 'Feature' : parts.last;
    return last
        .split('-')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
