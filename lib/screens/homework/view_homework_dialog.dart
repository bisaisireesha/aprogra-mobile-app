import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ViewHomeworkDialog extends StatelessWidget {
  final Map<String, dynamic> item;

  const ViewHomeworkDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Generate some mock student names based on the submitted/total count
    final int submittedCount = item['submitted'] ?? 0;
    final int totalCount = item['total'] ?? 0;
    final int notSubmittedCount = totalCount - submittedCount;

    final List<Map<String, dynamic>> submittedStudents = List.generate(submittedCount, (i) => {
      'name': ['Kabir Kapoor', 'Arjun Patel', 'Nisha Verma', 'Reyansh Gupta', 'Aarav Singh', 'Vivaan Kumar', 'Aditya Sharma', 'Vihaan Das'][i % 8],
      'id': '#${(i * 12 + 13)}',
    });

    final List<Map<String, dynamic>> notSubmittedStudents = List.generate(notSubmittedCount, (i) => {
      'name': ['Diya Khan', 'Vihaan Verma', 'Saanvi Gupta', 'Rohan Nair', 'Aadhya Bhat', 'Sai Khan', 'Pari Kapoor', 'Tara Patel'][i % 8],
      'id': '#${(i * 6 + 1)}',
    });

    return Dialog(
      backgroundColor: const Color(0xFFF6F6F8), // Match the background color in the image
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Color(0xFF8F96A3), size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HOMEWORK',
                          style: GoogleFonts.figtree(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8463E9),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['title'] ?? 'Homework Details',
                          style: GoogleFonts.figtree(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF181B20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Row
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isMobile = constraints.maxWidth < 600;
                        if (isMobile) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildStatCard('CLASS', item['class'] ?? 'N/A', LucideIcons.graduationCap)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildStatCard('ASSIGNED TO', item['teacher'] ?? 'N/A', LucideIcons.user)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildStatCard('DUE', item['due'] ?? 'N/A', LucideIcons.calendarDays)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildStatCard('SUBMITTED', '${item['submitted']}/${item['total']}', LucideIcons.check)),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(child: _buildStatCard('CLASS', item['class'] ?? 'N/A', LucideIcons.graduationCap)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('ASSIGNED TO', item['teacher'] ?? 'N/A', LucideIcons.user)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('DUE', item['due'] ?? 'N/A', LucideIcons.calendarDays)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('SUBMITTED', '${item['submitted']}/${item['total']}', LucideIcons.check)),
                            ],
                          );
                        }
                      }
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Submitted Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Submitted ($submittedCount)',
                          style: GoogleFonts.figtree(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF181B20),
                          ),
                        ),
                        Text(
                          'Click to toggle',
                          style: GoogleFonts.figtree(
                            fontSize: 13,
                            color: const Color(0xFF8F96A3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildStudentGrid(submittedStudents, true),
                    
                    const SizedBox(height: 32),
                    
                    // Not Submitted Section
                    Text(
                      'Not Submitted ($notSubmittedCount)',
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF181B20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStudentGrid(notSubmittedStudents, false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF8F96A3)),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.figtree(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8F96A3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.figtree(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF181B20),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentGrid(List<Map<String, dynamic>> students, bool isSubmitted) {
    if (students.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          'No students in this category.',
          style: GoogleFonts.figtree(fontSize: 14, color: const Color(0xFF8F96A3)),
        ),
      );
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 500 ? 1 : 2;
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: crossAxisCount == 1 ? 5 : 4.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSubmitted ? const Color(0xFFF0FDF4) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isSubmitted ? const Color(0xFFBBF7D0) : const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSubmitted ? const Color(0xFF22C55E) : const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                      border: isSubmitted ? null : Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: isSubmitted 
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      student['name'],
                      style: GoogleFonts.figtree(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF181B20),
                      ),
                    ),
                  ),
                  Text(
                    student['id'],
                    style: GoogleFonts.figtree(
                      fontSize: 13,
                      color: const Color(0xFF8F96A3),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
