import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class CreatePtmScreen extends StatefulWidget {
  const CreatePtmScreen({super.key});

  @override
  State<CreatePtmScreen> createState() => _CreatePtmScreenState();
}

class _CreatePtmScreenState extends State<CreatePtmScreen> {
  int _currentStep = 0;
  
  // Step 1 controllers and state
  final _titleCtrl = TextEditingController();
  final _parentsCtrl = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedVenue;
  
  // Step 2 controllers and state
  final _notesCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final List<String> _selectedClasses = [];
  bool _sendInvites = true;
  
  final _venues = ['Primary Block', 'Main Auditorium', 'Block A - Hall', 'Block B - Seminar Hall'];

  // Bottom sheet data
  final Map<String, List<String>> _allClasses = {
    'Pre-Primary': ['Nursery A', 'Nursery B', 'LKG A', 'LKG B', 'UKG A', 'UKG B', 'UKG C'],
    'Primary 1-5': ['Class 1A', 'Class 1B', 'Class 2A', 'Class 2B', 'Class 3A', 'Class 4A', 'Class 4B', 'Class 5A'],
    'Secondary 6-12': ['Class 6A', 'Class 7A', 'Class 7B', 'Class 8A', 'Class 9A', 'Class 10A', 'Class 11 Science', 'Class 12 Commerce'],
  };

  void _nextStep() {
    if (_currentStep == 0) {
      if (_titleCtrl.text.isEmpty || _selectedDate == null || _startTime == null || _endTime == null || _selectedVenue == null || _parentsCtrl.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields in Step 1'), backgroundColor: Colors.red));
        return;
      }
      setState(() => _currentStep = 1);
    } else {
      _savePtm();
    }
  }

