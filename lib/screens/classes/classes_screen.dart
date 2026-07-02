import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock_data/classes_mock.dart';
import '../../data/mock_data/dashboard_mock.dart';
import '../auth/menu_screen.dart';
import '../../screens/class_details_bottom_sheet.dart';
import '../students/students_list_screen.dart'; // Example for bottom nav
import 'create_class_wizard.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  int _bottomNavIndex = 1; // 1 for Academics
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 1;

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 40.w : 16.w, 24.w, _isTablet ? 40.w : 16.w, 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          SizedBox(height: 24.h),
                          _buildKpiGrid(),
                          SizedBox(height: 32.h),
                          _buildFilterButtons(),
                          SizedBox(height: 24.h),
                          _buildClassSectionsGrid(),
                          SizedBox(height: 32.h),
                          _buildOldBottomSections(),
                          SizedBox(height: 32.h),
                          _buildClassDistribution(),
                          SizedBox(height: 32.h),
                          _buildNewBottomSections(),
                          SizedBox(height: 32.h),
                          _buildFinalDashboardSections(),
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
      drawer: const MenuScreen(activeScreen: 'Classes'),
      
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Icon(Icons.menu_rounded, color: Color(0xFF8F96A3), size: 28),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F6F8),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14.sp),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Icon(Icons.notifications_none_rounded, color: Color(0xFF8F96A3), size: 24),
            SizedBox(width: 16.w),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF4F1FF),
              child: Text('A', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Color(0xFF8463E9))),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Classes',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        _buildCreateButton(),
      ],
    );
  }
  Widget _buildCreateButton() {
    return ElevatedButton.icon(
      onPressed: _showCreateClassPopup,
      icon: Icon(Icons.add, size: 18, color: Colors.white),
      label: Text(
        'Create Class',
        style: GoogleFonts.figtree(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _accent,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  Future<void> _showCreateClassPopup() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => const CreateClassWizard(),
    );

    if (result != null) {
      setState(() {
        final String category = result['category'] ?? 'Pre-Primary';
        if (category == 'Primary') {
          MockData.studentInsightsClassesPrimary.insert(0, result);
        } else if (category == 'Secondary') {
          MockData.studentInsightsClassesSecondary.insert(0, result);
        } else {
          MockData.studentInsightsClasses.insert(0, result);
        }
      });
    }
  }

  Widget _buildKpiGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 140.h,
      ),
      itemCount: ClassesMockData.classesKPIs.length,
      itemBuilder: (context, index) {
        final kpi = ClassesMockData.classesKPIs[index];
        final iconColor = kpi['color'] as Color;

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(20.r), 
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
            border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(kpi['icon'] as IconData, size: 24, color: iconColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kpi['title'] as String, style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.w600, color: _textMuted)),
                  SizedBox(height: 4.h),
                  Text(kpi['value'] as String, style: GoogleFonts.figtree(fontSize: 24.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.5)),
                  SizedBox(height: 2.h),
                  Text(kpi['subtitle'] as String, style: GoogleFonts.figtree(fontSize: 11.sp, color: _textMuted)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOldBottomSections() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isTablet) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _buildRecentActivity()),
              SizedBox(width: 24.w),
              Expanded(flex: 5, child: _buildRequiringAttention()),
            ],
          );
        }
        return Column(
          children: [
            _buildRecentActivity(),
            SizedBox(height: 32.h),
            _buildRequiringAttention(),
          ],
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Class Activity', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark)),
            Text('View all', style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.bold, color: _accent)),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
            border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
          ),
          child: Column(
            children: ClassesMockData.recentClassActivity.map((activity) {
              final isLast = activity == ClassesMockData.recentClassActivity.last;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: (activity['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(activity['icon'] as IconData, size: 20, color: activity['color'] as Color),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.figtree(fontSize: 13.sp, color: _textDark),
                                  children: [
                                    TextSpan(text: '${activity['action']} ', style: GoogleFonts.figtree(fontWeight: FontWeight.bold)),
                                    TextSpan(text: '· ${activity['class']}', style: GoogleFonts.figtree(color: _textMuted)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(activity['details'] as String, style: GoogleFonts.figtree(fontSize: 11.sp, color: _textMuted)),
                            ],
                          ),
                        ),
                        Text(activity['time'] as String, style: GoogleFonts.figtree(fontSize: 11.sp, color: _textMuted)),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1.h, color: Color(0xFFEBEBEB), indent: 64, endIndent: 16),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRequiringAttention() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(8.r)),
                        child: Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Classes Requiring Attention', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                            SizedBox(height: 4.h),
                            Text('Open items across capacity, staffing, and schedules', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1), 
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                  ),
                  child: Text('6 items', style: GoogleFonts.figtree(fontSize: 11.sp, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                ),
              ],
            ),
          ),
          Divider(height: 1.h, color: Color(0xFFEBEBEB)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 300;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 180.h,
                  ),
                  itemCount: ClassesMockData.classesRequiringAttention.length,
                  itemBuilder: (context, index) {
                    final alert = ClassesMockData.classesRequiringAttention[index];
                    final badgeColor = alert['badgeColor'] as Color;

                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFEBEBEB)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              alert['badge'] as String,
                              style: GoogleFonts.figtree(fontSize: 10.sp, fontWeight: FontWeight.bold, color: badgeColor, letterSpacing: 0.5),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(alert['class'] as String, style: GoogleFonts.figtree(fontSize: 15.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                          SizedBox(height: 4.h),
                          Text('${alert['level']} · ${alert['details']}', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => ClassDetailsBottomSheet(className: alert['class'] as String),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.w),
                              child: Row(
                                children: [
                                  Text('View class', style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.w600, color: _accent)),
                                  SizedBox(width: 4.w),
                                  Icon(Icons.arrow_forward, size: 14, color: _accent),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildClassDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Class Distribution', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark)),
        SizedBox(height: 16.h),
        LayoutBuilder(
          builder: (context, constraints) {
            if (_isTablet) {
              return Row(
                children: [
                  Expanded(child: _buildDistributionCard(ClassesMockData.classDistribution[0])),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildDistributionCard(ClassesMockData.classDistribution[1])),
                  SizedBox(width: 16.w),
                  Expanded(child: _buildDistributionCard(ClassesMockData.classDistribution[2])),
                ],
              );
            }
            return Column(
              children: [
                _buildDistributionCard(ClassesMockData.classDistribution[0]),
                SizedBox(height: 16.h),
                _buildDistributionCard(ClassesMockData.classDistribution[1]),
                SizedBox(height: 16.h),
                _buildDistributionCard(ClassesMockData.classDistribution[2]),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDistributionCard(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(data['icon'] as IconData, size: 14, color: _textMuted),
              SizedBox(width: 6.w),
              Text(data['level'] as String, style: GoogleFonts.figtree(fontSize: 10.sp, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
            ],
          ),
          SizedBox(height: 16.h),
          Text(data['sections'] as String, style: GoogleFonts.figtree(fontSize: 24.sp, fontWeight: FontWeight.bold, color: _textDark)),
          Text('total sections', style: GoogleFonts.figtree(fontSize: 10.sp, color: _textMuted)),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9FB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Classes', style: GoogleFonts.figtree(fontSize: 10.sp, color: _textMuted)),
                      SizedBox(height: 4.h),
                      Text(data['classes'] as String, style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.bold, color: _textDark)),
                    ],
                  ),
                ),
                Container(width: 1.w, height: 24.h, color: const Color(0xFFEBEBEB)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Seats Available', style: GoogleFonts.figtree(fontSize: 10.sp, color: _textMuted)),
                      SizedBox(height: 4.h),
                      Text(data['seats'] as String, style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.bold, color: _textDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildFilterButton('Pre-Primary', 1)),
        SizedBox(width: 8.w),
        Expanded(child: _buildFilterButton('Primary', 2)),
        SizedBox(width: 8.w),
        Expanded(child: _buildFilterButton('Secondary', 3)),
      ],
    );
  }

  Widget _buildFilterButton(String label, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
          boxShadow: isSelected ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 8.r, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildClassSectionsGrid() {
    List<Map<String, dynamic>> classesData;
    if (_selectedFilterIndex == 1) {
      classesData = MockData.studentInsightsClasses;
    } else if (_selectedFilterIndex == 2) {
      classesData = MockData.studentInsightsClassesPrimary;
    } else if (_selectedFilterIndex == 3) {
      classesData = MockData.studentInsightsClassesSecondary;
    } else {
      classesData = MockData.studentInsightsClasses;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 200.h,
      ),
      itemCount: classesData.length,
      itemBuilder: (context, index) {
        final cls = classesData[index];
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => ClassDetailsBottomSheet(className: cls['name'] as String),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10.r, offset: const Offset(0, 4))],
              border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: const BoxDecoration(color: Color(0xFFF4F1FF), shape: BoxShape.circle),
                            child: Icon(Icons.home_outlined, size: 20, color: _accent),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cls['name'] as String, 
                                  style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3), 
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  cls['sections'] as String, 
                                  style: GoogleFonts.figtree(fontSize: 11.sp, color: _textMuted), 
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.more_vert, size: 18, color: _textMuted),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Class Teacher', style: GoogleFonts.figtree(fontSize: 11.sp, color: _textMuted)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        cls['teacher'] as String, 
                        style: GoogleFonts.figtree(fontSize: 11.sp, fontWeight: FontWeight.w600, color: _textDark),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Students', style: GoogleFonts.figtree(fontSize: 11.sp, color: _textMuted)),
                    Text(cls['students'] as String, style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.bold, color: _accent)),
                  ],
                ),
                SizedBox(height: 6.h),
                LinearProgressIndicator(
                  value: cls['progress'] as double,
                  backgroundColor: const Color(0xFFEBEBEB),
                  color: _accent,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('View Details', style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.bold, color: _accent)),
                    Icon(Icons.arrow_forward, size: 14, color: _accent),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewBottomSections() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isTablet) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 7, child: _buildRecentlyUpdated()),
              SizedBox(width: 24.w),
              Expanded(flex: 4, child: _buildClassComposition()),
            ],
          );
        }
        return Column(
          children: [
            _buildRecentlyUpdated(),
            SizedBox(height: 32.h),
            _buildClassComposition(),
          ],
        );
      },
    );
  }

  Widget _buildRecentlyUpdated() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recently Updated Classes', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark)),
                    SizedBox(height: 4.h),
                    Text('Newly created or reassigned', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
                  ],
                ),
                Text('View all', style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.bold, color: _accent)),
              ],
            ),
          ),
          Divider(height: 1.h, color: Color(0xFFEBEBEB)),
          ...ClassesMockData.recentlyUpdatedClasses.map((item) {
            final isLast = item == ClassesMockData.recentlyUpdatedClasses.last;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: item['avatarColor'] as Color,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          item['avatarText'] as String,
                          style: GoogleFonts.figtree(fontSize: 14.sp, fontWeight: FontWeight.bold, color: item['avatarTextColor'] as Color),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'] as String, style: GoogleFonts.figtree(fontSize: 14.sp, fontWeight: FontWeight.bold, color: _textDark)),
                            SizedBox(height: 4.h),
                            Text(item['subtitle'] as String, style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item['time'] as String, style: GoogleFonts.figtree(fontSize: 11.sp, color: _textMuted)),
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                            decoration: BoxDecoration(
                              color: item['statusBg'] as Color,
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(color: (item['statusColor'] as Color).withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              item['status'] as String,
                              style: GoogleFonts.figtree(fontSize: 10.sp, fontWeight: FontWeight.bold, color: item['statusColor'] as Color),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isLast) Divider(height: 1.h, color: Color(0xFFEBEBEB), indent: 72),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildClassComposition() {
    final comp = ClassesMockData.classComposition;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Class Composition', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark)),
          SizedBox(height: 4.h),
          Text('Current tab · Primary', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE), // Light blue
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Boys', style: GoogleFonts.figtree(fontSize: 12.sp, color: const Color(0xFF0369A1))),
                      SizedBox(height: 8.h),
                      Text(comp['boys'] as String, style: GoogleFonts.figtree(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF0369A1))),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF), // Light purple
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Girls', style: GoogleFonts.figtree(fontSize: 12.sp, color: const Color(0xFF7E22CE))),
                      SizedBox(height: 8.h),
                      Text(comp['girls'] as String, style: GoogleFonts.figtree(fontSize: 24.sp, fontWeight: FontWeight.bold, color: const Color(0xFF7E22CE))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
                      SizedBox(height: 8.h),
                      Text(comp['total'] as String, style: GoogleFonts.figtree(fontSize: 24.sp, fontWeight: FontWeight.bold, color: _textDark)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sections', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
                      SizedBox(height: 8.h),
                      Text(comp['sections'] as String, style: GoogleFonts.figtree(fontSize: 24.sp, fontWeight: FontWeight.bold, color: _textDark)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalDashboardSections() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isTablet) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _buildClassCapacityMonitor()),
                  SizedBox(width: 24.w),
                  Expanded(flex: 5, child: _buildTeacherCoverage()),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _buildSafetyCompliance()),
                  SizedBox(width: 24.w),
                  Expanded(flex: 5, child: _buildTodaysHighlights()),
                ],
              ),
            ],
          );
        }
        return Column(
          children: [
            _buildClassCapacityMonitor(),
            SizedBox(height: 24.h),
            _buildTeacherCoverage(),
            SizedBox(height: 24.h),
            _buildSafetyCompliance(),
            SizedBox(height: 24.h),
            _buildTodaysHighlights(),
          ],
        );
      },
    );
  }

  Widget _buildClassCapacityMonitor() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Class Capacity Monitor', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                SizedBox(height: 4.h),
                Text('Where seats are full and where they\'re open', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
              ],
            ),
          ),
          Divider(height: 1.h, color: Color(0xFFEBEBEB)),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HIGHEST ENROLLMENT', style: GoogleFonts.figtree(fontSize: 10.sp, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                      SizedBox(height: 12.h),
                      ...ClassesMockData.classCapacityMonitor['highestEnrollment']!.map((item) => _buildCapacityRow(item['class']!, item['seats']!)),
                    ],
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AVAILABLE SEATS', style: GoogleFonts.figtree(fontSize: 10.sp, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                      SizedBox(height: 12.h),
                      ...ClassesMockData.classCapacityMonitor['availableSeats']!.map((item) => _buildCapacityRow(item['class']!, item['seats']!)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityRow(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.figtree(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _textDark)),
          Text(value, style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
        ],
      ),
    );
  }

  Widget _buildTeacherCoverage() {
    final data = ClassesMockData.teacherCoverage;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.co_present_outlined, color: _accent, size: 20),
                SizedBox(width: 8.w),
                Text('Teacher Coverage', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
              ],
            ),
          ),
          Divider(height: 1.h, color: Color(0xFFEBEBEB)),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildCoverageRow('Classes with teacher', data['classesWithTeacher']!, _textDark, isBold: true),
                SizedBox(height: 16.h),
                _buildCoverageRow('Unassigned classes', data['unassignedClasses']!, const Color(0xFFD97706), isBold: true),
                SizedBox(height: 16.h),
                _buildCoverageRow('Substitutes needed', data['substitutesNeeded']!, _textDark, isBold: true),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Avg. teacher rating', style: GoogleFonts.figtree(fontSize: 13.sp, color: _textMuted)),
                    Row(
                      children: [
                        Text(data['avgTeacherRating']!, style: GoogleFonts.figtree(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.green)),
                        SizedBox(width: 4.w),
                        Icon(Icons.star, size: 14, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverageRow(String label, String value, Color valueColor, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 13.sp, color: _textMuted)),
        Text(value, style: GoogleFonts.figtree(fontSize: 13.sp, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: valueColor)),
      ],
    );
  }

  Widget _buildSafetyCompliance() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(color: const Color(0xFFFFF1F1), borderRadius: BorderRadius.circular(6.r)),
                  child: Icon(Icons.favorite_border, color: Colors.redAccent, size: 16),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Classroom Safety & Compliance', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
                    SizedBox(height: 4.h),
                    Text('Active concerns only', style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1.h, color: Color(0xFFEBEBEB)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ClassesMockData.safetyCompliance.length,
            separatorBuilder: (context, index) => Divider(height: 1.h, color: Color(0xFFEBEBEB)),
            itemBuilder: (context, index) {
              final item = ClassesMockData.safetyCompliance[index];
              final isRed = item['colorType'] == 'red';
              final iconColor = isRed ? Colors.redAccent : const Color(0xFFD97706);
              final bgColor = isRed ? const Color(0xFFFFF1F1) : const Color(0xFFFFF7E6);

              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8.r)),
                      child: Icon(item['icon'] as IconData, color: iconColor, size: 20),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'] as String, style: GoogleFonts.figtree(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _textDark)),
                          SizedBox(height: 4.h),
                          Text(item['subtitle'] as String, style: GoogleFonts.figtree(fontSize: 12.sp, color: _textMuted)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _showSafetyDetails(context, item),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
                        child: Row(
                          children: [
                            Text('View details', style: GoogleFonts.figtree(fontSize: 12.sp, fontWeight: FontWeight.w600, color: _accent)),
                            SizedBox(width: 4.w),
                            Icon(Icons.arrow_forward, size: 14, color: _accent),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSafetyDetails(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item['icon'] as IconData, color: item['colorType'] == 'red' ? Colors.redAccent : const Color(0xFFD97706), size: 28),
                  SizedBox(width: 12.w),
                  Expanded(child: Text(item['title'] as String, style: GoogleFonts.figtree(fontSize: 18.sp, fontWeight: FontWeight.bold, color: _textDark))),
                ],
              ),
              SizedBox(height: 16.h),
              Text('Details', style: GoogleFonts.figtree(fontSize: 14.sp, fontWeight: FontWeight.bold, color: _textMuted)),
              SizedBox(height: 8.h),
              Text(item['subtitle'] as String, style: GoogleFonts.figtree(fontSize: 14.sp, color: _textDark)),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    padding: EdgeInsets.symmetric(vertical: 14.w),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text('Close', style: GoogleFonts.figtree(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTodaysHighlights() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFEBEBEB), width: 0.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: _accent, size: 20),
                SizedBox(width: 8.w),
                Text('Today\'s Highlights', style: GoogleFonts.figtree(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.3)),
              ],
            ),
          ),
          Divider(height: 1.h, color: Color(0xFFEBEBEB)),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: ClassesMockData.todaysHighlights.map((highlight) {
                final colorType = highlight['colorType'] as String;
                Color iconColor;
                Color bgColor;
                if (colorType == 'green') {
                  iconColor = Colors.green;
                  bgColor = const Color(0xFFE8F5E9);
                } else if (colorType == 'orange') {
                  iconColor = const Color(0xFFD97706);
                  bgColor = const Color(0xFFFFF7E6);
                } else {
                  iconColor = const Color(0xFF38BDF8);
                  bgColor = const Color(0xFFE0F2FE);
                }

                return Container(
                  margin: EdgeInsets.only(bottom: 12.w),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFEBEBEB)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6.r)),
                        child: Icon(highlight['icon'] as IconData, color: iconColor, size: 16),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(highlight['desc'] as String, style: GoogleFonts.figtree(fontSize: 13.sp, color: _textDark)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
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
        onTap: (index) {
          if (index == 3) {
            // Staff
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const StudentInsightsScreen(), // Assuming this routes correctly for now
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: Duration.zero,
              ),
            );
          } else {
            setState(() {
              _bottomNavIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.show_chart),
              ],
            ),
            activeIcon: Icon(Icons.show_chart),
            label: 'Activity',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }
}
