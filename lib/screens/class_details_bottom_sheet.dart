import 'package:flutter/material.dart';
import '../data/mock_data/dashboard_mock.dart';

const _bgColor = Color(0xFFFAF9FF);
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF6C5CE7);
const _borderColor = Color(0xFFEBEBEB);

class ClassDetailsBottomSheet extends StatefulWidget {
  final String className;
  
  const ClassDetailsBottomSheet({super.key, required this.className});

  @override
  State<ClassDetailsBottomSheet> createState() => _ClassDetailsBottomSheetState();
}

class _ClassDetailsBottomSheetState extends State<ClassDetailsBottomSheet> {
  String _selectedSection = 'All';
  String _selectedTab = 'Overview';
  final Map<String, int> _selectedDayIndices = {};
  int _currentStudentPage = 1;
  String _chartFilter = 'Week';
  String _selectedStudentFilter = 'All';
  String _selectedAttendanceFilter = 'Today';
  static const int _studentsPerPage = 10;
  
  // Custom edited timetables: Section -> DayIndex -> List of Periods
  final Map<String, Map<int, List<Map<String, String>>>> _customTimetables = {};
  
  List<Map<String, dynamic>> _teachersData = [];
  List<String> _timetableSubjects = [];
  List<Map<String, dynamic>> _syllabusData = [];
  List<Map<String, String>> _upcomingExamsData = [];
  List<Map<String, String>> _completedExamsData = [];

  @override
  void initState() {
    super.initState();
    _ensureDataInitialized();
  }
  
  void _ensureDataInitialized() {
    if (_teachersData.isEmpty) {
      _teachersData = [
        {
          'name': 'Meera Joshi',
          'students': 25,
          'section': '${widget.className.toUpperCase()} A',
          'avatar': 'https://i.pravatar.cc/150?u=meera',
        },
        {
          'name': 'Riya Kapoor',
          'students': 24,
          'section': '${widget.className.toUpperCase()} B',
          'avatar': 'https://i.pravatar.cc/150?u=riya2',
        },
      ];
    }
    
    final lowerClass = widget.className.toLowerCase();
    final isUKG = lowerClass.contains('ukg') || lowerClass.contains('nursery') || lowerClass.contains('lkg');
    final is1to5 = lowerClass.contains('class 1') || lowerClass.contains('class 2') || lowerClass.contains('class 3') || lowerClass.contains('class 4') || lowerClass.contains('class 5');
    
    if (_timetableSubjects.isEmpty) {
      _timetableSubjects = isUKG 
          ? ['Music & Rhymes', 'Interactive Play', 'Story Time', 'Art & Craft']
          : (is1to5 ? ['English Grammar', 'Basic Math', 'Environmental Science', 'Physical Education'] 
                       : ['Advanced Mathematics', 'Physics', 'Chemistry', 'Computer Science']);
    }
                     
    if (_syllabusData.isEmpty) {
      _syllabusData = isUKG 
          ? [
              {'name': 'Play', 'teacher': 'Meera Joshi', 'progress': 0.60, 'icon': Icons.toys_outlined, 'color': const Color(0xFF7B61FF)},
              {'name': 'Rhymes', 'teacher': 'Riya Kapoor', 'progress': 0.57, 'icon': Icons.menu_book_outlined, 'color': const Color(0xFF3498DB)},
              {'name': 'Story Time', 'teacher': 'Meera Joshi', 'progress': 0.89, 'icon': Icons.auto_stories_outlined, 'color': const Color(0xFF2EBA7C)},
              {'name': 'Art & Craft', 'teacher': 'Riya Kapoor', 'progress': 0.68, 'icon': Icons.palette_outlined, 'color': const Color(0xFFF39C12)},
              {'name': 'Music', 'teacher': 'Meera Joshi', 'progress': 0.49, 'icon': Icons.music_note_outlined, 'color': const Color(0xFF3498DB)},
            ]
          : (is1to5 
              ? [
                  {'name': 'English Grammar', 'teacher': 'Meera Joshi', 'progress': 0.70, 'icon': Icons.menu_book_outlined, 'color': const Color(0xFF7B61FF)},
                  {'name': 'Basic Math', 'teacher': 'Riya Kapoor', 'progress': 0.85, 'icon': Icons.calculate_outlined, 'color': const Color(0xFF3498DB)},
                  {'name': 'Environmental Science', 'teacher': 'Meera Joshi', 'progress': 0.45, 'icon': Icons.eco_outlined, 'color': const Color(0xFF2EBA7C)},
                ]
              : [
                  {'name': 'Advanced Mathematics', 'teacher': 'Meera Joshi', 'progress': 0.90, 'icon': Icons.functions, 'color': const Color(0xFF7B61FF)},
                  {'name': 'Physics', 'teacher': 'Riya Kapoor', 'progress': 0.75, 'icon': Icons.science_outlined, 'color': const Color(0xFF3498DB)},
                  {'name': 'Chemistry', 'teacher': 'Meera Joshi', 'progress': 0.60, 'icon': Icons.biotech_outlined, 'color': const Color(0xFF2EBA7C)},
                ]);
    }
    
    if (_upcomingExamsData.isEmpty) {
      final subjects = isUKG 
          ? ['Play', 'Rhymes', 'Story Time']
          : (is1to5 ? ['English', 'Math', 'EVS', 'Drawing'] : ['Physics', 'Chemistry', 'Math', 'Biology']);
          
      final secAStr = '${widget.className.toUpperCase()} A';
      final secBStr = '${widget.className.toUpperCase()} B';
      
      _upcomingExamsData = [
        {'subject': subjects[0], 'type': 'Unit Test', 'section': secAStr, 'date': '08 Jun', 'time': '9:00'},
        {'subject': subjects[1], 'type': 'Mid Term', 'section': secAStr, 'date': '12 Jun', 'time': '10:00'},
        {'subject': subjects[2], 'type': 'Unit Test', 'section': secAStr, 'date': '15 Jun', 'time': '11:00'},
        {'subject': subjects[0], 'type': 'Mid Term', 'section': secBStr, 'date': '09 Jun', 'time': '9:00'},
        {'subject': subjects[1], 'type': 'Unit Test', 'section': secBStr, 'date': '13 Jun', 'time': '10:00'},
        {'subject': subjects[2], 'type': 'Unit Test', 'section': secBStr, 'date': '16 Jun', 'time': '11:00'},
      ];
      
      _completedExamsData = [
        {'subject': subjects[0], 'type': 'Quiz', 'section': secAStr, 'date': '16 May', 'time': '11:00'},
        {'subject': subjects[1], 'type': 'Final', 'section': secAStr, 'date': '20 May', 'time': '12:00'},
        {'subject': subjects[0], 'type': 'Quiz', 'section': secBStr, 'date': '17 May', 'time': '11:00'},
        {'subject': subjects[1], 'type': 'Final', 'section': secBStr, 'date': '21 May', 'time': '12:00'},
      ];
    }
  }

