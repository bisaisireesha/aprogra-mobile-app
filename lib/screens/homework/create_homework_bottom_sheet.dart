import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Class-specific data mapping
const _classCategoryMap = {
  // Pre-Primary
  'Nursery A': 'Pre-Primary', 'Nursery B': 'Pre-Primary', 'Nursery C': 'Pre-Primary',
  'LKG A': 'Pre-Primary', 'LKG B': 'Pre-Primary', 'LKG C': 'Pre-Primary',
  'UKG A': 'Pre-Primary', 'UKG B': 'Pre-Primary', 'UKG C': 'Pre-Primary',
  // Primary
  'Class 1A': 'Primary', 'Class 1B': 'Primary', 'Class 1C': 'Primary',
  'Class 2A': 'Primary', 'Class 2B': 'Primary', 'Class 2C': 'Primary',
  'Class 3A': 'Primary', 'Class 3B': 'Primary',
  'Class 4A': 'Primary', 'Class 4B': 'Primary', 'Class 4C': 'Primary',
  'Class 5A': 'Primary', 'Class 5B': 'Primary',
  // Secondary
  'Class 6A': 'Secondary', 'Class 6B': 'Secondary',
  'Class 7A': 'Secondary', 'Class 7B': 'Secondary',
  'Class 8A': 'Secondary', 'Class 8B': 'Secondary',
  'Class 9A': 'Secondary', 'Class 9B': 'Secondary',
  'Class 10A': 'Secondary', 'Class 10B': 'Secondary',
  'Class 11A': 'Secondary', 'Class 12A': 'Secondary',
};

const _classTeacherMap = {
  'Nursery A': ['Anjali Sharma', 'Priya Nair'],
  'Nursery B': ['Priya Nair'],
  'Nursery C': ['Deepa Pillai'],
  'LKG A': ['Anjali Sharma'],
  'LKG B': ['Priya Nair'],
  'LKG C': ['Deepa Pillai'],
  'UKG A': ['Anjali Sharma', 'Deepa Pillai'],
  'UKG B': ['Priya Nair'],
  'UKG C': ['Deepa Pillai'],
  'Class 1A': ['Sneha Das', 'Kavita Menon'],
  'Class 1B': ['Sunita Reddy'],
  'Class 1C': ['Ritu Kapoor'],
  'Class 2A': ['Kavita Menon'],
  'Class 2B': ['Sneha Das', 'Ritu Kapoor'],
  'Class 2C': ['Sunita Reddy'],
  'Class 3A': ['Kavita Menon', 'Vikram Singh'],
  'Class 3B': ['Ritu Kapoor'],
  'Class 4A': ['Vikram Singh'],
  'Class 4B': ['Kavita Menon'],
  'Class 4C': ['Sneha Das'],
  'Class 5A': ['Vikram Singh', 'Sneha Das'],
  'Class 5B': ['Sunita Reddy'],
  'Class 6A': ['Rajesh Kumar', 'Nidhi Verma'],
  'Class 6B': ['Ramesh Iyer'],
  'Class 7A': ['Dr. S. K. Rao'],
  'Class 7B': ['Rajesh Kumar'],
  'Class 8A': ['Nidhi Verma', 'Ramesh Iyer'],
  'Class 8B': ['Dr. S. K. Rao'],
  'Class 9A': ['Rajesh Kumar'],
  'Class 9B': ['Rajesh Kumar', 'Dr. S. K. Rao'],
  'Class 10A': ['Nidhi Verma'],
  'Class 10B': ['Ramesh Iyer'],
  'Class 11A': ['Dr. S. K. Rao', 'Nidhi Verma'],
  'Class 12A': ['Ramesh Iyer', 'Rajesh Kumar'],
};

