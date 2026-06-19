import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'menu_screen.dart';
import 'dart:ui' as ui;

const _bgPrimary = Color(0xFFF9F9FB);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // [Responsive Fix]: Central breakpoint check for grids and paddings
  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        // [Responsive Fix]: Constrain width on ultra-wides to prevent infinite stretching
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              // [Responsive Fix]: Adjust side paddings based on device width
              padding: EdgeInsets.symmetric(horizontal: _isTablet ? 40 : 20, vertical: 16),
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 24),
              _buildGreeting(),
              const SizedBox(height: 24),
              _buildKPIGrid(),
              const SizedBox(height: 24),
              _buildActionRequired(),
              const SizedBox(height: 24),
              _buildAttendanceInsights(),
              const SizedBox(height: 24),
              _buildFinancialInsights(),
              const SizedBox(height: 24),
              _buildUpcomingEvents(),
              const SizedBox(height: 24),
              _buildAIInsights(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      ),
      ),
      drawer: const MenuScreen(activeScreen: 'Main Dashboard'),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(Icons.menu, color: _textDark, size: 28),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFF0F0F0)),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: _textMuted, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('Search anything...', style: TextStyle(color: _textMuted, fontSize: 14), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Stack(
          children: [
            const Icon(Icons.notifications_none, color: _textDark, size: 28),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: _bgPrimary, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFE5DCF3),
          child: Icon(Icons.person, color: _accent, size: 20),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Good morning, Saraswati! 👋',
          style: TextStyle(
            color: _textDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Here\'s how your school is doing today.',
          style: TextStyle(color: _textMuted, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildKPIGrid() {
    return GridView.count(
      // [Responsive Fix]: Show 4 cards on tablets/landscape, 2 on mobile
      crossAxisCount: _isTablet ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 16,
      mainAxisExtent: 140,
      children: [
        _buildKPICard(
          title: 'STUDENTS',
          value: MockData.kpiData['students'] as String,
          trend: MockData.kpiData['studentsTrend'] as String,
          trendUp: true,
          icon: Icons.people_outline,
          progress: MockData.kpiData['studentsProgress'] as double,
          progressColor: _accent,
        ),
        _buildKPICard(
          title: 'STAFF',
          value: MockData.kpiData['staff'] as String,
          trend: MockData.kpiData['staffTrend'] as String,
          trendUp: true,
          icon: Icons.person_outline,
          progress: MockData.kpiData['staffProgress'] as double,
          progressColor: const Color(0xFFE0E0E0),
        ),
        _buildAttendanceKPICard(),
        _buildFeesKPICard(),
      ],
    );
  }

  Widget _buildKPICard({
    required String title,
    required String value,
    required String trend,
    required bool trendUp,
    required IconData icon,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, size: 14, color: _textMuted),
                    const SizedBox(width: 4),
                    Expanded(child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted), overflow: TextOverflow.visible)),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(trendUp ? Icons.call_made : Icons.call_received, size: 12, color: _textDark),
                  const SizedBox(width: 2),
                  Text(trend, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textDark)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: _textDark, height: 1.0)),
          ),
          const SizedBox(height: 16),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F6),
              borderRadius: BorderRadius.circular(3),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceKPICard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: _textMuted),
                    const SizedBox(width: 4),
                    const Expanded(child: Text('ATTENDANCE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted), overflow: TextOverflow.visible)),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.call_made, size: 12, color: _textDark),
                  const SizedBox(width: 2),
                  Text(MockData.kpiData['attendanceTrend'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textDark)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(MockData.kpiData['attendance'] as String, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: _textDark, height: 1.0)),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('vs', style: TextStyle(fontSize: 10, color: _textMuted, fontWeight: FontWeight.bold, height: 1.0)),
                    Text('yesterday', style: TextStyle(fontSize: 10, color: _textMuted, height: 1.0)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeesKPICard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.credit_card, size: 14, color: _textMuted),
                    const SizedBox(width: 4),
                    const Expanded(child: Text('FEES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted), overflow: TextOverflow.visible)),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.call_received, size: 10, color: Colors.red),
                    const SizedBox(width: 2),
                    Text(MockData.kpiData['feesBadge'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(MockData.kpiData['fees'] as String, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: _textDark, height: 1.0)),
          ),
          const SizedBox(height: 16),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRequired() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Action Required',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
            ),
            const Text(
              'View all',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _accent),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // [Responsive Fix]: Expand grid to 4 items per row on tablets/landscape
            crossAxisCount: _isTablet ? 4 : 2,
            mainAxisExtent: 220,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: MockData.actionRequired.length,
          itemBuilder: (context, index) {
            final action = MockData.actionRequired[index];
            final colorType = action['colorType'] as String;
            
            Color bgColor = Colors.white;
            Color badgeBgColor = const Color(0xFFF3F3F6);
            Color badgeTextColor = _textDark;
            
            if (colorType == 'red') {
              bgColor = const Color(0xFFFFF1F1);
              badgeBgColor = Colors.redAccent.withValues(alpha: 0.15);
              badgeTextColor = Colors.redAccent;
            } else if (colorType == 'blue') {
              badgeBgColor = Colors.blueAccent.withValues(alpha: 0.15);
              badgeTextColor = Colors.blueAccent;
            } else if (colorType == 'purple') {
              badgeBgColor = _accent.withValues(alpha: 0.15);
              badgeTextColor = _accent;
            }
            
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: (colorType == 'grey' || colorType == 'purple')
                    ? Border.all(color: const Color(0xFFEBEBEB), width: 1.5)
                    : null,
                boxShadow: bgColor == Colors.white ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(action['icon'] as IconData, size: 20, color: _textMuted),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          action['type'] as String,
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: badgeTextColor, letterSpacing: 0.5),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(action['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(height: 2),
                      Text(action['value'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(height: 2),
                      Text(action['subtitle'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        (action['action'] as String).replaceAll(' →', ''),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _accent),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 14, color: _accent),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // [Responsive Fix]: 8 items on tablet row to save space, 4 on mobile
            crossAxisCount: _isTablet ? 8 : 4,
            mainAxisExtent: 90,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: MockData.quickActions.length,
          itemBuilder: (context, index) {
            final action = MockData.quickActions[index];
            return InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0EDFA),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: _accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    style: const TextStyle(fontSize: 12, color: _textDark, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAIInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDFA),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_graph, color: _accent, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'AI Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...MockData.aiInsights.map((insight) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(insight['icon'] as IconData, size: 16, color: _textMuted),
                    const SizedBox(width: 6),
                    Text(
                      insight['type'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  insight['description'] as String,
                  style: const TextStyle(fontSize: 15, color: _textDark, height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  insight['action'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _accent,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark),
            ),
            GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
              },
              child: Text(
                'Calendar',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _accent.withValues(alpha: 0.8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            children: [
              ...MockData.upcomingEvents.map((event) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 50,
                        child: Column(
                          children: [
                            Text(
                              event['date'] as String,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event['time'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark, height: 1.1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['title'] as String,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(color: _accent, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    event['location'] as String,
                                    style: const TextStyle(fontSize: 14, color: _textMuted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: _textMuted),
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }),
              const Divider(color: Color(0xFFF3F3F6)),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'View all events',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _accent),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Attendance Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 4),
                    Text(MockData.attendanceInsights['subtitle'] as String, style: const TextStyle(fontSize: 14, color: _textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(MockData.attendanceInsights['percentage'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: _textDark, size: 14),
                      const SizedBox(width: 2),
                      Text(MockData.attendanceInsights['trend'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),
          // Chart placeholder
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(MockData.attendanceInsights['chartPoints'] as List<double>),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Tue', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Wed', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Thu', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Fri', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Sat', style: TextStyle(fontSize: 12, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF3F3F6)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOP PERFORMING', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    _buildStatRow('Class 10', '96%', true),
                    const SizedBox(height: 12),
                    _buildStatRow('Class 9', '93%', true),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('BELOW THRESHOLD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                    const SizedBox(height: 12),
                    _buildStatRow('Class 5', '75%', false),
                    const SizedBox(height: 12),
                    _buildStatRow('Class 4', '78%', false),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('View detailed report', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _accent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, bool isGood) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: _textDark)),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isGood ? _textDark : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Financial Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 4),
                    Text(MockData.financialInsights['subtitle'] as String, style: const TextStyle(fontSize: 14, color: _textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(MockData.financialInsights['total'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: _textDark, size: 14),
                      const SizedBox(width: 2),
                      Text(MockData.financialInsights['trend'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarChartPainter(MockData.financialInsights['chartValues'] as List<double>),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('       ', style: TextStyle(fontSize: 12, color: Colors.transparent)), // Empty space for first bar
              Text('Dec', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Jan', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Feb', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Mar', style: TextStyle(fontSize: 12, color: _textMuted)),
              Text('Apr', style: TextStyle(fontSize: 12, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildFinancePill('OUTSTANDING', MockData.financialInsights['outstanding'] as String),
              const SizedBox(width: 8),
              _buildFinancePill('THIS MONTH', MockData.financialInsights['thisMonth'] as String),
              const SizedBox(width: 8),
              _buildFinancePill('RECOVERY', MockData.financialInsights['recovery'] as String),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancePill(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.dashboard_customize_outlined, 'Home'),
              _buildNavItem(1, Icons.school_outlined, 'Academics'),
              _buildNavItem(2, Icons.chat_bubble_outline, 'Messages', badge: '9'),
              _buildNavItem(3, Icons.cases_outlined, 'Operations'),
              _buildNavItem(4, Icons.menu, 'More'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {String? badge}) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isSelected ? _accent : _textMuted,
                size: 24,
              ),
              if (badge != null)
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? _accent : _textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> points;

  _LineChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final width = size.width;
    final height = size.height;
    final dx = width / (points.length - 1);

    final path = Path();
    path.moveTo(0, height - points[0] * height);

    for (int i = 0; i < points.length - 1; i++) {
      final p1x = i * dx;
      final p1y = height - points[i] * height;
      final p2x = (i + 1) * dx;
      final p2y = height - points[i + 1] * height;

      final cx1 = p1x + dx / 2;
      final cy1 = p1y;
      final cx2 = p2x - dx / 2;
      final cy2 = p2y;

      path.cubicTo(cx1, cy1, cx2, cy2, p2x, p2y);
    }

    final paintLine = Paint()
      ..color = const Color(0xFF5C88FF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPath = Path.from(path);
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    final paintFill = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, height),
        [
          const Color(0xFF5C88FF).withValues(alpha: 0.25),
          const Color(0xFF5C88FF).withValues(alpha: 0.0),
        ],
      )
      ..style = PaintingStyle.fill;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF0F0F5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
      
    // Draw 3 horizontal dashed lines
    for (int i = 0; i < 3; i++) {
      final y = height * (i / 2);
      double startX = 0;
      while (startX < width) {
        canvas.drawLine(Offset(startX, y), Offset(startX + 4, y), gridPaint);
        startX += 8;
      }
    }

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BarChartPainter extends CustomPainter {
  final List<double> values;

  _BarChartPainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final width = size.width;
    final height = size.height;
    final barCount = values.length;
    final spacing = width * 0.08;
    final totalSpacing = spacing * (barCount - 1);
    final barWidth = (width - totalSpacing) / barCount;

    final paint = Paint()
      ..color = const Color(0xFF8B84FF)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final barHeight = values[i] * height;
      final x = i * (barWidth + spacing);
      final y = height - barHeight;
      
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
        bottomLeft: const Radius.circular(6),
        bottomRight: const Radius.circular(6),
      );
      
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
