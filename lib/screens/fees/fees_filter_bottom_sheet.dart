import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FeesFilterBottomSheet extends StatefulWidget {
  final String selectedClass;
  final String selectedFeeType;
  final String selectedStatus;
  final String selectedDateRange;
  final DateTime? customFromDate;
  final DateTime? customToDate;
  final String selectedAmountRange;

  const FeesFilterBottomSheet({
    super.key,
    required this.selectedClass,
    required this.selectedFeeType,
    required this.selectedStatus,
    required this.selectedDateRange,
    this.customFromDate,
    this.customToDate,
    required this.selectedAmountRange,
  });

  @override
  State<FeesFilterBottomSheet> createState() => _FeesFilterBottomSheetState();
}

class _FeesFilterBottomSheetState extends State<FeesFilterBottomSheet> {
  final _dark = const Color(0xFF0F172A);
  final _muted = const Color(0xFF64748B);
  final _border = const Color(0xFFE2E8F0);
  final _primary = const Color(0xFF6366F1);

  late String _selectedClass;
  late String _selectedFeeType;
  late String _selectedStatus;
  late String _selectedDateRange;
  DateTime? _customFromDate;
  DateTime? _customToDate;
  late String _selectedAmountRange;

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.selectedClass;
    _selectedFeeType = widget.selectedFeeType;
    _selectedStatus = widget.selectedStatus;
    _selectedDateRange = widget.selectedDateRange;
    _customFromDate = widget.customFromDate;
    _customToDate = widget.customToDate;
    _selectedAmountRange = widget.selectedAmountRange;
  }

  void _reset() {
    setState(() {
      _selectedClass = 'All Classes';
      _selectedFeeType = 'All Fee Types';
      _selectedStatus = 'All Status';
      _selectedDateRange = 'All Time';
      _customFromDate = null;
      _customToDate = null;
      _selectedAmountRange = 'All Amounts';
    });
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _customFromDate : _customToDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: _primary)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _customFromDate = picked;
        } else {
          _customToDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'Select Date';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                TextButton(
                  onPressed: _reset,
                  child: Text('Clear All', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _primary)),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDropdownSection('Class', _selectedClass, [
                    'All Classes', 'Nursery', 'LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 
                    'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'
                  ], (v) => setState(() => _selectedClass = v!)),
                  
                  const SizedBox(height: 16),
                  _buildDropdownSection('Fee Type', _selectedFeeType, [
                    'All Fee Types', 'Tuition Fee', 'Transport', 'Hostel Fee', 'Exam Fee', 'Misc'
                  ], (v) => setState(() => _selectedFeeType = v!)),
                  
                  const SizedBox(height: 16),
                  _buildDropdownSection('Payment Status', _selectedStatus, [
                    'All Status', 'Paid', 'Pending', 'Overdue', 'Partial'
                  ], (v) => setState(() => _selectedStatus = v!)),
                  
                  const SizedBox(height: 16),
                  _buildDropdownSection('Due Date', _selectedDateRange, [
                    'All Time', 'Custom Range'
                  ], (v) => setState(() => _selectedDateRange = v!)),
                  
                  if (_selectedDateRange == 'Custom Range') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildDatePickerCard('From Date', _customFromDate, true)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDatePickerCard('To Date', _customToDate, false)),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                  _buildDropdownSection('Amount Range', _selectedAmountRange, [
                    'All Amounts', 'Below ₹5,000', '₹5,000 - ₹20,000', 'Above ₹20,000'
                  ], (v) => setState(() => _selectedAmountRange = v!)),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Container(
            padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _border))),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'class': _selectedClass,
                        'type': _selectedFeeType,
                        'status': _selectedStatus,
                        'dateRange': _selectedDateRange,
                        'fromDate': _customFromDate,
                        'toDate': _customToDate,
                        'amountRange': _selectedAmountRange,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Apply Filters', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: _border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Reset', style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: _primary)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _muted)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(LucideIcons.chevronDown, size: 20, color: Color(0xFF64748B)),
              onChanged: onChanged,
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _dark)),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerCard(String label, DateTime? date, bool isFrom) {
    return GestureDetector(
      onTap: () => _pickDate(isFrom),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _border)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: _muted)),
                  const SizedBox(height: 4),
                  Text(_formatDate(date), style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _dark)),
                ],
              ),
            ),
            const Icon(LucideIcons.calendar, size: 20, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
