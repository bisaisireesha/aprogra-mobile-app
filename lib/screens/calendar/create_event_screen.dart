import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleCtrl = TextEditingController();
  final _venueCtrl = TextEditingController();
  
  String _selectedCategory = 'Meeting';
  final List<String> _categories = ['Meeting', 'Exam', 'Holiday', 'Trip', 'Sports'];

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _saveEvent() {
    if (_titleCtrl.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill title, date, and time'), backgroundColor: Colors.red));
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event "${_titleCtrl.text}" created!'), backgroundColor: Colors.green),
    );
    
    Navigator.pop(context, {
      'title': _titleCtrl.text,
      'type': _selectedCategory.toLowerCase(),
      'date': _selectedDate,
      'time': _selectedTime!.format(context),
      'location': _venueCtrl.text.isEmpty ? 'TBA' : _venueCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
          SizedBox(height: 12.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(icon: const Icon(LucideIcons.x, color: Color(0xFF0F172A)), onPressed: () => Navigator.pop(context)),
                Expanded(child: Center(child: Text('Create Event', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))))),
                const SizedBox(width: 48), // Balance the flex
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Event Title'),
                  _buildTextField(_titleCtrl, 'e.g. Annual Sports Day'),
                  const SizedBox(height: 20),
                  _buildLabel('Category'),
                  _buildDropdown(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Date'),
                            _buildDatePicker(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Time'),
                            _buildTimePicker(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Venue (Optional)'),
                  _buildTextField(_venueCtrl, 'e.g. Main Auditorium'),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: ElevatedButton(
              onPressed: _saveEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('Create Event', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF0F172A)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown, color: Color(0xFF64748B), size: 20),
          items: _categories.map((c) => DropdownMenuItem(
            value: c,
            child: Text(c, style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF0F172A))),
          )).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedCategory = val);
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final initDate = _selectedDate ?? DateTime.now();
        final today = DateTime.now();
        final firstDate = initDate.isBefore(today) ? initDate : today;

        final date = await showDatePicker(
          context: context,
          initialDate: initDate,
          firstDate: firstDate,
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Color(0xFF6366F1)),
              ),
              child: child!,
            );
          },
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedDate == null ? 'Select' : DateFormat('dd MMM, yyyy').format(_selectedDate!),
                style: GoogleFonts.inter(fontSize: 15, color: _selectedDate == null ? const Color(0xFF94A3B8) : const Color(0xFF0F172A)),
              ),
            ),
            const Icon(LucideIcons.calendarDays, size: 18, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: _selectedTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Color(0xFF6366F1)),
              ),
              child: child!,
            );
          },
        );
        if (time != null) setState(() => _selectedTime = time);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedTime == null ? 'Select' : _selectedTime!.format(context),
                style: GoogleFonts.inter(fontSize: 15, color: _selectedTime == null ? const Color(0xFF94A3B8) : const Color(0xFF0F172A)),
              ),
            ),
            const Icon(LucideIcons.clock, size: 18, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
