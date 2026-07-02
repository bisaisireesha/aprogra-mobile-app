import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../admissions/admissions_insights_screen.dart';
import '../accounts/accounts_screen.dart';
import '../teachers/teachers_screen.dart';
import '../hostel/hostel_screen.dart';

class InsightsDashboardScreen extends StatefulWidget {
  final int initialIndex;

  const InsightsDashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<InsightsDashboardScreen> createState() => _InsightsDashboardScreenState();
}

class _InsightsDashboardScreenState extends State<InsightsDashboardScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    AdmissionsInsightsScreen(),
    FinancialSummaryScreen(),
    TeacherInsightsScreen(),
    HostelInsightsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
    );
  }
}