  List<Map<String, dynamic>> get _currentTeachers {
    if (_selectedSection == 'All') return _teachersData;
    return _teachersData.where((t) => t['section'] == _selectedSection.toUpperCase()).toList();
  }

  List<Map<String, dynamic>> get _currentStudents {
    final baseList = MockData.classStudentsList;
    final students = baseList.asMap().entries.map((entry) {
      final isSectionA = entry.key % 2 == 0;
      final section = entry.value['section']  ?? '${widget.className.toUpperCase()} ${isSectionA ? 'A' : 'B'}';
      return {
        ...entry.value,
        'section': section,
      };
    }).toList();

    if (_selectedSection == 'All') return students;
    return students.where((s) => s['section'] == _selectedSection.toUpperCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    _ensureDataInitialized();
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildDragHandle(),
          _buildHeader(),
          _buildFilters(),
          _buildTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedTab == 'Overview') ...[
                    _buildAttendanceOverview(),
                    const SizedBox(height: 16),
                    _buildClassTeachers(),
                    const SizedBox(height: 24),
                    _buildTimetableHeader(),
                    const SizedBox(height: 16),
                    ..._currentTeachers.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildTimetableBlock(t['section'] as String, t['name'] as String, '${t['students']} Students'),
                    )),
                  ] else if (_selectedTab == 'Students') ...[
                    _buildStudentsTab(),
                  ] else if (_selectedTab == 'Attendance') ...[
                    _buildAttendanceTab(),
                  ] else if (_selectedTab == 'Exams') ...[
                    _buildExamsTab(),
                  ] else if (_selectedTab == 'Syllabus') ...[
                    _buildSyllabusTab(),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.corporate_fare, color: _accent, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.className, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark, letterSpacing: -0.5)),
                      const SizedBox(width: 8),
                      const Text('2 SECTIONS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 12, color: _textMuted),
                      children: [
                        TextSpan(text: 'Total Students: '),
                        TextSpan(text: '49', style: TextStyle(fontWeight: FontWeight.bold, color: _accent)),
                        TextSpan(text: ' / 60'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: _textMuted),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilters() {
    final secA = '${widget.className} A';
    final secB = '${widget.className} B';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSectionPill('All'),
            const SizedBox(width: 8),
            _buildSectionPill(secA),
            const SizedBox(width: 8),
            _buildSectionPill(secB),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionPill(String label) {
    final isSelected = _selectedSection == label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedSection = label;
        _currentStudentPage = 1;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: _borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Colors.white : _textDark),
        ),
      ),
    );
  }
  
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            _buildTabItem('Overview', Icons.grid_view_rounded),
            const SizedBox(width: 24),
            _buildTabItem('Students', Icons.people_outline),
            const SizedBox(width: 24),
            _buildTabItem('Attendance', Icons.calendar_today_outlined),
            const SizedBox(width: 24),
            _buildTabItem('Exams', Icons.assignment_outlined),
            const SizedBox(width: 24),
            _buildTabItem('Syllabus', Icons.menu_book_outlined),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTabItem(String label, IconData icon) {
    final isActive = _selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = label),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isActive ? _accent : Colors.transparent, width: 2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isActive ? _accent : _textMuted),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? _accent : _textMuted)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAttendanceOverview() {
    int total = 49;
    int present = 43;
    if (_selectedSection != 'All') {
      final isA = _selectedSection.endsWith('A');
      total = isA ? 25 : 24;
      present = isA ? 22 : 21;
    }
    final presentPercent = ((present / total) * 100).round();
    final absentPercent = 100 - presentPercent;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ATTENDANCE OVERVIEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 8,
                      color: Colors.redAccent,
                      backgroundColor: Colors.transparent,
                    ),
                    CircularProgressIndicator(
                      value: present / total,
                      strokeWidth: 8,
                      color: const Color(0xFF00BFA5),
                      backgroundColor: Colors.transparent,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$present', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark, height: 1.0)),
                          const Text('PRESENT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Present', style: TextStyle(fontSize: 13, color: _textMuted)),
                        Text('$presentPercent%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Absent', style: TextStyle(fontSize: 13, color: _textMuted)),
                          ],
                        ),
                        Text('$absentPercent%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: _borderColor),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Capacity', style: TextStyle(fontSize: 13, color: _textMuted)),
                        Text('$total / ${total == 49 ? 60 : total + 5}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
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
  
  Widget _buildClassTeachers() {
    final teachers = _currentTeachers;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('CLASS TEACHERS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
              GestureDetector(
                onTap: _showEditTeachersBottomSheet,
                child: Row(
                  children: const [
                    Icon(Icons.edit_outlined, size: 12, color: _accent),
                    SizedBox(width: 4),
                    Text('Edit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _accent)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...teachers.map((t) {
            final teacher = t;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFE6E6EB),
                    child: ClipOval(
                      child: Image.network(
                        teacher['avatar'] as String,
                        width: 40, height: 40, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Text(
                          (teacher['name'] as String).isNotEmpty ? (teacher['name'] as String)[0] : 'T',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(teacher['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                        Text('${teacher['students']} students', style: const TextStyle(fontSize: 12, color: _textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFF3F0FF), borderRadius: BorderRadius.circular(12)),
                    child: Text(teacher['section'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _accent, letterSpacing: 0.5)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  void _showEditTimetableBottomSheet(String initialSection, int initialDayIndex) {
    String editSection = initialSection;
    int editDayIndex = initialDayIndex;
    
    // We need to keep a copy of the current periods being edited
    List<Map<String, String>> currentPeriods = [];
    
    // Function to load periods for the selected section/day
    void loadPeriods() {
      final base = _getTimetableFor(editSection, editDayIndex);
      currentPeriods = base.map((p) => Map<String, String>.from(p)).toList();
    }
    
    loadPeriods();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Timetable', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 16),
                  
                  // Section Dropdown
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: editSection,
                          decoration: const InputDecoration(labelText: 'Section', border: OutlineInputBorder()),
                          items: _currentTeachers.map((t) {
                            final sec = t['section'] as String;
                            return DropdownMenuItem(value: sec, child: Text(sec));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                editSection = val;
                                loadPeriods();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: editDayIndex,
                          decoration: const InputDecoration(labelText: 'Day', border: OutlineInputBorder()),
                          items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'].asMap().entries.map((e) {
                            return DropdownMenuItem(value: e.key, child: Text(e.value));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                editDayIndex = val;
                                loadPeriods();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // List of periods
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: currentPeriods.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: TextFormField(
                                  initialValue: currentPeriods[i]['period'],
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(labelText: 'Period', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                                  onChanged: (val) => currentPeriods[i]['period'] = val,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  initialValue: currentPeriods[i]['subject'],
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                                  onChanged: (val) => currentPeriods[i]['subject'] = val,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  initialValue: currentPeriods[i]['time'],
                                  style: const TextStyle(fontSize: 12),
                                  decoration: const InputDecoration(labelText: 'Time', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
                                  onChanged: (val) => currentPeriods[i]['time'] = val,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _accent, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        setState(() {
                          if (_customTimetables[editSection] == null) {
                            _customTimetables[editSection] = {};
                          }
                          _customTimetables[editSection]![editDayIndex] = List.from(currentPeriods);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimetableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.calendar_today_outlined, size: 18, color: _accent),
            SizedBox(width: 8),
            Text('Weekly Timetable', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        Row(
          children: [
            const Text('MON - SAT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          ],
        ),
      ],
    );
  }
  
  List<Map<String, String>> _getTimetableFor(String section, int dayIndex) {
    if (_customTimetables[section] != null && _customTimetables[section]![dayIndex] != null) {
      return _customTimetables[section]![dayIndex]!;
    }
    
    final isA = section.endsWith('A');
    
    // Rotate subjects based on the day of the week and section
    int offset = dayIndex + (isA ? 0 : 1);
    
    String sub1 = _timetableSubjects[(0 + offset) % _timetableSubjects.length];
    String sub2 = _timetableSubjects[(1 + offset) % _timetableSubjects.length];
    String sub3 = _timetableSubjects[(2 + offset) % _timetableSubjects.length];
    String sub5 = _timetableSubjects[(3 + offset) % _timetableSubjects.length];

    return [
      {
        'period': 'P1',
        'subject': sub1,
        'time': '08:00 - 08:45',
      },
      {
        'period': 'P2',
        'subject': sub2,
        'time': '08:45 - 09:30',
      },
      {
        'period': 'P3',
        'subject': sub3,
        'time': '09:30 - 10:15',
      },
      {
        'period': 'P4',
        'subject': 'Break / Snacks',
        'time': '10:15 - 11:00',
      },
      {
        'period': 'P5',
        'subject': sub5,
        'time': '11:00 - 11:45',
      },
    ];
  }

  Widget _buildTimetableBlock(String section, String teacher, String students) {
    final currentDayIndex = _selectedDayIndices[section] ?? 0;
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(16)),
              child: Text(section, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)),
            ),
            const SizedBox(width: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: _textDark),
                children: [
                  const TextSpan(text: 'Teacher: ', style: TextStyle(color: _textMuted)),
                  TextSpan(text: teacher, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showEditTimetableBottomSheet(section, currentDayIndex),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  children: const [
                    Icon(Icons.edit_outlined, size: 14, color: _accent),
                    SizedBox(width: 4),
                    Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(students, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _accent)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['M', 'T', 'W', 'T', 'F', 'S'].asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final isActive = currentDayIndex == index; 
            return GestureDetector(
              onTap: () => setState(() => _selectedDayIndices[section] = index),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? _accent : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  day,
                  style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? Colors.white : _textMuted),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showEditTimetableBottomSheet(section, currentDayIndex),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
            child: Column(
              children: [
                ..._getTimetableFor(section, currentDayIndex).map((period) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _borderColor)),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(period['period'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textDark)),
                                const Icon(Icons.access_time, size: 8, color: _textMuted),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(period['subject'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                                const SizedBox(height: 2),
                                Text(period['time'] as String, style: const TextStyle(fontSize: 11, color: _textMuted)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: _textMuted),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: _borderColor, indent: 68, endIndent: 16),
                  ],
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit_outlined, size: 14, color: _accent),
                    SizedBox(width: 8),
                    Text('Edit Timetable', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _accent)),
                  ],
                ),
              ),
            ],
          ),
        ),
        ), // Closes GestureDetector
      ],
    );
  }
  
// ignore: unused_element
  Widget _buildViewFullReport() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 14, color: _textMuted),
            const SizedBox(width: 6),
            Text('ALL SECTIONS OF ${widget.className.toUpperCase()}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: const Color(0xFF7B61FF), borderRadius: BorderRadius.circular(16)), 
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('View Full Report', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(width: 6),
              Icon(Icons.chevron_right, size: 18, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsTab() {
    if (_selectedSection == 'All') {
      return Column(
        children: [
          ..._currentTeachers.map((teacher) {
            final section = teacher['section'] as String;
            final teacherName = teacher['name'] as String;
            final sectionStudents = _currentStudents.where((s) => s['section'] == section).toList();
            return Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _buildStudentSectionList(section, teacherName, sectionStudents),
            );
          }),
        ],
      );
    } else {
      final sectionLabel = _selectedSection.toUpperCase();
      final teacherLabel = _currentTeachers.first['name'] as String;
      return _buildStudentSectionList(sectionLabel, teacherLabel, _currentStudents);
    }
  }

  Widget _buildStudentSectionList(String sectionLabel, String teacherLabel, List<Map<String, dynamic>> students) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFF8F7FF), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFEBE6FF), borderRadius: BorderRadius.circular(16)),
                child: Text(sectionLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _accent, letterSpacing: 0.5)),
              ),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: _textDark),
                  children: [
                    const TextSpan(text: 'Class Teacher: ', style: TextStyle(color: _textMuted)),
                    TextSpan(text: teacherLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showStudentFilterBottomSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_outlined, color: _accent, size: 16),
                      if (_selectedStudentFilter != 'All') ...[
                        const SizedBox(width: 4),
                        Text(_selectedStudentFilter == 'ACTIVE' ? 'Active' : 'Low Attd.', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _accent)),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: const [
            SizedBox(width: 24, child: Text('#', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted))),
            SizedBox(width: 48, child: Text('PROFILE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted))),
            Expanded(child: Text('NAME/GENDER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted))),
            Expanded(child: Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted))),
            SizedBox(width: 64, child: Text('FEES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted), textAlign: TextAlign.right)),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(color: _borderColor),
        ...() {
          final filteredStudents = students.where((s) {
            if (_selectedStudentFilter == 'All') return true;
            return s['status'] == _selectedStudentFilter;
          }).toList();

          final totalPages = (filteredStudents.isEmpty ? 1 : (filteredStudents.length / _studentsPerPage).ceil());
          final startIndex = _selectedSection == 'All' ? 0 : (_currentStudentPage - 1) * _studentsPerPage;
          final endIndex = (startIndex + _studentsPerPage) > filteredStudents.length ? filteredStudents.length : (startIndex + _studentsPerPage);
          final paginatedStudents = filteredStudents.isEmpty ? <Map<String, dynamic>>[] : filteredStudents.sublist(startIndex, endIndex);

          return [
            ...paginatedStudents.asMap().entries.map((entry) {
              final index = startIndex + entry.key + 1;
              final student = entry.value;
              final isLowAttd = student['status'] == 'LOW ATTD.';
              
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(width: 24, child: Text('$index', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark))),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFE6E6EB),
                          child: ClipOval(
                            child: Image.network(
                              student['avatar'] as String,
                              width: 36, height: 36, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Text(
                                (student['name'] as String).isNotEmpty ? (student['name'] as String)[0] : 'S',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(student['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                              const SizedBox(height: 2),
                              Text(student['gender'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: isLowAttd
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.redAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                    child: Text(student['status'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                    child: Text(student['status'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green)),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showFeeDetailsBottomSheet(context, student, index),
                          child: const SizedBox(
                            width: 64,
                            child: Text('View Fees', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _accent), textAlign: TextAlign.right),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: _borderColor, height: 1),
                ],
              );
            }),
            if (totalPages > 1 && _selectedSection != 'All')
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Showing ${startIndex + 1}-$endIndex of ${students.length} students', style: const TextStyle(fontSize: 11, color: _textMuted)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _currentStudentPage > 1 ? () => setState(() => _currentStudentPage--) : null,
                          child: Icon(Icons.chevron_left, color: _currentStudentPage > 1 ? _accent : _borderColor),
                        ),
                        const SizedBox(width: 8),
                        Text('Page $_currentStudentPage of $totalPages', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _currentStudentPage < totalPages ? () => setState(() => _currentStudentPage++) : null,
                          child: Icon(Icons.chevron_right, color: _currentStudentPage < totalPages ? _accent : _borderColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ];
        }(),
      ],
    );
  }

// ignore: unused_element
  Widget _buildStudentsFullReport() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ALL SECTIONS OF ${widget.className.toUpperCase()}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(color: const Color(0xFF7B61FF), borderRadius: BorderRadius.circular(16)), 
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('View Full Report', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.description_outlined, size: 18, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Generate detailed academic and attendance performance\ninsights for institutional review.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: _textMuted),
        ),
      ],
    );
  }

  Widget _buildAttendanceTab() {
    int total = 49;
    int present = 43;
    if (_selectedSection != 'All') {
      final isA = _selectedSection.endsWith('A');
      total = isA ? 25 : 24;
      present = isA ? 22 : 21;
    }
    final absent = total - present;
    final presentPercent = ((present / total) * 100).round();
    final absentPercent = 100 - presentPercent;
    
    final sectionLabel = _selectedSection == 'All' ? widget.className.toUpperCase() : _selectedSection.toUpperCase();
    final teacherLabel = _selectedSection == 'All' ? 'Multiple Teachers' : _currentTeachers.first['name'] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFF8F7FF), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFEBE6FF), borderRadius: BorderRadius.circular(16)),
                child: Text(sectionLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _accent, letterSpacing: 0.5)),
              ),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: _textDark),
                  children: [
                    const TextSpan(text: 'Class Teacher: ', style: TextStyle(color: _textMuted)),
                    TextSpan(text: teacherLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showAttendanceFilterBottomSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_outlined, color: _accent, size: 16),
                      const SizedBox(width: 4),
                      Text(_selectedAttendanceFilter, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _accent)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildAttendanceStatCard('PRESENT', '$present', '$presentPercent%', Icons.check_circle_outline, Colors.green)),
            const SizedBox(width: 16),
            Expanded(child: _buildAttendanceStatCard('ABSENT', '$absent', '$absentPercent%', Icons.cancel_outlined, Colors.red)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSmallStatCard('AVG THIS WEEK', '86%', Colors.blue, null)),
            const SizedBox(width: 16),
            Expanded(child: _buildSmallStatCard('AVG THIS MONTH', '84%', Colors.blue, null)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildSmallStatCard('BELOW 75%', '9', Colors.red, 'Students at risk')),
            const SizedBox(width: 16),
            Expanded(child: _buildSmallStatCard('PERFECT (100%)', '2', Colors.green, 'Attendance streak')),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionWiseAttendance(),
        const SizedBox(height: 24),
        _buildAttendanceChart(),
      ],
    );
  }

  Widget _buildAttendanceStatCard(String title, String value, String percent, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, size: 20, color: color),
              ),
              const Text('TODAY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark, height: 1)),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(percent, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Text('Click to view list', style: TextStyle(fontSize: 10, color: _textMuted)),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 12, color: _textMuted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(String title, String value, Color valueColor, String? subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor, height: 1)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: _textMuted)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionWiseAttendance() {
    final bool showA = _selectedSection == 'All' || _selectedSection.endsWith('A');
    final bool showB = _selectedSection == 'All' || _selectedSection.endsWith('B');
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_selectedSection == 'All' ? 'Section-wise Attendance Today' : '${_selectedSection.toUpperCase()} Attendance Today', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
          const SizedBox(height: 20),
          if (showA)
            _buildProgressRow('${widget.className} A', '22/25', '88%', 0.88),
          if (showA && showB)
            const SizedBox(height: 16),
          if (showB)
            _buildProgressRow('${widget.className} B', '21/24', '88%', 0.88),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, String fraction, String percent, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _textDark)),
            Row(
              children: [
                Text(fraction, style: const TextStyle(fontSize: 10, color: _textMuted)),
                const SizedBox(width: 8),
                Text(percent, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: const Color(0xFFF0F0F0),
          color: const Color(0xFF2EBA7C),
          minHeight: 6,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildAttendanceChart() {
    List<String> labels = [];
    if (_chartFilter == 'Week') {
      labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else if (_chartFilter == 'Month') {
      labels = ['W1', 'W2', 'W3', 'W4'];
    } else {
      labels = ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Attendance Trend', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(12)),
                child: PopupMenuButton<String>(
                  initialValue: _chartFilter,
                  tooltip: 'Filter Chart',
                  offset: const Offset(0, 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  onSelected: (String newValue) async {
                    if (newValue == 'Custom Date') {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF7B61FF),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF181821),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _chartFilter = 'Custom Date';
                        });
                      }
                    } else {
                      setState(() {
                        _chartFilter = newValue;
                      });
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'Week', child: Text('Week', style: TextStyle(fontSize: 13))),
                    const PopupMenuItem(value: 'Month', child: Text('Month', style: TextStyle(fontSize: 13))),
                    const PopupMenuItem(value: 'Custom Date', child: Text('Custom Date', style: TextStyle(fontSize: 13))),
                  ],
                  child: Row(
                    children: [
                      Text(_chartFilter == 'Custom Date' ? 'Custom' : _chartFilter, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _textDark)),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: _textMuted),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(
              painter: _ChartPainter(_chartFilter),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: _borderColor, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels.map((d) => Text(d, style: const TextStyle(fontSize: 10, color: _textMuted))).toList(),
          ),
        ],
      ),
    );
  }

