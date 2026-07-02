import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _textDark = Color(0xFF181B20);
const _textMuted = Color(0xFF595973);
const _accent = Color(0xFF6C5CE7);
const _bgPrimary = Color(0xFFF6F6F8);

class StudentDetailsPopup extends StatefulWidget {
  final Map<String, dynamic> student;
  final VoidCallback onEdit;

  const StudentDetailsPopup({super.key, required this.student, required this.onEdit});

  @override
  State<StudentDetailsPopup> createState() => _StudentDetailsPopupState();
}

class _StudentDetailsPopupState extends State<StudentDetailsPopup> {
  String _activeTab = 'Details';

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width > 800;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: isWide ? 900 : double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.9,
        decoration: BoxDecoration(
          color: _bgPrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildProfileCard(),
                    const SizedBox(height: 24),
                    _buildTabs(),
                    const SizedBox(height: 24),
                    _buildContentGrid(isWide),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    bool isWideHeader = MediaQuery.sizeOf(context).width > 600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: _accent, size: 18),
            label: Text(isWideHeader ? 'Back to Students' : 'Back', style: GoogleFonts.figtree(color: _accent, fontWeight: FontWeight.w600)),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onEdit();
                },
                icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                label: Text(isWideHeader ? 'Edit Student Details' : 'Edit', style: GoogleFonts.figtree(fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: _textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _accent,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.student['initials'] ?? '?',
              style: GoogleFonts.figtree(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student['name'] ?? 'Unknown Student',
                  style: GoogleFonts.figtree(fontSize: 24, fontWeight: FontWeight.bold, color: _textDark),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.school_outlined, size: 16, color: _textMuted),
                        const SizedBox(width: 4),
                        Text('${widget.student['class'] ?? '--'}', style: GoogleFonts.figtree(color: _textMuted, fontSize: 14)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline, size: 16, color: _textMuted),
                        const SizedBox(width: 4),
                        Text('Section A', style: GoogleFonts.figtree(color: _textMuted, fontSize: 14)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.numbers_outlined, size: 16, color: _textMuted),
                        const SizedBox(width: 4),
                        Text('${widget.student['roll'] ?? '--'}', style: GoogleFonts.figtree(color: _textMuted, fontSize: 14)),
                      ],
                    ),
                    Text('Boy', style: GoogleFonts.figtree(color: _textMuted, fontSize: 14)),
                  ],
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTag('Active', Colors.green),
                    _buildTag('Fees · Cleared', _accent),
                    _buildTag('Transport · Route 12', Colors.orange),
                    _buildTag('Daycare', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.figtree(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTabs() {
    bool isPrePrimary = false;
    final cls = widget.student['class']?.toLowerCase() ?? '';
    if (cls.contains('nursery') || cls.contains('pre') || cls.contains('lkg') || cls.contains('ukg')) {
      isPrePrimary = true;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTab('Details', LucideIcons.fileText),
          _buildTab('Attendance', LucideIcons.calendar),
          _buildTab('Fee', LucideIcons.creditCard),
          _buildTab('Admission', LucideIcons.userPlus),
          _buildTab('Medical', LucideIcons.activity),
          _buildTab('Transport', LucideIcons.truck),
          if (isPrePrimary) _buildTab('Daycare', LucideIcons.sun),
        ],
      ),
    );
  }

  Widget _buildTab(String title, IconData icon) {
    final bool isActive = _activeTab == title;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = title),
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        margin: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? _accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? _accent : _textMuted),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.figtree(
                color: isActive ? _accent : _textMuted,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentGrid(bool isWide) {
    if (_activeTab == 'Attendance') {
      return _buildAttendanceContent(isWide);
    }
    if (_activeTab == 'Fee') {
      return _buildFeeContent(isWide);
    }
    if (_activeTab == 'Admission') {
      return _buildAdmissionContent(isWide);
    }
    if (_activeTab == 'Medical') {
      return _buildMedicalContent(isWide);
    }
    if (_activeTab == 'Transport') {
      return _buildTransportContent(isWide);
    }
    if (_activeTab == 'Daycare') {
      return _buildDaycareContent(isWide);
    }
    
    if (_activeTab != 'Details') {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            '$_activeTab Information\\nComing Soon',
            textAlign: TextAlign.center,
            style: GoogleFonts.figtree(fontSize: 16, color: _textMuted),
          ),
        ),
      );
    }
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('PERSONAL INFORMATION', [
          _buildInfoRow(LucideIcons.calendar, 'Date of Birth', widget.student['dob']?.toString().isNotEmpty == true ? widget.student['dob'] : 'Not provided'),
          _buildInfoRow(LucideIcons.user, 'Blood Group', widget.student['bloodGroup']?.toString().isNotEmpty == true ? widget.student['bloodGroup'] : 'Not provided'),
          _buildInfoRow(LucideIcons.globe, 'Nationality', widget.student['nationality']?.toString().isNotEmpty == true ? widget.student['nationality'] : 'Not provided'),
          _buildInfoRow(LucideIcons.mapPin, 'Address', widget.student['address']?.toString().isNotEmpty == true ? widget.student['address'] : 'Not provided'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('GUARDIAN & CONTACT', [
          _buildInfoRow(LucideIcons.user, 'Father', widget.student['fatherName']?.toString().isNotEmpty == true ? widget.student['fatherName'] : (widget.student['parent'] ?? 'Not provided')),
          _buildInfoRow(LucideIcons.user, 'Mother', widget.student['motherName']?.toString().isNotEmpty == true ? widget.student['motherName'] : 'Not provided'),
          _buildInfoRow(LucideIcons.phone, 'Phone', widget.student['contactNumber']?.toString().isNotEmpty == true ? widget.student['contactNumber'] : 'Not provided'),
          _buildInfoRow(LucideIcons.mail, 'Email', widget.student['email']?.toString().isNotEmpty == true ? widget.student['email'] : 'Not provided'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('ACADEMIC SNAPSHOT', [
          _buildInfoRow(LucideIcons.graduationCap, 'Class', '${widget.student['class'] ?? 'Unassigned'}'),
          _buildInfoRow(LucideIcons.activity, 'Avg. Score', 'N/A'),
          _buildInfoRow(LucideIcons.award, 'Rank', 'N/A'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('IDENTIFIERS', [
          _buildInfoRow(LucideIcons.hash, 'Admission No.', widget.student['admissionNo']?.toString().isNotEmpty == true ? widget.student['admissionNo'] : 'Not provided'),
          _buildInfoRow(LucideIcons.hash, 'Roll No.', '${widget.student['roll'] ?? 'N/A'}'),
          _buildInfoRow(LucideIcons.hash, 'Aadhaar', widget.student['aadhaar']?.toString().isNotEmpty == true ? widget.student['aadhaar'] : 'Not provided'),
        ])),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.figtree(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8F96A3),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF8F96A3)),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.figtree(fontSize: 14, color: _textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: _textDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: _bgPrimary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          Text(
            'Class: ${widget.student['class'] ?? 'N/A'}  Section: A  Roll: ${widget.student['roll'] ?? 'N/A'}',
            style: GoogleFonts.figtree(fontSize: 12, color: _textMuted, fontWeight: FontWeight.w500),
          ),
          Text(
            'Basic profile preview — full profile design coming soon.',
            style: GoogleFonts.figtree(fontSize: 12, color: _textMuted),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceContent(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildSummaryCard('OVERALL', '95%', const Color(0xFF10B981), const Color(0xFFECFDF5))),
                const SizedBox(width: 8),
                Expanded(child: _buildSummaryCard('PRESENT', '20', const Color(0xFF10B981), const Color(0xFFECFDF5))),
                if (isWide) ...[
                  const SizedBox(width: 8),
                  Expanded(child: _buildSummaryCard('LATE', '1', const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSummaryCard('ABSENT', '1', const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
                ],
              ],
            ),
            if (!isWide) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildSummaryCard('LATE', '1', const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSummaryCard('ABSENT', '1', const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0F0F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 16,
                runSpacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('June 2026', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
                      const SizedBox(height: 4),
                      Text('${widget.student['name']?.split(' ')[0] ?? 'Student'}\'s monthly attendance', style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildLegendItem('Present', const Color(0xFF10B981)),
                      _buildLegendItem('Late', const Color(0xFFF59E0B)),
                      _buildLegendItem('Absent', const Color(0xFFEF4444)),
                      _buildLegendItem('Holiday', const Color(0xFF9CA3AF)),
                    ],
                  ),
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
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: isWide ? 250 : double.infinity,
              child: _buildStatCard('TERM 1', [
                {'icon': LucideIcons.checkCircle, 'label': 'Attendance', 'value': '92%'},
                {'icon': LucideIcons.xCircle, 'label': 'Absent days', 'value': '6'},
              ]),
            ),
            SizedBox(
              width: isWide ? 250 : double.infinity,
              child: _buildStatCard('TERM 2', [
                {'icon': LucideIcons.checkCircle, 'label': 'Attendance', 'value': '89%'},
                {'icon': LucideIcons.xCircle, 'label': 'Absent days', 'value': '9'},
              ]),
            ),
            SizedBox(
              width: isWide ? 250 : double.infinity,
              child: _buildStatCard('YEAR-TO-DATE', [
                {'icon': LucideIcons.zap, 'label': 'Streak', 'value': '14 days'},
                {'icon': LucideIcons.alertTriangle, 'label': 'Notices', 'value': '1'},
              ]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0F0F0)),
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
      mainAxisSize: MainAxisSize.min,
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
      {'day': '6', 'status': 'late'},
      {'day': '7', 'status': 'none'},
      {'day': '8', 'status': 'present'},
      {'day': '9', 'status': 'present'},
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
      {'day': '22', 'status': 'present'},
      {'day': '23', 'status': 'absent'},
      {'day': '24', 'status': 'present'},
      {'day': '25', 'status': 'present'},
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
        } else if (dayInfo['status'] == 'late') {
          bgColor = const Color(0xFFFFFBEB);
          textColor = const Color(0xFFF59E0B);
          icon = LucideIcons.clock;
          iconColor = const Color(0xFFF59E0B);
        } else {
          bgColor = Colors.white;
          textColor = _textMuted;
        }

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFF0F0F0)),
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
        border: Border.all(color: const Color(0xFFF0F0F0)),
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

  Widget _buildFeeContent(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildFeeSummaryCard('ANNUAL FEE', '₹84,000', _accent, const Color(0xFFF4F1FF))),
                const SizedBox(width: 16),
                Expanded(child: _buildFeeSummaryCard('PAID', '₹71,500', const Color(0xFF10B981), const Color(0xFFECFDF5))),
                if (isWide) ...[
                  const SizedBox(width: 16),
                  Expanded(child: _buildFeeSummaryCard('OUTSTANDING', '₹12,500', const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFeeSummaryCard('NEXT DUE', '15 Jun', const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
                ],
              ],
            ),
            if (!isWide) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(child: _buildFeeSummaryCard('OUTSTANDING', '₹12,500', const Color(0xFFEF4444), const Color(0xFFFEF2F2))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFeeSummaryCard('NEXT DUE', '15 Jun', const Color(0xFFF59E0B), const Color(0xFFFFFBEB))),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEBEBEB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RECENT TRANSACTIONS', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF8F96A3), letterSpacing: 1)),
              const SizedBox(height: 24),
              _buildTransactionRow('Term 3 Fee', '12 Apr 2026', '₹28,000', 'Paid'),
              const Divider(height: 32, color: Color(0xFFEBEBEB)),
              _buildTransactionRow('Term 2 Fee', '08 Jan 2026', '₹28,000', 'Paid'),
              const Divider(height: 32, color: Color(0xFFEBEBEB)),
              _buildTransactionRow('Term 1 Fee', '05 Sep 2025', '₹28,000', 'Paid'),
              const Divider(height: 32, color: Color(0xFFEBEBEB)),
              _buildTransactionRow('Admission Fee', '12 Aug 2025', '₹10,000', 'Paid'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeeSummaryCard(String title, String value, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEBEBEB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF8F96A3), letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value, style: GoogleFonts.figtree(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(String title, String date, String amount, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(height: 4),
            Text(date, style: GoogleFonts.figtree(fontSize: 12, color: _textMuted)),
          ],
        ),
        Row(
          children: [
            Text(amount, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(status, style: GoogleFonts.figtree(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdmissionContent(bool isWide) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('ADMISSION INFORMATION', [
          _buildInfoRow(LucideIcons.hash, 'Admission No.', 'ADM-ary-1'),
          _buildInfoRow(LucideIcons.calendar, 'Admission Date', '14 Jun 2022'),
          _buildInfoRow(LucideIcons.graduationCap, 'Admitted Class', 'Class 3'),
          _buildInfoRow(LucideIcons.user, 'Admission Type', 'Regular'),
          _buildInfoRow(LucideIcons.activity, 'Status', 'Active'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('PREVIOUS SCHOOL', [
          _buildInfoRow(LucideIcons.graduationCap, 'School', 'St. Mary\'s High School'),
          _buildInfoRow(LucideIcons.mapPin, 'City', 'Pune, Maharashtra'),
          _buildInfoRow(LucideIcons.calendar, 'Years', '2019 - 2022'),
          _buildInfoRow(LucideIcons.fileText, 'TC No.', 'TC/2022/1184'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('DOCUMENTS SUBMITTED', [
          _buildDocumentRow('Birth Certificate', true),
          _buildDocumentRow('Aadhaar Copy', true),
          _buildDocumentRow('Previous TC', true),
          _buildDocumentRow('Passport Photos', true),
          _buildDocumentRow('Address Proof', true),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('APPLICATION', [
          _buildInfoRow(LucideIcons.user, 'Applied By', 'Mr. Rajesh Sharma'),
          _buildInfoRow(LucideIcons.phone, 'Reference', '+91 98xxxxxx21'),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(LucideIcons.download, size: 16, color: _accent),
              const SizedBox(width: 8),
              Text('Download Admission Form', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _accent)),
            ],
          ),
        ])),
      ],
    );
  }

  Widget _buildDocumentRow(String docName, bool isVerified) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(LucideIcons.fileText, size: 16, color: const Color(0xFF8F96A3)),
              const SizedBox(width: 12),
              Text(docName, style: GoogleFonts.figtree(fontSize: 14, color: _textDark, fontWeight: FontWeight.w500)),
            ],
          ),
          if (isVerified)
            Row(
              children: [
                Icon(LucideIcons.checkCircle, size: 14, color: const Color(0xFF10B981)),
                const SizedBox(width: 4),
                Text('Verified', style: GoogleFonts.figtree(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMedicalContent(bool isWide) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('VITALS', [
          _buildInfoRow(LucideIcons.activity, 'Blood Group', 'O+'),
          _buildInfoRow(LucideIcons.moveVertical, 'Height', '142 cm'),
          _buildInfoRow(LucideIcons.activity, 'Weight', '38 kg'),
          _buildInfoRow(LucideIcons.activity, 'BMI', '18.8'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('HEALTH NOTES', [
          _buildInfoRow(LucideIcons.alertTriangle, 'Allergies', 'None reported'),
          _buildInfoRow(LucideIcons.activity, 'Chronic conditions', 'None'),
          _buildInfoRow(LucideIcons.activity, 'Medications', 'None'),
          _buildInfoRow(LucideIcons.checkCircle, 'Vaccinations', 'Up to date'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('EMERGENCY CONTACT', [
          _buildInfoRow(LucideIcons.user, 'Name', 'Mrs. Priya Sharma'),
          _buildInfoRow(LucideIcons.phone, 'Phone', '+91 98xxxxxx21'),
          _buildInfoRow(LucideIcons.activity, 'Family Doctor', 'Dr. Mehta · 0226789432'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('RECENT VISITS', [
          _buildVisitRow('Routine checkup', '04 Mar 2026'),
          _buildVisitRow('Fever (1 day rest)', '21 Jan 2026'),
          _buildVisitRow('Vision screening', '12 Oct 2025'),
        ])),
      ],
    );
  }

  Widget _buildVisitRow(String reason, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(reason, style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
          Text(date, style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF8F96A3))),
        ],
      ),
    );
  }

  Widget _buildRoutineRow(String task, String time, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(LucideIcons.clock, size: 16, color: const Color(0xFF8F96A3)),
              const SizedBox(width: 12),
              Text(task, style: GoogleFonts.figtree(fontSize: 14, color: _textMuted)),
            ],
          ),
          Row(
            children: [
              Text(time, style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: _textDark)),
              if (isDone) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check, size: 16, color: _textDark),
              ] else ...[
                const SizedBox(width: 20),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaycareContent(bool isWide) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('DAYCARE PLAN', [
          _buildInfoRow(LucideIcons.pieChart, 'Plan', 'Full Day (8 AM – 6 PM)'),
          _buildInfoRow(LucideIcons.user, 'Caregiver', 'Ms. Anita D.'),
          _buildInfoRow(LucideIcons.mapPin, 'Room', 'Sunshine Room'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('TODAY\'S ROUTINE', [
          _buildRoutineRow('Breakfast', '08:30 AM', true),
          _buildRoutineRow('Nap', '12:30 PM', true),
          _buildRoutineRow('Snack', '03:30 PM', false),
          _buildRoutineRow('Pickup', '06:00 PM', false),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('WELLBEING', [
          _buildInfoRow(LucideIcons.activity, 'Mood', 'Happy'),
          _buildInfoRow(LucideIcons.activity, 'Meals', 'Ate well'),
          _buildInfoRow(LucideIcons.activity, 'Nap Duration', '1h 20m'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('BILLING', [
          _buildInfoRow(LucideIcons.creditCard, 'Monthly Fee', '₹6,500'),
          _buildInfoRow(LucideIcons.checkCircle, 'Status', 'Paid'),
        ])),
      ],
    );
  }

  Widget _buildTransportContent(bool isWide) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('ROUTE ASSIGNMENT', [
          _buildInfoRow(LucideIcons.truck, 'Route', 'Route 10 · North Loop'),
          _buildInfoRow(LucideIcons.mapPin, 'Pickup Stop', 'Greenwood Society Gate'),
          _buildInfoRow(LucideIcons.clock, 'Pickup Time', '07:35 AM'),
          _buildInfoRow(LucideIcons.clock, 'Drop Time', '03:20 PM'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('VEHICLE & STAFF', [
          _buildInfoRow(LucideIcons.truck, 'Bus No.', 'MH12-BX-4421'),
          _buildInfoRow(LucideIcons.user, 'Driver', 'Mr. Suresh Kale'),
          _buildInfoRow(LucideIcons.user, 'Attendant', 'Mrs. Kavita R.'),
          _buildInfoRow(LucideIcons.phone, 'Bus Contact', '+91 99xxxxxx08'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('THIS WEEK', [
          _buildInfoRow(LucideIcons.checkCircle, 'Pickups', '5 / 5'),
          _buildInfoRow(LucideIcons.clock, 'Avg. Delay', '2 min'),
          _buildInfoRow(LucideIcons.alertTriangle, 'Incidents', 'None'),
        ])),
        SizedBox(width: isWide ? 400 : double.infinity, child: _buildInfoCard('BILLING', [
          _buildInfoRow(LucideIcons.creditCard, 'Monthly Fee', '₹1,800'),
          _buildInfoRow(LucideIcons.checkCircle, 'Status', 'Paid till Jun 2026'),
        ])),
      ],
    );
  }
}

