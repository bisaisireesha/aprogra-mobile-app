import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _primary = Color(0xFF00A2FF); // Blue matching the image
const _textDark = Color(0xFF181821);
const _textMuted = Color(0xFF595973);
const _bgColor = Color(0xFFF9F9FB); // Very light gray background
const _cardBorder = Color(0xFFF0F0F0);

class StaffDetailsPopup extends StatefulWidget {
  final Map<String, dynamic> staff;
  final Function(Map<String, dynamic>)? onUpdate;

  const StaffDetailsPopup({super.key, required this.staff, this.onUpdate});

  @override
  State<StaffDetailsPopup> createState() => _StaffDetailsPopupState();
}

class _StaffDetailsPopupState extends State<StaffDetailsPopup> {
  String _activeTab = 'Details';

  Map<String, dynamic> get _mockData {
    final name = widget.staff['name'] ?? '';
    final dept = widget.staff['department'] ?? '';
    
    final isSecurity = dept == 'Security';
    final isTransport = dept == 'Transport';
    final isAccounts = dept == 'Accounts';
    
    return {
      'dob': isSecurity ? '12 Jan 1982' : isTransport ? '05 Mar 1978' : isAccounts ? '22 Nov 1990' : '18 Mar 1986',
      'gender': name.contains('Rekha') || name.contains('Mehta') ? 'Female' : 'Male',
      'bloodGroup': isTransport ? 'O+' : isSecurity ? 'A+' : 'B+',
      'email': '${name.split(' ').first.toLowerCase()}@aprogra.edu',
      'phone': '+91 ${9000000000 + name.length * 1234567}',
      'address': '${10 + name.length}, Main Street, Sector ${name.length}, City',
      'aadhaar': 'XXXX-XXXX-${1000 + name.length * 111}',
      'pan': 'ABCDE${1000 + name.length * 11}F',
      'qual': isAccounts ? 'B.Com • Finance' : isTransport ? 'High School • Valid License' : 'Diploma • Operations',
      'skills': isAccounts ? 'Tally, Excel, Payroll' : isTransport ? 'Driving, Mechanics' : isSecurity ? 'Surveillance, CPR' : 'MS Office, Reporting',
      'exp': '${5 + (name.length % 5)} years',
      'lang': isTransport ? 'Hindi, Local' : 'English, Hindi, Marathi',
      
      'attendance': isSecurity ? '98%' : isTransport ? '95%' : '90%',
      'present': isSecurity ? '25' : isTransport ? '24' : '18',
      'absent': isSecurity ? '0' : isTransport ? '1' : '2',
      'leave': isSecurity ? '1' : isTransport ? '1' : '0',
      
      'gross': isTransport ? '₹22,000' : isAccounts ? '₹35,000' : isSecurity ? '₹18,000' : '₹28,000',
      'deduct': isTransport ? '₹2,640' : isAccounts ? '₹4,200' : isSecurity ? '₹2,160' : '₹3,360',
      'net': isTransport ? '₹19,360' : isAccounts ? '₹30,800' : isSecurity ? '₹15,840' : '₹24,640',
      'bank': isTransport ? 'SBI' : isAccounts ? 'ICICI' : 'HDFC',
      'acc': 'XXXX XXXX ${4000 + name.length * 11}',
      
      'leaveTotal': isAccounts ? '20' : '24',
      'leaveUsed': isAccounts ? '12' : '6',
      'leaveBal': isAccounts ? '8' : '18',
      'leavePend': isAccounts ? '0' : '1',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      _buildTabs(),
                      const SizedBox(height: 24),
                      _buildContent(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(LucideIcons.arrowLeft, color: _primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Back',
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showEditStaffModal(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.edit3, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Edit Staff Details',
                        style: GoogleFonts.figtree(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.staff['initials'],
                  style: GoogleFonts.figtree(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.staff['name'],
                      style: GoogleFonts.figtree(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(LucideIcons.briefcase, widget.staff['role']),
                    const SizedBox(height: 4),
                    _buildInfoRow(LucideIcons.building, widget.staff['department']),
                    const SizedBox(height: 4),
                    _buildInfoRow(LucideIcons.idCard, widget.staff['id']),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBadge('Active', const Color(0xFF10B981), const Color(0xFFECFDF5)),
              _buildBadge('Support Staff', _primary, _primary.withValues(alpha: 0.1)),
              _buildBadge(widget.staff['status'], const Color(0xFFF59E0B), const Color(0xFFFFFBEB)),
            ],
          ),
          const SizedBox(height: 8),
          _buildBadge('1 yrs • Tenure', const Color(0xFF8B5CF6), const Color(0xFFF3E8FF)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.figtree(fontSize: 13, color: const Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildBadge(String text, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: GoogleFonts.figtree(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab('Details', LucideIcons.fileText),
            _buildTab('Attendance', LucideIcons.calendar),
            _buildTab('Duties & Shifts', LucideIcons.briefcase),
            _buildTab('Payroll', LucideIcons.creditCard),
            _buildTab('Leaves', LucideIcons.calendarOff),
            _buildTab('Documents', LucideIcons.shieldCheck),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, IconData icon) {
    final bool isActive = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? _primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? _primary : _textMuted),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? _primary : _textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditStaffModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: widget.staff['name']);
    final TextEditingController roleController = TextEditingController(text: widget.staff['role']);
    final TextEditingController deptController = TextEditingController(text: widget.staff['department']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Edit Staff Details', style: GoogleFonts.figtree(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: roleController,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: deptController,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.figtree(color: _textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final role = roleController.text.trim();
                final dept = deptController.text.trim();
                
                if (name.isNotEmpty && role.isNotEmpty && dept.isNotEmpty) {
                  setState(() {
                    widget.staff['name'] = name;
                    widget.staff['role'] = role;
                    widget.staff['department'] = dept;
                    widget.staff['initials'] = name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
                  });
                  widget.onUpdate?.call(widget.staff);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Save', style: GoogleFonts.figtree(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (_activeTab == 'Details') ...[
            _CollapsibleSection(
              title: 'Personal Information',
              subtitle: 'Basic personal details',
              icon: LucideIcons.user,
              iconColor: _primary,
              iconBgColor: _primary.withValues(alpha: 0.1),
              initiallyExpanded: false,
              content: Column(
                children: [
                  _buildDataRow(LucideIcons.calendar, 'Date of Birth', _mockData['dob']),
                  _buildDataRow(LucideIcons.user, 'Gender', _mockData['gender']),
                  _buildDataRow(LucideIcons.userPlus, 'Blood Group', _mockData['bloodGroup']),
                  _buildDataRow(LucideIcons.mapPin, 'Address', _mockData['address'], multiline: true, isLast: true),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _CollapsibleSection(
              title: 'Contact',
              subtitle: 'Phone, email & emergency contact',
              icon: LucideIcons.phone,
              iconColor: const Color(0xFF10B981),
              iconBgColor: const Color(0xFFECFDF5),
              initiallyExpanded: false,
              content: Column(
                children: [
                  _buildDataRow(LucideIcons.phone, 'Mobile', _mockData['phone']),
                  _buildDataRow(LucideIcons.phoneCall, 'Alt. Phone', '+91 9876543255'),
                  _buildDataRow(LucideIcons.mail, 'Work Email', _mockData['email']),
                  _buildDataRow(LucideIcons.userCircle, 'Emergency Contact', 'Spouse • +91 9876543221', isLast: true),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _CollapsibleSection(
              title: 'Employment',
              subtitle: 'Job role, department & reporting',
              icon: LucideIcons.briefcase,
              iconColor: const Color(0xFFF59E0B),
              iconBgColor: const Color(0xFFFFFBEB),
              initiallyExpanded: false,
              content: Column(
                children: [
                  _buildDataRow(LucideIcons.briefcase, 'Designation', widget.staff['role']),
                  _buildDataRow(LucideIcons.building, 'Department', widget.staff['department']),
                  _buildDataRow(LucideIcons.calendar, 'Joined', '12 Jun 2018'),
                  _buildDataRow(LucideIcons.activity, 'Employment Type', 'Full-time'),
                  _buildDataRow(LucideIcons.clock, 'Shift Timing', '09:00 AM - 05:00 PM'),
                  _buildDataRow(LucideIcons.checkCircle, 'Reports To', 'Operations Manager', isLast: true),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _CollapsibleSection(
              title: 'Qualifications',
              subtitle: 'Education, skills & experience',
              icon: LucideIcons.graduationCap,
              iconColor: const Color(0xFF8B5CF6),
              iconBgColor: const Color(0xFFF3E8FF),
              initiallyExpanded: false,
              content: Column(
                children: [
                  _buildDataRow(LucideIcons.graduationCap, 'Highest Qualification', _mockData['qual']),
                  _buildDataRow(LucideIcons.award, 'Skills', _mockData['skills']),
                  _buildDataRow(LucideIcons.clock, 'Experience', _mockData['exp']),
                  _buildDataRow(LucideIcons.languages, 'Languages', _mockData['lang'], isLast: true),
                ],
              ),
            ),
          ] else if (_activeTab == 'Attendance') ...[
            _buildAttendanceContent(),
          ] else if (_activeTab == 'Duties & Shifts') ...[
            _buildDutiesContent(),
          ] else if (_activeTab == 'Payroll') ...[
            _buildPayrollContent(),
          ] else if (_activeTab == 'Leaves') ...[
            _buildLeavesContent(),
          ] else if (_activeTab == 'Documents') ...[
            _buildDocumentsContent(),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Text(
                  '$_activeTab Information\\nComing Soon',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.figtree(fontSize: 16, color: _textMuted),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttendanceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildSummaryCard('ATTENDANCE', _mockData['attendance'], const Color(0xFF10B981), const Color(0xFFECFDF5))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('PRESENT', _mockData['present'], const Color(0xFF10B981), const Color(0xFFECFDF5))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('LEAVE', _mockData['leave'], const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('ABSENT', _mockData['absent'], const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(LucideIcons.chevronLeft, size: 20, color: _textDark),
                  Text('June 2026', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                  const Icon(LucideIcons.chevronRight, size: 20, color: _textDark),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Present', const Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  _buildLegendItem('Leave', const Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  _buildLegendItem('Absent', const Color(0xFFEF4444)),
                  const SizedBox(width: 8),
                  _buildLegendItem('Holiday', const Color(0xFF9CA3AF)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'].map((day) => Expanded(
                  child: Text(day, textAlign: TextAlign.center, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: _textMuted)),
                )).toList(),
              ),
              const SizedBox(height: 12),
              _buildCalendarGrid(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildStatCard('THIS QUARTER', [
          {'icon': LucideIcons.checkCircle, 'label': 'Attendance', 'value': '94%'},
          {'icon': LucideIcons.xCircle, 'label': 'Absent days', 'value': '4'},
        ]),
        SizedBox(height: 12.h),
        _buildStatCard('YEAR-TO-DATE', [
          {'icon': LucideIcons.activity, 'label': 'Avg. attendance', 'value': '92%'},
          {'icon': LucideIcons.clock, 'label': 'Late marks', 'value': '3'},
        ]),
        SizedBox(height: 12.h),
        _buildStatCard('PUNCTUALITY', [
          {'icon': LucideIcons.zap, 'label': 'Streak', 'value': '22 days'},
          {'icon': LucideIcons.alertTriangle, 'label': 'Warnings', 'value': '0'},
        ]),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDutiesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildSummaryCard('ACTIVE DUTIES', '3', const Color(0xFF8B5CF6), const Color(0xFFF3E8FF))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('SHIFT', 'Day', const Color(0xFF10B981), const Color(0xFFECFDF5))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('HOURS/WK', '40', const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('ON-CALL', 'Yes', const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ASSIGNED DUTIES', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted)),
              SizedBox(height: 12.h),
              _buildDutyRow(
                widget.staff['department'] == 'Security' ? 'Main Gate · Day Shift' : 
                widget.staff['department'] == 'Transport' ? 'Morning Route' : 
                widget.staff['department'] == 'Accounts' ? 'Main Ledger' : 'Primary Shift',
                'Mon – Sat', '08:00 – 16:00'
              ),
              const Divider(color: _cardBorder, height: 32),
              _buildDutyRow(
                widget.staff['department'] == 'Security' ? 'Visitor Log' : 
                widget.staff['department'] == 'Transport' ? 'Vehicle Inspection' : 
                widget.staff['department'] == 'Accounts' ? 'Tax Filing' : 'Daily Logs',
                'Daily', 'Throughout shift', isBlue: false
              ),
              const Divider(color: _cardBorder, height: 32),
              _buildDutyRow(
                widget.staff['department'] == 'Security' ? 'Evening Patrol (rotation)' : 
                widget.staff['department'] == 'Transport' ? 'Evening Route' : 
                widget.staff['department'] == 'Accounts' ? 'Audit' : 'Evening Closing',
                'Tue, Thu', '16:00 – 20:00'
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('THIS WEEK\\\'S SCHEDULE', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted)),
              const SizedBox(height: 20),
              _buildScheduleRow('Mon', '08:00 – 16:00 · ${widget.staff['department']} Dept'),
              SizedBox(height: 12.h),
              _buildScheduleRow('Tue', '08:00 – 16:00 · ${widget.staff['department']} Dept'),
              SizedBox(height: 12.h),
              _buildScheduleRow('Wed', '08:00 – 16:00 · ${widget.staff['department']} Dept'),
              SizedBox(height: 12.h),
              _buildScheduleRow('Thu', '08:00 – 16:00 · ${widget.staff['department']} Dept'),
              SizedBox(height: 12.h),
              _buildScheduleRow('Fri', '08:00 – 16:00 · ${widget.staff['department']} Dept'),
              SizedBox(height: 12.h),
              _buildScheduleRow('Sat', '08:00 – 12:00 · ${widget.staff['department']} Dept'),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDutyRow(String title, String subtitle, String badgeText, {bool isBlue = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isBlue ? const Color(0xFFE0F2FE) : const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(badgeText, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: isBlue ? const Color(0xFF0284C7) : const Color(0xFF38BDF8))),
        ),
      ],
    );
  }

  Widget _buildScheduleRow(String day, String details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: GoogleFonts.figtree(fontSize: 14, color: _textDark)),
        Text(details, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
      ],
    );
  }

  Widget _buildPayrollContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildSummaryCard('MONTHLY GROSS', _mockData['gross'], const Color(0xFF8B5CF6), const Color(0xFFF3E8FF))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('DEDUCTIONS', _mockData['deduct'], const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('NET PAY', _mockData['net'], const Color(0xFF10B981), const Color(0xFFECFDF5))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('LAST PAID', '01 May 2026', const Color(0xFF8B5CF6), const Color(0xFFF3E8FF))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RECENT PAYSLIPS', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted)),
              SizedBox(height: 12.h),
              _buildPayslipRow('May 2026', 'Gross ₹28,000 · Net ₹24,640'),
              const Divider(color: _cardBorder, height: 32),
              _buildPayslipRow('Apr 2026', 'Gross ₹28,000 · Net ₹24,640'),
              const Divider(color: _cardBorder, height: 32),
              _buildPayslipRow('Mar 2026', 'Gross ₹27,500 · Net ₹24,140'),
              const Divider(color: _cardBorder, height: 32),
              _buildPayslipRow('Feb 2026', 'Gross ₹28,000 · Net ₹24,640'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('BANK & TAX', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted)),
              SizedBox(height: 12.h),
              _buildBankRow(LucideIcons.wallet, 'Salary Account', '${_mockData['bank']} · ${_mockData['acc']}'),
              _buildBankRow(LucideIcons.creditCard, 'PAN Number', _mockData['pan']!),
              _buildBankRow(LucideIcons.fileText, 'PF Account', 'MH/BAN/12345/678'),
              _buildBankRow(LucideIcons.hash, 'UAN Number', '100987654321'),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPayslipRow(String month, String details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(month, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text(details, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Processed', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF10B981))),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Icon(LucideIcons.download, size: 14, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 4),
                Text('Slip', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF8B5CF6))),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBankRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 13,
                color: _textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.figtree(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeavesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildSummaryCard('TOTAL LEAVES', _mockData['leaveTotal'], const Color(0xFF8B5CF6), const Color(0xFFF3E8FF))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('USED', _mockData['leaveUsed'], const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('BALANCE', _mockData['leaveBal'], const Color(0xFF10B981), const Color(0xFFECFDF5))),
              const SizedBox(width: 8),
              Expanded(child: _buildSummaryCard('PENDING', _mockData['leavePend'], const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LEAVE BALANCES', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted)),
              SizedBox(height: 12.h),
              _buildLeaveBalanceRow('Casual Leave', '2 / 8'),
              _buildLeaveBalanceRow('Sick Leave', '4 / 10'),
              _buildLeaveBalanceRow('Earned Leave', '6 / 6'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RECENT APPLICATIONS', style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted)),
              SizedBox(height: 12.h),
              _buildLeaveAppRow('Casual Leave', '14 – 15 Apr 2026', 'Approved', true),
              const Divider(color: _cardBorder, height: 32),
              _buildLeaveAppRow('Sick Leave', '02 Mar 2026', 'Approved', true),
              const Divider(color: _cardBorder, height: 32),
              _buildLeaveAppRow('Casual Leave', '22 Jan 2026', 'Approved', true),
              const Divider(color: _cardBorder, height: 32),
              _buildLeaveAppRow('Earned Leave (2d)', '08 Jun 2026', 'Pending', false),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLeaveBalanceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 12),
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: 13,
                color: _textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveAppRow(String title, String subtitle, String status, bool isApproved) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text(subtitle, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isApproved ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: GoogleFonts.figtree(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isApproved ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentCard(
          'IDENTITY DOCUMENTS',
          [
            _buildDocRow('Aadhaar Card', true, 'Verified'),
            _buildDocRow('PAN Card', true, 'Verified'),
            _buildDocRow('Address Proof', true, 'Verified'),
            _buildDocRow('Passport', true, 'Verified'),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDocumentCard(
          'EMPLOYMENT DOCUMENTS',
          [
            _buildDocRow('Offer Letter', true, 'On file'),
            _buildDocRow('Appointment Letter', true, 'On file'),
            _buildDocRow('NDA', true, 'On file'),
            _buildDocRow('Background Verification', true, 'On file'),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDocumentCard(
          'EDUCATION / SKILL',
          [
            _buildDocRow('Highest Degree Certificate', true, 'Verified'),
            _buildDocRow('B.Ed. / Diploma', true, 'Verified'),
            _buildDocRow('Experience Letters', true, 'Verified'),
            _buildDocRow('Certifications', true, 'Verified'),
          ],
        ),
        SizedBox(height: 12.h),
        _buildDocumentCard(
          'COMPLIANCE',
          [
            _buildComplianceRow('Police Verification', 'Valid till Aug 2027'),
            _buildComplianceRow('Medical Fitness', 'Cleared · Jan 2026'),
            _buildComplianceRow('POSH Training', 'Completed · Sep 2025'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(LucideIcons.download, size: 16, color: Color(0xFF8B5CF6)),
                const SizedBox(width: 8),
                Text('Download Complete File', style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF8B5CF6))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDocumentCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.bold, color: _textMuted)),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDocRow(String label, bool isGreen, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.fileText, size: 16, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 12),
              Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _textDark)),
            ],
          ),
          Row(
            children: [
              Icon(LucideIcons.checkCircle, size: 14, color: isGreen ? const Color(0xFF10B981) : _textMuted),
              const SizedBox(width: 4),
              Text(status, style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: isGreen ? const Color(0xFF10B981) : _textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.shield, size: 16, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 12),
              Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _textMuted)),
            ],
          ),
          Text(value, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.w600, color: _textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.figtree(fontSize: 10, color: _textMuted)),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    List<Map<String, dynamic>> days = [
      {'day': '', 'status': 'none'},
      {'day': '1', 'status': 'present'},
      {'day': '2', 'status': 'present'},
      {'day': '3', 'status': 'present'},
      {'day': '4', 'status': 'present'},
      {'day': '5', 'status': 'present'},
      {'day': '6', 'status': 'present'},
      {'day': '7', 'status': 'none'},
      {'day': '8', 'status': 'present'},
      {'day': '9', 'status': 'absent'},
      {'day': '10', 'status': 'present'},
      {'day': '11', 'status': 'present'},
      {'day': '12', 'status': 'present'},
      {'day': '13', 'status': 'present'},
      {'day': '14', 'status': 'none'},
      {'day': '15', 'status': 'present'},
      {'day': '16', 'status': 'present'},
      {'day': '17', 'status': 'present'},
      {'day': '18', 'status': 'present'},
      {'day': '19', 'status': 'present'},
      {'day': '20', 'status': 'present'},
      {'day': '21', 'status': 'none'},
      {'day': '22', 'status': 'absent'},
      {'day': '23', 'status': 'present'},
      {'day': '24', 'status': 'none'},
      {'day': '25', 'status': 'none'},
      {'day': '26', 'status': 'none'},
      {'day': '27', 'status': 'none'},
      {'day': '28', 'status': 'none'},
      {'day': '29', 'status': 'none'},
      {'day': '30', 'status': 'none'},
      {'day': '', 'status': 'none'},
      {'day': '', 'status': 'none'},
      {'day': '', 'status': 'none'},
      {'day': '', 'status': 'none'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        var dayInfo = days[index];
        if (dayInfo['day'] == '') return const SizedBox.shrink();

        Color bgColor = Colors.white;
        Color textColor = _textDark;
        IconData? icon;
        Color? iconColor;

        if (dayInfo['status'] == 'present') {
          bgColor = const Color(0xFFECFDF5);
          textColor = const Color(0xFF10B981);
          icon = LucideIcons.checkCircle;
          iconColor = const Color(0xFF10B981);
        } else if (dayInfo['status'] == 'absent') {
          bgColor = const Color(0xFFFEF2F2);
          textColor = const Color(0xFFEF4444);
          icon = LucideIcons.xCircle;
          iconColor = const Color(0xFFEF4444);
        } else if (dayInfo['status'] == 'leave') {
          bgColor = const Color(0xFFFFFBEB);
          textColor = const Color(0xFFF59E0B);
          icon = LucideIcons.minusCircle;
          iconColor = const Color(0xFFF59E0B);
        } else {
          bgColor = Colors.white;
          textColor = _textMuted;
        }

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayInfo['day'],
                style: GoogleFonts.figtree(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(height: 4),
                Icon(icon, size: 14, color: iconColor),
              ]
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, List<Map<String, dynamic>> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.figtree(fontSize: 11, fontWeight: FontWeight.w700, color: _textMuted)),
          SizedBox(height: 12.h),
          ...rows.map((row) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(row['icon'], size: 14, color: const Color(0xFF9CA3AF)),
                const SizedBox(width: 8),
                Text(row['label'], style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                const Spacer(),
                Text(row['value'], style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.bold, color: _textDark)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value, {bool multiline = false, bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
              const SizedBox(width: 12),
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    color: _textMuted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                    height: multiline ? 1.4 : 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: _cardBorder, height: 1),
      ],
    );
  }
}

class _CollapsibleSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Widget content;
  final bool initiallyExpanded;

  const _CollapsibleSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.content,
    required this.initiallyExpanded,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(widget.icon, color: widget.iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.figtree(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      if (!_isExpanded) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.figtree(
                            fontSize: 13,
                            color: _textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(_isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown, color: const Color(0xFF9CA3AF), size: 20),
              ],
            ),
            if (_isExpanded) ...[
              SizedBox(height: 12.h),
              const Divider(color: _cardBorder, height: 1),
              const SizedBox(height: 8),
              widget.content,
            ],
          ],
        ),
      ),
    );
  }
}