const _classSubjectMap = {
  'Nursery A': ['Rhymes', 'Alphabet', 'Numbers', 'Art & Craft'],
  'Nursery B': ['Rhymes', 'Alphabet', 'Numbers', 'Art & Craft'],
  'Nursery C': ['Rhymes', 'Alphabet', 'Numbers', 'Art & Craft'],
  'LKG A': ['Rhymes', 'Alphabet', 'Numbers', 'Drawing'],
  'LKG B': ['Rhymes', 'Alphabet', 'Numbers', 'Drawing'],
  'LKG C': ['Rhymes', 'Alphabet', 'Numbers', 'Drawing'],
  'UKG A': ['Alphabet', 'Numbers', 'Stories', 'Drawing'],
  'UKG B': ['Alphabet', 'Numbers', 'Stories', 'Drawing'],
  'UKG C': ['Alphabet', 'Numbers', 'Stories', 'Drawing'],
  'Class 1A': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 1B': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 1C': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 2A': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 2B': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 2C': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 3A': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 3B': ['English', 'Mathematics', 'EVS', 'Hindi', 'Art & Craft', 'PE'],
  'Class 4A': ['English', 'Mathematics', 'Science', 'Hindi', 'Social Studies', 'PE'],
  'Class 4B': ['English', 'Mathematics', 'Science', 'Hindi', 'Social Studies', 'PE'],
  'Class 4C': ['English', 'Mathematics', 'Science', 'Hindi', 'Social Studies', 'PE'],
  'Class 5A': ['English', 'Mathematics', 'Science', 'Hindi', 'Social Studies', 'PE'],
  'Class 5B': ['English', 'Mathematics', 'Science', 'Hindi', 'Social Studies', 'PE'],
  'Class 6A': ['Mathematics', 'Science', 'English', 'History', 'Geography', 'Computer'],
  'Class 6B': ['Mathematics', 'Science', 'English', 'History', 'Geography', 'Computer'],
  'Class 7A': ['Mathematics', 'Physics', 'Chemistry', 'English', 'History', 'Computer'],
  'Class 7B': ['Mathematics', 'Physics', 'Chemistry', 'English', 'History', 'Computer'],
  'Class 8A': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
  'Class 8B': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
  'Class 9A': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
  'Class 9B': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
  'Class 10A': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
  'Class 10B': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
  'Class 11A': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
  'Class 12A': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'English', 'Computer Science'],
};

class CreateHomeworkBottomSheet extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>)? onSave;

  const CreateHomeworkBottomSheet({
    super.key,
    this.initialData,
    this.onSave,
  });

  @override
  State<CreateHomeworkBottomSheet> createState() => _CreateHomeworkBottomSheetState();
}

