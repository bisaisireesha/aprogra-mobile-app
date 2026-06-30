import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddFeeHeadModal extends StatefulWidget {
  const AddFeeHeadModal({super.key});

  @override
  State<AddFeeHeadModal> createState() => _AddFeeHeadModalState();
}

class _AddFeeHeadModalState extends State<AddFeeHeadModal> {

  final _dark = const Color(0xFF181821);
  final _muted = const Color(0xFF595973);
  final _primary = const Color(0xFF6366F1);
  final _border = const Color(0xFFE5E7EB);

  String _applicableTo = 'All Classes';
  final String _status = 'Active';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Fee Head', style: GoogleFonts.figtree(fontSize: 20, fontWeight: FontWeight.bold, color: _dark)),
                    const SizedBox(height: 4),
                    Text('Create a new fee head to use across classes', style: GoogleFonts.figtree(fontSize: 14, color: _muted)),
                    const SizedBox(height: 24),

                    _buildTextField('Fee Head Name', 'e.g. Tuition Fee'),
                    const SizedBox(height: 20),

                    _buildDescriptionField(),
                    const SizedBox(height: 20),

                    _buildApplicableTo(),
                    const SizedBox(height: 20),

                    _buildDropdown('Type', 'Select type'),
                    const SizedBox(height: 20),

                    _buildDropdown('Status', _status, isStatus: true),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: _primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color(0xFFF5F3FF),
                      ),
                      child: Text('Cancel', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: _primary)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fee Head Added Successfully', style: GoogleFonts.figtree())),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Save Fee Head', style: GoogleFonts.figtree(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: TextField(
            style: GoogleFonts.figtree(fontSize: 15, color: _dark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.figtree(fontSize: 15, color: _muted.withValues(alpha: 0.6)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description (Optional)', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
        const SizedBox(height: 8),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: Stack(
            children: [
              TextField(
                maxLines: null,
                style: GoogleFonts.figtree(fontSize: 15, color: _dark),
                decoration: InputDecoration(
                  hintText: 'e.g. Term wise tuition fee',
                  hintStyle: GoogleFonts.figtree(fontSize: 15, color: _muted.withValues(alpha: 0.6)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 16,
                child: Text('0/150', style: GoogleFonts.figtree(fontSize: 12, color: _muted)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplicableTo() {
    final options = [
      {'label': 'All Classes', 'icon': LucideIcons.users},
      {'label': 'Selected Classes', 'icon': LucideIcons.graduationCap},
      {'label': 'Custom', 'icon': LucideIcons.settings},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Applicable To', style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
        const SizedBox(height: 8),
        Row(
          children: options.map((opt) {
            final isSelected = _applicableTo == opt['label'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _applicableTo = opt['label'] as String),
                child: Container(
                  margin: EdgeInsets.only(right: opt != options.last ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF3E8FF) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? _primary : _border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(opt['icon'] as IconData, size: 14, color: isSelected ? _primary : _muted),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          opt['label'] as String,
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? _primary : _muted,
                          ),
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildDropdown(String label, String value, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.figtree(fontSize: 13, color: _muted)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: GoogleFonts.figtree(fontSize: 15, color: isStatus ? _dark : _muted.withValues(alpha: 0.6))),
              const Icon(LucideIcons.chevronDown, size: 18, color: Color(0xFF595973)),
            ],
          ),
        ),
      ],
    );
  }
}
