import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialVehicle;
  final String title;
  final String saveText;

  const AddVehicleModal({
    super.key,
    required this.onSave,
    this.initialVehicle,
    this.title = 'Add New Vehicle',
    this.saveText = 'Save Vehicle',
  });

  @override
  State<AddVehicleModal> createState() => _AddVehicleModalState();
}

class _AddVehicleModalState extends State<AddVehicleModal> {
  final _regController = TextEditingController();
  final _seatsController = TextEditingController();
  final _yearController = TextEditingController();
  final _fuelCapacityController = TextEditingController();
  final _fuelCardController = TextEditingController();
  final _chassisController = TextEditingController();
  final _engineController = TextEditingController();
  final _notesController = TextEditingController();

  String _model = 'e.g. Tata Starbus';
  String _type = 'Select vehicle type';
  String _color = 'Select color';
  String _route = 'Select route';
  String _driver = 'Select driver';
  String _assistant = 'Select assistant / conductor';
  String _fuelType = 'Select fuel type';
  String _status = 'Active';

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.initialVehicle != null) {
      _regController.text = widget.initialVehicle!['registration'] ?? '';
      _seatsController.text = (widget.initialVehicle!['seats'] ?? '').toString();
      _yearController.text = widget.initialVehicle!['year'] ?? '';
      
      final model = widget.initialVehicle!['model'];
      if (model != null && ['e.g. Tata Starbus', 'Ashok Leyland', 'Force Traveller', 'Eicher Skyline'].contains(model)) {
        _model = model;
      }
      
      final type = widget.initialVehicle!['type'];
      if (type != null && ['Bus', 'Mini-bus', 'Van'].contains(type)) {
        _type = type;
      }
      
      final validStatuses = ['Active', 'Idle', 'Maintenance'];
      if (validStatuses.contains(widget.initialVehicle!['status'])) {
        _status = widget.initialVehicle!['status'];
      }
      
      final route = widget.initialVehicle!['route'];
      if (route != null) {
        _route = route;
      }
      
      final driver = widget.initialVehicle!['driver'];
      if (driver != null) {
        _driver = driver;
      }
    }
  }

  @override
  void dispose() {
    _regController.dispose();
    _seatsController.dispose();
    _yearController.dispose();
    _fuelCapacityController.dispose();
    _fuelCardController.dispose();
    _chassisController.dispose();
    _engineController.dispose();
    _notesController.dispose();
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

  void _saveVehicle() {
    Color getStatusColor(String val) {
      switch (val) {
        case 'Active':
          return const Color(0xFF10B981);
        case 'Idle':
          return const Color(0xFF0EA5E9);
        case 'Maintenance':
          return const Color(0xFFF59E0B);
        default:
          return const Color(0xFF94A3B8);
      }
    }

    final newVehicle = {
      'registration': _regController.text.isNotEmpty ? _regController.text : 'NEW-REG',
      'model': _model != 'e.g. Tata Starbus' ? _model : 'Tata Starbus',
      'type': _type != 'Select vehicle type' ? _type : 'Bus',
      'seats': int.tryParse(_seatsController.text) ?? 48,
      'year': _yearController.text.isNotEmpty ? _yearController.text : '2024',
      'serviceDate': '12 May 2026', // Mocked as it's not a direct input in the new design
      'status': _status,
      'statusColor': getStatusColor(_status),
      'fuel': 100, // Mocked as fuel level isn't in new design
      'route': _route != 'Select route' ? _route : 'Unassigned',
      'driver': _driver != 'Select driver' ? _driver : 'Unassigned',
    };

    widget.onSave(newVehicle);
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
                    title: 'Vehicle Information',
                    icon: LucideIcons.clipboardList,
                    iconColor: const Color(0xFF6366F1), // Purple from design
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Registration Number', _regController, hint: 'e.g. DL-1A-1234', required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Model',
                              _model,
                              ['e.g. Tata Starbus', 'Ashok Leyland', 'Force Traveller', 'Eicher Skyline'],
                              (val) => setState(() => _model = val!),
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'Vehicle Type',
                              _type,
                              ['Select vehicle type', 'Bus', 'Mini-bus', 'Van'],
                              (val) => setState(() => _type = val!),
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Seating Capacity', _seatsController, hint: 'e.g. 48', required: true),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Model Year', _yearController, hint: 'e.g. 2023', required: false),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Color',
                              _color,
                              ['Select color', 'Yellow', 'White', 'Blue'],
                              (val) => setState(() => _color = val!),
                              required: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildSectionCard(
                    title: 'Route & Driver',
                    icon: LucideIcons.gitMerge,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'Assign Route',
                              _route,
                              ['Select route', 'Route R-03', 'Route R-07', 'Route R-12', 'Route R-15'],
                              (val) => setState(() => _route = val!),
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Assign Driver',
                              _driver,
                              ['Select driver', 'R. Sharma', 'Hannah Cruz', 'Alexi Park', 'David Kim'],
                              (val) => setState(() => _driver = val!),
                              required: true,
                            ),
                          ),
                        ],
                      ),
                      _buildDropdown(
                        'Assistant / Conductor (Optional)',
                        _assistant,
                        ['Select assistant / conductor', 'A. Kumar', 'S. Singh'],
                        (val) => setState(() => _assistant = val!),
                        required: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildSectionCard(
                    title: 'Fuel Information',
                    icon: LucideIcons.fuel,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'Fuel Type',
                              _fuelType,
                              ['Select fuel type', 'Diesel', 'CNG', 'Electric'],
                              (val) => setState(() => _fuelType = val!),
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Fuel Tank Capacity (L)', _fuelCapacityController, hint: 'e.g. 100', required: true),
                          ),
                        ],
                      ),
                      _buildTextField('Fuel Card / Provider (Optional)', _fuelCardController, hint: 'e.g. IOCL', required: false),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  // Vehicle Image Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.image, size: 18, color: Color(0xFF6366F1)),
                          const SizedBox(width: 8),
                          Text(
                            'Vehicle Image',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF181821),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(Optional)',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F5FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                              style: BorderStyle.solid, // Using solid as dashed isn't native without custom painter
                            ),
                          ),
                          child: _selectedImage != null
                              ? Column(
                                  children: [
                                    Icon(LucideIcons.checkCircle2, size: 32, color: const Color(0xFF10B981)),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Image Selected',
                                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF181821)),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEDE9FE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(LucideIcons.uploadCloud, color: Color(0xFF8B5CF6), size: 24),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Upload vehicle image',
                                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF181821)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'JPG, PNG up to 5MB',
                                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8)),
                                    ),
                                    SizedBox(height: 12.h),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: const Color(0xFF6366F1)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(LucideIcons.image, size: 16, color: Color(0xFF6366F1)),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Choose Image',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF6366F1),
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
                  const SizedBox(height: 24),
                  
                  _buildSectionCard(
                    title: 'Additional Information',
                    icon: LucideIcons.info,
                    iconColor: const Color(0xFF6366F1),
                    titleSuffix: '(Optional)',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Chassis Number', _chassisController, hint: 'e.g. MA3XXXXXXXXXXXXXX', required: false),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Engine Number', _engineController, hint: 'e.g. ENGINEXXXXXXXXXX', required: false),
                          ),
                        ],
                      ),
                      _buildTextField('Notes', _notesController, hint: 'e.g. Any additional information', required: false, maxLines: 2),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildSectionCard(
                    title: 'Status',
                    icon: LucideIcons.shieldCheck, // or disc
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      _buildDropdown(
                        'Status',
                        _status,
                        ['Active', 'Idle', 'Maintenance'],
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
                onTap: _saveVehicle,
                child: Text(
                  widget.saveText == 'Save Changes' ? 'Save' : 'Save', // Follow the mockup "Save"
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
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String hint = '', bool required = false, int maxLines = 1}) {
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged, {bool required = false, bool showDot = false}) {
    Color getStatusColor(String val) {
      switch (val) {
        case 'Active':
          return const Color(0xFF10B981);
        case 'Idle':
          return const Color(0xFF0EA5E9);
        case 'Maintenance':
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
                onTap: _saveVehicle,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Save Vehicle',
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
