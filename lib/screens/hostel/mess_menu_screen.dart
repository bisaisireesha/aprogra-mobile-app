import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../widgets/common_app_bar.dart';
import '../auth/menu_screen.dart';
import '../../widgets/app_bottom_nav.dart';

class MessMenuScreen extends StatelessWidget {
  const MessMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      drawer: const MenuScreen(activeScreen: 'Mess Menu'),
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: CommonAppBar(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildWeeklyMenu(),
                  const SizedBox(height: 24),
                ],
              ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mess Menu',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF181821),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Weekly menu — what is served day by day across all four meals.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.printer,
                      size: 16,
                      color: Color(0xFF181821),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Print',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF181821),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.edit2,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Edit Menu',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          'Breakfast',
          '7:30 - 9:00 AM',
          LucideIcons.coffee,
          const Color(0xFFF59E0B),
          const Color(0xFFFEF3C7),
        ),
        _buildStatCard(
          'Lunch',
          '12:30 - 2:00 PM',
          LucideIcons.utensils,
          const Color(0xFF10B981),
          const Color(0xFFD1FAE5),
        ),
        _buildStatCard(
          'Snacks',
          '4:30 - 5:30 PM',
          LucideIcons.cookie,
          const Color(0xFF0EA5E9),
          const Color(0xFFE0F2FE),
        ),
        _buildStatCard(
          'Dinner',
          '7:30 - 9:00 PM',
          LucideIcons.moon,
          const Color(0xFF8B5CF6),
          const Color(0xFFEDE9FE),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color iconBgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
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
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.fileEdit,
              size: 18,
              color: Color(0xFF595973),
            ),
            const SizedBox(width: 8),
            Text(
              "This Week's Menu",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF181821),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Highlighted row shows today.',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: const Color(0xFF94A3B8),
          ),
        ),
        SizedBox(height: 12.h),
        ExpandableDayItem(
          day: 'Monday',
          letter: 'M',
          isToday: true,
          breakfast: const ['Poha', 'Boiled Egg', 'Banana', 'Tea / Milk'],
          lunch: const [
            'Rice',
            'Dal Tadka',
            'Aloo Gobi',
            'Chapati',
            'Salad',
            'Curd',
          ],
          snacks: const ['Vegetable Sandwich', 'Tea / Coffee'],
          dinner: const [
            'Chapati',
            'Rajma',
            'Jeera Rice',
            'Mixed Veg',
            'Pickle',
          ],
        ),
        ExpandableDayItem(
          day: 'Tuesday',
          letter: 'T',
          isToday: false,
          breakfast: const [
            'Idli & Sambar',
            'Coconut Chutney',
            'Fruit',
            'Tea / Milk',
          ],
          lunch: const ['Rice', 'Sambar', 'Beans Poriyal', 'Chapati', 'Curd'],
          snacks: const ['Samosa', 'Tea / Coffee'],
          dinner: const ['Chapati', 'Chole', 'Veg Pulao', 'Raita'],
        ),
        ExpandableDayItem(
          day: 'Wednesday',
          letter: 'W',
          isToday: false,
          breakfast: const [
            'Paratha & Curd',
            'Omelette',
            'Apple',
            'Tea / Milk',
          ],
          lunch: const [
            'Jeera Rice',
            'Dal Fry',
            'Paneer Butter Masala',
            'Roti',
            'Salad',
          ],
          snacks: const ['Pakora', 'Tea / Coffee'],
          dinner: const ['Chapati', 'Dal Makhani', 'Rice', 'Gulab Jamun'],
        ),
        ExpandableDayItem(
          day: 'Thursday',
          letter: 'T',
          isToday: false,
          breakfast: const ['Upma', 'Banana', 'Tea / Milk'],
          lunch: const ['Kadhi', 'Rice', 'Egg Curry', 'Roti', 'Salad'],
          snacks: const ['Biscuits', 'Tea / Coffee'],
          dinner: const ['Chapati', 'Aloo Matar', 'Rice', 'Pickle'],
        ),
        ExpandableDayItem(
          day: 'Friday',
          letter: 'F',
          isToday: false,
          breakfast: const ['Sandwich', 'Milk', 'Fruit'],
          lunch: const ['Biryani', 'Raita', 'Salad'],
          snacks: const ['Puffs', 'Tea / Coffee'],
          dinner: const ['Chowmein', 'Manchurian', 'Fried Rice'],
        ),
        ExpandableDayItem(
          day: 'Saturday',
          letter: 'S',
          isToday: false,
          breakfast: const ['Dosa', 'Chutney', 'Tea / Milk'],
          lunch: const ['Special Thali', 'Sweet', 'Salad'],
          snacks: const ['Cake', 'Tea / Coffee'],
          dinner: const ['Pav Bhaji', 'Pulao', 'Salad'],
        ),
        ExpandableDayItem(
          day: 'Sunday',
          letter: 'S',
          isToday: false,
          breakfast: const ['Puri', 'Aloo', 'Tea / Milk'],
          lunch: const ['Chicken / Mushroom', 'Rice', 'Roti', 'Salad'],
          snacks: const ['Chips', 'Tea / Coffee'],
          dinner: const ['Fried Rice', 'Dessert', 'Salad'],
        ),
      ],
    );
  }
}

class ExpandableDayItem extends StatefulWidget {
  final String day;
  final String letter;
  final bool isToday;
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> snacks;
  final List<String> dinner;

  const ExpandableDayItem({
    super.key,
    required this.day,
    required this.letter,
    required this.isToday,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
  });

  @override
  State<ExpandableDayItem> createState() => _ExpandableDayItemState();
}

class _ExpandableDayItemState extends State<ExpandableDayItem> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.isToday) {
      _isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _isExpanded ? const Color(0xFFF8F5FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              if (!_isExpanded) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.isToday
                        ? const Color(0xFFEDE9FE)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.letter,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: widget.isToday
                          ? const Color(0xFF6366F1)
                          : const Color(0xFF181821),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                widget.day,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
              if (_isExpanded && widget.isToday) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Today',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isExpanded)
                Text(
                  '4 meals',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF595973),
                  ),
                ),
              if (!_isExpanded) const SizedBox(width: 8),
              Icon(
                _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                color: const Color(0xFF6366F1),
                size: 20,
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _buildMealCard(
                    'Breakfast',
                    '7:30 - 9:00 AM',
                    LucideIcons.coffee,
                    const Color(0xFFF59E0B),
                    const Color(0xFFFEF3C7),
                    widget.breakfast,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    'Lunch',
                    '12:30 - 2:00 PM',
                    LucideIcons.utensils,
                    const Color(0xFF10B981),
                    const Color(0xFFD1FAE5),
                    widget.lunch,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    'Snacks',
                    '4:30 - 5:30 PM',
                    LucideIcons.cookie,
                    const Color(0xFF0EA5E9),
                    const Color(0xFFE0F2FE),
                    widget.snacks,
                  ),
                  const SizedBox(height: 12),
                  _buildMealCard(
                    'Dinner',
                    '7:30 - 9:00 PM',
                    LucideIcons.moon,
                    const Color(0xFF8B5CF6),
                    const Color(0xFFEDE9FE),
                    widget.dinner,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(
    String title,
    String time,
    IconData icon,
    Color iconColor,
    Color iconBg,
    List<String> items,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF181821),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
