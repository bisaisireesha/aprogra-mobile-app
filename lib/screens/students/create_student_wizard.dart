import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF6C5CE7);

class CreateStudentWizard extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? initialStudent;
  const CreateStudentWizard({super.key, this.initialStudent, this.isEditing = false});

  @override
  State<CreateStudentWizard> createState() => _CreateStudentWizardState();
}

class _CreateStudentWizardState extends State<CreateStudentWizard> {
  int _currentStep = 0; // 0 to 5

  // Step 1: Basics
  String _admissionNo = '';
  String _studentName = '';
  String _gender = 'Male';
  String _dob = '';
  String _nationality = 'Indian';
  String _address = '';
  String _aadhaar = '';

  // Step 2: Academic
  String _level = 'Primary';
  String? _classSection;
  String _rollNumber = '';
  String _academicYear = '2025 - 2026';

  // Step 3: Guardian
  String _fatherName = '';
  String _motherName = '';
  String? _primaryGuardian;
  String _contactNumber = '';
  String _email = '';

  // Step 4: Medical
  String? _bloodGroup;
  String _emergencyName = '';
  String _emergencyNumber = '';
  String _medicalNotes = '';

  // Step 5: Admission
  String _admissionDate = '';
  String _prevSchool = '';
  String _admissionType = 'New Admission';
  String _reference = '';

  bool get _isWide => MediaQuery.sizeOf(context).width > 600;

  @override
  void initState() {
    super.initState();
    if (widget.initialStudent != null) {
      _studentName = widget.initialStudent!['name'] ?? '';
      _classSection = widget.initialStudent!['class'];
      _rollNumber = widget.initialStudent!['roll']?.toString().replaceAll('Roll #', '') ?? '';
      _fatherName = widget.initialStudent!['parent'] ?? '';
      
      if (_classSection != null) {
        if (['Nursery A', 'Nursery B', 'LKG A', 'LKG B', 'UKG A', 'UKG B'].contains(_classSection)) {
          _level = 'Pre-Primary';
        } else if (['Class 1A', 'Class 1B', 'Class 2A', 'Class 3A', 'Class 4A', 'Class 5A'].contains(_classSection)) {
          _level = 'Primary';
        } else {
          _level = 'Secondary';
        }
      }
    }
  }

