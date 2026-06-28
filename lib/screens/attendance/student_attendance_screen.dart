import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/mock_data/student_attendance_mock.dart';
import '../auth/menu_screen.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  int _bottomNavIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 2; // Default: Primary

  DateTime _selectedDate = DateTime(2026, 6, 27);
  String _selectedClass = 'All Classes';
  String _selectedSection = 'All Sections';
  String _selectedStatus = 'All Status';
  bool _isLocked = false;

  List<Map<String, dynamic>> _roster = [];

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void initState() {
    super.initState();
    // Create a copy of mock data so we can modify statuses/remarks locally
    _roster = StudentAttendanceMockData.attendanceRoster.map((e) => Map<String, dynamic>.from(e)).toList();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _currentCategory =>
      _selectedFilterIndex == 1 ? 'Pre-Primary' : _selectedFilterIndex == 2 ? 'Primary' : 'Secondary';

  List<Map<String, dynamic>> get _filteredRoster {
    final query = _searchController.text.toLowerCase();
    return _roster.where((item) {
      final matchesCategory = item['category'] == _currentCategory;
      final matchesQuery = query.isEmpty ||
          (item['name'] as String).toLowerCase().contains(query) ||
          (item['admNo'] as String).toLowerCase().contains(query) ||
          (item['class'] as String).toLowerCase().contains(query);
          
      final matchesClass = _selectedClass == 'All Classes' || item['class'] == _selectedClass;
      final matchesSection = _selectedSection == 'All Sections' || item['section'] == _selectedSection;
      final matchesStatus = _selectedStatus == 'All Status' || item['status'] == _selectedStatus;

      return matchesCategory && matchesQuery && matchesClass && matchesSection && matchesStatus;
    }).toList();
  }

  void _handleMark(Map<String, dynamic> item, String mark) {
    setState(() {
      if (mark == 'P') {
        item['status'] = 'Present';
      } else if (mark == 'A') {
        item['status'] = 'Absent';
      } else if (mark == 'L') {
        item['status'] = 'Late';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Student Attendance'),
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
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildTopControls(),
                          const SizedBox(height: 24),
                          _buildSearchAndFilters(),
                          const SizedBox(height: 24),
                          _buildStatsRow(),
                          const SizedBox(height: 24),
                          _buildRosterList(),
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
      floatingActionButton: !_isTablet ? FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance saved successfully!')));
        },
        backgroundColor: _accent,
        icon: const Icon(LucideIcons.save, color: Colors.white, size: 20),
        label: Text('Save', style: GoogleFonts.figtree(fontWeight: FontWeight.bold, color: Colors.white)),
      ) : null,
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Builder(builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu_rounded, color: Color(0xFF8F96A3), size: 28),
          )),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Student Attendance', style: GoogleFonts.figtree(fontSize: _isTablet ? 32 : 28, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 8),
        Text(
          'Mark and review daily attendance · ${_selectedDate.day} ${_monthString(_selectedDate.month)} ${_selectedDate.year}',
          style: GoogleFonts.figtree(fontSize: _isTablet ? 16 : 14, color: _textMuted),
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _isTablet ? 400 : double.infinity,
          child: Row(
            children: [
              Expanded(child: _buildCategoryBtn('Pre-Primary', 1)),
              const SizedBox(width: 8),
              Expanded(child: _buildCategoryBtn('Primary', 2)),
              const SizedBox(width: 8),
              Expanded(child: _buildCategoryBtn('Secondary', 3)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildActionBtn('Export', LucideIcons.download),
              const SizedBox(width: 8),
              _buildActionBtn(_isLocked ? 'Unlock' : 'Lock', _isLocked ? LucideIcons.unlock : LucideIcons.lock, onTap: () {
                setState(() {
                  _isLocked = !_isLocked;
                });
              }),
              const SizedBox(width: 8),
              _buildActionBtn('Mark All Present', LucideIcons.check, onTap: () {
                if (_isLocked) return;
                setState(() {
                  for (var item in _filteredRoster) {
                    item['status'] = 'Present';
                  }
                });
              }),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance saved successfully!')));
                },
                child: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.save, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBtn(String label, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
          boxShadow: isSelected ? [BoxShadow(color: _accent.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn(String label, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _textDark),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search name, roll, admission no',
                hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8F96A3), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _showFilterBottomSheet,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.filter, color: _textDark, size: 20),
                if (_isTablet) ...[
                  const SizedBox(width: 8),
                  Text('Filters', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    DateTime tempDate = _selectedDate;
    String tempClass = _selectedClass;
    String tempSection = _selectedSection;
    String tempStatus = _selectedStatus;

    final availableClasses = ['All Classes', 'Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'];
    final availableSections = ['All Sections', 'A', 'B', 'C', 'D'];
    final availableStatuses = ['All Status', 'Present', 'Absent', 'Late', 'On Leave'];

    if (!availableClasses.contains(tempClass)) tempClass = 'All Classes';
    if (!availableSections.contains(tempSection)) tempSection = 'All Sections';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Filters', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) setModalState(() => tempDate = picked);
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.calendarDays, size: 16, color: _textMuted),
                            const SizedBox(width: 8),
                            Expanded(child: Text('${tempDate.day} ${_monthString(tempDate.month)} ${tempDate.year}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w500, color: _textDark))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRealDropdown(
                      value: tempClass,
                      items: availableClasses,
                      onChanged: (v) => setModalState(() => tempClass = v!),
                    ),
                    const SizedBox(height: 16),
                    _buildRealDropdown(
                      value: tempSection,
                      items: availableSections,
                      onChanged: (v) => setModalState(() => tempSection = v!),
                    ),
                    const SizedBox(height: 16),
                    _buildRealDropdown(
                      value: tempStatus,
                      items: availableStatuses,
                      onChanged: (v) => setModalState(() => tempStatus = v!),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDate = tempDate;
                            _selectedClass = tempClass;
                            _selectedSection = tempSection;
                            _selectedStatus = tempStatus;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: _accent, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text('Apply Filters', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _monthString(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildRealDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(LucideIcons.chevronDown, size: 16, color: _textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w500, color: _textDark)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    int total = _filteredRoster.length;
    int present = _filteredRoster.where((r) => r['status'] == 'Present').length;
    int absent = _filteredRoster.where((r) => r['status'] == 'Absent').length;
    int late = _filteredRoster.where((r) => r['status'] == 'Late').length;
    int onLeave = _filteredRoster.where((r) => r['status'] == 'On Leave').length;

    int presentPct = total > 0 ? ((present / total) * 100).round() : 0;
    int absentPct = total > 0 ? ((absent / total) * 100).round() : 0;

    if (_isTablet) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildHorizontalStatCard('Total Students', '$total', '', LucideIcons.users, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
            const SizedBox(width: 16),
            _buildHorizontalStatCard('Present', '$present', '$presentPct%', LucideIcons.userCheck, const Color(0xFF22C55E), const Color(0xFFDCFCE7)),
            const SizedBox(width: 16),
            _buildHorizontalStatCard('Absent', '$absent', '$absentPct%', LucideIcons.userX, const Color(0xFFEF4444), const Color(0xFFFEE2E2)),
            const SizedBox(width: 16),
            _buildHorizontalStatCard('Late', '$late', '', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
            const SizedBox(width: 16),
            _buildHorizontalStatCard('On Leave', '$onLeave', '', LucideIcons.fileMinus, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE)),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildVerticalStatCard('Total Students', '$total', '', LucideIcons.users, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE))),
              const SizedBox(width: 8),
              Expanded(child: _buildVerticalStatCard('Present', '$present', '$presentPct%', LucideIcons.userCheck, const Color(0xFF22C55E), const Color(0xFFDCFCE7))),
              const SizedBox(width: 8),
              Expanded(child: _buildVerticalStatCard('Absent', '$absent', '$absentPct%', LucideIcons.userX, const Color(0xFFEF4444), const Color(0xFFFEE2E2))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildHorizontalStatCard('Late', '$late', '', LucideIcons.clock, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
              const SizedBox(width: 12),
              Expanded(child: _buildHorizontalStatCard('On Leave', '$onLeave', '', LucideIcons.fileMinus, const Color(0xFF0EA5E9), const Color(0xFFE0F2FE))),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildVerticalStatCard(String title, String value, String subtitle, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF595973)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.figtree(fontSize: 22, fontWeight: FontWeight.bold, color: _textDark, height: 1.0),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle.isNotEmpty ? subtitle : ' ',
            style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: subtitle.isNotEmpty ? iconColor : Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalStatCard(String title, String value, String subtitle, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: _isTablet ? 190 : null,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF595973)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark, height: 1.0),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: iconColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRosterList() {
    return Container(
      decoration: BoxDecoration(
        color: _isTablet ? Colors.white : Colors.transparent, 
        borderRadius: BorderRadius.circular(12), 
        border: _isTablet ? Border.all(color: const Color(0xFFE5E7EB)) : null
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isTablet)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
              child: Row(children: [
                Expanded(child: Text('Roster  ${_filteredRoster.length} of ${_filteredRoster.length}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark))),
                Text(_isLocked ? 'Locked mode' : 'Editing mode', style: GoogleFonts.figtree(fontSize: 13, color: _isLocked ? const Color(0xFFEF4444) : _textMuted)),
              ]),
            )
          else 
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Roster • ${_filteredRoster.length} of ${_filteredRoster.length}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                  Text(_isLocked ? 'Locked' : 'Edit', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _isLocked ? const Color(0xFFEF4444) : _accent)),
                ],
              ),
            ),
          if (_filteredRoster.isEmpty)
            Padding(padding: const EdgeInsets.all(32), child: Text('No students found.', style: GoogleFonts.figtree(fontSize: 16, color: _textMuted))),
          if (_filteredRoster.isNotEmpty && _isTablet)
            _buildTableHeader(),
          if (_isTablet) ..._filteredRoster.map(_buildDesktopRow) else ..._filteredRoster.map(_buildMobileCard),
        ],
      ),
    );
  }
  
  Widget _buildMobileCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 20, child: Text(item['roll'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark))),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFF4F1FF),
                child: Icon(LucideIcons.user, size: 20, color: Color(0xFF8463E9)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 2),
                    Text(item['admNo'], style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ),
              _buildStatusBadge(item['status']),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(width: 40, child: Text(item['checkIn'], style: GoogleFonts.figtree(fontSize: 12, color: _textDark, fontWeight: FontWeight.w500))),
              const SizedBox(width: 12),
              Expanded(child: Text('${item['class']} • Section ${item['section']}', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted))),
              _buildMarkControls(item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(Map<String, dynamic> item) {
    final isLast = item == _filteredRoster.last;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 50, child: Text(item['roll'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark))),
          Expanded(flex: 3, child: Row(children: [
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFF4F1FF),
              child: Icon(LucideIcons.user, size: 16, color: Color(0xFF8463E9)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item['name'], style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
              Text(item['admNo'], style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            ])),
          ])),
          Expanded(flex: 2, child: Text(item['class'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark))),
          Expanded(flex: 2, child: Text(item['section'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark))),
          Expanded(flex: 2, child: _buildStatusBadge(item['status'])),
          Expanded(flex: 2, child: Text(item['checkIn'], style: GoogleFonts.figtree(fontSize: 14, color: _textDark))),
          Expanded(flex: 2, child: _buildMarkControls(item)),
          Expanded(flex: 3, child: _buildRemarksField(item)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB)))),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text('Roll', style: _headerStyle())),
          Expanded(flex: 3, child: Text('Student', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Class', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Section', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Status', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Check-in', style: _headerStyle())),
          Expanded(flex: 2, child: Text('Mark', style: _headerStyle())),
          Expanded(flex: 3, child: Text('Remarks', style: _headerStyle())),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF8F96A3));

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;
    if (status == 'Present') { color = const Color(0xFF22C55E); bgColor = const Color(0xFFDCFCE7); }
    else if (status == 'Absent') { color = const Color(0xFFEF4444); bgColor = const Color(0xFFFEE2E2); }
    else if (status == 'Late') { color = const Color(0xFFF59E0B); bgColor = const Color(0xFFFEF3C7); }
    else { color = const Color(0xFF3B82F6); bgColor = const Color(0xFFDBEAFE); } // On Leave

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(status, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildMarkControls(Map<String, dynamic> item) {
    final status = item['status'];
    return Opacity(
      opacity: _isLocked ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFE5E7EB))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMarkBtn('P', status == 'Present', const Color(0xFF22C55E), () { if (!_isLocked) _handleMark(item, 'P'); }),
            Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
            _buildMarkBtn('A', status == 'Absent', const Color(0xFFEF4444), () { if (!_isLocked) _handleMark(item, 'A'); }),
            Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
            _buildMarkBtn('L', status == 'Late', const Color(0xFFF59E0B), () { if (!_isLocked) _handleMark(item, 'L'); }),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkBtn(String label, bool isSelected, Color activeColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: isSelected ? activeColor : Colors.transparent),
        child: Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : _textDark)),
      ),
    );
  }

  Widget _buildRemarksField(Map<String, dynamic> item) {
    return Container(
      height: 36,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: TextField(
        enabled: !_isLocked,
        controller: TextEditingController(text: item['remarks']),
        onChanged: (val) => item['remarks'] = val,
        decoration: const InputDecoration(
          hintText: 'Add note...',
          hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
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
        onTap: (i) => setState(() => _bottomNavIndex = i),
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

  Widget _buildMobileBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.save, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Save Attendance', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
