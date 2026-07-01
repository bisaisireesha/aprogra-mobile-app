import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../data/mock_data/subjects_mock.dart';
import '../../data/mock_data/timetables_mock.dart';

const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9); // Purple from image

class CreateTimetableWizard extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final bool isViewOnly;

  const CreateTimetableWizard({
    super.key,
    this.initialData,
    this.isViewOnly = false,
  });

  @override
  State<CreateTimetableWizard> createState() => _CreateTimetableWizardState();
}

class _CreateTimetableWizardState extends State<CreateTimetableWizard> {
  static String? _draftClassSection = 'Nursery A - Meera Joshi';
  static String _draftName = 'Regular Academic Schedule';
  static String _draftViewMode = 'Grid'; // 'Grid' or 'List'
  static List<Map<String, dynamic>> _draftPeriods = [];

  final List<String> _allClassesAndTeachers = [
    'Nursery A - Meera Joshi',
    'Nursery B - Aditi Iyer',
    'LKG A - Priya Sharma',
    'UKG B - Ritu Verma',
    'Class 1A - Kavita Menon',
    'Class 2C - Rahul Gupta',
    'Class 3A - Sneha Rao',
    'Class 4B - Vikram Singh',
    'Class 5A - Amit Kumar',
    'Class 6B - Anjali Desai',
    'Class 7A - Sunita Patel',
    'Class 8C - Ramesh Nair',
    'Class 9A - Pooja Reddy',
    'Class 10B - Suresh Babu',
  ];

  late String? _classSection = widget.initialData != null ? '${widget.initialData!['class']} - ${widget.initialData!['teacher']}' : _draftClassSection;
  late final TextEditingController _nameController = TextEditingController(text: widget.initialData?['title'] ?? _draftName);
  final String _effectiveDate = '25-06-2026';
  String _viewMode = _draftViewMode; // 'Grid' or 'List'
  late final List<Map<String, dynamic>> _periods = widget.initialData != null && widget.initialData!['periods_data'] != null
      ? List<Map<String, dynamic>>.from(widget.initialData!['periods_data'])
      : List.from(_draftPeriods);
  String _activeDay = 'Mon';

  Map<String, List<Map<String, dynamic>>> get _classSubjects {
    final map = <String, List<Map<String, dynamic>>>{};
    for (var c in _allClassesAndTeachers) {
      if (c.contains('Nursery') || c.contains('LKG') || c.contains('UKG')) {
        map[c] = SubjectsMockData.prePrimarySubjects;
      } else if (c.contains('Class 6') || c.contains('Class 7') || c.contains('Class 8') || c.contains('Class 9') || c.contains('Class 10')) {
        map[c] = SubjectsMockData.secondarySubjects;
      } else {
        map[c] = SubjectsMockData.primarySubjects;
      }
    }
    return map;
  }

  bool get _isWide => (MediaQuery.maybeSizeOf(context)?.width ?? 800) > 800;

  @override
  void initState() {
    super.initState();
    _loadDraftperiods();
    _nameController.addListener(() {
      setState(() {});
    });
  }

