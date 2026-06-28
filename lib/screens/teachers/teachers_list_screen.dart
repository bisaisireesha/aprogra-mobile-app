import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import '../students/students_list_screen.dart';
import '../dashboard/dashboard_screen.dart';

class TeachersListScreen extends StatefulWidget {
  const TeachersListScreen({super.key});

  @override
  State<TeachersListScreen> createState() => _TeachersListScreenState();
}

class _TeachersListScreenState extends State<TeachersListScreen> {
  String _selectedFilter = 'All';
  int _currentIndex = 1; // 1 represents Academics

  final List<Map<String, dynamic>> _allTeachers = [
    {
      'initials': 'MJ', 'name': 'Meera Joshi', 'id': 'EMP-101', 'role': 'Senior Teacher',
      'department': 'Pre-Primary', 'subjects': ['Rhymes'], 'experience': '3 yrs',
      'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)
    },
    {
      'initials': 'PR', 'name': 'Pooja Rao', 'id': 'EMP-102', 'role': 'Class Teacher',
      'department': 'Pre-Primary', 'subjects': ['Story Time'], 'experience': '4 yrs',
      'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)
    },
    {
      'initials': 'AS', 'name': 'Anita Sharma', 'id': 'EMP-103', 'role': 'Subject Lead',
      'department': 'Primary', 'subjects': ['Art & Craft'], 'experience': '5 yrs',
      'avatarColor': const Color(0xFFE0E7FF), 'textColor': const Color(0xFF4338CA)
    },
    {
      'initials': 'SD', 'name': 'Sneha Das', 'id': 'EMP-104', 'role': 'Coordinator',
      'department': 'Secondary', 'subjects': ['Music'], 'experience': '6 yrs',
      'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)
    },
    {
      'initials': 'KM', 'name': 'Kavita Menon', 'id': 'EMP-105', 'role': 'Head of Department',
      'department': 'Secondary', 'subjects': ['English'], 'experience': '7 yrs',
      'avatarColor': const Color(0xFFF3E8FF), 'textColor': const Color(0xFF7E22CE)
    },
  ];