// ignore: unused_element
  Widget _buildAttendanceFullReport() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFF0F2F5), shape: BoxShape.circle),
              child: const Icon(Icons.people_outline, size: 20, color: _textMuted),
            ),
            const SizedBox(width: 12),
            Text('ALL SECTIONS OF\n${widget.className.toUpperCase()}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5, height: 1.3)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFF7B61FF), borderRadius: BorderRadius.circular(12)),
          child: const Text('VIEW FULL REPORT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildExamsTab() {
    final upcomingExams = _selectedSection == 'All' 
        ? _upcomingExamsData 
        : _upcomingExamsData.where((e) => e['section'] == _selectedSection.toUpperCase()).toList();
        
    final completedExams = _selectedSection == 'All' 
        ? _completedExamsData 
        : _completedExamsData.where((e) => e['section'] == _selectedSection.toUpperCase()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Exam Timetable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
            GestureDetector(
              onTap: _showEditExamsBottomSheet,
              child: Row(
                children: const [
                  Icon(Icons.edit_outlined, size: 14, color: _accent),
                  SizedBox(width: 4),
                  Text('Edit Exams', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _accent)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildExamKPI('UPCOMING', '${upcomingExams.length}', const Color(0xFF7B61FF))),
                const SizedBox(width: 12),
                Expanded(child: _buildExamKPI('COMPLETED', '${completedExams.length}', const Color(0xFF2EBA7C))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildExamKPI('TOTAL PAPERS', '${upcomingExams.length + completedExams.length}', const Color(0xFFF39C12))),
                const SizedBox(width: 12),
                Expanded(child: _buildExamKPI('NEXT EXAM', upcomingExams.isNotEmpty ? upcomingExams[0]['date']! : '--', const Color(0xFFE74C3C))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        _buildExamListSection('Upcoming Exams', upcomingExams.length, const Color(0xFF7B61FF), upcomingExams),
        const SizedBox(height: 32),
        _buildExamListSection('Completed Exams', completedExams.length, const Color(0xFF2EBA7C), completedExams),
      ],
    );
  }

  Widget _buildExamKPI(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildExamListSection(String title, int count, Color dotColor, List<Map<String, String>> exams) {
    if (exams.isEmpty) return const SizedBox.shrink();
    
    final isUpcoming = title.contains('Upcoming');
    
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                ],
              ),
              Text('$count ${isUpcoming ? 'scheduled' : 'done'}', style: const TextStyle(fontSize: 12, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 16),
          ...exams.asMap().entries.map((entry) {
            final e = entry.value;
            
            // Theme logic based on subject
            String subject = e['subject']!.toLowerCase();

            if (subject.contains('english')) {
            } else if (subject.contains('science') || subject.contains('physics') || subject.contains('chemistry')) {
            } else if (subject.contains('hindi')) {
            } else if (subject.contains('social')) {
            }
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e['subject']!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(e['type']!, style: const TextStyle(fontSize: 11, color: _textMuted)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B61FF).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(e['section']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7B61FF))),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.calendar_today_outlined, size: 12, color: _textMuted),
                              const SizedBox(width: 4),
                              Text(e['date']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(e['time']!, style: const TextStyle(fontSize: 11, color: _textMuted)),
                                  Text((e['time']!.startsWith('12') || e['time']!.startsWith('11')) ? 'PM' : 'AM', style: const TextStyle(fontSize: 11, color: _textMuted)),
                                ],
                              ),
                              if (!isUpcoming) ...[
                                const SizedBox(width: 6),
                                const Icon(Icons.check_circle, size: 16, color: Color(0xFF2EBA7C)),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSyllabusTab() {
    final isNursery = widget.className.toLowerCase().contains('nursery');
    
    List<Map<String, dynamic>> subjects = _syllabusData.map((s) => Map<String, dynamic>.from(s)).toList();

    // Update teacher names based on selected section if specific
    final isA = _selectedSection.endsWith('A') || _selectedSection == 'All';
    final overallCompletion = isA ? (isNursery ? 0.64 : 0.72) : (isNursery ? 0.58 : 0.68);
    
    if (!isA) {
      for (var s in subjects) {
        s['teacher'] = 'Riya Kapoor';
        s['progress'] = (s['progress'] as double) * 0.8; // Lower progress for section B
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _borderColor),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            children: [
              const Text('OVERALL SYLLABUS COMPLETION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: overallCompletion,
                          strokeWidth: 10,
                          backgroundColor: const Color(0xFFF0F0F0),
                          color: const Color(0xFF7B61FF),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${(overallCompletion * 100).toInt()}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark)),
                            const Text('OVERALL', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: _textDark, height: 1.5),
                        children: [
                          const TextSpan(text: 'Across '),
                          TextSpan(text: '${subjects.length} subjects', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: ', the class has completed an average of '),
                          TextSpan(text: '${(overallCompletion * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B61FF))),
                          const TextSpan(text: ' of the planned syllabus.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subject-wise Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            Text('${subjects.length} subjects', style: const TextStyle(fontSize: 11, color: _textMuted)),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(subjects.length, (index) {
          final s = subjects[index];
          return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _borderColor),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: (s['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(s['icon'] as IconData, size: 20, color: s['color'] as Color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 11, color: _textMuted),
                            children: [
                              const TextSpan(text: 'Teacher: '),
                              TextSpan(text: s['teacher'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: _textDark)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showEditSyllabusBottomSheet(index),
                    child: Row(
                      children: const [
                        Icon(Icons.edit_outlined, size: 12, color: Color(0xFF7B61FF)),
                        SizedBox(width: 4),
                        Text('Edit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF7B61FF))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Progress', style: TextStyle(fontSize: 11, color: _textMuted)),
                  Text('${((s['progress'] as double) * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: s['progress'] as double,
                backgroundColor: const Color(0xFFF0F0F0),
                color: s['color'] as Color,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
        }),
      ],
    );
  }

  void _showFeeDetailsBottomSheet(BuildContext context, Map<String, dynamic> student, int rollNumber) {
    // Dynamic generation based on class level
    final isNursery = widget.className.toLowerCase().contains('nursery');
    final isPrimary = widget.className.toLowerCase().contains('class 1') || widget.className.toLowerCase().contains('class 2');
    final baseAnnualFee = isNursery ? 36000 : (isPrimary ? 48000 : 60000);

    // Dynamic uniqueness per student using name as seed
    final nameLength = (student['name'] as String).length;
    final seed = student['name'].toString().codeUnitAt(0);
    final isPaidInFull = (nameLength + seed) % 3 == 0;
    
    final int annualFee = baseAnnualFee;
    // They either paid in full, or paid 1 or 2 installments
    final int paid = isPaidInFull ? annualFee : (annualFee ~/ 3) * ((seed % 2) + 1);
    final int outstanding = annualFee - paid;
    final double progress = paid / annualFee;
    
    final String session = 'Session 2026-27';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F6F9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFEFEAFB), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.account_balance_wallet_outlined, color: _accent, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fee Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(height: 4),
                        Text('${student['name']} • ${student['section']} • Roll $rollNumber', 
                          style: const TextStyle(fontSize: 12, color: _textMuted)
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Main Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isPaidInFull ? const Color(0xFF2EBA7C).withValues(alpha: 0.1) : const Color(0xFFF39C12).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isPaidInFull ? const Color(0xFF2EBA7C) : const Color(0xFFF39C12), width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Icon(isPaidInFull ? Icons.check_circle_outline : Icons.schedule, 
                                size: 14, color: isPaidInFull ? const Color(0xFF2EBA7C) : const Color(0xFFF39C12)),
                              const SizedBox(width: 6),
                              Text(isPaidInFull ? 'Paid in Full' : 'Pending', 
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isPaidInFull ? const Color(0xFF2EBA7C) : const Color(0xFFF39C12))),
                            ],
                          ),
                        ),
                        Text(session, style: const TextStyle(fontSize: 11, color: _textMuted)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ANNUAL FEE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                            const SizedBox(height: 8),
                            Text('₹${annualFee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PAID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                            const SizedBox(height: 8),
                            Text('₹${paid.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2EBA7C))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('OUTSTANDING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
                            const SizedBox(height: 8),
                            Text('₹${outstanding.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Collected', style: TextStyle(fontSize: 11, color: _textMuted)),
                        Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFF0F0F0),
                      color: const Color(0xFF2EBA7C),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Installments
              const Text('INSTALLMENTS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 1.0)),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: 3,
                    separatorBuilder: (context, index) => const Divider(color: _borderColor, height: 32),
                    itemBuilder: (context, index) {
                      final termNames = ['Term 1', 'Term 2', 'Term 3'];
                      final termDates = ['12 Apr 2026', '10 Aug 2026', '08 Dec 2026'];
                      final termAmount = annualFee ~/ 3;
                      
                      // Logic for term status
                      bool isPaid = true;
                      if (!isPaidInFull && index == 2) isPaid = false;

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.calendar_today_outlined, size: 18, color: _textMuted),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(termNames[index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                                const SizedBox(height: 4),
                                Text(termDates[index], style: const TextStyle(fontSize: 11, color: _textMuted)),
                              ],
                            ),
                          ),
                          Text('₹${termAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}', 
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPaid ? const Color(0xFF2EBA7C).withValues(alpha: 0.1) : const Color(0xFFF39C12).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: isPaid ? const Color(0xFF2EBA7C) : const Color(0xFFF39C12), width: 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(isPaid ? Icons.check_circle_outline : Icons.schedule, 
                                  size: 10, color: isPaid ? const Color(0xFF2EBA7C) : const Color(0xFFF39C12)),
                                const SizedBox(width: 4),
                                Text(isPaid ? 'Paid' : 'Pending', 
                                  style: TextStyle(fontSize: 10, color: isPaid ? const Color(0xFF2EBA7C) : const Color(0xFFF39C12))),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Bottom Actions
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.download_outlined, size: 16, color: _textDark),
                          SizedBox(width: 8),
                          Text('Download Receipt', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: _accent, borderRadius: BorderRadius.circular(12)),
                        alignment: Alignment.center,
                        child: const Text('Close', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
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

  void _showEditTeachersBottomSheet() {
    // Local state for selected teachers
    final List<String> selectedTeachers = _teachersData.map((t) => t['name'] as String).toList();
    
    // A mock list of available teachers to pick from
    final List<String> availableTeachers = [
      'Meera Joshi', 'Riya Kapoor', 'Pooja Rao', 'Anita Sharma', 
      'Sneha Patil', 'Ravi Kumar', 'Kavya Singh', 'Sunita Verma'
    ];
    
    // Ensure current teachers are in the available list
    for (var t in selectedTeachers) {
      if (!availableTeachers.contains(t)) {
        availableTeachers.add(t);
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Assign Class Teachers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_teachersData.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedTeachers[i],
                        decoration: InputDecoration(
                          labelText: '${_teachersData[i]['section']} Teacher',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: availableTeachers.map((t) {
                          return DropdownMenuItem(value: t, child: Text(t));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedTeachers[i] = val;
                            });
                          }
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < _teachersData.length; i++) {
                            _teachersData[i]['name'] = selectedTeachers[i];
                            final nameQuery = selectedTeachers[i].replaceAll(' ', '+');
                            _teachersData[i]['avatar'] = 'https://ui-avatars.com/api/?name=$nameQuery&background=EBE6FF&color=6C5CE7';
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Save Assignments', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _showStudentFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F6F9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header matching View Fees style
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFEFEAFB), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.filter_alt_outlined, color: _accent, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filter Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(height: 4),
                        const Text('Choose status to filter list', style: TextStyle(fontSize: 12, color: _textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildFilterOption('All', 'All Students', Icons.group_outlined),
              const SizedBox(height: 12),
              _buildFilterOption('ACTIVE', 'Active Only', Icons.check_circle_outline),
              const SizedBox(height: 12),
              _buildFilterOption('LOW ATTD.', 'Low Attendance', Icons.warning_amber_outlined),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String label, IconData icon) {
    final isSelected = _selectedStudentFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStudentFilter = value;
          _currentStudentPage = 1;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? _accent : _borderColor, width: isSelected ? 1.5 : 1.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isSelected ? const Color(0xFFF3F0FF) : Colors.grey.shade50, shape: BoxShape.circle),
              child: Icon(icon, color: isSelected ? _accent : _textMuted, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? _accent : _textDark)),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: _accent),
          ],
        ),
      ),
    );
  }

  void _showAttendanceFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F6F9),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFEFEAFB), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.calendar_today_outlined, color: _accent, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filter Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(height: 4),
                        const Text('Select timeframe to view', style: TextStyle(fontSize: 12, color: _textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: _textMuted),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildAttendanceFilterOption('Today', 'Today', Icons.today),
              const SizedBox(height: 12),
              _buildAttendanceFilterOption('This Week', 'This Week', Icons.view_week_outlined),
              const SizedBox(height: 12),
              _buildAttendanceFilterOption('This Month', 'This Month', Icons.calendar_month_outlined),
              const SizedBox(height: 12),
              _buildAttendanceFilterOption('Overall', 'Overall', Icons.history),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceFilterOption(String value, String label, IconData icon) {
    final isSelected = _selectedAttendanceFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAttendanceFilter = value;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? _accent : _borderColor, width: isSelected ? 1.5 : 1.0),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: isSelected ? const Color(0xFFF3F0FF) : Colors.grey.shade50, shape: BoxShape.circle),
              child: Icon(icon, color: isSelected ? _accent : _textMuted, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? _accent : _textDark)),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: _accent),
          ],
        ),
      ),
    );
  }


  void _showEditSyllabusBottomSheet(int index) {
    final subject = _syllabusData[index];
    final nameController = TextEditingController(text: subject['name'] as String);
    final teacherController = TextEditingController(text: subject['teacher'] as String);
    final progressController = TextEditingController(text: ((subject['progress'] as double) * 100).toInt().toString());
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit ${subject['name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Subject Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: teacherController,
                decoration: InputDecoration(labelText: 'Teacher Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: progressController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Progress %', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _syllabusData[index]['name'] = nameController.text;
                      _syllabusData[index]['teacher'] = teacherController.text;
                      double parsedProgress = double.tryParse(progressController.text) ?? 0.0;
                      if (parsedProgress > 100) parsedProgress = 100;
                      if (parsedProgress < 0) parsedProgress = 0;
                      _syllabusData[index]['progress'] = parsedProgress / 100.0;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save Changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showEditExamsBottomSheet() {
    // Only edit the exams for the selected section, or all if 'All' is selected.
    final examsToEdit = _selectedSection == 'All' 
        ? _upcomingExamsData 
        : _upcomingExamsData.where((e) => e['section'] == _selectedSection.toUpperCase()).toList();

    // Local state for the controllers
    final subjectControllers = examsToEdit.map((e) => TextEditingController(text: e['subject'])).toList();
    final typeControllers = examsToEdit.map((e) => TextEditingController(text: e['type'])).toList();
    final dateControllers = examsToEdit.map((e) => TextEditingController(text: e['date'])).toList();
    final timeControllers = examsToEdit.map((e) => TextEditingController(text: e['time'])).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Upcoming Exams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: examsToEdit.length,
                    itemBuilder: (context, i) {
                      final exam = examsToEdit[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F7FF),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exam['section']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: subjectControllers[i],
                                    decoration: const InputDecoration(labelText: 'Subject', isDense: true),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: typeControllers[i],
                                    decoration: const InputDecoration(labelText: 'Type (e.g. Unit Test)', isDense: true),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: dateControllers[i],
                                    decoration: const InputDecoration(labelText: 'Date (e.g. 08 Jun)', isDense: true),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: timeControllers[i],
                                    decoration: const InputDecoration(labelText: 'Time (e.g. 9:00)', isDense: true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() {
                          for (int i = 0; i < examsToEdit.length; i++) {
                            examsToEdit[i]['subject'] = subjectControllers[i].text;
                            examsToEdit[i]['type'] = typeControllers[i].text;
                            examsToEdit[i]['date'] = dateControllers[i].text;
                            examsToEdit[i]['time'] = timeControllers[i].text;
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Save Changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  final String filter;
  _ChartPainter(this.filter);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    if (filter == 'Week') {
      path.moveTo(0, size.height * 0.4);
      path.quadraticBezierTo(size.width * 0.2, size.height * 0.35, size.width * 0.4, size.height * 0.4);
      path.quadraticBezierTo(size.width * 0.6, size.height * 0.45, size.width * 0.7, size.height * 0.35);
      path.quadraticBezierTo(size.width * 0.85, size.height * 0.25, size.width, size.height * 0.9);
    } else if (filter == 'Month') {
      path.moveTo(0, size.height * 0.8);
      path.quadraticBezierTo(size.width * 0.3, size.height * 0.2, size.width * 0.5, size.height * 0.6);
      path.quadraticBezierTo(size.width * 0.8, size.height * 0.9, size.width, size.height * 0.3);
    } else {
      path.moveTo(0, size.height * 0.6);
      path.quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width, size.height * 0.4);
    }
    
    canvas.drawPath(path, paint);
    
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue.withValues(alpha: 0.2), Colors.blue.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
      
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
      
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
