import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class AddAdmissionModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialData;
  final String title;
  final String saveText;

  const AddAdmissionModal({
    super.key,
    required this.onSave,
    this.initialData,
    this.title = 'Add Admission',
    this.saveText = 'Save',
  });

  @override
  State<AddAdmissionModal> createState() => _AddAdmissionModalState();
}

class _AddAdmissionModalState extends State<AddAdmissionModal> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _sectionController = TextEditingController();
  final _parentController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _feeAmountController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _dob;
  DateTime? _dueDate;
  TimeOfDay? _time;

  String _class = 'Select class';
  String _gender = 'Select gender';
  String _route = 'Select route';
  String _stop = 'Select stop';
  String _pickupDrop = 'Pickup';
  String _feeType = 'Select fee type';
  String _paymentStatus = 'Select status';
  String _status = 'Allocated';

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _idController.text = widget.initialData!['id'] ?? '';
      _phoneController.text = widget.initialData!['phone'] ?? '';
      _parentController.text = widget.initialData!['parent'] ?? '';
      
      final parts = (widget.initialData!['class'] ?? '').split('-');
      if (parts.length > 1) {
        _class = parts[0];
        _sectionController.text = parts[1];
      } else if (parts.isNotEmpty) {
        _class = parts[0];
      }
      
      if (widget.initialData!['route'] != null && widget.initialData!['route'] != '-') {
        _route = widget.initialData!['route'];
      }
      if (widget.initialData!['stop'] != null && widget.initialData!['stop'] != '-') {
        _stop = widget.initialData!['stop'];
      }
      
      _status = widget.initialData!['status'] ?? 'Allocated';
      if (widget.initialData!['feeStatus'] != null) {
        _paymentStatus = widget.initialData!['feeStatus'];
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _sectionController.dispose();
    _parentController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _feeAmountController.dispose();
    _notesController.dispose();
    super.dispose();
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
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF181821),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) onDateSelected(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF181821),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _time = picked;
      });
    }
  }

  void _save() {
    final isPickup = _pickupDrop == 'Pickup';
    final formattedTime = _time != null ? _time!.format(context) : '-';

    final newData = {
      'name': _nameController.text.isNotEmpty ? _nameController.text : 'New Student',
      'id': _idController.text.isNotEmpty ? _idController.text : 'S-0000',
      'class': _class != 'Select class' ? '$_class${_sectionController.text.isNotEmpty ? '-${_sectionController.text}' : ''}' : '-',
      'route': _route != 'Select route' ? _route : '-',
      'stop': _stop != 'Select stop' ? _stop : '-',
      'pickup': isPickup ? formattedTime : '-',
      'drop': !isPickup ? formattedTime : '-',
      'feeStatus': _paymentStatus != 'Select status' ? _paymentStatus : 'Due',
      'status': _status,
      'admissionDate': DateFormat('dd MMM yyyy').format(DateTime.now()),
      'parent': _parentController.text.isNotEmpty ? _parentController.text : '-',
      'phone': _phoneController.text.isNotEmpty ? _phoneController.text : '-',
      'totalFee': _feeAmountController.text.isNotEmpty ? '₹${_feeAmountController.text}' : '₹0',
      'paidAmount': _paymentStatus == 'Paid' ? (_feeAmountController.text.isNotEmpty ? '₹${_feeAmountController.text}' : '₹0') : '₹0',
      'dueAmount': _paymentStatus == 'Due' ? (_feeAmountController.text.isNotEmpty ? '₹${_feeAmountController.text}' : '₹0') : '₹0',
    };

    widget.onSave(newData);
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
                    title: 'Student Information',
                    icon: LucideIcons.user,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Student Name', _nameController, hint: 'e.g. Aarav Mehta', required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Admission No.', _idController, hint: 'e.g. S-1042', required: true),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown('Class', _class, ['Select class', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'], (val) => setState(() => _class = val!), required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Section', _sectionController, hint: 'e.g. B', titleSuffix: '(Optional)'),
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
                            child: _buildDropdown('Gender', _gender, ['Select gender', 'Male', 'Female', 'Other'], (val) => setState(() => _gender = val!), required: true),
                          ),
                        ],
                      ),
                      _buildTextField('Parent / Guardian Name', _parentController, hint: 'e.g. Rohit Mehta', required: true),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Phone Number', _phoneController, hint: '+91 98xxxx 1023', required: true, prefixIcon: LucideIcons.phone),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField('Email', _emailController, hint: 'e.g. parent@email.com', titleSuffix: '(Optional)', prefixIcon: LucideIcons.mail),
                          ),
                        ],
                      ),
                      _buildTextField('Address', _addressController, hint: 'e.g. Sector 42, Delhi - 110001', prefixIcon: LucideIcons.mapPin),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  _buildSectionCard(
                    title: 'Route & Stop Allocation',
                    icon: LucideIcons.bus,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown('Route', _route, ['Select route', 'R-03', 'R-07', 'R-09', 'R-12', 'R-15'], (val) => setState(() => _route = val!), required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown('Stop', _stop, ['Select stop', 'Park Lane', 'Mehrauli Gate', 'Ring Road', 'Hauz Khas', 'Sector 42 Mkt'], (val) => setState(() => _stop = val!), required: true),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildRadioGroup('Pickup / Drop', ['Pickup', 'Drop'], _pickupDrop, (val) => setState(() => _pickupDrop = val!), required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTimePicker('Pickup / Drop Time', _time, () => _selectTime(context), required: true),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  _buildSectionCard(
                    title: 'Fee Details',
                    icon: LucideIcons.wallet,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField('Fee Amount (₹)', _feeAmountController, hint: 'e.g. 12000', required: true),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdown('Fee Type', _feeType, ['Select fee type', 'Monthly', 'Quarterly', 'Annual'], (val) => setState(() => _feeType = val!)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown('Payment Status', _paymentStatus, ['Select status', 'Paid', 'Due'], (val) => setState(() => _paymentStatus = val!)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDatePicker('Due Date', _dueDate, (date) => setState(() => _dueDate = date), titleSuffix: '(Optional)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  _buildSectionCard(
                    title: 'Additional Information',
                    titleSuffix: '(Optional)',
                    icon: LucideIcons.fileText,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      _buildTextField('Notes', _notesController, hint: 'Any additional information...', maxLines: 3, titleSuffix: '(Optional)'),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  _buildSectionCard(
                    title: 'Status',
                    icon: LucideIcons.shieldCheck,
                    iconColor: const Color(0xFF6366F1),
                    children: [
                      _buildDropdown('Admission Status', _status, ['Allocated', 'Pending', 'Opted Out'], (val) => setState(() => _status = val!), required: true, showDot: true),
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
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 32, height: 4, decoration: BoxDecoration(color: const Color(0xFF6366F1), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Container(width: 32, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Container(width: 32, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
            ],
          ),
          SizedBox(height: 12.h),
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
                onTap: _save,
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

  Widget _buildSectionCard({required String title, required IconData icon, required Color iconColor, required List<Widget> children, String? titleSuffix}) {
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
              Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF181821))),
              if (titleSuffix != null) ...[
                const SizedBox(width: 6),
                Text(titleSuffix, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8))),
              ]
            ],
          ),
          SizedBox(height: 12.h),
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
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF595973))),
              if (required) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
              if (titleSuffix != null) Text(' $titleSuffix', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: maxLines > 1 ? 12 : 14),
                isDense: true,
                prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16, color: const Color(0xFF94A3B8)) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onDateSelected, {bool required = false, String? titleSuffix}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF595973))),
              if (required) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
              if (titleSuffix != null) Text(' $titleSuffix', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _selectDate(context, date, onDateSelected),
            child: Container(
              height: 46,
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

  Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onTap, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF595973))),
              if (required) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.clock, size: 16, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 8),
                  Text(
                    time != null ? time.format(context) : 'Select time',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: time != null ? const Color(0xFF181821) : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged, {bool required = false, bool showDot = false}) {
    Color getStatusColor(String val) {
      if (val == 'Allocated' || val == 'Paid') return const Color(0xFF10B981);
      if (val == 'Pending') return const Color(0xFFF59E0B);
      if (val == 'Due') return const Color(0xFFEF4444);
      return Colors.transparent;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF595973))),
              if (required) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 46,
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
                            decoration: BoxDecoration(color: getStatusColor(item), shape: BoxShape.circle),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: item.startsWith('Select') ? const Color(0xFF94A3B8) : const Color(0xFF181821),
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

  Widget _buildRadioGroup(String label, List<String> options, String currentValue, Function(String) onChanged, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF595973))),
              if (required) const Text(' *', style: TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: options.map((option) {
              final isSelected = currentValue == option;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: Container(
                    height: 46,
                    margin: EdgeInsets.only(right: option == options.first ? 8 : 0, left: option == options.last ? 8 : 0),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF8F5FF) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isSelected ? const Color(0xFF6366F1).withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                          color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF94A3B8),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          option,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? const Color(0xFF6366F1) : const Color(0xFF595973),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
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
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
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
                    child: Text('Cancel', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1))),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: _save,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(color: const Color(0xFF6366F1), borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text('Save Admission', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
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
