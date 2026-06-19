import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'dashboard_screen.dart';
import 'menu_screen.dart';
import 'action_center_screen.dart';

// --- Design Tokens ---
const _bgColor = Color(0xFFFAF9FF);
const _cardBg = Colors.white;
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF6C5CE7); // Primary Purple
const _darkPurple = Color(0xFF5B4CD8); // Dark Purple
const _lightPurple = Color(0xFF8A7AF0); // Light Purple
const _borderColor = Color(0xFFEBEBEB);

class StudentInsightsScreen extends StatefulWidget {
  const StudentInsightsScreen({super.key});

  @override
  State<StudentInsightsScreen> createState() => _StudentInsightsScreenState();
}

class _StudentInsightsScreenState extends State<StudentInsightsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1; // Academics tab
  String _selectedTab = 'Pre-Primary'; // Track selected tab

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const DashboardScreen();
        break;
      case 1:
        nextScreen = const StudentInsightsScreen();
        break;
      case 2:
        nextScreen = const ActionCenterScreen();
        break;
      default:
        return; // Other tabs not fully implemented in this flow
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bgColor,
      drawer: const MenuScreen(activeScreen: 'Academics'),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Action'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), activeIcon: Icon(Icons.menu), label: 'More'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _accent,
        child: const Icon(Icons.show_chart_rounded, color: Colors.white),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildTopKPIs(isTablet),
                        const SizedBox(height: 24),
                        _buildTabsAndFilters(),
                        const SizedBox(height: 20),
                        _buildClassSectionsGrid(isTablet),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Recent Activity', 'View all'),
                        const SizedBox(height: 16),
                        _buildRecentActivity(),
                        const SizedBox(height: 32),
                        _buildRequiringAttention(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Enrollment Distribution', ''),
                        const SizedBox(height: 16),
                        _buildEnrollmentDistribution(isTablet),
                        const SizedBox(height: 32),
                        _buildSectionTitle('New Admissions', 'View all'),
                        const SizedBox(height: 16),
                        _buildNewAdmissions(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Class Capacity Monitor', ''),
                        const Text('Monitor over and under-filled classes', style: TextStyle(fontSize: 12, color: _textMuted)),
                        const SizedBox(height: 16),
                        _buildClassCapacityMonitor(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Health & Safety Alerts', ''),
                        const SizedBox(height: 16),
                        _buildHealthSafety(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('Today\'s Highlights', ''),
                        const SizedBox(height: 16),
                        _buildTodayHighlights(),
                        const SizedBox(height: 40), // Bottom padding
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Icon(Icons.menu, color: _textDark, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA5A5B4)),
                  prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFFA5A5B4)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              const Icon(Icons.notifications_none_rounded, color: _textMuted, size: 28),
              Positioned(
                right: 2,
                top: 2,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage('assets/images/user1.jpg'), // Generic fallback
            backgroundColor: Color(0xFFE6E6EB),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Student Insights', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.5)),
        SizedBox(height: 4),
        Text('A quick, operational view of students across the school.', style: TextStyle(fontSize: 13, color: _textMuted)),
      ],
    );
  }

  Widget _buildTopKPIs(bool isTablet) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 140, // Fixed height to prevent overflow
      ),
      itemCount: MockData.studentInsightsKpi.length,
      itemBuilder: (context, index) {
        final kpi = MockData.studentInsightsKpi[index];
        final colorType = kpi['colorType'] as String;
        Color iconBg = _accent.withValues(alpha: 0.1);
        Color iconColor = _accent;
        
        if (colorType == 'yellow') {
          iconBg = const Color(0xFFFFF7E6);
          iconColor = const Color(0xFFD97706);
        } else if (colorType == 'blue') {
          iconBg = const Color(0xFFE8F2FF);
          iconColor = const Color(0xFF2563EB);
        } else if (colorType == 'grey') {
          iconBg = const Color(0xFFF4F4F6);
          iconColor = const Color(0xFF595973);
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(kpi['icon'] as IconData, size: 20, color: iconColor),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kpi['title'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textMuted)),
                  const SizedBox(height: 4),
                  Text(kpi['value'] as String, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 2),
                  Text(kpi['subtitle'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabsAndFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTabPill('Pre-Primary'),
              const SizedBox(width: 8),
              _buildTabPill('Primary'),
              const SizedBox(width: 8),
              _buildTabPill('Secondary'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
                child: const Row(
                  children: [
                    Icon(Icons.filter_list, size: 16, color: _textMuted),
                    SizedBox(width: 6),
                    Text('Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _textDark)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: _accent.withValues(alpha: 0.3))),
                child: const Text('All Classes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _accent)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
                child: const Text('Attention Required', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _textMuted)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabPill(String label) {
    final isActive = _selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isActive ? null : Border.all(color: _borderColor),
          boxShadow: isActive ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildClassSectionsGrid(bool isTablet) {
    List<Map<String, Object>> classesData;
    if (_selectedTab == 'Primary') {
      classesData = MockData.studentInsightsClassesPrimary;
    } else if (_selectedTab == 'Secondary') {
      classesData = MockData.studentInsightsClassesSecondary;
    } else {
      classesData = MockData.studentInsightsClasses;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 180, // Fixed height for the card
      ),
      itemCount: classesData.length,
      itemBuilder: (context, index) {
        final cls = classesData[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
            border: Border.all(color: _borderColor, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Color(0xFFF4F1FF), shape: BoxShape.circle),
                        child: const Icon(Icons.home_outlined, size: 20, color: _accent),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cls['name'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                          const SizedBox(height: 2),
                          Text(cls['sections'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert, size: 18, color: _textMuted),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Class Teacher', style: TextStyle(fontSize: 11, color: _textMuted)),
                  Text(cls['teacher'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _textDark)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Students', style: TextStyle(fontSize: 11, color: _textMuted)),
                  Text(cls['students'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: cls['progress'] as double,
                backgroundColor: const Color(0xFFEBEBEB),
                color: _accent,
                minHeight: 6,
                borderRadius: BorderRadius.circular(4),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
                  const Icon(Icons.arrow_forward, size: 14, color: _accent),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, String actionLabel, {bool isBadge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
        if (actionLabel.isNotEmpty)
          isBadge
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                  child: Text(actionLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                )
              : Text(actionLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _accent)),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: MockData.studentInsightsActivity.map((activity) {
          final isLast = activity == MockData.studentInsightsActivity.last;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(activity['icon'] as IconData, size: 20, color: activity['color'] as Color),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 13, color: _textDark),
                              children: [
                                TextSpan(text: '${activity['type']}: ', style: const TextStyle(color: _textMuted)),
                                TextSpan(text: activity['desc'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(activity['subDesc'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                        ],
                      ),
                    ),
                    Text(activity['time'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, color: _borderColor, indent: 52, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRequiringAttention() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    const Text('Requiring Attention', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                  child: const Text('6 cases', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: MockData.studentInsightsAttention.map((alert) {
                final isAttendance = alert['badge'] == 'Attendance';
                final isAcademic = alert['badge'] == 'Academics';
                
                final cardBg = isAttendance 
                    ? const Color(0xFFF4F1FF) 
                    : isAcademic ? const Color(0xFFFFFBF0) : const Color(0xFFFFF5F5);
                
                final badgeColor = isAttendance 
                    ? _accent 
                    : isAcademic ? const Color(0xFFD97706) : Colors.redAccent;
                    
                final borderColor = isAttendance 
                    ? _accent.withValues(alpha: 0.2) 
                    : isAcademic ? const Color(0xFFD97706).withValues(alpha: 0.2) : Colors.redAccent.withValues(alpha: 0.2);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _textDark.withValues(alpha: 0.8), width: 1),
                        ),
                        child: Text(
                          alert['badge'] as String,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textDark),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(alert['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                      const SizedBox(height: 4),
                      Text(alert['desc'] as String, style: TextStyle(fontSize: 12, color: badgeColor.withValues(alpha: 0.6))),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text('View student', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: badgeColor)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 12, color: badgeColor),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEnrollmentDistribution(bool isTablet) {
    return Row(
      children: MockData.studentInsightsEnrollment.map((dist) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: dist == MockData.studentInsightsEnrollment.first ? 12 : 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.loop_outlined, size: 14, color: dist['color'] as Color),
                    const SizedBox(width: 6),
                    Text(dist['level'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(dist['total'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
                const Text('total students', style: TextStyle(fontSize: 10, color: _textMuted)),
                const SizedBox(height: 16),
                const Divider(height: 1, color: _borderColor),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dist['classes'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                        const Text('CLASSES', style: TextStyle(fontSize: 8, color: _textMuted, letterSpacing: 0.5)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dist['staff'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                        const Text('STAFF AVAIL.', style: TextStyle(fontSize: 8, color: _textMuted, letterSpacing: 0.5)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNewAdmissions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: MockData.studentInsightsAdmissions.map((adm) {
          final isLast = adm == MockData.studentInsightsAdmissions.last;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(adm['avatar'] as String),
                      backgroundColor: const Color(0xFFE6E6EB),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(adm['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                          const SizedBox(height: 2),
                          Text(adm['desc'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: adm['statusBg'] as Color,
                        border: Border.all(color: adm['statusColor'] as Color, width: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        adm['status'] as String,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: adm['statusColor'] as Color),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, color: _borderColor, indent: 60, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildClassCapacityMonitor() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HIGHEST POPULATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          ...MockData.studentInsightsCapacityHighest.map((cap) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cap['class'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                  Text(cap['ratio'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.redAccent)),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          const Divider(height: 1, color: _borderColor),
          const SizedBox(height: 16),
          const Text('UNDER-CAPACITY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          ...MockData.studentInsightsCapacityUnder.map((cap) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cap['class'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                  Text(cap['desc'] as String, style: const TextStyle(fontSize: 12, color: _textMuted)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHealthSafety() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: MockData.studentInsightsHealth.map((alert) {
          final isLast = alert == MockData.studentInsightsHealth.last;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(alert['icon'] as IconData, size: 20, color: alert['iconColor'] as Color),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alert['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                          const SizedBox(height: 2),
                          Text(alert['desc'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 18, color: _textMuted),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, color: _borderColor, indent: 52, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTodayHighlights() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, size: 18, color: _textMuted),
              const SizedBox(width: 8),
              const Text('Today\'s Highlights', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            ],
          ),
          const SizedBox(height: 16),
          ...MockData.studentInsightsHighlights.map((hl) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(hl['icon'] as IconData, size: 16, color: _textMuted),
                  const SizedBox(width: 12),
                  Text(hl['text'] as String, style: const TextStyle(fontSize: 13, color: _textDark)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
