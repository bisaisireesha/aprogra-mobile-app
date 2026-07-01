import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';

class TransportReportsScreen extends StatefulWidget {
  const TransportReportsScreen({super.key});

  @override
  State<TransportReportsScreen> createState() => _TransportReportsScreenState();
}

class _TransportReportsScreenState extends State<TransportReportsScreen> {
  String _selectedPeriod = 'This Year';

  final List<String> _periods = ['This Week', 'This Month', 'This Term', 'This Year'];

  void _showActionSnackbar(String action, String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action for $reportName coming soon...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: const MenuScreen(activeScreen: 'Transport Reports'),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSummaryCards(),
                    const SizedBox(height: 32),
                    _buildSectionHeader('FLEET'),
                    const SizedBox(height: 16),
                    _buildReportCards(
                      [
                        _ReportData('Fleet Inventory', 'All vehicles with registration, capacity, type and assigned route.', LucideIcons.bus, const Color(0xFF6366F1), ['PDF', 'Excel']),
                        _ReportData('Vehicle Utilization', 'Per-bus distance, trips and idle time over the selected period.', LucideIcons.share2, const Color(0xFF0EA5E9), ['PDF', 'Excel', 'CSV']),
                        _ReportData('Fuel Consumption', 'Litres consumed, average mileage and cost trends per vehicle.', LucideIcons.fuel, const Color(0xFFF59E0B), ['PDF', 'Excel']),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('OPERATIONS'),
                    const SizedBox(height: 16),
                    _buildReportCards(
                      [
                        _ReportData('Route Performance', 'On-time %, delay reasons and average ETA accuracy per route.', LucideIcons.share2, const Color(0xFF0EA5E9), ['PDF', 'Excel']),
                        _ReportData('Student Boarding', 'Daily headcount by route, stop and time slot.', LucideIcons.users, const Color(0xFF10B981), ['PDF', 'Excel', 'CSV']),
                        _ReportData('Driver Duty Log', 'Trips driven, hours logged and leave taken per driver.', LucideIcons.shieldCheck, const Color(0xFF6366F1), ['PDF', 'Excel']),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('SERVICE & SAFETY'),
                    const SizedBox(height: 16),
                    _buildReportCards(
                      [
                        _ReportData('Maintenance Spend', 'Workshop expenses by vehicle, type and mechanic.', LucideIcons.wrench, const Color(0xFFF59E0B), ['PDF', 'Excel']),
                        _ReportData('Incident & Safety Log', 'Reported incidents, near-misses and corrective actions taken.', LucideIcons.shieldAlert, const Color(0xFFEF4444), ['PDF']),
                        _ReportData('Insurance & Compliance', 'Insurance, PUC, fitness and permit expiry tracking.', LucideIcons.fileText, const Color(0xFF0EA5E9), ['PDF', 'Excel']),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.bus),
            label: 'Transport',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.user),
            label: 'Profile',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF94A3B8),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuScreen(activeScreen: 'Home')));
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: isWide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transport Reports',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pre-built reports for fleet, operations, service and compliance.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
            if (!isWide) const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _periods.map((period) {
                  bool isSelected = _selectedPeriod == period;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = period),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        period,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF595973),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          children: [
            Expanded(flex: isWide ? 1 : 0, child: _buildSummaryCard('Fleet', '3 reports available', LucideIcons.bus, const Color(0xFF6366F1), isWide)),
            if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),
            Expanded(flex: isWide ? 1 : 0, child: _buildSummaryCard('Operations', '3 reports available', LucideIcons.share2, const Color(0xFF0EA5E9), isWide)),
            if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),
            Expanded(flex: isWide ? 1 : 0, child: _buildSummaryCard('Service & Safety', '3 reports available', LucideIcons.wrench, const Color(0xFFF59E0B), isWide)),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String subtitle, IconData icon, Color color, bool isWide) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$subtitle · ${_selectedPeriod.toLowerCase()}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFF181821)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: const Color(0xFF94A3B8),
      ),
    );
  }

  Widget _buildReportCards(List<_ReportData> reports) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reports.map((report) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: report == reports.last ? 0 : 16),
                  child: _buildSingleReportCard(report, isWide),
                ),
              );
            }).toList(),
          );
        } else {
          return Column(
            children: reports.map((report) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildSingleReportCard(report, isWide),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildSingleReportCard(_ReportData report, bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
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
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: report.iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(report.icon, color: report.iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF181821),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.description,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          height: 1.4,
                          color: const Color(0xFF595973),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isWide) const Icon(LucideIcons.chevronRight, size: 20, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: report.formats.map((format) {
                    Color formatColor;
                    IconData formatIcon;
                    if (format == 'PDF') {
                      formatColor = const Color(0xFFEF4444);
                      formatIcon = LucideIcons.fileText;
                    } else if (format == 'Excel') {
                      formatColor = const Color(0xFF10B981);
                      formatIcon = LucideIcons.fileSpreadsheet;
                    } else {
                      formatColor = const Color(0xFF0EA5E9);
                      formatIcon = LucideIcons.fileCode2;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _showActionSnackbar('Downloading $format', report.title),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: formatColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(formatIcon, size: 12, color: formatColor),
                              const SizedBox(width: 4),
                              Text(
                                format,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: formatColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                InkWell(
                  onTap: () => _showActionSnackbar('Generating report', report.title),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.download, size: 14, color: Color(0xFF6366F1)),
                        const SizedBox(width: 4),
                        Text(
                          'Generate',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportData {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<String> formats;

  _ReportData(this.title, this.description, this.icon, this.iconColor, this.formats);
}