  void _nextStep() {
    setState(() {
      if (_currentStep < 5) _currentStep++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 0) _currentStep--;
    });
  }

  void _submitWizard() {
    String initials = '';
    final parts = _studentName.trim().split(' ');
    if (parts.isNotEmpty) {
      initials += parts.first[0].toUpperCase();
      if (parts.length > 1 && parts.last.isNotEmpty) {
        initials += parts.last[0].toUpperCase();
      }
    }
    if (initials.isEmpty) initials = '?';

    String parent = _fatherName;
    if (parent.trim().isEmpty) parent = _motherName;
    if (parent.trim().isEmpty) parent = 'Unknown Parent';

    final newStudent = {
      'initials': initials,
      'name': _studentName.trim().isEmpty ? 'New Student' : _studentName.trim(),
      'roll': _rollNumber.trim().isEmpty ? 'Roll #--' : 'Roll #${_rollNumber.trim()}',
      'class': _classSection ?? 'Unknown Class',
      'parent': parent,
      'dob': _dob,
      'bloodGroup': _bloodGroup,
      'nationality': _nationality,
      'address': _address,
      'fatherName': _fatherName,
      'motherName': _motherName,
      'contactNumber': _contactNumber,
      'email': _email,
      'admissionNo': _admissionNo,
      'aadhaar': _aadhaar,
    };
    Navigator.pop(context, newStudent);
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
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildCurrentStep(),
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
                  child: Text(
                    _currentStep == 5 
                        ? (widget.isEditing ? 'Review Changes' : 'Review Student Details')
                        : (widget.isEditing ? 'Edit Student Details' : 'Add New Student'), 
                    style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEBEBEB)),
      ],
    );
  }

  Widget _buildStepIndicator() {
    if (_currentStep == 5) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 24, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(9, (index) {
          if (index % 2 != 0) {
            int stepIndex = index ~/ 2;
            bool isCompleted = _currentStep > stepIndex;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? _accent : const Color(0xFFEBEBEB),
              ),
            );
          } else {
            int stepIndex = index ~/ 2;
            bool isActive = _currentStep == stepIndex;
            bool isCompleted = _currentStep > stepIndex;
            return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isActive || isCompleted ? Colors.white : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isActive || isCompleted ? _accent : const Color(0xFFEBEBEB),
                  width: isActive || isCompleted ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, size: 16, color: _accent)
                    : Text(
                        '${stepIndex + 1}',
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isActive ? _accent : const Color(0xFF8F96A3),
                        ),
                      ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildStep1Basics();
      case 1: return _buildStep2Academic();
      case 2: return _buildStep3Guardian();
      case 3: return _buildStep4Medical();
      case 4: return _buildStep5Admission();
      case 5: return _buildStep6Review();
      default: return const SizedBox();
    }
  }

  Widget _buildStep1Basics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Student Basics', 'Identity and admission details.'),
        const SizedBox(height: 24),
        Center(
          child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.face, size: 40, color: _accent),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_outlined, size: 16, color: _textDark),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildInputField('Admission No.', 'e.g. ADM-25-1042', _admissionNo, (val) => _admissionNo = val),
        const SizedBox(height: 16),
        _buildInputField('Student Name', 'e.g. Aarav Sharma', _studentName, (val) => _studentName = val),
        const SizedBox(height: 16),
        Text('Gender', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildGenderBtn('Male')),
            const SizedBox(width: 8),
            Expanded(child: _buildGenderBtn('Female')),
            const SizedBox(width: 8),
            Expanded(child: _buildGenderBtn('Other')),
          ],
        ),
        const SizedBox(height: 16),
        _buildInputField('Date of Birth', 'DD/MM/YYYY', _dob, (val) => _dob = val, icon: Icons.calendar_today_outlined, readOnly: true, onTap: () async {
          DateTime initial = DateTime.now();
          if (_dob.isNotEmpty && _dob.contains('/')) {
            final parts = _dob.split('/');
            if (parts.length == 3) {
              initial = DateTime.tryParse('${parts[2]}-${parts[1]}-${parts[0]}') ?? DateTime.now();
            }
          }
          final date = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: DateTime(1990),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            setState(() {
              _dob = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
            });
          }
        }),
        const SizedBox(height: 16),
        _buildDropdown('Nationality', ['Indian', 'Other'], _nationality, (val) => _nationality = val!),
        const SizedBox(height: 16),
        _buildInputField('Address', 'e.g. 123, Main Street, City', _address, (val) => _address = val, maxLines: 2),
      ],
    );
  }

  Widget _buildGenderBtn(String title) {
    bool isSelected = _gender == title;
    return GestureDetector(
      onTap: () => setState(() => _gender = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F1FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
        ),
        alignment: Alignment.center,
        child: Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? _accent : _textDark)),
      ),
    );
  }

  List<String> get _currentClasses {
    if (_level == 'Pre-Primary') {
      return ['Nursery A', 'Nursery B', 'LKG A', 'LKG B', 'UKG A', 'UKG B'];
    } else if (_level == 'Primary') {
      return ['Class 1A', 'Class 1B', 'Class 2A', 'Class 3A', 'Class 4A', 'Class 5A'];
    } else {
      return ['Class 6A', 'Class 7A', 'Class 8A', 'Class 9A', 'Class 10A', 'Class 11 Science', 'Class 12 Commerce'];
    }
  }

  Widget _buildStep2Academic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Academic Placement', 'Choose class, section and roll number.'),
        const SizedBox(height: 24),
        Text('Level', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildLevelCard('Pre-Primary', 'Nursery - UKG', Icons.shield_outlined)),
            const SizedBox(width: 8),
            Expanded(child: _buildLevelCard('Primary', 'Class 1 - 5', Icons.backpack_outlined)),
            const SizedBox(width: 8),
            Expanded(child: _buildLevelCard('Secondary', 'Class 6 - 12', Icons.school_outlined)),
          ],
        ),
        const SizedBox(height: 24),
        _buildDropdown('Class / Section', _currentClasses, _classSection, (val) => _classSection = val, hint: 'Select Class'),
        const SizedBox(height: 16),
        _buildInputField('Roll Number', 'e.g. 15', _rollNumber, (val) => _rollNumber = val, keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildDropdown('Academic Year', ['2024 - 2025', '2025 - 2026'], _academicYear, (val) => _academicYear = val!),
      ],
    );
  }

  Widget _buildLevelCard(String title, String subtitle, IconData icon) {
    bool isSelected = _level == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _level = title;
          if (!_currentClasses.contains(_classSection)) {
            _classSection = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F1FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? _accent : const Color(0xFFEBEBEB)),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? _accent : const Color(0xFF8F96A3), size: 24),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? _textDark : _textDark)),
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3Guardian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Guardian & Contact', 'Primary contact for the student.'),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.people_outline, color: _accent, size: 18),
            const SizedBox(width: 8),
            Text('Parents / Guardians', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInputField('Father\'s Name', 'e.g. Rajesh Sharma', _fatherName, (val) => _fatherName = val),
        const SizedBox(height: 16),
        _buildInputField('Mother\'s Name', 'e.g. Priya Sharma', _motherName, (val) => _motherName = val),
        const SizedBox(height: 16),
        _buildDropdown('Primary Guardian', ['Father', 'Mother', 'Other'], _primaryGuardian, (val) => _primaryGuardian = val, hint: 'Select relationship'),
        const SizedBox(height: 16),
        _buildInputField('Contact Number', 'e.g. 9876543210', _contactNumber, (val) => _contactNumber = val, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildInputField('Email (optional)', 'parent@example.com', _email, (val) => _email = val),
      ],
    );
  }

  Widget _buildStep4Medical() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Medical & Emergency', 'Health and emergency information.'),
        const SizedBox(height: 24),
        _buildDropdown('Blood Group', ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'], _bloodGroup, (val) => _bloodGroup = val, hint: 'Select blood group'),
        const SizedBox(height: 16),
        _buildInputField('Emergency Contact Name', 'e.g. Priya Sharma', _emergencyName, (val) => _emergencyName = val),
        const SizedBox(height: 16),
        _buildInputField('Emergency Contact Number', 'e.g. 9876543210', _emergencyNumber, (val) => _emergencyNumber = val, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildInputField('Notes (optional)', 'Any important medical notes', _medicalNotes, (val) => _medicalNotes = val, maxLines: 3),
      ],
    );
  }

  Widget _buildStep5Admission() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Admission Details', 'Final details before saving.'),
        const SizedBox(height: 24),
        _buildInputField('Admission Date', 'DD/MM/YYYY', _admissionDate, (val) => _admissionDate = val, icon: Icons.calendar_today_outlined, readOnly: true, onTap: () async {
          DateTime initial = DateTime.now();
          if (_admissionDate.isNotEmpty && _admissionDate.contains('/')) {
            final parts = _admissionDate.split('/');
            if (parts.length == 3) {
              initial = DateTime.tryParse('${parts[2]}-${parts[1]}-${parts[0]}') ?? DateTime.now();
            }
          }
          final date = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            setState(() {
              _admissionDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
            });
          }
        }),
        const SizedBox(height: 16),
        _buildInputField('Previous School (optional)', 'School name (if any)', _prevSchool, (val) => _prevSchool = val),
        const SizedBox(height: 16),
        _buildDropdown('Admission Type', ['New Admission', 'Transfer'], _admissionType, (val) => _admissionType = val!),
        const SizedBox(height: 16),
        _buildInputField('Reference (optional)', 'Who referred the admission?', _reference, (val) => _reference = val),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEBEBEB)),
          ),
          child: Row(
            children: [
              const Icon(Icons.description_outlined, color: _accent, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Summary Preview', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                    const SizedBox(height: 4),
                    Text('Review all details before creating the student record.', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep6Review() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Student Overview', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: _accent,
              child: Text(
                _studentName.isNotEmpty ? _studentName[0].toUpperCase() : '?',
                style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_studentName.isEmpty ? 'Student Name' : _studentName, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _textDark)),
                  const SizedBox(height: 4),
                  Text(_admissionNo.isEmpty ? 'ADM-XX-XXXX' : _admissionNo, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFFF4F1FF), borderRadius: BorderRadius.circular(8)),
              child: Text(_classSection ?? 'Class --', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: _accent)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildReviewSection(LucideIcons.user, 'Basics', [
          '$_gender  •  ${_dob.isEmpty ? 'DD/MM/YYYY' : _dob}',
          '$_nationality  •  New Admission',
        ]),
        _buildReviewSection(LucideIcons.graduationCap, 'Academic', [
          '$_level  •  ${_classSection ?? 'Class --'}',
          'Roll No. ${_rollNumber.isEmpty ? '--' : _rollNumber}  •  $_academicYear',
        ]),
        _buildReviewSection(LucideIcons.users, 'Guardian', [
          '${_fatherName.isEmpty ? 'Father Name' : _fatherName} (Father)',
          '${_motherName.isEmpty ? 'Mother Name' : _motherName} (Mother)',
          _contactNumber.isEmpty ? '+91 ----------' : _contactNumber,
        ]),
        _buildReviewSection(LucideIcons.activity, 'Medical', [
          '${_bloodGroup ?? 'O+'}',
          'Emergency: ${_emergencyName.isEmpty ? '--' : _emergencyName}',
        ], isRed: true),
        _buildReviewSection(LucideIcons.fileText, 'Admission', [
          'Date: ${_admissionDate.isEmpty ? 'DD/MM/YYYY' : _admissionDate}',
          'Previous School: ${_prevSchool.isEmpty ? '--' : _prevSchool}',
        ]),
      ],
    );
  }

  Widget _buildReviewSection(IconData icon, String title, List<String> details, {bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isRed ? Colors.redAccent.withValues(alpha: 0.1) : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: isRed ? Colors.redAccent : const Color(0xFF8F96A3)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                    Icon(Icons.edit_outlined, size: 16, color: _textMuted),
                  ],
                ),
                const SizedBox(height: 8),
                ...details.map((detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(detail, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _textDark)),
        const SizedBox(height: 4),
        Text(subtitle, style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
      ],
    );
  }

  Widget _buildInputField(String label, String hint, String value, Function(String) onChanged, {IconData? icon, int maxLines = 1, TextInputType? keyboardType, bool readOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEBEBEB)),
              color: Colors.white,
            ),
            child: TextFormField(
              key: readOnly ? ValueKey('${label}_$value') : ValueKey(label),
              initialValue: value,
              maxLines: maxLines,
              keyboardType: keyboardType,
              readOnly: readOnly,
              enabled: !readOnly || onTap != null,
              onTap: onTap,
              onChanged: (val) {
                setState(() {
                  onChanged(val);
                });
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.figtree(color: const Color(0xFF9CA3AF), fontSize: 14),
                suffixIcon: icon != null ? Icon(icon, color: const Color(0xFF9CA3AF), size: 20) : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              style: GoogleFonts.figtree(fontSize: 14, color: _textDark),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged, {String? hint}) {
    // Safely handle value to prevent dropdown errors if the value is not in the items list
    final safeValue = value != null && items.contains(value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _textDark)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEBEBEB)),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            dropdownColor: Colors.white,
            decoration: const InputDecoration(border: InputBorder.none),
            hint: hint != null ? Text(hint, style: GoogleFonts.figtree(color: const Color(0xFF9CA3AF), fontSize: 14)) : null,
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
            value: safeValue,
            items: items.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val, style: GoogleFonts.figtree(color: _textDark, fontSize: 14)),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                onChanged(val);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == 0 ? () => Navigator.pop(context) : _prevStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFFEBEBEB))),
                elevation: 0,
              ),
              child: Text(_currentStep == 0 ? 'Cancel' : 'Back', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep == 5 ? _submitWizard : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text(
                _currentStep == 5 
                    ? (widget.isEditing ? 'Save Changes' : 'Create Student') 
                    : 'Continue', 
                style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
