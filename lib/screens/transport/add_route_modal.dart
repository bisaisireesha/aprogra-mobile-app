import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddRouteModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialRoute;
  final String title;
  final String saveText;

  const AddRouteModal({
    super.key,
    required this.onSave,
    this.initialRoute,
    this.title = 'Add New Route',
    this.saveText = 'Save Route',
  });

  @override
  State<AddRouteModal> createState() => _AddRouteModalState();
}

class _AddRouteModalState extends State<AddRouteModal> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _stopsController = TextEditingController();
  final _distanceController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  String _fromLocation = 'Select from location';
  String _toLocation = 'Select to location';
  String _frequency = 'Select frequency';
  String _assignedBus = 'Select bus';
  String _assignedDriver = 'Select driver';
  String _assistant = 'Select assistant / conductor';
  String _status = 'Active';

  @override
  void initState() {
    super.initState();
    if (widget.initialRoute != null) {
      _codeController.text = widget.initialRoute!['code'] ?? '';
      _nameController.text = widget.initialRoute!['name'] ?? '';
      
      final validLocations = ['Select from location', 'Campus', 'Vasant Kunj', 'Saket', 'Mehrauli'];
      if (validLocations.contains(widget.initialRoute!['from'])) {
        _fromLocation = widget.initialRoute!['from'];
      }
      
      final validToLocations = ['Select to location', 'Campus', 'Vasant Kunj', 'Saket', 'Mehrauli'];
      if (validToLocations.contains(widget.initialRoute!['to'])) {
        _toLocation = widget.initialRoute!['to'];
      }

      final validBuses = ['Select bus', 'BUS-551', 'BUS-118', 'BUS-405', 'BUS-204', 'BUS-392'];
      if (validBuses.contains(widget.initialRoute!['bus'])) {
        _assignedBus = widget.initialRoute!['bus'];
      } else if (widget.initialRoute!['bus'] != '—') {
        _assignedBus = widget.initialRoute!['bus'];
      }
      
      final validDrivers = ['Select driver', 'Alexi Park', 'Hannah Cruz', 'Marcus Lee', 'R. Sharma', 'David Kim'];
      if (validDrivers.contains(widget.initialRoute!['driver'])) {
        _assignedDriver = widget.initialRoute!['driver'];
      } else if (widget.initialRoute!['driver'] != 'Unassigned') {
        _assignedDriver = widget.initialRoute!['driver'];
      }

      final validStatuses = ['Active', 'Paused', 'Draft'];
      if (validStatuses.contains(widget.initialRoute!['status'])) {
        _status = widget.initialRoute!['status'];
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _stopsController.dispose();
    _distanceController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _saveRoute() {
    // Create new route object and pass it to onSave
    final newRoute = {
      'code': _codeController.text.isNotEmpty ? _codeController.text : 'R-NEW',
      'name': _nameController.text.isNotEmpty ? _nameController.text : 'New Route',
      'students': widget.initialRoute?['students'] ?? 0,
      'duration': _calculateDuration(_startTimeController.text, _endTimeController.text),
      'from': _fromLocation != 'Select from location' ? _fromLocation : 'Campus',
      'to': _toLocation != 'Select to location' ? _toLocation : 'Unknown',
      'bus': _assignedBus != 'Select bus' ? _assignedBus : '—',
      'driver': _assignedDriver != 'Select driver' ? _assignedDriver : 'Unassigned',
      'status': _status,
      'color': _status == 'Active' 
          ? const Color(0xFF10B981) 
          : _status == 'Paused' 
              ? const Color(0xFFF59E0B) 
              : const Color(0xFF8B5CF6),
    };

    widget.onSave(newRoute);
    Navigator.pop(context);
  }

  String _calculateDuration(String start, String end) {
    if (start.isEmpty || end.isEmpty) return '0m';
    return '45m'; // Mock duration based on input
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA), // Slightly off-white background
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
                    title: 'Route Information',
                    icon: LucideIcons.mapPin,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      _buildTextField('Route Code', _codeController, hint: 'e.g. R-03'),
                      _buildTextField('Route Name', _nameController, hint: 'e.g. Vasant Kunj Loop'),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'From Location',
                              _fromLocation,
                              ['Select from location', 'Campus', 'Vasant Kunj', 'Saket', 'Mehrauli'],
                              (val) => setState(() => _fromLocation = val!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'To Location',
                              _toLocation,
                              ['Select to location', 'Campus', 'Vasant Kunj', 'Saket', 'Mehrauli'],
                              (val) => setState(() => _toLocation = val!),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('No. of Stops', _stopsController, hint: 'e.g. 9'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Distance (km)', _distanceController, hint: 'e.g. 14.2'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Schedule',
                    icon: LucideIcons.calendar,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Route Start Time',
                              _startTimeController,
                              hint: '07:15 AM',
                              suffixIcon: LucideIcons.clock,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Route End Time',
                              _endTimeController,
                              hint: '08:10 AM',
                              suffixIcon: LucideIcons.clock,
                            ),
                          ),
                        ],
                      ),
                      _buildDropdown(
                        'Frequency',
                        _frequency,
                        ['Select frequency', 'Daily (Mon-Fri)', 'Weekends', 'Specific Days'],
                        (val) => setState(() => _frequency = val!),
                        required: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Assign Bus & Driver',
                    icon: LucideIcons.users,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              'Assign Bus',
                              _assignedBus,
                              ['Select bus', 'BUS-551', 'BUS-118', 'BUS-405', 'BUS-204', 'BUS-392'],
                              (val) => setState(() => _assignedBus = val!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown(
                              'Assign Driver',
                              _assignedDriver,
                              ['Select driver', 'Alexi Park', 'Hannah Cruz', 'Marcus Lee', 'R. Sharma', 'David Kim'],
                              (val) => setState(() => _assignedDriver = val!),
                            ),
                          ),
                        ],
                      ),
                      _buildDropdown(
                        'Assistant / Conductor (Optional)',
                        _assistant,
                        ['Select assistant / conductor', 'Rahul Singh', 'Anita Sharma'],
                        (val) => setState(() => _assistant = val!),
                        required: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Route Status',
                    icon: LucideIcons.fileText,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      _buildDropdown(
                        'Status',
                        _status,
                        ['Active', 'Paused', 'Draft'],
                        (val) => setState(() => _status = val!),
                        showDot: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildNote(),
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
                onTap: _saveRoute,
                child: Text(
                  widget.title == 'Add New Route' ? 'Save' : 'Update',
                  style: GoogleFonts.inter(
                    fontSize: 14,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String hint = '', IconData? suffixIcon}) {
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
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF181821)),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18, color: const Color(0xFF94A3B8)) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged, {bool required = true, bool showDot = false}) {
    Color getStatusColor(String val) {
      switch (val) {
        case 'Active':
          return const Color(0xFF10B981);
        case 'Paused':
          return const Color(0xFFF59E0B);
        case 'Draft':
          return const Color(0xFF8B5CF6);
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
                value: value,
                isExpanded: true,
                dropdownColor: Colors.white,
                icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF94A3B8)),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Row(
                      children: [
                        if (showDot && item != 'Select status') ...[
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
                        Text(
                          item,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: item.startsWith('Select') ? const Color(0xFF94A3B8) : const Color(0xFF181821),
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

  Widget _buildNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F5FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.info, size: 16, color: Color(0xFF6366F1)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Note',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF181821),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You can edit stops and route map after creating the route.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF595973),
                  ),
                ),
              ],
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
                onTap: _saveRoute,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      widget.saveText,
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
