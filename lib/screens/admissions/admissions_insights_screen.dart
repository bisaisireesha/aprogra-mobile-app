import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

import '../../widgets/common_app_bar.dart';
import '../../screens/auth/menu_screen.dart';

const _bgColor = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);
const _trendsAccent = Color(0xFF6366F1);

class AdmissionsInsightsScreen extends StatefulWidget {
  const AdmissionsInsightsScreen({super.key});

  @override
  State<AdmissionsInsightsScreen> createState() => _AdmissionsInsightsScreenState();
}

class _AdmissionsInsightsScreenState extends State<AdmissionsInsightsScreen> {
  String _selectedPeriod = 'Yearly';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Admissions Insights'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: CommonAppBar(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildKPIs(isTablet),
                        const SizedBox(height: 48),
                        
                        // Funnel Section
                        _buildSectionTitle('Admission Funnel', 'Where leads convert and drop off', actionText: 'Export >'),
                        const SizedBox(height: 32),
                        _buildFunnelList(),
                        const SizedBox(height: 48),

                        // Trends Section
                        _buildSectionTitle('Enrollment Trends', 'Current vs previous academic year'),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF0F0F0)),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildSegmentedControl(),
                              const SizedBox(height: 24),
                              _buildLegend(),
                              const SizedBox(height: 32),
                              SizedBox(height: 250, child: _buildChart()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildQuickSummary(),
                        const SizedBox(height: 48),

                        // Grades Section
                        _buildSectionTitle('Grade-Level Admission Insights', 'Seat capacity and fill rate', actionText: 'View all grades >'),
                        const SizedBox(height: 32),
                        _buildGradesList(),
                        const SizedBox(height: 48),

                        // Sources Section
                        _buildSectionTitle('Admission Source Analysis', 'Lead origin and channel conversion'),
                        const SizedBox(height: 32),
                        _buildSourcesList(),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Header ---
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Admissions Insights',
          style: GoogleFonts.figtree(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textDark,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Monitor enrollment performance and conversion trends',
          style: GoogleFonts.figtree(
            fontSize: 14,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  // --- Shared Section Title ---
  Widget _buildSectionTitle(String title, String subtitle, {String? actionText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.figtree(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.figtree(
                  fontSize: 13,
                  color: _textMuted,
                ),
              ),
            ],
          ),
        ),
        if (actionText != null)
          Text(
            actionText,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _trendsAccent,
            ),
          ),
      ],
    );
  }

  // --- KPIs Section ---
  Widget _buildKPIs(bool isTablet) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 200,
      ),
      children: [
        _buildKPICard(
          title: 'TOTAL ENQUIRIES',
          value: '486',
          trend: '+16.3%',
          isPositive: true,
          iconBg: const Color(0xFFF4F1FD),
          iconColor: _accent,
          icon: LucideIcons.phoneCall,
          sparklineColor: _accent,
          data: [1, 2, 2.5, 3, 3.5, 4, 4.2],
          leftBottomText: '486 this month',
          rightBottomText: '418 last month',
        ),
        _buildKPICard(
          title: 'ADMISSIONS CONFIRMED',
          value: '118',
          trend: '+25.5%',
          isPositive: true,
          iconBg: const Color(0xFFE8FDF3),
          iconColor: const Color(0xFF10B981),
          icon: LucideIcons.checkCircle2,
          sparklineColor: const Color(0xFF10B981),
          data: [1, 1.2, 1.8, 2.5, 2.8, 3.5, 4],
          leftBottomText: '118 this month',
          rightBottomText: '94 last month',
        ),
        _buildKPICard(
          title: 'CONVERSION RATE',
          value: '24.3%',
          trend: '-3.7 pp',
          isPositive: false,
          iconBg: const Color(0xFFFFF7ED),
          iconColor: const Color(0xFFF59E0B),
          icon: LucideIcons.activity,
          sparklineColor: const Color(0xFFF59E0B),
          data: [4, 3.8, 3.5, 3.6, 3.2, 3.0, 3.1],
          leftBottomText: 'Current 24.3%',
          rightBottomText: 'Target 28%',
        ),
        _buildKPICard(
          title: 'PROJECTED ADMISSIONS',
          value: '521',
          trend: '+4.2% vs target',
          isPositive: true,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF3B82F6),
          icon: LucideIcons.target,
          sparklineColor: const Color(0xFF3B82F6),
          data: [2, 2.2, 2.5, 2.4, 2.8, 3.0, 3.5],
          leftBottomText: 'Year-end forecast',
          rightBottomText: 'Confidence 92%',
        ),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required Color sparklineColor,
    required List<double> data,
    required String leftBottomText,
    required String rightBottomText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
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
          // Top row: Icon, Title, ... Menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

            ],
          ),
          const SizedBox(height: 16),
          // Value
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _textDark,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          // Trend and Sparkline row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    isPositive ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
                    size: 14,
                    color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: CustomPaint(
                    painter: _SparklinePainter(data: data, color: sparklineColor),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Divider and down data
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    leftBottomText,
                    style: GoogleFonts.figtree(
                      fontSize: 11,
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    rightBottomText,
                    style: GoogleFonts.figtree(
                      fontSize: 11,
                      color: _textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Trends Section ---
  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(child: _buildSegmentButton('Monthly')),
          Expanded(child: _buildSegmentButton('Quarterly')),
          Expanded(child: _buildSegmentButton('Yearly')),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String label) {
    final isActive = _selectedPeriod == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _trendsAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: _trendsAccent, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text('Current Year', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          ],
        ),
        const SizedBox(width: 24),
        Row(
          children: [
            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFD1D5DB), shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text('Previous Year', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          ],
        ),
      ],
    );
  }

  Widget _buildChart() {
    List<FlSpot> currentData;
    List<FlSpot> previousData;
    double maxX;
    double maxY;
    double intervalX;
    Widget Function(double, TitleMeta) getBottomTitles;
    
    if (_selectedPeriod == 'Monthly') {
      currentData = const [
        FlSpot(0, 42), FlSpot(1, 55), FlSpot(2, 68), FlSpot(3, 48),
        FlSpot(4, 40), FlSpot(5, 50), FlSpot(6, 52), FlSpot(7, 56),
        FlSpot(8, 70), FlSpot(9, 65), FlSpot(10, 80), FlSpot(11, 85),
      ];
      previousData = const [
        FlSpot(0, 35), FlSpot(1, 45), FlSpot(2, 55), FlSpot(3, 40),
        FlSpot(4, 38), FlSpot(5, 48), FlSpot(6, 50), FlSpot(7, 52),
        FlSpot(8, 60), FlSpot(9, 58), FlSpot(10, 75), FlSpot(11, 78),
      ];
      maxX = 11;
      maxY = 100;
      intervalX = 2;
      getBottomTitles = (value, meta) {
        const style = TextStyle(color: _textMuted, fontSize: 12);
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final index = value.toInt();
        if (index >= 0 && index < months.length) {
          return SideTitleWidget(meta: meta, child: Text(months[index], style: style));
        }
        return const SizedBox.shrink();
      };
    } else if (_selectedPeriod == 'Quarterly') {
      currentData = const [
        FlSpot(0, 165), FlSpot(1, 148), FlSpot(2, 178), FlSpot(3, 230),
      ];
      previousData = const [
        FlSpot(0, 135), FlSpot(1, 126), FlSpot(2, 162), FlSpot(3, 213),
      ];
      maxX = 3;
      maxY = 300;
      intervalX = 1;
      getBottomTitles = (value, meta) {
        const style = TextStyle(color: _textMuted, fontSize: 12);
        final index = value.toInt();
        if (index >= 0 && index < 4) {
          return SideTitleWidget(meta: meta, child: Text('Q${index + 1}', style: style));
        }
        return const SizedBox.shrink();
      };
    } else {
      // Yearly
      currentData = const [
        FlSpot(0, 480), FlSpot(1, 520), FlSpot(2, 590), FlSpot(3, 640), FlSpot(4, 721),
      ];
      previousData = const [
        FlSpot(0, 450), FlSpot(1, 500), FlSpot(2, 560), FlSpot(3, 610), FlSpot(4, 636),
      ];
      maxX = 4;
      maxY = 800;
      intervalX = 1;
      getBottomTitles = (value, meta) {
        const style = TextStyle(color: _textMuted, fontSize: 12);
        final index = value.toInt();
        final years = ['2021', '2022', '2023', '2024', '2025'];
        if (index >= 0 && index < years.length) {
          return SideTitleWidget(meta: meta, child: Text(years[index], style: style));
        }
        return const SizedBox.shrink();
      };
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xFFF3F4F6),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: intervalX,
              getTitlesWidget: getBottomTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(), style: const TextStyle(color: _textMuted, fontSize: 12));
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: maxX,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: previousData,
            isCurved: true,
            color: const Color(0xFFD1D5DB),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD1D5DB).withValues(alpha: 0.2),
                  const Color(0xFFD1D5DB).withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          LineChartBarData(
            spots: currentData,
            isCurved: true,
            color: _trendsAccent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  _trendsAccent.withValues(alpha: 0.2),
                  _trendsAccent.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                String xLabel = '';
                if (_selectedPeriod == 'Monthly') {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                  final index = spot.x.toInt();
                  if (index >= 0 && index < months.length) xLabel = months[index];
                } else if (_selectedPeriod == 'Quarterly') {
                  xLabel = 'Q${spot.x.toInt() + 1}';
                } else {
                  const years = ['2021', '2022', '2023', '2024', '2025'];
                  final index = spot.x.toInt();
                  if (index >= 0 && index < years.length) xLabel = years[index];
                }

                final isCurrent = spot.barIndex == 1;
                final prefix = isCurrent ? 'current : ' : 'previous : ';
                final color = isCurrent ? _trendsAccent : const Color(0xFF9CA3AF);

                if (spot == touchedSpots.first) {
                  return LineTooltipItem(
                    '$xLabel\n',
                    GoogleFonts.figtree(
                      color: _textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: '$prefix${spot.y.toInt()}',
                        style: GoogleFonts.figtree(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    textAlign: TextAlign.left,
                  );
                } else {
                  return LineTooltipItem(
                    '$prefix${spot.y.toInt()}',
                    GoogleFonts.figtree(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.left,
                  );
                }
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(LucideIcons.barChart2, size: 16, color: _trendsAccent),
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Summary',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'This Year (YTD)',
            style: GoogleFonts.figtree(
              fontSize: 12,
              color: _textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Enrollments', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('436', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.arrowUpRight, size: 14, color: Color(0xFF10B981)),
                        Text('12.4%', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Avg. Monthly', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('36.3', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.arrowDownRight, size: 14, color: Color(0xFFEF4444)),
                        Text('3.1%', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Sources Section ---
  Widget _buildSourcesList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _buildSourceItem(LucideIcons.globe, 'Website', 412, 118, 0.29, const Color(0xFF6366F1)),
          const SizedBox(height: 24),
          _buildSourceItem(LucideIcons.users, 'Referral', 258, 95, 0.36, const Color(0xFF10B981)),
          const SizedBox(height: 24),
          _buildSourceItem(Icons.camera_alt, 'Instagram', 324, 64, 0.20, const Color(0xFFEF4444)),
          const SizedBox(height: 24),
          _buildSourceItem(LucideIcons.search, 'Google Ads', 286, 58, 0.20, const Color(0xFF3B82F6)),
          const SizedBox(height: 24),
          _buildSourceItem(LucideIcons.userPlus, 'Existing Parents', 142, 72, 0.51, const Color(0xFF10B981)),
          const SizedBox(height: 24),
          _buildSourceItem(Icons.facebook, 'Facebook', 198, 32, 0.16, const Color(0xFF3B82F6)),
          const SizedBox(height: 24),
          _buildSourceItem(LucideIcons.footprints, 'Walk-In', 124, 41, 0.33, const Color(0xFF10B981)),
          const SizedBox(height: 24),
          _buildSourceItem(LucideIcons.megaphone, 'Offline Campaign', 86, 18, 0.21, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _buildSourceItem(IconData icon, String label, int total, int converted, double progress, Color color) {
    final percent = (progress * 100).toInt();
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(3))),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(width: 30, child: Text(total.toString(), style: GoogleFonts.figtree(fontSize: 13, color: _textMuted), textAlign: TextAlign.right)),
        const SizedBox(width: 12),
        SizedBox(width: 30, child: Text(converted.toString(), style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark), textAlign: TextAlign.right)),
        const SizedBox(width: 12),
        SizedBox(width: 36, child: Text('$percent%', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.right)),
      ],
    );
  }

  // --- Grades Section ---
  Widget _buildGradesList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _buildGradeItem('Nursery', 97, 58, 60, 2),
          const Divider(height: 32, color: Color(0xFFF3F4F6)),
          _buildGradeItem('LKG', 95, 76, 80, 4),
          const Divider(height: 32, color: Color(0xFFF3F4F6)),
          _buildGradeItem('UKG', 89, 71, 80, 9),
          const Divider(height: 32, color: Color(0xFFF3F4F6)),
          _buildGradeItem('Grade 1', 93, 84, 90, 6),
          const Divider(height: 32, color: Color(0xFFF3F4F6)),
          _buildGradeItem('Grade 2', 69, 62, 90, 28),
          const Divider(height: 32, color: Color(0xFFF3F4F6)),
          _buildGradeItem('Grade 3', 98, 88, 90, 2),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String grade, int percent, int filled, int capacity, int remaining) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(grade, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
            Text('$percent%', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$filled / $capacity filled', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            Text('$remaining remaining', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(height: 8, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(4))),
            FractionallySizedBox(
              widthFactor: percent / 100.0,
              child: Container(height: 8, decoration: BoxDecoration(color: _trendsAccent, borderRadius: BorderRadius.circular(4))),
            ),
          ],
        ),
      ],
    );
  }

  // --- Funnel Section ---
  Widget _buildFunnelList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _buildFunnelStage(
            icon: LucideIcons.search,
            color: const Color(0xFF8463E9),
            stage: 'STAGE 1',
            title: 'Enquiries',
            value: '1,840',
            percentStr: 'Conv 100%',
            percent: 1.0,
            dropStr: '-',
            badgePercent: '100%',
            isLast: false,
          ),
          _buildFunnelStage(
            icon: LucideIcons.phone,
            color: const Color(0xFF3B82F6),
            stage: 'STAGE 2',
            title: 'Follow-Ups Completed',
            value: '1,412',
            percentStr: 'Conv 77%',
            percent: 0.77,
            dropStr: 'Drop 23%',
            badgePercent: '77%',
            isLast: false,
          ),
          _buildFunnelStage(
            icon: LucideIcons.send,
            color: const Color(0xFF14B8A6),
            stage: 'STAGE 3',
            title: 'Applications Submitted',
            value: '968',
            percentStr: 'Conv 53%',
            percent: 0.53,
            dropStr: 'Drop 31%',
            badgePercent: '53%',
            isLast: false,
          ),
          _buildFunnelStage(
            icon: LucideIcons.fileText,
            color: const Color(0xFFF59E0B),
            stage: 'STAGE 4',
            title: 'Documents Verified',
            value: '658',
            percentStr: 'Conv 36%',
            percent: 0.36,
            dropStr: 'Drop 32%',
            badgePercent: '36%',
            isLast: false,
          ),
          _buildFunnelStage(
            icon: LucideIcons.check,
            color: const Color(0xFF22C55E),
            stage: 'STAGE 5',
            title: 'Admissions Confirmed',
            value: '372',
            percentStr: 'Conv 20%',
            percent: 0.20,
            dropStr: 'Drop 43%',
            badgePercent: '20%',
            isLast: true,
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 24),
          _buildFunnelStage(
            icon: LucideIcons.x,
            color: const Color(0xFFEF4444),
            stage: 'OUTCOME',
            title: 'Rejected',
            value: '286',
            percentStr: 'Share 16%',
            percent: 0.16,
            dropStr: 'Not admitted',
            badgePercent: '16%',
            isLast: true,
            isSeparateCard: false,
          ),
        ],
      ),
    );
  }

  Widget _buildFunnelStage({
    required IconData icon,
    required Color color,
    required String stage,
    required String title,
    required String value,
    required String percentStr,
    required double percent,
    required String dropStr,
    required String badgePercent,
    required bool isLast,
    bool isSeparateCard = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Column
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
                if (!isLast && !isSeparateCard)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFF3F4F6),
                    ),
                  ),
              ],
            ),
          ),
          // Right Column
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(stage, style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(badgePercent, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(title, style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(value, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      if (!isSeparateCard)
                        Positioned(
                          left: -20,
                          child: Container(
                            width: 36,
                            height: 2,
                            color: const Color(0xFFF3F4F6),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Stack(
                          children: [
                            Container(height: 6, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(3))),
                            FractionallySizedBox(
                              widthFactor: percent,
                              child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(percentStr, style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFFA5A5B4))),
                        Text(dropStr, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: dropStr == '-' ? const Color(0xFFA5A5B4) : color)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Sparkline Painter ---
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final paint = Paint()..color = color..strokeWidth = 2.0..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final fillPaint = Paint()..color = color.withValues(alpha: 0.1)..style = PaintingStyle.fill;
    final minData = data.reduce(math.min);
    final maxData = data.reduce(math.max);
    final range = maxData - minData == 0 ? 1 : maxData - minData;
    final path = Path();
    final fillPath = Path();
    final xStep = size.width / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - (((data[i] - minData) / range) * size.height);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prevX = (i - 1) * xStep;
        final prevY = size.height - (((data[i - 1] - minData) / range) * size.height);
        final controlX = (prevX + x) / 2;
        path.cubicTo(controlX, prevY, controlX, y, x, y);
        fillPath.cubicTo(controlX, prevY, controlX, y, x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