  void _savePtm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PTM "${_titleCtrl.text}" created successfully!'), backgroundColor: Colors.green),
    );
    Navigator.pop(context, {
      'title': _titleCtrl.text,
      'date': _selectedDate == null ? 'TBA' : DateFormat('dd MMM yyyy').format(_selectedDate!),
      'time': _startTime == null || _endTime == null ? 'TBA' : '${_startTime!.format(context)} - ${_endTime!.format(context)}',
      'location': _selectedVenue ?? 'TBA',
      'people': '${_parentsCtrl.text} invited',
      'isUpcoming': true,
    });
  }

  void _showClassesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40),
                        Text('Select Classes', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Done', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF6366F1))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search classes',
                          hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
                          prefixIcon: const Icon(LucideIcons.search, size: 18, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      children: _allClasses.entries.map((entry) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.key, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: entry.value.map((className) {
                                final isSelected = _selectedClasses.contains(className);
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      if (isSelected) {
                                        _selectedClasses.remove(className);
                                      } else {
                                        _selectedClasses.add(className);
                                      }
                                    });
                                    setState(() {}); // Update main screen too
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width - 40 - 24) / 3, // 3 columns
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
                                      border: Border.all(color: isSelected ? const Color(0xFF6366F1) : const Color(0xFFE2E8F0)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      className,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  if (_selectedClasses.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${_selectedClasses.length} classes selected', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
                              GestureDetector(
                                onTap: () {
                                  setModalState(() => _selectedClasses.clear());
                                  setState(() {});
                                },
                                child: Text('Clear All', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFEF4444))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _selectedClasses.map((c) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(c, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF6366F1), fontWeight: FontWeight.w500)),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () {
                                          setModalState(() => _selectedClasses.remove(c));
                                          setState(() {});
                                        },
                                        child: const Icon(LucideIcons.x, size: 12, color: Color(0xFF94A3B8)),
                                      ),
                                    ],
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
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
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Color(0xFF0F172A), size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(child: Center(child: Text('Create PTM', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))))),
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(_currentStep == 0 ? 'Next' : 'Create', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: _currentStep == 0 ? _buildStep1() : _buildStep2(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.calendarDays, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 8),
              Text('Meeting details', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
            ],
          ),
          const SizedBox(height: 4),
          Text('Fill in the schedule and venue for this PTM.', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B))),
          const SizedBox(height: 24),
          
          // Preview Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Icon(LucideIcons.calendarPlus, size: 48, color: const Color(0xFF818CF8)),
                ),
                const SizedBox(height: 24),
                Text('New PTM', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF6366F1))),
                const SizedBox(height: 4),
                Text(_titleCtrl.text.isEmpty ? 'Meeting title' : _titleCtrl.text, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                const SizedBox(height: 16),
                _buildPreviewRow(LucideIcons.calendar, _selectedDate == null ? 'No date selected' : DateFormat('EEEE, d MMM yyyy').format(_selectedDate!)),
                _buildPreviewRow(LucideIcons.clock, _startTime == null || _endTime == null ? 'Time not set' : '${_startTime!.format(context)} to ${_endTime!.format(context)}'),
                _buildPreviewRow(LucideIcons.mapPin, _selectedVenue ?? 'No venue'),
                _buildPreviewRow(LucideIcons.users, _parentsCtrl.text.isEmpty ? '0 invited' : '${_parentsCtrl.text} invited'),
                _buildPreviewRow(LucideIcons.graduationCap, 'No classes selected'), // Will update in step 2
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          _buildLabel('Meeting Title', required: true),
          _buildTextField(_titleCtrl, 'e.g. Term 1 Parent-Teacher Meeting', onChanged: (v) => setState((){})),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Date', required: true),
                    GestureDetector(
                      onTap: () async {
                        final d = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                        if (d != null) setState(() => _selectedDate = d);
                      },
                      child: _buildSelectorBox(LucideIcons.calendar, _selectedDate == null ? 'Pick a date' : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Block / Venue', required: true),
                    GestureDetector(
                      onTap: () {
                        // Simple bottom sheet for venue
                        showModalBottomSheet(context: context, builder: (c) => ListView(
                          shrinkWrap: true,
                          children: _venues.map((v) => ListTile(
                            title: Text(v, style: GoogleFonts.inter(fontSize: 14)),
                            onTap: () { setState(() => _selectedVenue = v); Navigator.pop(context); },
                          )).toList(),
                        ));
                      },
                      child: _buildSelectorBox(LucideIcons.mapPin, _selectedVenue ?? 'Select venue', trailing: LucideIcons.chevronRight),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Start Time', required: true),
                    GestureDetector(
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: _startTime ?? TimeOfDay.now());
                        if (t != null) setState(() => _startTime = t);
                      },
                      child: _buildSelectorBox(LucideIcons.clock, _startTime == null ? '--:-- --' : _startTime!.format(context)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('End Time', required: true),
                    GestureDetector(
                      onTap: () async {
                        final t = await showTimePicker(context: context, initialTime: _endTime ?? TimeOfDay.now());
                        if (t != null) setState(() => _endTime = t);
                      },
                      child: _buildSelectorBox(LucideIcons.clock, _endTime == null ? '--:-- --' : _endTime!.format(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          _buildLabel('Parents Invited', required: true),
          _buildTextField(_parentsCtrl, 'e.g. 120', onChanged: (v) => setState((){}), keyboardType: TextInputType.number),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Classes Invited', required: true),
          GestureDetector(
            onTap: _showClassesBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC), // subtle blue-gray
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(LucideIcons.graduationCap, color: Color(0xFF6366F1), size: 24),
                    const SizedBox(height: 8),
                    Text(
                      _selectedClasses.isEmpty ? 'Select classes' : '${_selectedClasses.length} classes selected',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF6366F1)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLabel('Add Notes (Optional)'),
          _buildTextField(_notesCtrl, 'Add any notes for this meeting', maxLines: 3),
          const SizedBox(height: 20),
          _buildLabel('Meeting Description (Optional)'),
          _buildTextField(_descCtrl, 'Add description about the agenda, purpose, or topics to be discussed', maxLines: 4),
          const SizedBox(height: 24),
          
          // Meeting Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Meeting Summary', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                const SizedBox(height: 16),
                _buildSummaryRow(LucideIcons.calendar, 'Title', _titleCtrl.text),
                _buildSummaryRow(LucideIcons.calendar, 'Date', _selectedDate == null ? 'Not selected' : DateFormat('dd MMM yyyy').format(_selectedDate!)),
                _buildSummaryRow(LucideIcons.clock, 'Time', _startTime == null || _endTime == null ? '--:-- -- to --:-- --' : '${_startTime!.format(context)} to ${_endTime!.format(context)}'),
                _buildSummaryRow(LucideIcons.mapPin, 'Venue', _selectedVenue ?? 'Not selected'),
                _buildSummaryRow(LucideIcons.users, 'Parents Invited', _parentsCtrl.text),
                _buildSummaryRow(LucideIcons.graduationCap, 'Classes', _selectedClasses.isEmpty ? 'Not selected' : _selectedClasses.join(', ')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Send Invitations Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Send invitations to parents', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                    const SizedBox(height: 2),
                    Text('Parents will receive an SMS/Email invite.', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF64748B))),
                  ],
                ),
                Switch(
                  value: _sendInvites,
                  onChanged: (val) => setState(() => _sendInvites = val),
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF6366F1),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _savePtm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text('Create Meeting', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 12),
          Text(text, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569))),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF64748B)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
          Text(text, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A))),
          if (required) Text(' *', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFEF4444))),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, {int maxLines = 1, void Function(String)? onChanged, TextInputType? keyboardType}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F172A)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSelectorBox(IconData icon, String text, {IconData? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 14, color: text.contains('Pick') || text.contains('Select') || text.contains('--') ? const Color(0xFF94A3B8) : const Color(0xFF0F172A)))),
          if (trailing != null) Icon(trailing, size: 16, color: const Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
