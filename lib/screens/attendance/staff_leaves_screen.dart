import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../auth/menu_screen.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StaffLeavesScreen extends StatefulWidget {
  const StaffLeavesScreen({super.key});

  @override
  State<StaffLeavesScreen> createState() => _StaffLeavesScreenState();
}

class _StaffLeavesScreenState extends State<StaffLeavesScreen> {
  int _bottomNavIndex = 3; // 'Staff' is index 3
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'All';

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  List<Map<String, dynamic>> _leaves = [
    {
      'name': 'Priya Sharma',
      'department': 'Mathematics',
      'status': 'Pending',
      'type': 'Sick',
      'dateRange': '20 May - 22 May 2025',
      'duration': '3 Days',
      'reason': 'Fever and rest',
    },
    {
      'name': 'Rajan Pillai',
      'department': 'Science',
      'status': 'Approved',
      'type': 'Casual',
      'dateRange': '18 May 2025',
      'duration': '1 Day',
      'reason': 'Personal work',
    },
    {
      'name': 'Meena Krishnamurthy',
      'department': 'English',
      'status': 'Approved',
      'type': 'Earned',
      'dateRange': '15 May - 20 May 2025',
      'duration': '6 Days',
      'reason': 'Family function',
    },
    {
      'name': 'Suresh Kumar',
      'department': 'Social Studies',
      'status': 'Pending',
      'type': 'Casual',
      'dateRange': '21 May 2025',
      'duration': '1 Day',
      'reason': 'Bank visit',
    },
    {
      'name': 'Anita Desai',
      'department': 'Hindi',
      'status': 'Approved',
      'type': 'Maternity',
      'dateRange': '01 Jun - 30 Aug 2025',
      'duration': '90 Days',
      'reason': 'Maternity leave',
    },
    {
      'name': 'Vikram Singh',
      'department': 'Physical Education',
      'status': 'Rejected',
      'type': 'Casual',
      'dateRange': '10 May 2025',
      'duration': '1 Day',
      'reason': 'Attending a match',
    },
    {
      'name': 'Sunita Rao',
      'department': 'Administration',
      'status': 'Pending',
      'type': 'Earned',
      'dateRange': '05 Jun - 10 Jun 2025',
      'duration': '6 Days',
      'reason': 'Vacation',
    },
    {
      'name': 'Ravi Patel',
      'department': 'Computer Science',
      'status': 'Approved',
      'type': 'Sick',
      'dateRange': '12 May - 13 May 2025',
      'duration': '2 Days',
      'reason': 'Viral fever',
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadLeaves();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  
  Future<void> _loadLeaves() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__leaves_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _leaves = decoded.map((item) {
          final map = Map<String, dynamic>.from(item);
          for (final key in map.keys.toList()) {
            if (key.toLowerCase().contains('color') && map[key] is int) {
              map[key] = Color(map[key] as int);
            }
          }
          return map;
        }).toList();
      });
    }
  }

  Future<void> _saveLeaves() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _leaves.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__leaves_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Leaves'),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(_isTablet ? 40 : 16, 24, _isTablet ? 40 : 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildHeader()),
                              if (_isTablet) _buildTopControls(),
                            ],
                          ),
                          if (!_isTablet) ...[
                            const SizedBox(height: 16),
                            _buildTopControls(),
                          ],
                          const SizedBox(height: 24),
                          _buildStatsRow(),
                          const SizedBox(height: 24),
                          if (_isTablet)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildTabsRow(),
                                      const SizedBox(height: 24),
                                      _buildLeaveList(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLeaveBalanceCard(),
                                      const SizedBox(height: 24),
                                      _buildUpcomingLeavesCard(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLeaveBalanceCard(),
                                const SizedBox(height: 24),
                                _buildUpcomingLeavesCard(),
                                const SizedBox(height: 24),
                                _buildTabsRow(),
                                const SizedBox(height: 24),
                                _buildLeaveList(),
                              ],
                            ),
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

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(LucideIcons.menu, color: _textDark),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
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
                    hintText: 'Search by staff name or reason...',
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
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFF4F1FF),
              child: Text('A', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Home', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text('Staff', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            const Icon(Icons.chevron_right, size: 14, color: Color(0xFF6B7280)),
            Text('Leaves', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        const SizedBox(height: 16),
        Text('Leave Management', style: GoogleFonts.figtree(fontSize: _isTablet ? 32 : 28, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 8),
        Text(
          "Review leave requests, manage approvals, and track staff leave balances.",
          style: GoogleFonts.figtree(fontSize: _isTablet ? 16 : 14, color: _textMuted),
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: _showNewRequestSheet,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.plus, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text('New Request', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.count(
          crossAxisCount: _isTablet ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: _isTablet ? 1.4 : 1.05,
          children: [
            _buildKpiCard('8', 'Pending Approvals', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
            _buildKpiCard('34', 'Approved This Month', LucideIcons.checkCircle, const Color(0xFF22C55E), const Color(0xFFDCFCE7)),
            _buildKpiCard('5', 'Rejected', LucideIcons.xCircle, const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
            _buildKpiCard('3', 'Currently On Leave', LucideIcons.users, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard(String value, String title, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
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
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.figtree(fontSize: 28, fontWeight: FontWeight.w900, color: _textDark, height: 1.0),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsRow() {
    final pendingCount = _leaves.where((l) => l['status'] == 'Pending').length;
    final approvedCount = _leaves.where((l) => l['status'] == 'Approved').length;
    final rejectedCount = _leaves.where((l) => l['status'] == 'Rejected').length;
    final allCount = _leaves.length;

    final tabs = [
      {'name': 'All', 'label': 'All'},
      {'name': 'Pending', 'label': 'Pending'},
      {'name': 'Approved', 'label': 'Approved'},
      {'name': 'Rejected', 'label': 'Rejected'},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: tabs.map((tab) {
            final isSelected = _selectedTab == tab['name'];
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = tab['name']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tab['label']!,
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : _textMuted,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLeaveDetails(Map<String, dynamic> leave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.80,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            // Header
            Row(
              children: [
                _buildAvatar(leave['name']),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(leave['name'], style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(height: 4),
                      Text(leave['department'], style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
                    ],
                  ),
                ),
                _buildStatusBadge(leave['status']),
              ],
            ),
            const SizedBox(height: 20),
            // Details container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Column(
                children: [
                  _buildLeaveDetailRow('Leave Type', leave['type']),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildLeaveDetailRow('Date Range', leave['dateRange']),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildLeaveDetailRow('Duration', leave['duration']),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildLeaveDetailRow('Reason', leave['reason']),
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  _buildLeaveDetailRow('Status', leave['status']),
                ],
              ),
            ),
            const Spacer(),
            if (leave['status'] == 'Pending')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFEF4444)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Reject', style: GoogleFonts.figtree(fontSize: 16, color: const Color(0xFFEF4444), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text('Approve', style: GoogleFonts.figtree(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text('Close', style: GoogleFonts.figtree(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
          Flexible(
            child: Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark), textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveList() {
    final query = _searchController.text.toLowerCase();
    final filtered = _leaves.where((item) {
      final matchesTab = _selectedTab == 'All' || item['status'] == _selectedTab;
      final matchesSearch = query.isEmpty || 
          item['name'].toString().toLowerCase().contains(query) || 
          item['reason'].toString().toLowerCase().contains(query);
      return matchesTab && matchesSearch;
    }).toList();

    return Column(
      children: filtered.map((item) {
        return GestureDetector(
          onTap: () => _showLeaveDetails(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAvatar(item['name']),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'], style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _textDark)),
                          const SizedBox(height: 2),
                          Text(item['department'], style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
                          const SizedBox(height: 12),
                          _buildTypeBadge(item['type']),
                        ],
                      ),
                    ),
                    _buildStatusBadge(item['status']),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.calendarDays, size: 16, color: _textMuted),
                        const SizedBox(width: 8),
                        Text(item['dateRange'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
                      ],
                    ),
                    Text(item['duration'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['reason'], style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAvatar(String name) {
    String initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
    
    final colors = [
      (const Color(0xFFFCE7F3), const Color(0xFFDB2777)), // Pink
      (const Color(0xFFE0F2FE), const Color(0xFF0EA5E9)), // Blue
      (const Color(0xFFF3E8FF), const Color(0xFF9333EA)), // Purple
      (const Color(0xFFE0E7FF), const Color(0xFF4F46E5)), // Indigo
    ];
    int hash = name.codeUnits.fold(0, (a, b) => a + b);
    final bg = colors[hash % colors.length].$1;
    final fg = colors[hash % colors.length].$2;

    return CircleAvatar(
      radius: 22,
      backgroundColor: bg,
      child: Text(initials, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg, fg;
    if (status == 'Approved') {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF22C55E);
    } else if (status == 'Rejected') {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFFEF4444);
    } else {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFF59E0B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _buildTypeBadge(String type) {
    Color bg, fg;
    if (type == 'Sick') {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFFEF4444);
    } else if (type == 'Casual') {
      bg = const Color(0xFFE0F2FE);
      fg = const Color(0xFF0EA5E9);
    } else { // Earned, Maternity
      bg = const Color(0xFFF3E8FF);
      fg = const Color(0xFF9333EA);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(type, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), activeIcon: Icon(Icons.school), label: 'Academics'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }

  Widget _buildLeaveBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Leave Balance (Avg)', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 4),
          Text('Average remaining across all staff', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          const SizedBox(height: 24),
          _buildProgressRow('Casual', 8, 12),
          const SizedBox(height: 16),
          _buildProgressRow('Sick', 7, 10),
          const SizedBox(height: 16),
          _buildProgressRow('Earned', 12, 20),
          const SizedBox(height: 16),
          _buildProgressRow('Maternity', 90, 90),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, int current, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
            Text('$current/$total left', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: const Color(0xFFF3F4F6),
            color: const Color(0xFF9D84F0),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingLeavesCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upcoming Leaves', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 24),
          _buildUpcomingLeaveItem('Anita Desai', 'Maternity', '01 Jun – 30 Aug', '90 days'),
          const SizedBox(height: 20),
          _buildUpcomingLeaveItem('Deepa Iyer', 'Casual', '23 May – 24 May', '2 days'),
          const SizedBox(height: 20),
          _buildUpcomingLeaveItem('Sanjay Verma', 'Earned', '26 May – 28 May', '3 days'),
        ],
      ),
    );
  }

  Widget _buildUpcomingLeaveItem(String name, String type, String dates, String duration) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(LucideIcons.calendarDays, size: 20, color: Color(0xFFF59E0B)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
              const SizedBox(height: 4),
              Text('$type · $dates', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
              const SizedBox(height: 4),
              Text(duration, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
    );
  }

  Widget _buildDropdown({required String hint, required String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
          value: value,
          icon: const Icon(LucideIcons.chevronDown, size: 16, color: _textDark),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDatePicker({required String hint, required DateTime? date, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? '${date.day} ${_monthString(date.month)} ${date.year}' : hint,
              style: TextStyle(color: date != null ? _textDark : const Color(0xFF9CA3AF), fontSize: 14),
            ),
            const Icon(LucideIcons.calendarDays, size: 16, color: _textDark),
          ],
        ),
      ),
    );
  }

  String _monthString(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _showNewRequestSheet() {
    String? selectedStaff;
    String? selectedType;
    DateTime? startDate;
    DateTime? endDate;
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final totalDays = (startDate != null && endDate != null)
                ? endDate!.difference(startDate!).inDays + 1
                : 0;

            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(LucideIcons.arrowLeft, color: _textDark),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          Text('New Leave Request', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormLabel('Staff Member'),
                          _buildDropdown(
                            hint: 'Select staff member',
                            value: selectedStaff,
                            items: const ['Anita Desai', 'Deepa Iyer', 'Sanjay Verma', 'Meena Krishnamurthy', 'Rajan Pillai'],
                            onChanged: (v) => setModalState(() => selectedStaff = v),
                          ),
                          const SizedBox(height: 16),
                          _buildFormLabel('Leave Type'),
                          _buildDropdown(
                            hint: 'Select leave type',
                            value: selectedType,
                            items: const ['Casual', 'Sick', 'Earned', 'Maternity'],
                            onChanged: (v) => setModalState(() => selectedType = v),
                          ),
                          const SizedBox(height: 16),
                          _buildFormLabel('Start Date'),
                          _buildDatePicker(
                            hint: 'Select start date',
                            date: startDate,
                            onTap: () async {
                              final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                              if (picked != null) setModalState(() => startDate = picked);
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildFormLabel('End Date'),
                          _buildDatePicker(
                            hint: 'Select end date',
                            date: endDate,
                            onTap: () async {
                              final picked = await showDatePicker(context: context, initialDate: startDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                              if (picked != null) setModalState(() => endDate = picked);
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildFormLabel('Total Days'),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('${totalDays > 0 ? totalDays : 0} Days', style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                          ),
                          const SizedBox(height: 16),
                          _buildFormLabel('Reason'),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: reasonController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: 'Enter reason for leave...',
                                hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFormLabel('Attachment (Optional)'),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFE5E7EB), style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Icon(LucideIcons.upload, color: _textDark, size: 24),
                                const SizedBox(height: 8),
                                Text('Upload Document', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                                const SizedBox(height: 4),
                                Text('PDF, JPG, PNG up to 5MB', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedStaff != null && selectedType != null && startDate != null && endDate != null) {
                          setState(() {
                            _leaves.insert(0, {
                              'name': selectedStaff,
                              'department': 'Operations',
                              'status': 'Pending',
                              'type': selectedType,
                              'dateRange': '${startDate!.day} ${_monthString(startDate!.month)} - ${endDate!.day} ${_monthString(endDate!.month)} ${endDate!.year}',
                              'duration': '${totalDays > 0 ? totalDays : 0} Days',
                              'reason': reasonController.text.isNotEmpty ? reasonController.text : 'No reason provided',
                            });
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text('Submit Request', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
