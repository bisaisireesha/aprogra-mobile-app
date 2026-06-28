import 'package:lucide_icons_flutter/lucide_icons.dart';

class AssignmentsMockData {
  static final List<Map<String, dynamic>> assignmentItems = [
    // Pre-Primary
    {
      'title': 'Draw and color your family',
      'class': 'LKG A',
      'teacher': 'Anjali Sharma',
      'windowStart': 'Jun 27',
      'windowEnd': 'Jul 04',
      'submitted': 8,
      'total': 20,
      'icon': LucideIcons.palette,
      'category': 'Pre-Primary',
    },
    {
      'title': 'Paste 5 fruit pictures',
      'class': 'Nursery B',
      'teacher': 'Priya Nair',
      'windowStart': 'Jun 28',
      'windowEnd': 'Jul 05',
      'submitted': 6,
      'total': 18,
      'icon': LucideIcons.scissors,
      'category': 'Pre-Primary',
    },

    // Primary
    {
      'title': 'Summer holiday science project',
      'class': 'Class 1A',
      'teacher': 'Sneha Das',
      'windowStart': 'Jun 27',
      'windowEnd': 'Jul 04',
      'submitted': 4,
      'total': 8,
      'icon': LucideIcons.clipboardList,
      'category': 'Primary',
    },
    {
      'title': 'Weekly book review',
      'class': 'Class 3A',
      'teacher': 'Kavita Menon',
      'windowStart': 'Jun 28',
      'windowEnd': 'Jul 07',
      'submitted': 4,
      'total': 8,
      'icon': LucideIcons.clipboardList,
      'category': 'Primary',
    },
    {
      'title': 'Geography map activity',
      'class': 'Class 5A',
      'teacher': 'Vikram Singh',
      'windowStart': 'Jun 29',
      'windowEnd': 'Jul 10',
      'submitted': 4,
      'total': 8,
      'icon': LucideIcons.clipboardList,
      'category': 'Primary',
    },

    // Secondary
    {
      'title': 'Physics lab report — Chapter 3',
      'class': 'Class 9B',
      'teacher': 'Dr. S. K. Rao',
      'windowStart': 'Jun 30',
      'windowEnd': 'Jul 12',
      'submitted': 12,
      'total': 30,
      'icon': LucideIcons.microscope,
      'category': 'Secondary',
    },
  ];
}
