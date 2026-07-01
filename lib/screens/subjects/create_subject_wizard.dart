import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:google_fonts/google_fonts.dart';

const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF8463E9);

class CreateSubjectWizard extends StatefulWidget {
  final Map<String, dynamic>? initialSubject;
  const CreateSubjectWizard({super.key, this.initialSubject});

  @override
  State<CreateSubjectWizard> createState() => _CreateSubjectWizardState();
}

class _CreateSubjectWizardState extends State<CreateSubjectWizard> {
  String _selectedCategory = 'Primary';
  String _subjectName = '';
  String? _selectedTeacher;
  final TextEditingController _unitController = TextEditingController();
  
  List<Map<String, dynamic>> _units = [];

  bool get _isWide => MediaQuery.sizeOf(context).width > 600;

  @override
  void initState() {
    super.initState();
    _loadUnits();
    if (widget.initialSubject != null) {
      _subjectName = widget.initialSubject!['subject'] ?? '';
      _selectedTeacher = widget.initialSubject!['teacher'];
      if (_selectedTeacher == 'Unassigned') _selectedTeacher = null;
      
      // Attempt to infer category if present, otherwise default to Primary
      if (widget.initialSubject!.containsKey('category')) {
        _selectedCategory = widget.initialSubject!['category'];
      }
    }
  }

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  void _submitWizard() {
    final newSubject = {
      'subject': _subjectName.isEmpty ? 'New Subject' : _subjectName,
      'teacher': _selectedTeacher ?? 'Unassigned',
      'progress': _units.where((u) => u['done'] == true).length,
      'total': _units.length,
      'color': _accent,
      'category': _selectedCategory,
    };
    Navigator.pop(context, newSubject);
  }

  
  Future<void> _loadUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('cache__units_data');
    if (dataString != null) {
      final List<dynamic> decoded = jsonDecode(dataString);
      setState(() {
        _units = decoded.map((item) {
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

  Future<void> _saveUnits() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _units.map((item) {
      final copy = Map<String, dynamic>.from(item);
      for (final key in copy.keys.toList()) {
        if (copy[key] is Color) {
          copy[key] = (copy[key] as Color).value;
        }
      }
      return copy;
    }).toList();
    await prefs.setString('cache__units_data', jsonEncode(serialized));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: _isWide ? 500 : double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
                    _buildSectionHeader(Icons.menu_book_outlined, 'Subject Basics', 'Add subject details.'),
                    const SizedBox(height: 24),
                    _buildCategorySelection(),
                    const SizedBox(height: 24),
                    _buildSubjectNameField(),
                    const SizedBox(height: 24),
                    _buildTeacherSelection(),
                    const SizedBox(height: 32),
                    const Divider(height: 1, color: Color(0xFFEBEBEB)),
                    const SizedBox(height: 32),
                    _buildSectionHeader(Icons.layers_outlined, 'Syllabus', 'Add chapters or units.'),
                    const SizedBox(height: 24),
                    _buildSyllabusBuilder(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF8F96A3)),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Center(
                  child: Text(widget.initialSubject != null ? 'Edit Subject' : 'Create New Subject', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                ),
              ),
              const SizedBox(width: 40), // Balance the close button for centering
            ],
          ),
        ),
        Container(height: 2, color: _accent, width: double.infinity), // Thin purple progress line across the top
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F1FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _accent, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
            Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildCategoryCard('Pre-Primary', Icons.child_care)),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard('Primary', Icons.backpack_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard('Secondary', Icons.school_outlined)),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F1FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? _accent : _textMuted, size: 24),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? _accent : _textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subject Name', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEBEBEB)),
            color: Colors.white,
          ),
          child: TextFormField(
            initialValue: _subjectName,
            onChanged: (val) {
              setState(() {
                _subjectName = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'e.g. Mathematics',
              hintStyle: GoogleFonts.figtree(color: const Color(0xFF9CA3AF), fontSize: 14),
              prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF9CA3AF), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
            style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildTeacherSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Assigned Teacher', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEBEBEB)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(right: 8),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            dropdownColor: Colors.white,
            menuMaxHeight: 300,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_outline, color: Color(0xFF9CA3AF), size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
            hint: Text('Select a teacher', style: GoogleFonts.figtree(color: const Color(0xFF9CA3AF), fontSize: 14)),
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
            initialValue: _selectedTeacher,
            items: ['Kavita Menon', 'Vikram Singh', 'Sunita Reddy', 'Ritu Kapoor', 'Sanjay Iyer', 'Reema Joshi', 'Neeraj Bhat'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedTeacher = newValue;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSyllabusBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFEBEBEB)),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _unitController,
                  decoration: InputDecoration(
                    hintText: 'Add chapter or unit title',
                    hintStyle: GoogleFonts.figtree(color: const Color(0xFF9CA3AF), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
                  onSubmitted: (_) => _addUnit(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: _addUnit,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _units.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _units[index]['done'],
                    onChanged: (val) {
                      setState(() {
                        _units[index]['done'] = val;
                      });
                    },
                    activeColor: _accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF9CA3AF), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _units[index]['title'],
                      style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w500, color: _textDark),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFF9CA3AF), size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() {
                        _units.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _addUnit() {
    if (_unitController.text.trim().isNotEmpty) {
      setState(() {
        _units.add({
          'title': _unitController.text.trim(),
          'done': false,
        });
        _unitController.clear();
      });
    }
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitWizard,
          style: ElevatedButton.styleFrom(
            backgroundColor: _accent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: Text(widget.initialSubject != null ? 'Update Subject' : 'Create Subject', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
