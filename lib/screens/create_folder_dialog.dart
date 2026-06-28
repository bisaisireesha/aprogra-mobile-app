import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFolderDialog extends StatefulWidget {
  const CreateFolderDialog({super.key});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final _subjectController = TextEditingController();
  String _selectedLevel = 'Primary';
  String _selectedGrade = 'Grade 1';
  String _selectedStatus = 'Active';

  List<String> get _gradeOptions {
    if (_selectedLevel == 'Pre-Primary') return ['Nursery', 'LKG', 'UKG'];
    if (_selectedLevel == 'Primary') return ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'];
    return ['Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'];
  }

  void _createFolder() {
    if (_subjectController.text.trim().isEmpty) return;

    final newFolder = {
      'subject': _subjectController.text.trim(),
      'foldersCount': 0,
      'resourcesCount': 0,
      'tags': ['Notes', 'Worksheets'],
      'level': _selectedLevel,
    };

    Navigator.pop(context, newFolder);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
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
                  Text('Create Folder', style: GoogleFonts.figtree(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF181B20))),
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
                  _buildLabel('Subject name'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      hintText: 'e.g. Biology',
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
                            _buildLabel('Level'),
                            const SizedBox(height: 8),
                            _buildDropdown(_selectedLevel, ['Pre-Primary', 'Primary', 'Secondary'], (v) {
                              setState(() {
                                _selectedLevel = v!;
                                _selectedGrade = _gradeOptions.first;
                              });
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Grade'),
                            const SizedBox(height: 8),
                            _buildDropdown(_selectedGrade, _gradeOptions, (v) => setState(() => _selectedGrade = v!)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _buildLabel('Status'),
                  const SizedBox(height: 8),
                  _buildDropdown(_selectedStatus, ['Active', 'Archived', 'Draft'], (v) => setState(() => _selectedStatus = v!)),
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
                    onPressed: _createFolder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8463E9),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text('Create', style: GoogleFonts.figtree(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
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