class _CreateHomeworkBottomSheetState extends State<CreateHomeworkBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String? _selectedClass;
  String? _selectedSubject;
  String? _selectedTeacher;
  DateTime? _selectedDate;

  final List<String> _allClasses = [
    'Nursery A', 'Nursery B', 'Nursery C',
    'LKG A', 'LKG B', 'LKG C',
    'UKG A', 'UKG B', 'UKG C',
    'Class 1A', 'Class 1B', 'Class 1C',
    'Class 2A', 'Class 2B', 'Class 2C',
    'Class 3A', 'Class 3B',
    'Class 4A', 'Class 4B', 'Class 4C',
    'Class 5A', 'Class 5B',
    'Class 6A', 'Class 6B',
    'Class 7A', 'Class 7B',
    'Class 8A', 'Class 8B',
    'Class 9A', 'Class 9B',
    'Class 10A', 'Class 10B',
    'Class 11A', 'Class 12A',
  ];

  List<String> get _availableSubjects =>
      _selectedClass != null ? (_classSubjectMap[_selectedClass] ?? []) : [];

  List<String> get _availableTeachers =>
      _selectedClass != null ? (_classTeacherMap[_selectedClass] ?? []) : [];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _titleController.text = widget.initialData!['title'] ?? '';
      _descController.text = widget.initialData!['description'] ?? '';
      _selectedClass = widget.initialData!['class'];
      _selectedTeacher = widget.initialData!['teacher'];
      _selectedDate = DateTime.now().add(const Duration(days: 3));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (widget.onSave != null) {
      final isEdit = widget.initialData != null;
      final category = _classCategoryMap[_selectedClass] ?? 'Primary';
      final newItem = {
        'title': _titleController.text.isNotEmpty ? _titleController.text : 'New Homework',
        'class': _selectedClass ?? 'Unassigned',
        'teacher': _selectedTeacher ?? 'Unassigned',
        'due': _selectedDate != null
            ? "${_selectedDate!.day}/${_selectedDate!.month}"
            : 'No Due Date',
        'submitted': isEdit ? widget.initialData!['submitted'] : 0,
        'total': isEdit ? widget.initialData!['total'] : 30,
        'icon': isEdit ? widget.initialData!['icon'] : LucideIcons.notebookPen,
        'category': category,
        'description': _descController.text,
      };
      if (isEdit) {
        final merged = Map<String, dynamic>.from(widget.initialData!);
        merged.addAll(newItem);
        widget.onSave!(merged);
      } else {
        widget.onSave!(newItem);
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Color(0xFF8F96A3), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.initialData != null ? 'Edit Homework' : 'Create New Homework',
                        style: GoogleFonts.figtree(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF181B20),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Assign homework to a class and a teacher to follow up.',
                        style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF595973)),
                      ),
                    ],
                  ),
                ),
                // Purple Create/Save button
                GestureDetector(
                  onTap: _handleSave,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8463E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.initialData != null ? 'Save Changes' : 'Create Homework',
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            _buildTextField(
              label: 'Homework Title',
              hint: 'e.g. Read Chapter 3 aloud',
              icon: LucideIcons.bookOpen,
              controller: _titleController,
            ),

            const SizedBox(height: 24),

            // Class Dropdown (full width)
            _buildDropdownField(
              label: 'Class',
              hint: 'Select a class',
              icon: LucideIcons.graduationCap,
              value: _selectedClass,
              items: _allClasses,
              onChanged: (val) => setState(() {
                _selectedClass = val;
                _selectedSubject = null;
                _selectedTeacher = null;
              }),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Subject (optional)',
                    hint: _selectedClass == null ? 'Select a class first' : 'Pick a subject',
                    icon: LucideIcons.layers,
                    value: _selectedSubject,
                    items: _availableSubjects,
                    onChanged: _selectedClass == null ? null : (val) => setState(() => _selectedSubject = val),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Assigned Teacher',
                    hint: _selectedClass == null ? 'Select a class first' : 'Pick a teacher',
                    icon: LucideIcons.user,
                    value: _selectedTeacher,
                    items: _availableTeachers,
                    onChanged: _selectedClass == null ? null : (val) => setState(() => _selectedTeacher = val),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildDateField(),

            const SizedBox(height: 24),

            Text(
              'Description (optional)',
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF595973),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                color: Colors.white,
              ),
              child: TextField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Brief instructions for the class',
                  hintStyle: GoogleFonts.figtree(color: const Color(0xFF8F96A3)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 16, color: const Color(0xFF595973)),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF595973))),
        ]),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.figtree(color: const Color(0xFF8F96A3)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    final isDisabled = onChanged == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 16, color: const Color(0xFF595973)),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF595973))),
        ]),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            color: isDisabled ? const Color(0xFFF9FAFB) : Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: (value != null && items.contains(value)) ? value : null,
              hint: Text(hint, style: GoogleFonts.figtree(color: const Color(0xFF8F96A3))),
              icon: Icon(LucideIcons.chevronDown, size: 16, color: isDisabled ? const Color(0xFFD1D5DB) : const Color(0xFF8F96A3)),
              style: GoogleFonts.figtree(color: const Color(0xFF181B20)),
              dropdownColor: Colors.white, // White dropdown list background
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, style: GoogleFonts.figtree(color: const Color(0xFF181B20))),
                );
              }).toList(),
              onChanged: isDisabled ? null : onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(LucideIcons.calendarDays, size: 16, color: Color(0xFF595973)),
          const SizedBox(width: 8),
          Text('Due Date', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF595973))),
        ]),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) setState(() => _selectedDate = date);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.calendarDays, size: 16, color: Color(0xFF8F96A3)),
                const SizedBox(width: 8),
                Text(
                  _selectedDate != null
                      ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                      : 'Pick a due date',
                  style: GoogleFonts.figtree(
                    color: _selectedDate != null ? const Color(0xFF181B20) : const Color(0xFF8F96A3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
