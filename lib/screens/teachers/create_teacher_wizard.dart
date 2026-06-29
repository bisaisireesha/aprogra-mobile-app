import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTeacherWizard extends StatefulWidget {
  final Map<String, dynamic>? initialData;
  const CreateTeacherWizard({super.key, this.initialData});

  @override
  State<CreateTeacherWizard> createState() => _CreateTeacherWizardState();
}

class _CreateTeacherWizardState extends State<CreateTeacherWizard> {
  int _currentStep = 1;

  // Form fields
  final _employeeIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _selectedGender = 'Male';
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  
  String _selectedDepartment = 'Pre-Primary';
  final _designationController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _joiningDateController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  final _notesController = TextEditingController();
  final _subjectSearchController = TextEditingController();

  final List<String> _availableSubjects = [
    'Art & Craft', 'Computer Science', 'EVS', 'English', 'Hindi',
    'Mathematics', 'Music', 'Physical Education', 'Rhymes', 'Science',
    'Social Studies', 'Story Time'
  ];
  final Set<String> _selectedSubjects = {};

  final Color _accent = const Color(0xFF6366F1);
  final Color _textDark = const Color(0xFF111827);
  final Color _textMuted = const Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final t = widget.initialData!;
      _employeeIdController.text = t['id'] ?? '';
      _fullNameController.text = t['name'] ?? '';
      _selectedGender = t['gender'] ?? 'Male';
      _phoneController.text = t['phone'] ?? '';
      _emailController.text = t['email'] ?? '';
      _addressController.text = t['address'] ?? '';
      _selectedDepartment = t['department'] ?? 'Pre-Primary';
      _designationController.text = t['role'] ?? '';
      _qualificationController.text = t['qualification'] ?? '';
      _experienceController.text = (t['experience'] ?? '').replaceAll(' yrs', '');
      _joiningDateController.text = t['joiningDate'] ?? '';
      _emergencyContactController.text = t['emergencyContact'] ?? '';
      _notesController.text = t['notes'] ?? '';
      if (t['subjects'] != null) {
        _selectedSubjects.addAll((t['subjects'] as List).map((s) => s.toString()));
      }
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _designationController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _joiningDateController.dispose();
    _emergencyContactController.dispose();
    _notesController.dispose();
    _subjectSearchController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _submit() {
    final newTeacher = {
      'name': _fullNameController.text.isNotEmpty ? _fullNameController.text : 'New Teacher',
      'id': _employeeIdController.text.isNotEmpty ? _employeeIdController.text : 'EMP-NEW',
      'role': _designationController.text.isNotEmpty ? _designationController.text : 'Teacher',
      'department': _selectedDepartment,
      'subjects': _selectedSubjects.toList(),
      'experience': _experienceController.text.isNotEmpty ? '${_experienceController.text} yrs' : '0 yrs',
      'gender': _selectedGender,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'address': _addressController.text,
      'qualification': _qualificationController.text,
      'joiningDate': _joiningDateController.text,
      'emergencyContact': _emergencyContactController.text,
      'notes': _notesController.text,
    };
    Navigator.of(context).pop(newTeacher);
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {bool multiline = false, int maxLength = 300}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: _textDark)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: multiline ? 4 : 1,
          maxLength: multiline ? maxLength : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _accent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: _textDark)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: GoogleFonts.inter(fontSize: 14, color: _textDark)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon, Color iconBgColor, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: _textDark)),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: _textMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Personal details', 'Identity and contact information.', Icons.person_outline, const Color(0xFFEEF2FF), const Color(0xFF6366F1)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildTextField('Employee ID', 'e.g. EMP-204', _employeeIdController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Full Name', 'e.g. Mrs. Anita Rao', _fullNameController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDropdown('Gender', _selectedGender, ['Male', 'Female', 'Other'], (val) => setState(() => _selectedGender = val!))),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Phone', '+91 9xxxxxxxxx', _phoneController)),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField('Email', 'teacher@school.edu', _emailController),
        const SizedBox(height: 16),
        _buildTextField('Address', 'Street, City', _addressController),
        
        const SizedBox(height: 32),
        const Divider(color: Color(0xFFE5E7EB)),
        const SizedBox(height: 32),
        
        _buildSectionHeader('Professional details', 'Role, department and experience.', Icons.work_outline, const Color(0xFFEEF2FF), const Color(0xFF6366F1)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: _buildDropdown('Department', _selectedDepartment, ['Pre-Primary', 'Primary', 'Secondary'], (val) => setState(() => _selectedDepartment = val!))),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Designation', 'Class Teacher', _designationController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Qualification', 'e.g. M.Sc, B.Ed', _qualificationController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Experience (years)', '0', _experienceController)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField('Joining Date', 'DD/MM/YYYY', _joiningDateController)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField('Emergency Contact', '+91 9xxxxxxxxx', _emergencyContactController)),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Assigned subjects', 'Pick one or more subjects this teacher handles.', Icons.menu_book, const Color(0xFFEEF2FF), const Color(0xFF6366F1)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _subjectSearchController,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search subjects',
                    hintStyle: GoogleFonts.inter(color: const Color(0xFF9CA3AF), fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableSubjects.where((s) => s.toLowerCase().contains(_subjectSearchController.text.toLowerCase())).map((subject) {
            final isSelected = _selectedSubjects.contains(subject);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSubjects.remove(subject);
                  } else {
                    _selectedSubjects.add(subject);
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? const Color(0xFF818CF8) : const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      size: 18,
                      color: isSelected ? _accent : const Color(0xFFD1D5DB),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subject,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _textDark,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 32),
        const Divider(color: Color(0xFFE5E7EB)),
        const SizedBox(height: 32),
        
        _buildSectionHeader('Notes', 'Any additional information', Icons.description_outlined, const Color(0xFFEEF2FF), const Color(0xFF6366F1)),
        const SizedBox(height: 24),
        _buildTextField('', 'Write any additional information...', _notesController, multiline: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _currentStep == 1 ? 'Add New Teacher' : 'Teacher Additional Details';
    final subtitle = _currentStep == 1 ? 'Personal, professional details and subject assignments.' : '';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 600,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
                        if (subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(subtitle, style: GoogleFonts.inter(fontSize: 14, color: _textMuted)),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_currentStep == 2) {
                          setState(() => _currentStep = 1);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(_currentStep == 2 ? 'Back' : 'Cancel', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        _currentStep == 1 ? 'Create Teacher' : 'Save Details',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
