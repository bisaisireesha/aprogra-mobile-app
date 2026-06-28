import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';

class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  final Color _bgPrimary = const Color(0xFFFAFAFA);
  final Color _textDark = const Color(0xFF111827);
  final Color _textMuted = const Color(0xFF6B7280);

  final TextEditingController _searchController = TextEditingController();
  int _bottomNavIndex = 3; // Staff/Departments

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _departments = [
    {
      'name': 'Mathematics',
      'initials': 'VS',
      'initialsBg': const Color(0xFFF4F1FF),
      'initialsColor': const Color(0xFF4F46E5),
      'hod': 'Vikram Singh',
      'openRoles': 2,
      'chips': ['Algebra', 'Calculus', 'Statistics'],
      'members': 18,
      'teachers': 16,
      'support': 2,
      'budget': 78,
      'budgetColor': const Color(0xFF4F46E5),
    },
    {
      'name': 'Sciences',
      'initials': 'DR',
      'initialsBg': const Color(0xFFE0F2FE),
      'initialsColor': const Color(0xFF0EA5E9),
      'hod': 'Dr. Ravi Sharma',
      'openRoles': 4,
      'chips': ['Physics', 'Chemistry', 'Biology', '+1'],
      'members': 22,
      'teachers': 18,
      'support': 4,
      'budget': 85,
      'budgetColor': const Color(0xFF0EA5E9),
    },
    {
      'name': 'English',
      'initials': 'MK',
      'initialsBg': const Color(0xFFDCFCE7),
      'initialsColor': const Color(0xFF22C55E),
      'hod': 'Meera Kapoor',
      'openRoles': 1,
      'chips': ['Literature', 'Grammar', 'Creative Writing'],
      'members': 14,
      'teachers': 13,
      'support': 1,
      'budget': 62,
      'budgetColor': const Color(0xFF22C55E),
    },
    {
      'name': 'Social Studies',
      'initials': 'SN',
      'initialsBg': const Color(0xFFFEF3C7),
      'initialsColor': const Color(0xFFF59E0B),
      'hod': 'Sunil Nair',
      'openRoles': 2,
      'chips': ['History', 'Geography', 'Civics', '+1'],
      'members': 12,
      'teachers': 11,
      'support': 1,
      'budget': 55,
      'budgetColor': const Color(0xFFF59E0B),
    },
    {
      'name': 'Hindi',
      'initials': 'PK',
      'initialsBg': const Color(0xFFFEE2E2),
      'initialsColor': const Color(0xFFEF4444),
      'hod': 'Priya Krishnan',
      'openRoles': 1,
      'chips': ['Hindi Lang', 'Hindi Literature'],
      'members': 10,
      'teachers': 10,
      'support': 0,
      'budget': 48,
      'budgetColor': const Color(0xFFEF4444),
    },
    {
      'name': 'Computer Science',
      'initials': 'AM',
      'initialsBg': const Color(0xFFF4F1FF),
      'initialsColor': const Color(0xFF4F46E5),
      'hod': 'Arjun Mehta',
      'openRoles': 2,
      'chips': ['Python', 'DBMS', 'Networking', '+1'],
      'members': 8,
      'teachers': 7,
      'support': 1,
      'budget': 70,
      'budgetColor': const Color(0xFF4F46E5),
    },
    {
      'name': 'Administration',
      'initials': 'RM',
      'initialsBg': const Color(0xFFF4F1FF),
      'initialsColor': const Color(0xFF4F46E5),
      'hod': 'Rekha Mehta',
      'openRoles': 3,
      'chips': ['Admissions', 'Accounts', 'HR', '+1'],
      'members': 28,
      'teachers': 0,
      'support': 28,
      'budget': 91,
      'budgetColor': const Color(0xFF4F46E5),
    },
    {
      'name': 'Transport',
      'initials': 'KN',
      'initialsBg': const Color(0xFFE0F2FE),
      'initialsColor': const Color(0xFF0EA5E9),
      'hod': 'Kishore Naidu',
      'openRoles': 1,
      'chips': ['Logistics', 'Fleet Management'],
      'members': 22,
      'teachers': 0,
      'support': 22,
      'budget': 60,
      'budgetColor': const Color(0xFF0EA5E9),
    },
    {
      'name': 'Security',
      'initials': 'BS',
      'initialsBg': const Color(0xFFF3F4F6),
      'initialsColor': const Color(0xFF4B5563),
      'hod': 'Bharat Singh',
      'openRoles': 1,
      'chips': ['Campus Security', 'CCTV', 'Gate Mgmt'],
      'members': 18,
      'teachers': 0,
      'support': 18,
      'budget': 44,
      'budgetColor': const Color(0xFF6B7280),
    },
    {
      'name': 'Housekeeping',
      'initials': 'LP',
      'initialsBg': const Color(0xFFDCFCE7),
      'initialsColor': const Color(0xFF22C55E),
      'hod': 'Lata Pereira',
      'openRoles': 1,
      'chips': ['Sanitation', 'Maintenance', 'Grounds'],
      'members': 14,
      'teachers': 0,
      'support': 14,
      'budget': 38,
      'budgetColor': const Color(0xFF22C55E),
    },
  ];

  final List<Map<String, dynamic>> _comparisonData = [
    {'name': 'Mathematics', 'color': const Color(0xFF4F46E5), 'hod': 'Vikram Singh', 'members': 18, 'teachers': 16, 'nonTeaching': 2, 'vacancies': 2, 'budget': 78},
    {'name': 'Sciences', 'color': const Color(0xFF0EA5E9), 'hod': 'Dr. Ravi Sharma', 'members': 22, 'teachers': 18, 'nonTeaching': 4, 'vacancies': 4, 'budget': 85},
    {'name': 'English', 'color': const Color(0xFF22C55E), 'hod': 'Meera Kapoor', 'members': 14, 'teachers': 13, 'nonTeaching': 1, 'vacancies': 1, 'budget': 62},
    {'name': 'Social Studies', 'color': const Color(0xFFF59E0B), 'hod': 'Sunil Nair', 'members': 12, 'teachers': 11, 'nonTeaching': 1, 'vacancies': 2, 'budget': 55},
    {'name': 'Hindi', 'color': const Color(0xFFEF4444), 'hod': 'Priya Krishnan', 'members': 10, 'teachers': 10, 'nonTeaching': 0, 'vacancies': 1, 'budget': 48},
    {'name': 'Computer Science', 'color': const Color(0xFF4F46E5), 'hod': 'Arjun Mehta', 'members': 8, 'teachers': 7, 'nonTeaching': 1, 'vacancies': 2, 'budget': 70},
    {'name': 'Administration', 'color': const Color(0xFF4F46E5), 'hod': 'Rekha Mehta', 'members': 28, 'teachers': 0, 'nonTeaching': 28, 'vacancies': 3, 'budget': 91},
    {'name': 'Transport', 'color': const Color(0xFF0EA5E9), 'hod': 'Kishore Naidu', 'members': 22, 'teachers': 0, 'nonTeaching': 22, 'vacancies': 1, 'budget': 60},
    {'name': 'Security', 'color': const Color(0xFF6B7280), 'hod': 'Bharat Singh', 'members': 18, 'teachers': 0, 'nonTeaching': 18, 'vacancies': 1, 'budget': 44},
    {'name': 'Housekeeping', 'color': const Color(0xFF22C55E), 'hod': 'Lata Pereira', 'members': 14, 'teachers': 0, 'nonTeaching': 14, 'vacancies': 1, 'budget': 38},
  ];

  bool get _isTablet => MediaQuery.of(context).size.width > 768;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Departments'),
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 32 : 16, 24, _isTablet ? 32 : 16, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildScreenHeader(),
                          const SizedBox(height: 24),
                          _buildKpis(),
                          const SizedBox(height: 32),
                          _buildDepartmentsSection(),
                          const SizedBox(height: 32),
                          _buildDepartmentComparisonSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.05))),
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: const Color(0xFF6B7280),
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), activeIcon: Icon(Icons.show_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.menu_rounded, color: Color(0xFF8F96A3), size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.notifications_none_rounded, color: Color(0xFF8F96A3), size: 24),
            const SizedBox(width: 16),
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150&h=150'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Departments',
                          style: GoogleFonts.figtree(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Department directory with head of department, member count, vacancies, and budget utilisation.',
                          style: GoogleFonts.figtree(
                            fontSize: 16,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildAddButton(),
                ],
              )
            else ...[
              Text(
                'Departments',
                style: GoogleFonts.figtree(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Department directory with head of department, member count, vacancies, and budget utilisation.',
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  color: _textMuted,
                ),
              ),
              const SizedBox(height: 16),
              _buildAddButton(),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, size: 18, color: Colors.white),
      label: Text(
        'Add Department',
        style: GoogleFonts.figtree(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8463E9),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildKpis() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _isTablet ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 184,
          ),
          children: [
            _buildKpiCard(
              title: 'Total Departments',
              value: '10',
              subtitle: 'academic + support',
              icon: LucideIcons.building, // purple building
              color: const Color(0xFF4F46E5),
              bgColor: const Color(0xFFF4F1FF),
            ),
            _buildKpiCard(
              title: 'Total Members',
              value: '248',
              subtitle: 'teaching + non-teaching',
              icon: LucideIcons.users, // green users
              color: const Color(0xFF22C55E),
              bgColor: const Color(0xFFDCFCE7),
            ),
            _buildKpiCard(
              title: 'Avg Dept Size',
              value: '24.8',
              subtitle: 'members per dept',
              icon: LucideIcons.barChart2, // blue chart
              color: const Color(0xFF0EA5E9),
              bgColor: const Color(0xFFE0F2FE),
            ),
            _buildKpiCard(
              title: 'Total Vacancies',
              value: '18',
              subtitle: 'open positions',
              icon: LucideIcons.alertCircle, // red alert
              color: const Color(0xFFEF4444),
              bgColor: const Color(0xFFFEE2E2),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, height: 1.1)),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark, height: 1.2)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
        ],
      ),
    );
  }

  Widget _buildDepartmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_isTablet) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Departments', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
              Text('View All', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
            ],
          ),
          const SizedBox(height: 16),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 1;
            if (constraints.maxWidth > 1100) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 800) {
              crossAxisCount = 2;
            }
            
            double spacing = 16.0;
            double cardWidth = (constraints.maxWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
            
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: _departments.map((d) => SizedBox(
                width: cardWidth,
                child: _buildDepartmentCard(d),
              )).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDepartmentCard(Map<String, dynamic> dept) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: dept['initialsBg'] as Color,
                child: Text(
                  dept['initials'] as String,
                  style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: dept['initialsColor'] as Color),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${dept['openRoles']} open',
                  style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(dept['name'] as String, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(LucideIcons.graduationCap, size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text('HOD: ${dept['hod']}', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (dept['chips'] as List<String>).map((chip) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(chip, style: GoogleFonts.figtree(fontSize: 11, color: const Color(0xFF4B5563))),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(dept['members'].toString(), 'Members'),
              _buildStatColumn(dept['teachers'].toString(), 'Teachers'),
              _buildStatColumn(dept['support'].toString(), 'Support'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Budget Used', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
              Text('${dept['budget']}%', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: dept['budgetColor'] as Color)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (dept['budget'] as int) / 100,
              backgroundColor: const Color(0xFFF3F4F6),
              valueColor: AlwaysStoppedAnimation<Color>(dept['budgetColor'] as Color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => _showDepartmentPopup(dept),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(LucideIcons.eye, size: 16, color: Color(0xFF4F46E5)),
                  const SizedBox(width: 8),
                  Text('View Department', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF4F46E5))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDepartmentPopup(Map<String, dynamic> dept) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: dept['initialsBg'] as Color,
                          child: Text(
                            dept['initials'] as String,
                            style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: dept['initialsColor'] as Color),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dept['name'] as String, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
                            const SizedBox(height: 4),
                            Text('HOD: ${dept['hod']}', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Overview', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                const SizedBox(height: 16),
                _buildPopupDetailRow('Open Roles', '${dept['openRoles']} Vacancies'),
                const SizedBox(height: 12),
                _buildPopupDetailRow('Members', '${dept['members']} Total'),
                const SizedBox(height: 12),
                _buildPopupDetailRow('Teachers', '${dept['teachers']} Staff'),
                const SizedBox(height: 12),
                _buildPopupDetailRow('Support Staff', '${dept['support']} Staff'),
                const SizedBox(height: 12),
                _buildPopupDetailRow('Budget Utilisation', '${dept['budget']}% Used'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Close', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
        Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
      ],
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
      ],
    );
  }

  Widget _buildDepartmentComparisonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Department Comparison', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 16),
        _isTablet ? _buildComparisonTable() : _buildComparisonMobileList(),
      ],
    );
  }

  Widget _buildComparisonTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text('DEPARTMENT', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6B7280)))),
                Expanded(flex: 2, child: Text('HEAD', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6B7280)))),
                Expanded(flex: 1, child: Text('MEMBERS', textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6B7280)))),
                Expanded(flex: 1, child: Text('TEACHERS', textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6B7280)))),
                Expanded(flex: 2, child: Text('NON-TEACHING', textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6B7280)))),
                Expanded(flex: 1, child: Text('VACANCIES', textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6B7280)))),
                Expanded(flex: 2, child: Text('BUDGET USED', textAlign: TextAlign.right, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6B7280)))),
              ],
            ),
          ),
          ..._comparisonData.map((data) => _buildTableRow(data)),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> data) {
    int budget = data['budget'] as int;
    Color budgetTextColor = budget >= 80 ? const Color(0xFFEF4444) : budget > 62 ? const Color(0xFFF59E0B) : const Color(0xFF22C55E);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: data['color'] as Color)),
              const SizedBox(width: 12),
              Text(data['name'] as String, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
            ],
          )),
          Expanded(flex: 2, child: Text(data['hod'] as String, style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF6B7280)))),
          Expanded(flex: 1, child: Text(data['members'].toString(), textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF111827)))),
          Expanded(flex: 1, child: Text(data['teachers'].toString(), textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF4B5563)))),
          Expanded(flex: 2, child: Text(data['nonTeaching'].toString(), textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF4B5563)))),
          Expanded(
            flex: 1, 
            child: Align(
              alignment: Alignment.center,
              child: Text(data['vacancies'].toString(), style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFFEF4444))),
            ),
          ),
          Expanded(flex: 2, child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: budget / 100,
                  backgroundColor: const Color(0xFFF3F4F6),
                  valueColor: AlwaysStoppedAnimation<Color>(data['color'] as Color),
                  minHeight: 6,
                ),
              )),
              const SizedBox(width: 12),
              SizedBox(
                width: 32,
                child: Text('$budget%', textAlign: TextAlign.right, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: budgetTextColor)),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildComparisonMobileList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _comparisonData.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildMobileComparisonCard(_comparisonData[index]);
      },
    );
  }

  Widget _buildMobileComparisonCard(Map<String, dynamic> data) {
    int budget = data['budget'] as int;
    Color budgetTextColor = budget >= 80 ? const Color(0xFFEF4444) : budget > 62 ? const Color(0xFFF59E0B) : const Color(0xFF22C55E);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 10, height: 10, 
                decoration: BoxDecoration(shape: BoxShape.circle, color: data['color'] as Color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['name'] as String, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 4),
                    Text(data['hod'] as String, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$budget%', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: budgetTextColor)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: budget / 100,
                        backgroundColor: const Color(0xFFF3F4F6),
                        valueColor: AlwaysStoppedAnimation<Color>(data['color'] as Color),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['members'].toString(), style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 4),
                  Text('Members', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                ],
              )),
              Container(width: 1, height: 32, color: const Color(0xFFE5E7EB)),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['teachers'].toString(), style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 4),
                    Text('Teachers', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              )),
              Container(width: 1, height: 32, color: const Color(0xFFE5E7EB)),
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['nonTeaching'].toString(), style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 4),
                    Text('Non-Teaching', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