  Map<String, String> _calculateNextTime(int durationMinutes) {
    if (_periods.isEmpty) {
      final endMins = 8 * 60 + durationMinutes;
      final endH = endMins ~/ 60;
      final endM = endMins % 60;
      final endPeriod = endH >= 12 ? 'PM' : 'AM';
      var dispEndH = endH > 12 ? endH - 12 : endH;
      if (dispEndH == 0) dispEndH = 12;
      return {
        'time': '08:00 AM',
        'end': '${dispEndH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')} $endPeriod',
        'duration': '${durationMinutes}m',
      };
    }
    
    final lastEndStr = _periods.last['end'] as String;
    final parts = lastEndStr.split(' ');
    int h = 8;
    int m = 0;
    if (parts.length == 2) {
      final timeParts = parts[0].split(':');
      if (timeParts.length == 2) {
        h = int.tryParse(timeParts[0]) ?? 8;
        m = int.tryParse(timeParts[1]) ?? 0;
        if (parts[1].toUpperCase() == 'PM' && h != 12) h += 12;
        if (parts[1].toUpperCase() == 'AM' && h == 12) h = 0;
      }
    }
    
    final endTotalMins = (h * 60 + m) + durationMinutes;
    final endH = endTotalMins ~/ 60;
    final endM = endTotalMins % 60;
    final endPeriod = endH >= 12 ? 'PM' : 'AM';
    var dispEndH = endH > 12 ? endH - 12 : endH;
    if (dispEndH == 0) dispEndH = 12;
    
    return {
      'time': lastEndStr,
      'end': '${dispEndH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')} $endPeriod',
      'duration': '${durationMinutes}m',
    };
  }

  void _addEmptyPeriod() {
    setState(() {
      final nextTime = _calculateNextTime(45);
      int next = _periods.length + 1;
      _periods.add({
        'number': next.toString(),
        'time': nextTime['time'],
        'end': nextTime['end'],
        'duration': nextTime['duration'],
        'days': <String, Map<String, dynamic>>{
          'Mon': {'type': 'empty'},
          'Tue': {'type': 'empty'},
          'Wed': {'type': 'empty'},
          'Thu': {'type': 'empty'},
          'Fri': {'type': 'empty'},
          'Sat': {'type': 'empty'},
        }
      });
    });
  }

  void _addSpecialPeriod(String type, String title, Color color, int durationMinutes) {
    setState(() {
      final nextTime = _calculateNextTime(durationMinutes);
      int next = _periods.length + 1;
      _periods.add({
        'number': next.toString(),
        'time': nextTime['time'],
        'end': nextTime['end'],
        'duration': nextTime['duration'],
        'days': <String, Map<String, dynamic>>{
          'Mon': {'type': 'subject', 'title': title, 'subtitle': type, 'color': color},
          'Tue': {'type': 'subject', 'title': title, 'subtitle': type, 'color': color},
          'Wed': {'type': 'subject', 'title': title, 'subtitle': type, 'color': color},
          'Thu': {'type': 'subject', 'title': title, 'subtitle': type, 'color': color},
          'Fri': {'type': 'subject', 'title': title, 'subtitle': type, 'color': color},
          'Sat': {'type': 'subject', 'title': title, 'subtitle': type, 'color': color},
        }
      });
    });
  }

  void _addBreakPeriod() => _addSpecialPeriod('Break', 'Short Break', const Color(0xFFF59E0B), 15);
  void _addLunchPeriod() => _addSpecialPeriod('Break', 'Lunch Break', const Color(0xFFF59E0B), 30);
  void _addActivityPeriod() => _addSpecialPeriod('Activity', 'Extracurricular', const Color(0xFF3B82F6), 45);

  @override
  void dispose() {
    _draftClassSection = _classSection;
    _draftName = _nameController.text;
    _draftViewMode = _viewMode;
    _draftPeriods = _periods;

    _nameController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    // Wipe stale state on hot reload to prevent type inference crashes
    _periods.clear();
  }

  
  Future<void> _loadDraftperiods() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__draftPeriods_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _draftPeriods = decoded.map((item) {
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

  Future<void> _saveDraftperiods() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _draftPeriods.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__draftPeriods_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(_isWide ? 32 : 16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight: (MediaQuery.maybeSizeOf(context)?.height ?? 800) * 0.95,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Color(0xFFEBEBEB)),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildFormRow(),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFEBEBEB)),
                ),
                child: Column(
                  children: [
                    if (_viewMode == 'Grid') 
                      Expanded(
                        child: _periods.isEmpty ? _buildEmptyState() : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 80 + (100 * 6.0) + 48, // Minimum width to prevent column overflow
                            child: Column(
                              children: [
                                _buildGridHeader(),
                                const Divider(height: 1, color: Color(0xFFEBEBEB)),
                                Expanded(
                                  child: _buildGridView(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else 
                      Expanded(
                        child: _periods.isEmpty ? _buildEmptyState() : _buildDayView(),
                      ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEBEBEB)),
            if (!widget.isViewOnly) _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final bool canPublish = _nameController.text.trim().isNotEmpty && _periods.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: _textDark),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Create Timetable',
              style: GoogleFonts.figtree(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (!widget.isViewOnly)
            ElevatedButton(
              onPressed: canPublish ? () {
                setState(() {
                _draftPeriods = []; // Clear draft when publishing
              });
              
              final newTimetable = {
                'title': _nameController.text.isNotEmpty ? _nameController.text : 'New Timetable',
                'level': _classSection?.contains('Nursery') == true ? 'Pre Primary' : 'Primary',
                'time': '08:00 - 14:00',
                'class': _classSection?.split(' - ').first ?? 'Custom Class',
                'teacher': _classSection?.split(' - ').last ?? 'Assigned Teacher',
                'periods': _periods.length,
                'breaks': 1,
                'duration': '6h',
                'periods_data': List<Map<String, dynamic>>.from(_periods),
              };

              if (widget.initialData != null) {
                final index = TimetablesMockData.allTimetables.indexOf(widget.initialData!);
                if (index != -1) {
                  TimetablesMockData.allTimetables[index] = newTimetable;
                } else {
                  TimetablesMockData.allTimetables.add(newTimetable);
                }
              } else {
                TimetablesMockData.allTimetables.add(newTimetable);
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Timetable Published Successfully')),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canPublish ? const Color(0xFFACA1FF) : const Color(0xFFE2E8F0),
              disabledBackgroundColor: const Color(0xFFE2E8F0),
              disabledForegroundColor: const Color(0xFFA1A1AA),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Publish Timetable',
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow() {
    if (!_isWide) {
      return Column(
        children: [
          _buildDropdownField('CLASS & SECTION', _allClassesAndTeachers, _classSection, (v) {
            setState(() {
              _classSection = v;
              _periods.clear();
            });
          }),
          const SizedBox(height: 16),
          _buildTextField('TIMETABLE NAME', _nameController),
          const SizedBox(height: 16),
          _buildDateField('EFFECTIVE FROM', _effectiveDate),
          const SizedBox(height: 16),
          _buildViewToggle(),
        ],
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: _buildDropdownField('CLASS & SECTION', _allClassesAndTeachers, _classSection, (v) {
            setState(() {
              _classSection = v;
              _periods.clear();
            });
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: _buildTextField('TIMETABLE NAME', _nameController),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildDateField('EFFECTIVE FROM', _effectiveDate),
        ),
        const SizedBox(width: 16),
        _buildViewToggle(),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? value, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEBEBEB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text('Select Class', style: GoogleFonts.figtree(color: const Color(0xFF8F96A3), fontSize: 14)),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF8F96A3)),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEBEBEB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            readOnly: widget.isViewOnly,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: GoogleFonts.figtree(color: _textDark, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEBEBEB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
              const Icon(LucideIcons.calendar, size: 16, color: _textDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('VIEW MODE', style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEBEBEB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(child: _buildToggleButton('Grid')),
              Expanded(child: _buildToggleButton('List')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label) {
    bool isSelected = _viewMode == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? _accent : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : _textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildGridHeader() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: Color(0xFFEBEBEB))),
          ),
          child: Text('Time', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFFA1A1AA))),
        ),
        ...days.map((day) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFEBEBEB))),
            ),
            child: Text(day, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFFA1A1AA))),
          ),
        )),
        const SizedBox(width: 48), // Action menu column width
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(LucideIcons.calendarDays, size: 32, color: _accent),
          ),
          const SizedBox(height: 24),
          Text(
            'Build your weekly schedule',
            style: GoogleFonts.figtree(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start by adding a period. Then click any cell to pick a subject —\nor drag subjects from the sidebar.',
            textAlign: TextAlign.center,
            style: GoogleFonts.figtree(
              fontSize: 14,
              color: _textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addEmptyPeriod,
            icon: const Icon(Icons.add, size: 16, color: Colors.white),
            label: Text(
              'Add First Period',
              style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTextButton(Icons.add, 'Add Period', _accent, onTap: _addEmptyPeriod),
            const SizedBox(width: 24),
            _buildTextButton(LucideIcons.coffee, 'Break', const Color(0xFFF59E0B), onTap: _addBreakPeriod),
            const SizedBox(width: 24),
            _buildTextButton(Icons.restaurant_menu, 'Lunch', const Color(0xFFF59E0B), onTap: _addLunchPeriod),
            const SizedBox(width: 24),
            _buildTextButton(LucideIcons.sparkles, 'Activity', const Color(0xFF3B82F6), onTap: _addActivityPeriod),
            const SizedBox(width: 40),
            Text('0 / 0', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted, fontWeight: FontWeight.w500)),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.copy, size: 16, color: _textDark),
              label: Text('Copy Mon → All', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEBEBEB)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(width: 16),
            if (!widget.isViewOnly)
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _periods.clear();
                  });
                },
                icon: const Icon(Icons.delete_outline, size: 16, color: _textDark),
                label: Text('Clear Cells', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEBEBEB)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.figtree(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _periods.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEBEBEB)),
      itemBuilder: (context, index) {
        final p = _periods[index];
        final timeString = p['time'] ?? '08:00 AM';
        final parts = timeString.split(' ');
        final formattedTime = parts.length > 1 ? '${parts[0]}\n${parts[1]}' : timeString;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Color(0xFFEBEBEB))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(p['number'] ?? '${index + 1}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(LucideIcons.clock, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(formattedTime, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8), height: 1.2)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(p['duration'] ?? '45m', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8))),
                  ],
                ),
              ),
              ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) {
                final dayData = p['days'] != null ? p['days'][day] : null;
                final isEmpty = dayData == null || dayData['type'] == 'empty';

                if (isEmpty) {
                  return Expanded(
                    child: InkWell(
                      onTap: widget.isViewOnly ? null : () => _showSubjectPicker(context, index, day),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: Color(0xFFEBEBEB))),
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5), // In lieu of dashed border
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add, size: 16, color: Color(0xFFCBD5E1)),
                              const SizedBox(width: 4),
                              Text('Add', style: GoogleFonts.figtree(color: const Color(0xFFCBD5E1), fontSize: 14, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final color = dayData['color'] as Color? ?? const Color(0xFF8463E9);
                return Expanded(
                  child: InkWell(
                    onTap: widget.isViewOnly ? null : () => _showSubjectPicker(context, index, day),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Color(0xFFEBEBEB))),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: color.withOpacity(0.2)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(dayData['title']?.toString() ?? '', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: color), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(dayData['subtitle']?.toString() ?? '', style: GoogleFonts.figtree(fontSize: 10, color: _textDark), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              if (!widget.isViewOnly)
                SizedBox(
                  width: 48,
                  child: Center(
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz, color: Color(0xFFA1A1AA)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'up',
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_upward, size: 16, color: Color(0xFF8F96A3)),
                            const SizedBox(width: 8),
                            Text('Move up', style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'down',
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_downward, size: 16, color: Color(0xFF8F96A3)),
                            const SizedBox(width: 8),
                            Text('Move down', style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            const Icon(LucideIcons.copy, size: 16, color: _textDark),
                            const SizedBox(width: 8),
                            Text('Duplicate', style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Text('Delete row', style: GoogleFonts.figtree(color: Colors.red, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (val) {
                      setState(() {
                        if (val == 'up' && index > 0) {
                          final p = _periods.removeAt(index);
                          _periods.insert(index - 1, p);
                        } else if (val == 'down' && index < _periods.length - 1) {
                          final p = _periods.removeAt(index);
                          _periods.insert(index + 1, p);
                        } else if (val == 'duplicate') {
                          final p = Map<String, dynamic>.from(_periods[index]);
                          p['days'] = <String, Map<String, dynamic>>{};
                          if (_periods[index]['days'] != null) {
                            for (var entry in (_periods[index]['days'] as Map).entries) {
                              p['days'][entry.key as String] = Map<String, dynamic>.from(entry.value as Map);
                            }
                          }
                          _periods.insert(index + 1, p);
                        } else if (val == 'delete') {
                          _periods.removeAt(index);
                        }
                        
                        // Re-number rows
                        for(int i=0; i<_periods.length; i++) {
                          _periods[i]['number'] = (i+1).toString();
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayView() {
    final days = [
      {'day': 'Mon', 'date': '23 Jun', 'active': true},
      {'day': 'Tue', 'date': '24 Jun', 'active': false},
      {'day': 'Wed', 'date': '25 Jun', 'active': false},
      {'day': 'Thu', 'date': '26 Jun', 'active': false},
      {'day': 'Fri', 'date': '27 Jun', 'active': false},
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEBEBEB))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFEBEBEB)), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_left, size: 16, color: _textMuted),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: days.map((d) {
                      bool isActive = _activeDay == d['day'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () => setState(() => _activeDay = d['day'] as String),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isActive ? _accent : Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                Text(d['day'] as String, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.white : _textDark)),
                                const SizedBox(height: 4),
                                Text(d['date'] as String, style: GoogleFonts.figtree(fontSize: 12, color: isActive ? Colors.white : _textMuted)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFEBEBEB)), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.chevron_right, size: 16, color: _textMuted),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: _periods.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final p = _periods[index];
              final dayData = p['days'] != null ? p['days'][_activeDay] : null;
              final isEmpty = dayData == null || dayData['type'] == 'empty';
              
              if (isEmpty) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['time']!, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                          Text('-', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                          Text(p['end']!, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                          const SizedBox(height: 4),
                          Text(p['duration']!, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _showSubjectPicker(context, index, _activeDay),
                        child: Container(
                          height: 72,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5), // In lieu of dashed border
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text('—', style: GoogleFonts.figtree(color: const Color(0xFFCBD5E1), fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                );
              }
              
              final color = dayData['color'] as Color? ?? const Color(0xFF8463E9);
              
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['time']!, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                        Text('-', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                        Text(p['end']!, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _textDark)),
                        const SizedBox(height: 4),
                        Text(p['duration']!, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _showSubjectPicker(context, index, _activeDay),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: color.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dayData['title']?.toString() ?? '', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                                  const SizedBox(height: 4),
                                  Text(dayData['subtitle']?.toString() ?? '', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                                ],
                              ),
                            ),
                            const Icon(LucideIcons.moreVertical, color: _textMuted, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _showSubjectPicker(BuildContext context, int periodIndex, String day) {
    final currentSubjects = _classSection != null ? _classSubjects[_classSection!] ?? [] : [];
    String searchQuery = '';
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final filteredSubjects = currentSubjects.where((sub) {
              final title = (sub['subject'] as String).toLowerCase();
              final teacher = (sub['teacher'] as String).toLowerCase();
              final query = searchQuery.toLowerCase();
              return title.contains(query) || teacher.contains(query);
            }).toList();

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(24),
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextField(
                          onChanged: (val) {
                            setDialogState(() {
                              searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search subject or teacher...',
                            hintStyle: GoogleFonts.figtree(color: _textMuted, fontSize: 13),
                            prefixIcon: const Icon(LucideIcons.search, size: 16, color: _textMuted),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: filteredSubjects.map((sub) => InkWell(
                        onTap: () {
                          setState(() {
                            if (_periods[periodIndex]['days'] == null) {
                               _periods[periodIndex]['days'] = <String, Map<String, dynamic>>{
                                 'Mon': {'type': 'empty'},
                                 'Tue': {'type': 'empty'},
                                 'Wed': {'type': 'empty'},
                                 'Thu': {'type': 'empty'},
                                 'Fri': {'type': 'empty'},
                                 'Sat': {'type': 'empty'},
                               };
                            } else if (_periods[periodIndex]['days'] is! Map<String, Map<String, dynamic>>) {
                               // Defensive re-cast for stale hot-reloaded memory state
                               final oldMap = _periods[periodIndex]['days'] as Map;
                               _periods[periodIndex]['days'] = <String, Map<String, dynamic>>{};
                               for (var key in oldMap.keys) {
                                 _periods[periodIndex]['days'][key as String] = Map<String, dynamic>.from(oldMap[key] as Map);
                               }
                            }
                            _periods[periodIndex]['days'][day] = <String, dynamic>{
                              'type': 'subject',
                              'title': sub['subject'],
                              'subtitle': sub['teacher'],
                              'color': sub['color'],
                            };
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(width: 8, height: 8, decoration: BoxDecoration(color: sub['color'], shape: BoxShape.circle)),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sub['subject'] as String, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                                  const SizedBox(height: 2),
                                  Text(sub['teacher'] as String, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
          },
        );
      }
    );
  }
}
