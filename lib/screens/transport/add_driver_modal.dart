import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddDriverModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialDriver;
  final String title;
  final String saveText;

  const AddDriverModal({
    super.key,
    required this.onSave,
    this.initialDriver,
    this.title = 'Add Driver',
    this.saveText = 'Save',
  });

  @override
  State<AddDriverModal> createState() => _AddDriverModalState();
}

class _AddDriverModalState extends State<AddDriverModal> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  
  final _licenseController = TextEditingController();
  final _experienceController = TextEditingController();
  
  final _emerNameController = TextEditingController();
  final _emerRelController = TextEditingController();
  final _emerPhoneController = TextEditingController();

  DateTime? _dob;
  DateTime? _issueDate;
  DateTime? _expiryDate;

  String _gender = 'Select gender';
  String _bloodGroup = 'Select blood group';
  String _nationality = 'Indian';
  
  String _licenseType = 'Select license type';
  
  String _vehicle = 'Select vehicle';
  String _route = 'Select route';
  String _vehicleType = 'Select vehicle type';
  String _workType = 'Select work type';
  
  String _status = 'On Duty';

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialDriver != null) {
      _nameController.text = widget.initialDriver!['name'] ?? '';
      _idController.text = widget.initialDriver!['id'] ?? '';
      _licenseController.text = widget.initialDriver!['license'] ?? '';
      
      final exp = widget.initialDriver!['exp'];
      if (exp != null) {
        try {
          _expiryDate = DateFormat('dd MMM yyyy').parse(exp);
        } catch (e) {
          // ignore parse error
        }
      }
      
      final bus = widget.initialDriver!['bus'];
      if (bus != null) _vehicle = bus;
      
      final route = widget.initialDriver!['route'];
      if (route != null) _route = route;
      
      final status = widget.initialDriver!['status'];
      if (status != null && ['On Duty', 'Available', 'On Leave'].contains(status)) {
        _status = status;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    _emerNameController.dispose();
    _emerRelController.dispose();
    _emerPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1), // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Color(0xFF181821), // body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _saveDriver() {
    Color getStatusColor(String val) {
      switch (val) {
        case 'On Duty':
          return const Color(0xFF10B981); // Green
        case 'Available':
          return const Color(0xFF0EA5E9); // Blue
        case 'On Leave':
          return const Color(0xFFF59E0B); // Orange
        default:
          return const Color(0xFF94A3B8);
      }
    }

    final isExpiringSoon = _expiryDate != null && _expiryDate!.difference(DateTime.now()).inDays < 90;

    final newDriver = {
      'name': _nameController.text.isNotEmpty ? _nameController.text : 'New Driver',
      'id': _idController.text.isNotEmpty ? _idController.text : 'NEW-01',
      'license': _licenseController.text.isNotEmpty ? _licenseController.text : 'DL-XXXXXXXXXX',
      'exp': _expiryDate != null ? DateFormat('dd MMM yyyy').format(_expiryDate!) : 'Unknown',
      'expiringSoon': isExpiringSoon,
      'bus': _vehicle != 'Select vehicle' ? _vehicle : 'Unassigned',
      'route': _route != 'Select route' ? _route : 'Unassigned',
      'status': _status,
      'statusColor': getStatusColor(_status),
    };

    widget.onSave(newDriver);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    title: 'Personal Information',
                    icon: LucideIcons.user,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Driver Name', _nameController, hint: 'e.g. R. Sharma', required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Driver ID', _idController, hint: 'e.g. ID-0007', required: false, titleSuffix: '(Optional)'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker('Date of Birth', _dob, (date) => setState(() => _dob = date), required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Gender',
                              _gender,
                              ['Select gender', 'Male', 'Female', 'Other'],
                              (val) => setState(() => _gender = val!),
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'Blood Group',
                              _bloodGroup,
                              ['Select blood group', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                              (val) => setState(() => _bloodGroup = val!),
                              required: false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Nationality',
                              _nationality,
                              ['Indian', 'Other'],
                              (val) => setState(() => _nationality = val!),
                              required: false,
                            ),
                          ),
                        ],
                      ),
                      _buildTextField('Address', _addressController, hint: 'e.g. Sector 42, Delhi - 110001', required: true, maxLines: 2),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Phone Number', _phoneController, hint: '+91 98xxxx 1023', required: true, prefixIcon: LucideIcons.phone),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Alternate Number', _altPhoneController, hint: '+91 98xxxx 5678', required: false, prefixIcon: LucideIcons.phone, titleSuffix: '(Optional)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSectionCard(
                    title: 'License Information',
                    icon: LucideIcons.contact,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('License Number', _licenseController, hint: 'e.g. DL-1320110012345', required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'License Type',
                              _licenseType,
                              ['Select license type', 'Heavy Motor Vehicle (HMV)', 'Light Motor Vehicle (LMV)'],
                              (val) => setState(() => _licenseType = val!),
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePicker('Issue Date', _issueDate, (date) => setState(() => _issueDate = date), required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDatePicker('Expiry Date', _expiryDate, (date) => setState(() => _expiryDate = date), required: true),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField('Experience (Years)', _experienceController, hint: 'e.g. 5', required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildImageUpload('Upload License (Photo)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildSectionCard(
                    title: 'Vehicle & Route Assignment',
                    icon: LucideIcons.car,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'Assign Vehicle',
                              _vehicle,
                              ['Select vehicle', 'BUS-118', 'BUS-204', 'BUS-392', 'BUS-405', 'BUS-551'],
                              (val) => setState(() => _vehicle = val!),
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Assign Route',
                              _route,
                              ['Select route', 'Route R-03', 'Route R-07', 'Route R-09', 'Route R-12', 'Route R-15'],
                              (val) => setState(() => _route = val!),
                              required: false,
                              titleSuffix: '(Optional)',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'Vehicle Type',
                              _vehicleType,
                              ['Select vehicle type', 'Bus', 'Van', 'Mini-bus'],
                              (val) => setState(() => _vehicleType = val!),
                              required: false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Work Type',
                              _workType,
                              ['Select work type', 'Full-time', 'Part-time', 'Contract'],
                              (val) => setState(() => _workType = val!),
                              required: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSectionCard(
                    title: 'Emergency Contact',
                    icon: LucideIcons.users,
                    iconColor: const Color(0xFF6366F1),
                    titleSuffix: '(Optional)',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Contact Name', _emerNameController, hint: 'e.g. Suresh Sharma', required: false),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Relationship', _emerRelController, hint: 'e.g. Brother', required: false),
                          ),
                        ],
                      ),
                      _buildTextField('Phone Number', _emerPhoneController, hint: '+91 98xxxx 1234', required: false, prefixIcon: LucideIcons.phone),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSectionCard(
                    title: 'Status',
                    icon: LucideIcons.shieldCheck,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      _buildDropdown(
                        'Status',
                        _status,
                        ['On Duty', 'Available', 'On Leave'],
                        (val) => setState(() => _status = val!),
                        required: true,
                        showDot: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(LucideIcons.x, size: 24, color: Color(0xFF181821)),
              ),
              Text(
                widget.title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
              GestureDetector(
                onTap: _saveDriver,
                child: Text(
                  widget.saveText,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
    String? titleSuffix,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF181821),
                ),
              ),
              if (titleSuffix != null) ...[
                const SizedBox(width: 6),
                Text(
                  titleSuffix,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String hint = '', bool required = false, int maxLines = 1, String? titleSuffix, IconData? prefixIcon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF595973),
                ),
              ),
              if (required) ...[
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
              ],
              if (titleSuffix != null) ...[
                const SizedBox(width: 4),
                Text(
                  titleSuffix,
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                ),
              ]
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF181821)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
                prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16, color: const Color(0xFF94A3B8)) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onDateSelected, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF595973),
                ),
              ),
              if (required) ...[
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
              ]
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context, date, onDateSelected),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date != null ? DateFormat('dd / MM / yyyy').format(date) : 'DD / MM / YYYY',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: date != null ? const Color(0xFF181821) : const Color(0xFF94A3B8),
                    ),
                  ),
                  const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged, {bool required = false, bool showDot = false, String? titleSuffix}) {
    Color getStatusColor(String val) {
      switch (val) {
        case 'On Duty':
          return const Color(0xFF10B981);
        case 'Available':
          return const Color(0xFF0EA5E9);
        case 'On Leave':
          return const Color(0xFFF59E0B);
        default:
          return Colors.transparent;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF595973),
                ),
              ),
              if (required) ...[
                const SizedBox(width: 4),
                const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
              ],
              if (titleSuffix != null) ...[
                const SizedBox(width: 4),
                Text(
                  titleSuffix,
                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                ),
              ]
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(value) ? value : items[0],
                isExpanded: true,
                dropdownColor: Colors.white,
                icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF94A3B8)),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Row(
                      children: [
                        if (showDot && !item.startsWith('Select')) ...[
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: getStatusColor(item),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: item.startsWith('Select') || item.startsWith('e.g.') ? const Color(0xFF94A3B8) : const Color(0xFF181821),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUpload(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF595973),
              ),
            ),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: _selectedImage != null
                ? Row(
                    children: [
                      const Icon(LucideIcons.checkCircle2, size: 20, color: Color(0xFF10B981)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Selected',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF181821)),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEDE9FE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.uploadCloud, color: Color(0xFF8B5CF6), size: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload image',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF181821)),
                            ),
                            Text(
                              'JPG, PNG up to 5MB',
                              style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF6366F1)),
                  ),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6366F1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: _saveDriver,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Save Driver',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
