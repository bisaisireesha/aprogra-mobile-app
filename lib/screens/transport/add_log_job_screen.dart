import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../../widgets/app_bottom_nav.dart';

class AddLogJobScreen extends StatefulWidget {
  const AddLogJobScreen({super.key});

  @override
  State<AddLogJobScreen> createState() => _AddLogJobScreenState();
}

class _AddLogJobScreenState extends State<AddLogJobScreen> {
  int _currentStep = 1;
  final ScrollController _scrollController = ScrollController();

  // Step 1 Data
  String _selectedJobType = 'Repair';
  String _selectedPriority = 'High';
  String? _selectedVehicle;
  String? _selectedMechanic;
  String? _selectedHelper;
  String _reportedBy = 'Driver';
  String _selectedStatus = 'In Service';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Step 2 Data
  final List<XFile> _attachments = [];
  final ImagePicker _picker = ImagePicker();
  DateTime? _nextServiceDate;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _scrollToTop();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
      _scrollToTop();
    } else {
      Navigator.pop(context);
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickImage() async {
    if (_attachments.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maximum 10 photos allowed')));
      return;
    }
    final List<XFile> picked = await _picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _attachments.addAll(picked.take(10 - _attachments.length));
      });
    }
  }

  Future<void> _pickDate(BuildContext context, bool isNextService) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isNextService) {
          _nextServiceDate = picked;
        } else {
          _selectedDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStepper(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  if (_currentStep == 1) ...[
                    _buildStep1(),
                  ] else if (_currentStep == 2) ...[
                    _buildStep2(),
                  ] else if (_currentStep == 3) ...[
                    _buildStep3(),
                  ],
                ],
              ),
            ),
            const AppBottomNav(),
          ],
        ),
      ),
    );
  }

    Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Add Log Job',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildStepper() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildStepIndicator(1, 'Job Details'),
          Expanded(child: Container(height: 1, color: Colors.grey.withValues(alpha: 0.2))),
          _buildStepIndicator(2, 'Parts & Labor'),
          Expanded(child: Container(height: 1, color: Colors.grey.withValues(alpha: 0.2))),
          _buildStepIndicator(3, 'Review'),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String title) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;
    
    Color color = isActive || isCompleted ? const Color(0xFF6366F1) : const Color(0xFF94A3B8);
    Color bgColor = isActive ? const Color(0xFF6366F1) : (isCompleted ? Colors.white : const Color(0xFFF1F5F9));
    Color iconColor = isCompleted ? const Color(0xFF6366F1) : (isActive ? Colors.white : const Color(0xFF94A3B8));

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: isCompleted ? Border.all(color: color) : null,
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? Icon(Icons.check, size: 14, color: color)
              : Text(
                  step.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: iconColor,
                  ),
                ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isActive || isCompleted ? FontWeight.w600 : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // STEP 1 UI
  // ===========================================================================
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Job Information',
          icon: LucideIcons.fileText,
          children: [
            _buildLabel('Job ID'),
            _buildTextField(hint: 'Auto generated', enabled: false),
            SizedBox(height: 12.h),
            _buildLabel('Job Type', required: true),
            _buildDropdown(
              value: 'Select job type',
              items: ['Select job type', 'Repair', 'Preventive', 'Inspection'],
              onChanged: (val) {},
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildJobTypeSelector('Repair', LucideIcons.wrench, const Color(0xFFEF4444))),
                const SizedBox(width: 8),
                Expanded(child: _buildJobTypeSelector('Preventive', LucideIcons.shield, const Color(0xFF6366F1))),
                const SizedBox(width: 8),
                Expanded(child: _buildJobTypeSelector('Inspection', LucideIcons.clipboardCheck, const Color(0xFF64748B))),
              ],
            ),
            SizedBox(height: 12.h),
            _buildLabel('Description', required: true),
            _buildTextField(hint: 'Enter job description', maxLines: 3),
            SizedBox(height: 12.h),
            _buildLabel('Priority'),
            _buildDropdown(
              value: 'Select priority',
              items: ['Select priority', 'Low', 'Medium', 'High'],
              onChanged: (val) {},
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildPrioritySelector('Low', const Color(0xFF10B981))),
                const SizedBox(width: 8),
                Expanded(child: _buildPrioritySelector('Medium', const Color(0xFFF59E0B))),
                const SizedBox(width: 8),
                Expanded(child: _buildPrioritySelector('High', const Color(0xFFEF4444))),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Job Date', required: true),
                      GestureDetector(
                        onTap: () => _pickDate(context, false),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 8),
                              Text(
                                _selectedDate == null ? 'DD / MM / YYYY' : DateFormat('dd MMM yyyy').format(_selectedDate!),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: _selectedDate == null ? const Color(0xFF94A3B8) : const Color(0xFF181821),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Job Time'),
                      GestureDetector(
                        onTap: () => _pickTime(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(LucideIcons.clock, size: 16, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 8),
                              Text(
                                _selectedTime == null ? 'Select time' : _selectedTime!.format(context),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: _selectedTime == null ? const Color(0xFF94A3B8) : const Color(0xFF181821),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Vehicle Information',
          icon: LucideIcons.bus,
          children: [
            _buildLabel('Vehicle', required: true),
            _buildDropdown(
              value: _selectedVehicle ?? 'Select vehicle',
              items: ['Select vehicle', 'BUS-204 (Tata Starbus)'],
              onChanged: (val) {
                if (val != 'Select vehicle') setState(() => _selectedVehicle = val);
              },
            ),
            if (_selectedVehicle != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F5FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.bus, size: 16, color: Color(0xFF6366F1)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BUS-204',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF181821),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Tata Starbus',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF595973),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'R-12',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF595973),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 16, color: Color(0xFF94A3B8)),
                      onPressed: () => setState(() => _selectedVehicle = null),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 12.h),
            _buildLabel('Current Mileage (km)'),
            _buildTextField(hint: 'Enter current mileage'),
            SizedBox(height: 12.h),
            _buildLabel('Location'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 8),
                  Text(
                    'Select location',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Assigned To',
          icon: LucideIcons.user,
          children: [
            _buildLabel('Mechanic', required: true),
            _buildDropdown(
              value: 'Select mechanic',
              items: ['Select mechanic', 'Verma Motors', 'In-house', 'Tyre Hub'],
              onChanged: (val) {},
            ),
            SizedBox(height: 12.h),
            _buildLabel('Helper (Optional)'),
            _buildDropdown(
              value: 'Select helper',
              items: ['Select helper', 'Rahul', 'Amit'],
              onChanged: (val) {},
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Problem Details',
          icon: LucideIcons.alertTriangle,
          children: [
            _buildLabel('Reported By'),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _reportedBy = 'Driver'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _reportedBy == 'Driver' ? const Color(0xFFF8F5FF) : Colors.white,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                        border: Border.all(
                          color: _reportedBy == 'Driver' ? const Color(0xFF6366F1) : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _reportedBy == 'Driver' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            size: 16,
                            color: _reportedBy == 'Driver' ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Driver',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: _reportedBy == 'Driver' ? FontWeight.w600 : FontWeight.w500,
                              color: _reportedBy == 'Driver' ? const Color(0xFF6366F1) : const Color(0xFF595973),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _reportedBy = 'Other'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _reportedBy == 'Other' ? const Color(0xFFF8F5FF) : Colors.white,
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                        border: Border.all(
                          color: _reportedBy == 'Other' ? const Color(0xFF6366F1) : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _reportedBy == 'Other' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            size: 16,
                            color: _reportedBy == 'Other' ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Other',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: _reportedBy == 'Other' ? FontWeight.w600 : FontWeight.w500,
                              color: _reportedBy == 'Other' ? const Color(0xFF6366F1) : const Color(0xFF595973),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildLabel('Reported By Name'),
            _buildTextField(hint: 'Enter name'),
            SizedBox(height: 12.h),
            _buildLabel('Problem Reported', required: true),
            _buildTextField(hint: 'Describe the problem in detail', maxLines: 3),
            SizedBox(height: 12.h),
            _buildLabel('Observed By Mechanic', required: true),
            _buildTextField(hint: 'Describe observations / findings', maxLines: 2),
            SizedBox(height: 12.h),
            _buildLabel('Root Cause (Optional)'),
            _buildTextField(hint: 'Enter root cause (if known)'),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Job Status',
          icon: LucideIcons.activity,
          children: [
            Row(
              children: [
                Expanded(child: _buildStatusSelector('In Service', const Color(0xFFF59E0B))),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusSelector('Scheduled', const Color(0xFF0EA5E9))),
                const SizedBox(width: 8),
                Expanded(child: _buildStatusSelector('Completed', const Color(0xFF10B981))),
              ],
            ),
            SizedBox(height: 12.h),
            _buildLabel('Remarks (Optional)'),
            _buildTextField(hint: 'Add any remarks...', maxLines: 2),
          ],
        ),
      ],
    );
  }

  Widget _buildJobTypeSelector(String title, IconData icon, Color color) {
    bool isSelected = _selectedJobType == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedJobType = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF595973),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySelector(String title, Color color) {
    bool isSelected = _selectedPriority == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF595973),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSelector(String title, Color color) {
    bool isSelected = _selectedStatus == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.radio_button_checked, size: 14, color: color),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF595973),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // STEP 2 UI
  // ===========================================================================
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Parts Used',
          icon: LucideIcons.package,
          actionWidget: TextButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.plus, size: 16),
            label: Text(
              'Add Part',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6366F1),
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          children: [
            _buildCostItem('Gear Oil (5L)', 'Qty: 5 L', '₹2,500'),
            Divider(color: Colors.grey.withValues(alpha: 0.1)),
            _buildCostItem('Clutch Plate', 'Qty: 1', '₹6,800'),
            Divider(color: Colors.grey.withValues(alpha: 0.1)),
            _buildCostItem('Seal Kit', 'Qty: 1', '₹1,200'),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Labor & Charges',
          icon: LucideIcons.user,
          actionWidget: TextButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.plus, size: 16),
            label: Text(
              'Add Labor',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6366F1),
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          children: [
            _buildCostItem('Mechanic Labor', '2.5 hrs', '₹1,250', showDelete: false),
            Divider(color: Colors.grey.withValues(alpha: 0.1)),
            _buildCostItem('Helper Labor', '1 hr', '₹400', showDelete: false),
            Divider(color: Colors.grey.withValues(alpha: 0.1)),
            _buildCostItem('Service Charges', '', '₹800', showDelete: false),
            Divider(color: Colors.grey.withValues(alpha: 0.1)),
            _buildCostItem('Other Charges (If any)', '', '₹250'),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Labor & Charges',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF181821),
                  ),
                ),
                Text(
                  '₹2,700',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Job Summary',
          icon: LucideIcons.fileText,
          iconColor: Colors.transparent, // No icon for summary in mockup
          noHeaderBorder: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Parts Total', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF595973))),
                Text('₹10,500', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF181821))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Labor & Charges', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF595973))),
                Text('₹2,700', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF181821))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Discount (Optional)', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF595973))),
                Text('Enter amount', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFEF4444))),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  Text(
                    '₹13,200',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Attachments',
          icon: LucideIcons.paperclip,
          actionWidget: TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(LucideIcons.plus, size: 16),
            label: Text(
              'Add Photo',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6366F1),
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          children: [
            if (_attachments.isNotEmpty) ...[
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _attachments.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_attachments[index].path),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _attachments.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(LucideIcons.x, size: 12, color: Color(0xFF181821)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Max 10 photos  ·  JPG, PNG up to 5MB',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildSectionCard(
          title: 'Work Notes',
          icon: LucideIcons.clipboardList,
          children: [
            _buildLabel('Work Performed', required: true),
            _buildTextField(hint: 'Describe work performed', maxLines: 3),
            SizedBox(height: 12.h),
            _buildLabel('Recommendations'),
            _buildTextField(hint: 'Enter recommendations (If any)', maxLines: 2),
            SizedBox(height: 12.h),
            _buildLabel('Next Service Due (Optional)'),
            GestureDetector(
              onTap: () => _pickDate(context, true),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    Text(
                      _nextServiceDate == null ? 'DD / MM / YYYY' : DateFormat('dd MMM yyyy').format(_nextServiceDate!),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _nextServiceDate == null ? const Color(0xFF94A3B8) : const Color(0xFF181821),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _buildLabel('Next Service Mileage (Optional)'),
            _buildTextField(hint: 'Enter mileage'),
          ],
        ),
      ],
    );
  }

  Widget _buildCostItem(String name, String sub, String cost, {bool showDelete = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF181821),
                  ),
                ),
                if (sub.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF595973),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            cost,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF181821),
            ),
          ),
          if (showDelete) ...[
            const SizedBox(width: 16),
            const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // STEP 3 UI (Review)
  // ===========================================================================
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Review Summary',
          icon: LucideIcons.checkSquare,
          children: [
            Text('Review details here before submitting.', style: GoogleFonts.inter(color: const Color(0xFF595973))),
            // Implementation of full review summary is implied
          ],
        ),
      ],
    );
  }

  // ===========================================================================
  // COMMON HELPERS
  // ===========================================================================
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? actionWidget,
    Color iconColor = const Color(0xFF6366F1),
    bool noHeaderBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (iconColor != Colors.transparent) ...[
                      Icon(icon, size: 20, color: iconColor),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF181821),
                      ),
                    ),
                  ],
                ),
                if (actionWidget != null) actionWidget,
              ],
            ),
          ),
          if (!noHeaderBorder) Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF181821),
            ),
          ),
          if (required) ...[
            const SizedBox(width: 4),
            Text(
              '*',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTextField({String? hint, int maxLines = 1, bool enabled = true}) {
    return TextField(
      maxLines: maxLines,
      enabled: enabled,
      style: GoogleFonts.inter(
        fontSize: 14,
        color: const Color(0xFF181821),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF94A3B8),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF8F9FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6366F1)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF94A3B8)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: item.startsWith('Select') ? const Color(0xFF94A3B8) : const Color(0xFF181821),
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 1) ...[
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF6366F1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(LucideIcons.arrowLeft, size: 16, color: Color(0xFF6366F1)),
                      const SizedBox(width: 8),
                      Text(
                        'Back',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _currentStep == 3 ? () {
                  final newJob = {
                    'id': 'M-24${(DateTime.now().millisecondsSinceEpoch % 100).toString().padLeft(2, '0')}',
                    'bus': _selectedVehicle ?? 'BUS-000',
                    'type': _selectedJobType,
                    'title': 'New Logged Job',
                    'date': _selectedDate != null ? DateFormat('dd MMM yyyy').format(_selectedDate!) : DateFormat('dd MMM yyyy').format(DateTime.now()),
                    'mechanic': _selectedMechanic ?? 'In-house',
                    'cost': '0',
                    'status': _selectedStatus,
                  };
                  Navigator.pop(context, newJob);
                } : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentStep == 1
                          ? 'Next: Add Parts & Labor'
                          : (_currentStep == 2 ? 'Next: Review' : 'Submit Job'),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.arrowRight, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
