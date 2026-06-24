import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateClassWizard extends StatefulWidget {
  const CreateClassWizard({super.key});

  @override
  State<CreateClassWizard> createState() => _CreateClassWizardState();
}

class _CreateClassWizardState extends State<CreateClassWizard> {
  int _currentStep = 0; // 0 for Class Basics, 1 for Section Details
  String _selectedCategory = 'Pre-Primary'; // Pre-Primary, Primary, Secondary
  String _className = '';
  bool _enableSections = false;
  
  // Section data: name, capacity
  List<Map<String, dynamic>> _sections = [
    {'name': 'A', 'capacity': '40', 'teacher': null},
    {'name': 'B', 'capacity': '40', 'teacher': null},
  ];
  
  int _selectedSectionTabIndex = 0;

  final Color _accent = const Color(0xFF8463E9);
  final Color _textDark = const Color(0xFF181B20);
  final Color _textMuted = const Color(0xFF595973);

  bool get _isWide => MediaQuery.sizeOf(context).width >= 900;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF6F6F8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000, maxHeight: 800),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, thickness: 4, color: Color(0xFF8463E9)),
            Expanded(
              child: _isWide 
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: SingleChildScrollView(child: _buildLeftPreview())),
                      Expanded(flex: 6, child: SingleChildScrollView(child: _buildRightContent())),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLeftPreview(),
                        _buildRightContent(),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF8F96A3), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text('Create New Class', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: _textDark), overflow: TextOverflow.ellipsis)),
          if (_currentStep == 1)
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFF8F96A3)),
              onPressed: () {
                setState(() {
                  _currentStep = 0;
                });
              },
            ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              if (_currentStep == 0 && _enableSections) {
                setState(() {
                  _currentStep = 1;
                });
              } else {
                _submitWizard();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent.withValues(alpha: (_currentStep == 0 && !_enableSections) ? 0.5 : 1.0),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: _isWide ? 24 : 12, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              _currentStep == 0 ? 'Continue' : 'Create',
              style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _submitWizard() {
    int totalCapacity = 0;
    if (_enableSections) {
      for (var sec in _sections) {
        totalCapacity += int.tryParse(sec['capacity'] ?? '0') ?? 0;
      }
    } else {
      totalCapacity = 40;
    }

    final newClass = {
      'name': _className.isEmpty ? 'New Class' : _className,
      'sections': _enableSections ? '${_sections.length} Sections' : '1 Section',
      'teacher': _enableSections && _sections.isNotEmpty ? (_sections.first['teacher'] ?? 'Unassigned') : 'Unassigned',
      'students': '0 / $totalCapacity',
      'progress': 0.0,
      'category': _selectedCategory,
    };
    Navigator.pop(context, newClass);
  }

  Widget _buildLeftPreview() {
    Color categoryColor;
    IconData categoryIcon;
    
    if (_selectedCategory == 'Pre-Primary') {
      categoryColor = const Color(0xFFF59E0B);
      categoryIcon = Icons.child_care;
    } else if (_selectedCategory == 'Primary') {
      categoryColor = const Color(0xFF6B7280);
      categoryIcon = Icons.backpack_outlined;
    } else {
      categoryColor = _accent;
      categoryIcon = Icons.school_outlined;
    }

    int totalSeats = 0;
    if (_enableSections) {
      for (var sec in _sections) {
        totalSeats += int.tryParse(sec['capacity'] ?? '0') ?? 0;
      }
    } else {
      totalSeats = 40; // Default single group
    }

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentStep == 0 ? 'Step 1 : Class Basics' : 'Step 2 : Section Details',
            style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEBEBEB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Icon(categoryIcon, size: 80, color: categoryColor),
                  ),
                ),
                Text(
                  _selectedCategory,
                  style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: categoryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  _className.isEmpty ? 'Class Name' : _className,
                  style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark),
                ),
                const SizedBox(height: 32),
                const Divider(height: 1, color: Color(0xFFEBEBEB)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.layers_outlined, size: 16, color: _textMuted),
                        const SizedBox(width: 8),
                        Text(
                          _enableSections ? '${_sections.length} Sections' : 'Single Group',
                          style: GoogleFonts.figtree(fontSize: 13, color: _textMuted),
                        ),
                      ],
                    ),
                    Text(
                      '$totalSeats seats',
                      style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark),
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

  Widget _buildRightContent() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: _currentStep == 0 ? _buildStep1() : _buildStep2(),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book_outlined, color: Color(0xFF8463E9), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Let\'s set up your class', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark), overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Pick a category and name your class.', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
        const SizedBox(height: 32),
        Text('Category', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted)),
        const SizedBox(height: 12),
        _isWide ? Row(
          children: [
            Expanded(child: _buildCategoryCard('Pre-Primary', 'Nursery · LKG · U...', Icons.child_care, const Color(0xFFF59E0B))),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard('Primary', 'Class 1 – 5', Icons.backpack_outlined, const Color(0xFF6B7280))),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard('Secondary', 'Class 6 – 12', Icons.school_outlined, _accent)),
          ],
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryCard('Pre-Primary', 'Nursery · LKG · U...', Icons.child_care, const Color(0xFFF59E0B)),
            const SizedBox(height: 12),
            _buildCategoryCard('Primary', 'Class 1 – 5', Icons.backpack_outlined, const Color(0xFF6B7280)),
            const SizedBox(height: 12),
            _buildCategoryCard('Secondary', 'Class 6 – 12', Icons.school_outlined, _accent),
          ],
        ),
        const SizedBox(height: 32),
        Text('Class Name', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: _textMuted)),
        const SizedBox(height: 12),
        TextField(
          onChanged: (val) {
            setState(() {
              _className = val;
            });
          },
          decoration: InputDecoration(
            hintText: 'e.g. Class 3 or Nursery',
            hintStyle: GoogleFonts.figtree(color: const Color(0xFF9CA3AF)),
            border: InputBorder.none,
          ),
          style: GoogleFonts.figtree(fontSize: 16, color: _textDark),
        ),
        const Divider(height: 1, color: Color(0xFFEBEBEB)),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enable Sections', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 4),
                  Text('Split this class into multiple sections (A, B, C). You\'ll configure each one next.', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                ],
              ),
            ),
            Switch(
              value: _enableSections,
              onChanged: (val) {
                setState(() {
                  _enableSections = val;
                });
              },
              activeThumbColor: _accent,
            ),
          ],
        ),
        if (_enableSections) ...[
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sections', style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
              Text('${_sections.length} total', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sections.length + 1,
              itemBuilder: (context, index) {
                if (index == _sections.length) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _sections.add({'name': String.fromCharCode(65 + _sections.length), 'capacity': '40', 'teacher': null});
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.add, size: 16, color: Color(0xFF8463E9)),
                          const SizedBox(width: 8),
                          Text('Add section', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF8463E9))),
                        ],
                      ),
                    ),
                  );
                }
                final sec = _sections[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBE6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(sec['name']!, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _accent)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFEBEBEB)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Text(sec['name']!, style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 80,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFEBEBEB)),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(sec['capacity']!, style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFF8F96A3), size: 18),
                        onPressed: () {
                          setState(() {
                            _sections.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ]
      ],
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, IconData icon, Color iconColor) {
    bool isSelected = _selectedCategory == title;
    return InkWell(
      onTap: () {
          setState(() {
            _selectedCategory = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF3F0FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? _accent : const Color(0xFF8F96A3)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.figtree(fontSize: 11, color: _textMuted), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.layers_outlined, color: Color(0xFF8463E9), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Configure each section', style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark), overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('Assign a class teacher and room for every section.', style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
        const SizedBox(height: 32),
        Row(
          children: [
            ...List.generate(_sections.length, (index) {
              bool isSelected = _selectedSectionTabIndex == index;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedSectionTabIndex = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 12, right: 24),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: isSelected ? _accent : Colors.transparent, width: 2)),
                  ),
                  child: Text('Section ${_sections[index]['name']}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? _accent : _textMuted)),
                ),
              );
            }),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Icon(Icons.add, size: 16, color: Color(0xFF8F96A3)),
            ),
          ],
        ),
        const Divider(height: 1, color: Color(0xFFEBEBEB)),
        const SizedBox(height: 32),
        Row(
          children: [
            const Icon(Icons.apartment, size: 18, color: Color(0xFF181B20)),
            const SizedBox(width: 8),
            Text('Section ${_sections[_selectedSectionTabIndex]['name']}', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        const SizedBox(height: 32),
        _isWide ? Row(
          children: [
            Expanded(child: _buildSectionNameInput()),
            const SizedBox(width: 32),
            Expanded(child: _buildClassTeacherInput()),
          ],
        ) : Column(
          children: [
            _buildSectionNameInput(),
            const SizedBox(height: 16),
            _buildClassTeacherInput(),
          ],
        ),
        const SizedBox(height: 32),
        _isWide ? Row(
          children: [
            Expanded(child: _buildRoomInput()),
            const SizedBox(width: 32),
            Expanded(child: _buildCapacityInput()),
          ],
        ) : Column(
          children: [
            _buildRoomInput(),
            const SizedBox(height: 16),
            _buildCapacityInput(),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Room Number', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'e.g. 204',
            hintStyle: GoogleFonts.figtree(fontSize: 16, color: const Color(0xFF9CA3AF)),
            border: InputBorder.none,
          ),
          style: GoogleFonts.figtree(fontSize: 16, color: _textDark),
        ),
        const Divider(height: 1, color: Color(0xFFEBEBEB)),
      ],
    );
  }

  Widget _buildCapacityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Capacity', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _sections[_selectedSectionTabIndex]['capacity'],
          decoration: const InputDecoration(border: InputBorder.none),
          style: GoogleFonts.figtree(fontSize: 16, color: _textDark),
        ),
        const Divider(height: 1, color: Color(0xFFEBEBEB)),
      ],
    );
  }

  Widget _buildSectionNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Section Name', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: _sections[_selectedSectionTabIndex]['name'],
          decoration: const InputDecoration(border: InputBorder.none),
          style: GoogleFonts.figtree(fontSize: 16, color: _textDark),
        ),
        const Divider(height: 1, color: Color(0xFFEBEBEB)),
      ],
    );
  }

  Widget _buildClassTeacherInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Class Teacher', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
          hint: Text('Assign a teacher', style: GoogleFonts.figtree(fontSize: 16, color: const Color(0xFF9CA3AF)), overflow: TextOverflow.ellipsis),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF), size: 20),
          isExpanded: true,
          value: _sections[_selectedSectionTabIndex]['teacher'] as String?,
          items: ['Sarah Jenkins', 'Michael Brown', 'Emily Davis', 'David Wilson', 'Jessica Taylor']
              .map((t) => DropdownMenuItem(value: t, child: Text(t, style: GoogleFonts.figtree(fontSize: 16, color: _textDark), overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: (val) {
            setState(() {
              _sections[_selectedSectionTabIndex]['teacher'] = val;
            });
          },
        ),
        const SizedBox(height: 1),
        const Divider(height: 1, color: Color(0xFFEBEBEB)),
      ],
    );
  }
}
