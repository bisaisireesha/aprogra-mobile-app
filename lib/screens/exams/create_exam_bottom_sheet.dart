import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CreateExamBottomSheet extends StatefulWidget {
  const CreateExamBottomSheet({super.key});

  @override
  State<CreateExamBottomSheet> createState() => _CreateExamBottomSheetState();
}

class _CreateExamBottomSheetState extends State<CreateExamBottomSheet> {


  
  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  final _nameController = TextEditingController();
  final _generalInstructionsController = TextEditingController();

  String _selectedType = 'Unit Test';
  String _selectedClass = 'Select a class';
  String _selectedStatus = 'Scheduled';

  List<Map<String, dynamic>> _papers = [
    {
      'subject': 'Pick a subject',
      'date': null,
      'startTime': '09:00',
      'duration': '60',
      'totalMarks': '100',
      'passingMarks': '33',
      'invigilator': 'Assign teacher',
      'syllabus': '',
      'instructions': '',
    }
  ];

  void _addPaper() {
    setState(() {
      _papers.add({
        'subject': 'Pick a subject',
        'date': null,
        'startTime': '09:00',
        'duration': '60',
        'totalMarks': '100',
        'passingMarks': '33',
        'invigilator': 'Assign teacher',
        'syllabus': '',
        'instructions': '',
      });
    });
  }

  void _removePaper(int index) {
    if (_papers.length > 1) {
      setState(() {
        _papers.removeAt(index);
      });
    }
  }

  void _createExam() {
    if (_nameController.text.trim().isEmpty) return;
    if (_selectedClass == 'Select a class') return;

    final newExam = {
      'name': _nameController.text.trim(),
      'papers': _papers.length,
      'class': _selectedClass,
      'type': _selectedType,
      'schedule': 'Upcoming',
      'status': _selectedStatus,
    };

    Navigator.pop(context, newExam);
  }

  Future<void> _pickDate(int index) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _papers[index]['date'] = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  
  Future<void> _loadPapers() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__papers_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _papers = decoded.map((item) {
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

  Future<void> _savePapers() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _papers.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__papers_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('EXAM DETAILS'),
                  const SizedBox(height: 16),
                  _buildTextField('Exam Name', _nameController, hint: 'e.g. Mid-Term Examination', icon: LucideIcons.fileText),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildDropdownField('Type', _selectedType, ['Unit Test', 'Term Exam', 'Mid Term', 'Mock', 'Final'], (v) => setState(() => _selectedType = v!), icon: LucideIcons.fileType)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDropdownField('Class', _selectedClass, [
                        'Select a class', 'Nursery', 'LKG', 'UKG', 
                        'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 
                        'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'
                      ], (v) => setState(() => _selectedClass = v!), icon: LucideIcons.graduationCap)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField('Status', _selectedStatus, ['Scheduled', 'Draft', 'Published'], (v) => setState(() => _selectedStatus = v!), icon: LucideIcons.calendar),
                  const SizedBox(height: 16),
                  _buildTextField('General Instructions (optional)', _generalInstructionsController, hint: 'Common instructions visible to all papers', maxLines: 4),
                  
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('SUBJECT PAPERS'),
                      TextButton.icon(
                        onPressed: _addPaper,
                        icon: const Icon(Icons.add, size: 16, color: Color(0xFF8463E9)),
                        label: Text('Add Paper', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF8463E9))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(_papers.length, (index) => _buildPaperCard(index)),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create New Exam', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
                  const SizedBox(height: 4),
                  Text('Add subject papers, dates, invigilators, and rooms.', style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF595973))),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF595973)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF8F96A3), letterSpacing: 0.5));
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint, int maxLines = 1, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: const Color(0xFF8F96A3)),
              const SizedBox(width: 6),
            ],
            Text(label, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF595973))),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF8F96A3)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF8463E9))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: const Color(0xFF8F96A3)),
              const SizedBox(width: 6),
            ],
            Text(label, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF595973))),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF8F96A3)),
              style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF181B20)),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaperCard(int index) {
    final paper = _papers[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Paper ${index + 1}', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
              if (_papers.length > 1)
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: Color(0xFFEF4444)),
                  onPressed: () => _removePaper(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDropdownField('Subject', paper['subject'], [
            'Pick a subject', 'English', 'Mathematics', 'Science', 'Social Studies', 'Hindi', 'Physics', 'Chemistry', 'Biology', 'Computer Science', 'Physical Education'
          ], (v) {
            setState(() => paper['subject'] = v!);
          }, icon: LucideIcons.book),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.calendar, size: 14, color: Color(0xFF8F96A3)),
                  const SizedBox(width: 6),
                  Text('Date', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF595973))),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _pickDate(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(paper['date'] ?? 'Pick date', style: GoogleFonts.figtree(fontSize: 14, color: paper['date'] == null ? const Color(0xFF8F96A3) : const Color(0xFF181B20))),
                      const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF8F96A3)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField('Start Time', TextEditingController(text: paper['startTime']), icon: LucideIcons.clock),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField('Duration (min)', TextEditingController(text: paper['duration']), icon: LucideIcons.timer),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField('# Total Marks', TextEditingController(text: paper['totalMarks'])),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField('# Passing Marks', TextEditingController(text: paper['passingMarks'])),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDropdownField('Invigilator', paper['invigilator'], [
            'Assign teacher', 'Mr. Sharma', 'Ms. Gupta', 'Mrs. Iyer', 'Mr. Verma', 'Ms. Kaur', 'Mr. Khan', 'Mrs. Reddy'
          ], (v) {
            setState(() => paper['invigilator'] = v!);
          }, icon: LucideIcons.user),
          const SizedBox(height: 16),
          _buildTextField('Syllabus', TextEditingController(text: paper['syllabus']), hint: 'Topics / chapters covered', maxLines: 3),
          const SizedBox(height: 16),
          _buildTextField('Paper Instructions', TextEditingController(text: paper['instructions']), hint: 'Specific notes for this paper', maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _createExam,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8463E9),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: Text('Create Exam', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
