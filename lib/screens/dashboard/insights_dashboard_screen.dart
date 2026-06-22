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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6366F1),
          unselectedItemColor: const Color(0xFF9CA3AF),
          selectedLabelStyle: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w500),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(LucideIcons.trendingUp),
              ),
              label: 'Admissions',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(LucideIcons.creditCard),
              ),
              label: 'Financial',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(LucideIcons.monitor),
              ),
              label: 'Teachers',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(LucideIcons.bedDouble),
              ),
              label: 'Hostel',
            ),
          ],
        ),
      ),
    );
  }
}