  List<Map<String, dynamic>> get _teachers {
    if (_selectedFilter == 'All') return _allTeachers;
    return _allTeachers.where((t) => t['department'] == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MenuScreen(activeScreen: 'Teachers'),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildStatsCards(),
                    const SizedBox(height: 24),
                    _buildFiltersAndSearch(),
                    const SizedBox(height: 24),
                    _buildTeachersTable(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Teachers',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All teaching staff across pre-primary, primary, and secondary levels.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(LucideIcons.plus, size: 18, color: Colors.white),
          label: Text(
            'Add Teacher',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final Widget totalCard = _buildStatCard(
          title: 'Total Teachers',
          value: '16',
          icon: LucideIcons.users,
          iconColor: const Color(0xFF6366F1),
          iconBgColor: const Color(0xFFEEF2FF),
          isActive: _selectedFilter == 'All',
          onTap: () => setState(() => _selectedFilter = 'All'),
        );
        final Widget prePrimaryCard = _buildStatCard(
          title: 'Pre-Primary Teachers',
          value: '6',
          icon: LucideIcons.baby,
          iconColor: const Color(0xFFEF4444),
          iconBgColor: const Color(0xFFFEF2F2),
          isActive: _selectedFilter == 'Pre-Primary',
          onTap: () => setState(() => _selectedFilter = 'Pre-Primary'),
        );
        final Widget primaryCard = _buildStatCard(
          title: 'Primary Teachers',
          value: '10',
          icon: LucideIcons.blocks,
          iconColor: const Color(0xFFF59E0B),
          iconBgColor: const Color(0xFFFFF7ED),
          isActive: _selectedFilter == 'Primary',
          onTap: () => setState(() => _selectedFilter = 'Primary'),
        );
        final Widget secondaryCard = _buildStatCard(
          title: 'Secondary Teachers',
          value: '9',
          icon: LucideIcons.graduationCap,
          iconColor: const Color(0xFF10B981),
          iconBgColor: const Color(0xFFECFDF5),
          isActive: _selectedFilter == 'Secondary',
          onTap: () => setState(() => _selectedFilter = 'Secondary'),
        );

        if (isMobile) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: totalCard),
                  const SizedBox(width: 16),
                  Expanded(child: prePrimaryCard),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: primaryCard),
                  const SizedBox(width: 16),
                  Expanded(child: secondaryCard),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: totalCard),
            const SizedBox(width: 16),
            Expanded(child: prePrimaryCard),
            const SizedBox(width: 16),
            Expanded(child: primaryCard),
            const SizedBox(width: 16),
            Expanded(child: secondaryCard),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterChip('Pre-Primary', '6', 'Nursery • LKG • UKG', LucideIcons.baby, const Color(0xFF6366F1)),
                Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                _buildFilterChip('Primary', '10', 'Class 1 - 5', LucideIcons.blocks, const Color(0xFF6366F1)),
                Container(width: 1, height: 40, color: const Color(0xFFE5E7EB)),
                _buildFilterChip('Secondary', '9', 'Class 6 - 12', LucideIcons.graduationCap, const Color(0xFF6366F1)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            final searchField = Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.search, size: 20, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search teachers, ID, email, or subject',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            );
            final showingText = Text(
              'Showing ${_teachers.length} teachers',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF6B7280),
              ),
            );

            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchField,
                  const SizedBox(height: 16),
                  showingText,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: searchField),
                const SizedBox(width: 16),
                showingText,
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(String title, String count, String subtitle, IconData icon, Color color) {
    bool isSelected = _selectedFilter == title;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3E8FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeachersTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              if (isMobile) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _teachers.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  itemBuilder: (context, index) => _buildMobileTeacherCard(_teachers[index]),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 800,
                    maxWidth: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text('TEACHER', style: _tableHeaderStyle())),
                            Expanded(flex: 2, child: Text('DEPARTMENT', style: _tableHeaderStyle())),
                            Expanded(flex: 2, child: Text('SUBJECTS', style: _tableHeaderStyle())),
                            Expanded(flex: 2, child: Text('EXPERIENCE', style: _tableHeaderStyle())),
                            const SizedBox(width: 40), // For more_vert icon
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _teachers.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE5E7EB)),
                        itemBuilder: (context, index) {
                          final t = _teachers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: t['avatarColor'],
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          t['initials'],
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: t['textColor'],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            t['name'],
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${t['id']} • ${t['role']}',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: const Color(0xFF6B7280),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    t['department'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: (t['subjects'] as List).map((s) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        s,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF374151),
                                        ),
                                      ),
                                    )).toList(),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    t['experience'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                ),
                                const Icon(Icons.more_vert, size: 20, color: Color(0xFF9CA3AF)),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildMobileTeacherCard(Map<String, dynamic> t) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: t['avatarColor'], shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(t['initials'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: t['textColor'])),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['name'], style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                const SizedBox(height: 4),
                Text('${t['id']} • ${t['role']}', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280))),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('${t['department']} • ', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280))),
                    if ((t['subjects'] as List).isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6)),
                        child: Text(t['subjects'][0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.more_vert, size: 20, color: Color(0xFF9CA3AF)),
              const SizedBox(height: 16),
              Text(t['experience'], style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF374151))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 450;
          final showingText = Text(
            'Showing 1 to ${_teachers.length} of ${_teachers.length} entries',
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B7280)),
          );
          final pageControls = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPageButton(Icons.chevron_left),
              const SizedBox(width: 8),
              _buildPageNumber('1', isActive: true),
              const SizedBox(width: 8),
              _buildPageNumber('2'),
              const SizedBox(width: 8),
              _buildPageNumber('3'),
              const SizedBox(width: 8),
              _buildPageButton(Icons.chevron_right),
            ],
          );

          if (isSmall) {
            return Column(
              children: [
                showingText,
                const SizedBox(height: 16),
                pageControls,
              ],
            );
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showingText,
              pageControls,
            ],
          );
        },
      ),
    );
  }

  Widget _buildPageButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
    );
  }

  Widget _buildPageNumber(String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF3E8FF) : Colors.white,
        border: Border.all(color: isActive ? const Color(0xFFD8B4FE) : const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? const Color(0xFF7E22CE) : const Color(0xFF374151),
        ),
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF9CA3AF),
      letterSpacing: 0.5,
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
    final accentColor = const Color(0xFF8463E9);
    final textMuted = const Color(0xFF595973);

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: Duration.zero,
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const StudentInsightsScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: Duration.zero,
            ),
          );
        } else {
          setState(() => _currentIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isSelected ? accentColor : textMuted,
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
              color: isSelected ? accentColor : textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

