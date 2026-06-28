import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UploadResourceDialog extends StatefulWidget {
  const UploadResourceDialog({super.key});

  @override
  State<UploadResourceDialog> createState() => _UploadResourceDialogState();
}

class _UploadResourceDialogState extends State<UploadResourceDialog> {
  final _titleController = TextEditingController();
  final _teacherController = TextEditingController();
  String _selectedCategory = 'Notes';
  String _selectedType = 'PDF';

  void _upload() {
    if (_titleController.text.trim().isEmpty) return;

    Color color;
    Color bgColor;
    if (_selectedType == 'PDF') {
      color = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEE2E2);
    } else if (_selectedType == 'DOC') {
      color = const Color(0xFF3B82F6);
      bgColor = const Color(0xFFDBEAFE);
    } else if (_selectedType == 'Video') {
      color = const Color(0xFF8B5CF6);
      bgColor = const Color(0xFFEDE9FE);
    } else {
      color = const Color(0xFF10B981);
      bgColor = const Color(0xFFD1FAE5);
    }

    final newResource = {
      'title': _titleController.text.trim(),
      'type': _selectedCategory,
      'size': '0.0 MB', // Dummy size for newly uploaded
      'author': _teacherController.text.trim().isNotEmpty ? _teacherController.text.trim() : 'Unknown Teacher',
      'date': DateTime.now().toString().split(' ')[0],
      'fileType': _selectedType,
      'color': color,
      'bgColor': bgColor,
    };

    Navigator.pop(context, newResource);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upload Resource', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: Color(0xFF8F96A3)),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              
              // Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Title'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Chapter 3 — Notes',
                        hintStyle: GoogleFonts.figtree(color: const Color(0xFF8F96A3), fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF8463E9))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildLabel('Teacher Name'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _teacherController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Mrs. Iyer',
                        hintStyle: GoogleFonts.figtree(color: const Color(0xFF8F96A3), fontSize: 14),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF8463E9))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Category'),
                              const SizedBox(height: 8),
                              _buildDropdown(_selectedCategory, ['Notes', 'Question Bank', 'Worksheets', 'Assignments', 'Practice Papers'], (v) => setState(() => _selectedCategory = v!)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Type'),
                              const SizedBox(height: 8),
                              _buildDropdown(_selectedType, ['PDF', 'DOC', 'Video', 'Link'], (v) => setState(() => _selectedType = v!)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Drag and Drop Area
                    CustomPaint(
                      painter: DashedBorderPainter(color: const Color(0xFFD1D5DB), radius: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Icon(LucideIcons.filePlus, size: 28, color: Color(0xFF8F96A3)),
                            const SizedBox(height: 12),
                            Text('Drag & drop a file', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
                            const SizedBox(height: 4),
                            Text('or click to browse — PDF, DOC, MP4 up to 50 MB', style: GoogleFonts.figtree(fontSize: 12, color: const Color(0xFF8F96A3))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1, color: Color(0xFFE5E7EB)),
              
              // Footer
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      child: Text('Cancel', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF181B20))),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _upload,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8463E9),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: Text('Upload', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.figtree(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF595973)));
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF181B20)),
          style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF181B20)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  DashedBorderPainter({this.color = Colors.black, this.strokeWidth = 1.0, this.radius = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius));
    
    // A simple dashed path logic 
    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();

    double dashWidth = 6.0;
    double dashSpace = 4.0;
    double distance = 0.0;
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
      distance = 0.0;
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
