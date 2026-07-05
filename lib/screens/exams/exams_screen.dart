import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/mock_data/exams_mock.dart';
import '../auth/menu_screen.dart';
import 'create_exam_bottom_sheet.dart';
import 'exam_details_screen.dart';
import '../../widgets/app_bottom_nav.dart';

const _bgPrimary = Color(0xFFF6F6F8);
const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class ExamsScreen extends StatefulWidget {
  const ExamsScreen({super.key});

  @override
  State<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends State<ExamsScreen> {
  int _bottomNavIndex = 1; // Academics
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 2; // 1: Pre-Primary, 2: Primary, 3: Secondary
  String _activeTab = 'Schedule';
  String? _selectedExam;
  String? _selectedPaper;

  bool get _isTablet => MediaQuery.sizeOf(context).width >= 600;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showCreateExamModal() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateExamBottomSheet(),
    );

    if (result != null) {
      setState(() {
        final className = result['class'].toString();
        if (className.contains('Nursery') || className.contains('KG')) {
          ExamsMockData.examsPrePrimary.insert(0, result);
        } else if (className.contains('10') ||
            className.contains('11') ||
            className.contains('12')) {
          ExamsMockData.examsSecondary.insert(0, result);
        } else {
          ExamsMockData.examsPrimary.insert(0, result);
        }
      });
    }
  }

  List<Map<String, dynamic>> get _currentExams {
    List<Map<String, dynamic>> exams;
    if (_selectedFilterIndex == 1) {
      exams = ExamsMockData.examsPrePrimary;
    } else if (_selectedFilterIndex == 2) {
      exams = ExamsMockData.examsPrimary;
    } else {
      exams = ExamsMockData.examsSecondary;
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      return exams
          .where((e) => e['name'].toString().toLowerCase().contains(query))
          .toList();
    }
    return exams;
  }

  List<Map<String, dynamic>> get _currentSeating {
    List<Map<String, dynamic>> baseList;
    if (_selectedFilterIndex == 1)
      baseList = ExamsMockData.seatingPrePrimary;
    else if (_selectedFilterIndex == 2)
      baseList = ExamsMockData.seatingPrimary;
    else
      baseList = ExamsMockData.seatingSecondary;

    // Generate dynamic mock data based on selected exam and paper
    final List<Map<String, dynamic>> dynamicList = [];
    final examName = _selectedExam ?? 'Exam';
    final paperName = _selectedPaper ?? 'Paper';

    // We'll create a few rooms for the selected paper
    for (int i = 0; i < baseList.length; i++) {
      final baseItem = baseList[i];
      final Map<String, dynamic> newItem = Map.from(baseItem);
      newItem['subject'] = '$examName - $paperName';
      newItem['room'] = 'Room ${i + 1}A';
      newItem['roll'] = 'Roll ${i * 30 + 1} - ${(i + 1) * 30}';
      newItem['students'] = 30;
      dynamicList.add(newItem);
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      return dynamicList
          .where(
            (e) =>
                e['subject'].toString().toLowerCase().contains(query) ||
                e['building'].toString().toLowerCase().contains(query),
          )
          .toList();
    }
    return dynamicList;
  }

  List<Map<String, dynamic>> get _currentResultsStudents {
    List<Map<String, dynamic>> list;
    if (_selectedFilterIndex == 1)
      list = ExamsMockData.resultsStudentsPrePrimary;
    else if (_selectedFilterIndex == 2)
      list = ExamsMockData.resultsStudentsPrimary;
    else
      list = ExamsMockData.resultsStudentsSecondary;

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where(
            (e) =>
                e['name'].toString().toLowerCase().contains(query) ||
                e['id'].toString().toLowerCase().contains(query),
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPrimary,
      drawer: const MenuScreen(activeScreen: 'Exams'),
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
                      padding: EdgeInsets.fromLTRB(
                        _isTablet ? 40 : 16,
                        24,
                        _isTablet ? 40 : 16,
                        24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildTabs(),
                          const SizedBox(height: 24),
                          _buildFilterButtons(),
                          const SizedBox(height: 24),
                          if (_activeTab == 'Seating') ...[
                            _buildSeatingControls(),
                            const SizedBox(height: 24),
                            _buildSeatingList(),
                          ] else if (_activeTab == 'Results') ...[
                            _buildResultsView(),
                          ] else ...[
                            _buildSearchAndFilters(),
                            const SizedBox(height: 24),
                            _buildExamsList(),
                          ],
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
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Icon(
                Icons.menu_rounded,
                color: Color(0xFF8F96A3),
                size: 28,
              ),
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF8F96A3),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF8F96A3),
            size: 24,
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF4F1FF),
            child: Text(
              'A',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8463E9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (!_isTablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exams',
                style: GoogleFonts.figtree(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showCreateExamModal,
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: Text(
                  'New Exam',
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule exams across classes, assign invigilators and rooms, and enter results.',
            style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exams',
                style: GoogleFonts.figtree(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Schedule exams across classes, assign invigilators and rooms, and enter results.',
                style: GoogleFonts.figtree(fontSize: 16, color: _textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _showCreateExamModal,
          icon: const Icon(Icons.add, size: 18, color: Colors.white),
          label: Text(
            'New Exam',
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _accent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      padding: const EdgeInsets.all(4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTabItem('Schedule', LucideIcons.calendar),
            _buildTabItem('Seating', LucideIcons.users),
            _buildTabItem('Results', LucideIcons.barChart2),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, IconData icon) {
    bool isSelected = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : _textMuted),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : _textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildFilterButton('Pre-Primary', 1)),
        const SizedBox(width: 8),
        Expanded(child: _buildFilterButton('Primary', 2)),
        const SizedBox(width: 8),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? _accent : const Color(0xFFEBEBEB),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search exam, class, or subject',
                hintStyle: TextStyle(color: Color(0xFF8F96A3), fontSize: 14),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF8F96A3),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        if (!_isTablet) ...[
          const SizedBox(width: 12),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(LucideIcons.filter, color: _textDark, size: 20),
          ),
        ],
        if (_isTablet) ...[
          const SizedBox(width: 16),
          Text(
            '${_currentExams.length} exams',
            style: GoogleFonts.figtree(
              fontSize: 14,
              color: _textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
        ],
      ],
    );
  }

  Widget _buildExamsList() {
    if (_isTablet) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            _buildTableHeader(),
            ..._currentExams.map(_buildDesktopRow),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_currentExams.length} exams',
            style: GoogleFonts.figtree(
              fontSize: 14,
              color: _textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ..._currentExams.map(_buildMobileCard),
        ],
      );
    }
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('EXAM', style: _headerStyle())),
          Expanded(flex: 2, child: Text('CLASS', style: _headerStyle())),
          Expanded(flex: 2, child: Text('TYPE', style: _headerStyle())),
          Expanded(flex: 3, child: Text('SCHEDULE', style: _headerStyle())),
          Expanded(flex: 2, child: Text('STATUS', style: _headerStyle())),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF8F96A3),
  );

  Widget _buildDesktopRow(Map<String, dynamic> item) {
    final isLast = item == _currentExams.last;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F1FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    LucideIcons.clipboardList,
                    color: _accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: GoogleFonts.figtree(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['papers']} papers',
                        style: GoogleFonts.figtree(
                          fontSize: 12,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['class'],
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildTypeBadge(item['type']),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(
                  LucideIcons.calendarDays,
                  size: 16,
                  color: _textMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  item['schedule'],
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildStatusBadge(item['status']),
            ),
          ),
          SizedBox(width: 24, child: _buildPopupMenu(item)),
        ],
      ),
    );
  }

  Widget _buildMobileCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.clipboardList,
                  color: _accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item['papers']} papers',
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPopupMenu(item),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                item['class'],
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(width: 16),
              _buildTypeBadge(item['type']),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.calendarDays,
                    size: 16,
                    color: _textMuted,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['schedule'],
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(item['status']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(Map<String, dynamic> item) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: _textMuted, size: 20),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'View Details') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExamDetailsScreen(exam: item),
            ),
          );
        } else if (value == 'Edit') {
          _showCreateExamModal();
        } else if (value == 'Mark as Complete') {
          setState(() {
            if (item['status'] == 'Completed') {
              item['status'] =
                  'Scheduled'; // Toggle back to Scheduled (or you could store previous state)
            } else {
              item['status'] = 'Completed';
            }
          });
        } else if (value == 'Delete') {
          setState(() {
            ExamsMockData.examsPrePrimary.remove(item);
            ExamsMockData.examsPrimary.remove(item);
            ExamsMockData.examsSecondary.remove(item);
          });
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'View Details',
          child: Row(
            children: [
              const Icon(LucideIcons.eye, size: 16, color: _textMuted),
              const SizedBox(width: 8),
              Text(
                'View Details',
                style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Edit',
          child: Row(
            children: [
              const Icon(LucideIcons.edit2, size: 16, color: _textMuted),
              const SizedBox(width: 8),
              Text(
                'Edit',
                style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Mark as Complete',
          child: Row(
            children: [
              Icon(
                item['status'] == 'Completed'
                    ? LucideIcons.xCircle
                    : LucideIcons.checkCircle,
                size: 16,
                color: _textMuted,
              ),
              const SizedBox(width: 8),
              Text(
                item['status'] == 'Completed'
                    ? 'Mark as Incomplete'
                    : 'Mark as Complete',
                style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'Delete',
          child: Row(
            children: [
              const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Delete',
                style: GoogleFonts.figtree(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1FF),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: GoogleFonts.figtree(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _accent,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;
    if (status == 'Scheduled') {
      color = const Color(0xFF0EA5E9);
      bgColor = const Color(0xFFE0F2FE);
    } else if (status == 'Draft') {
      color = const Color(0xFFF59E0B);
      bgColor = const Color(0xFFFEF3C7);
    } else {
      color = const Color(0xFF22C55E);
      bgColor = const Color(0xFFDCFCE7);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: GoogleFonts.figtree(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSeatingControls() {
    final examNames = _currentExams
        .map((e) => e['name'].toString())
        .toSet()
        .toList();
    if (examNames.isEmpty) examNames.add('No Exams');

    _selectedExam = _selectedExam != null && examNames.contains(_selectedExam)
        ? _selectedExam
        : examNames.first;

    final paperNames = ['Math', 'Science', 'English', 'History', 'Geography'];
    _selectedPaper = _selectedPaper != null ? _selectedPaper : paperNames.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.users, size: 20, color: _textDark),
              const SizedBox(width: 8),
              Text(
                'Seating Arrangement',
                style: GoogleFonts.figtree(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedExam,
                    items: examNames
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: GoogleFonts.figtree(
                                fontSize: 13,
                                color: _textDark,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedExam = v),
                    icon: const Icon(
                      LucideIcons.chevronDown,
                      size: 16,
                      color: _textMuted,
                    ),
                    isDense: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPaper,
                    items: paperNames
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: GoogleFonts.figtree(
                                fontSize: 13,
                                color: _textDark,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedPaper = v),
                    icon: const Icon(
                      LucideIcons.chevronDown,
                      size: 16,
                      color: _textMuted,
                    ),
                    isDense: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatingList() {
    if (_isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 195.h,
        ),
        itemCount: _currentSeating.length,
        itemBuilder: (context, index) =>
            _buildSeatingCardDesktop(_currentSeating[index]),
      );
    } else {
      return Column(
        children: _currentSeating
            .map((item) => _buildSeatingCardMobile(item))
            .toList(),
      );
    }
  }

  Widget _buildSeatingCardDesktop(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['subject'],
                    style: GoogleFonts.figtree(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['date'],
                    style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(LucideIcons.building, size: 16, color: _textMuted),
                  const SizedBox(width: 6),
                  Text(
                    item['building'],
                    style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['room'],
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['roll'],
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        color: _textMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${item['students']} students',
                  style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatingCardMobile(Map<String, dynamic> item) {
    final color = Color(item['color']);
    final bgColor = Color(item['bgColor']);
    final buildingParts = item['building'].split(':');
    final buildingTitle = buildingParts.first;
    final buildingSubtitle = buildingParts.length > 1
        ? buildingParts.last.trim()
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.bookOpen,
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['subject'],
                              style: GoogleFonts.figtree(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['date'],
                              style: GoogleFonts.figtree(
                                fontSize: 13,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            buildingTitle,
                            style: GoogleFonts.figtree(
                              fontSize: 12,
                              color: color.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            buildingSubtitle,
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['room'],
                              style: GoogleFonts.figtree(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['roll'],
                              style: GoogleFonts.figtree(
                                fontSize: 13,
                                color: _textMuted,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${item['students']} students',
                            style: GoogleFonts.figtree(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
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

  Widget _buildResultsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultsControls(),
        const SizedBox(height: 24),
        _buildResultsKpis(),
        const SizedBox(height: 32),
        _buildResultsList(),
      ],
    );
  }

  Widget _buildResultsControls() {
    if (_isTablet) {
      return Row(
        children: [
          Expanded(
            child: _buildResultDropdown('EXAM', 'Unit Test 1 · Class 5A'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildResultDropdown('PAPER', 'English · 2026-07-01'),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildResultDropdown('EXAM', 'Unit Test 1 · Class 5A'),
          SizedBox(height: 12.h),
          _buildResultDropdown('PAPER', 'English · 2026-07-01'),
        ],
      );
    }
  }

  Widget _buildResultDropdown(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF8F96A3),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
              ),
              const Icon(LucideIcons.chevronDown, size: 16, color: _textMuted),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultsKpis() {
    final kpis = [
      {
        'title': 'AVERAGE',
        'value': ExamsMockData.resultsKpis['average'],
        'icon': LucideIcons.history,
        'color': const Color(0xFF8463E9),
        'bgColor': const Color(0xFFF4F1FF),
      },
      {
        'title': 'HIGHEST',
        'value': ExamsMockData.resultsKpis['highest'],
        'icon': LucideIcons.barChart,
        'color': const Color(0xFF22C55E),
        'bgColor': const Color(0xFFDCFCE7),
      },
      {
        'title': 'LOWEST',
        'value': ExamsMockData.resultsKpis['lowest'],
        'icon': LucideIcons.barChart2,
        'color': const Color(0xFFF59E0B),
        'bgColor': const Color(0xFFFEF3C7),
      },
      {
        'title': 'PASS RATE',
        'value': ExamsMockData.resultsKpis['passRate'],
        'icon': LucideIcons.barChart,
        'color': const Color(0xFF0EA5E9),
        'bgColor': const Color(0xFFE0F2FE),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _isTablet ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 125.h,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kpi['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  kpi['icon'] as IconData,
                  color: kpi['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    kpi['title'] as String,
                    style: GoogleFonts.figtree(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8F96A3),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kpi['value'] as String,
                    style: GoogleFonts.figtree(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultsList() {
    return Column(
      children: [
        _buildResultsHeader(),
        const SizedBox(height: 8),
        ..._currentResultsStudents.map(_buildResultRow),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('ROLL', style: _headerStyle())),
          Expanded(flex: 4, child: Text('STUDENT', style: _headerStyle())),
          Expanded(
            flex: 2,
            child: Text(
              'MARKS',
              style: _headerStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'STATUS',
              style: _headerStyle(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(Map<String, dynamic> student) {
    bool isFail = student['status'] == 'Fail';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  student['roll'],
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _accent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['roll'].replaceAll('#', ''),
                  style: GoogleFonts.figtree(fontSize: 11, color: _textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  student['name'],
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 60,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  student['marks'],
                  style: GoogleFonts.figtree(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isFail
                      ? const Color(0xFFFEF2F2)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  student['status'],
                  style: GoogleFonts.figtree(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isFail
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF22C55E),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: Color(0xFFEBEBEB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (i) => setState(() => _bottomNavIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: _accent,
        unselectedItemColor: _textMuted,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Academics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Staff',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}
