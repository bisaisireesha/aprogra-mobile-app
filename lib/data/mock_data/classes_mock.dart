import 'package:flutter/material.dart';

class ClassesMockData {
  static const List<Map<String, dynamic>> classesKPIs = [
    {
      'title': 'Total Classes',
      'value': '33',
      'subtitle': 'across 3 levels',
      'icon': Icons.school_outlined,
      'color': Color(0xFF38Bdf8), // Light Blue
      'bgColor': Color(0xFFE0F2FE),
    },
    {
      'title': 'Total Sections',
      'value': '78',
      'subtitle': '2-3 per class',
      'icon': Icons.people_outline,
      'color': Color(0xFF4ADE80), // Light Green
      'bgColor': Color(0xFFDCFCE7),
    },
    {
      'title': 'Sections Near Full',
      'value': '9',
      'subtitle': '>90% capacity',
      'icon': Icons.warning_amber_rounded,
      'color': Color(0xFFFBBF24), // Light Orange/Yellow
      'bgColor': Color(0xFFFEF3C7),
    },
    {
      'title': 'Classes Needing Action',
      'value': '5',
      'subtitle': 'open items',
      'icon': Icons.error_outline,
      'color': Color(0xFFF87171), // Light Red
      'bgColor': Color(0xFFFEE2E2),
    },
  ];

  static const List<Map<String, dynamic>> recentClassActivity = [
    {
      'action': 'Section Added',
      'class': 'Class 4C',
      'details': 'Created by Principal',
      'time': 'Today, 10:24 AM',
      'icon': Icons.person_add_alt_1,
      'color': Color(0xFF4ADE80),
      'bgColor': Color(0xFFDCFCE7),
    },
    {
      'action': 'Teacher Reassigned',
      'class': 'Class 7B',
      'details': 'Mrs. Mehra → Mr. Khan',
      'time': 'Yesterday',
      'icon': Icons.swap_horiz,
      'color': Color(0xFF38BDF8),
      'bgColor': Color(0xFFE0F2FE),
    },
    {
      'action': 'Capacity Updated',
      'class': 'Class 5A',
      'details': '40 → 45 seats',
      'time': '2 days ago',
      'icon': Icons.trending_up,
      'color': Color(0xFFFBBF24),
      'bgColor': Color(0xFFFEF3C7),
    },
    {
      'action': 'Section Merged',
      'class': 'Nursery A + B',
      'details': 'Combined for activity',
      'time': '3 days ago',
      'icon': Icons.merge_type,
      'color': Color(0xFF38BDF8),
      'bgColor': Color(0xFFE0F2FE),
    },
    {
      'action': 'Schedule Published',
      'class': 'Class 3A',
      'details': 'Term 2 timetable live',
      'time': '4 days ago',
      'icon': Icons.calendar_today,
      'color': Color(0xFF4ADE80),
      'bgColor': Color(0xFFDCFCE7),
    },
  ];

  static const List<Map<String, dynamic>> classesRequiringAttention = [
    {
      'badge': 'OVER CAPACITY',
      'badgeColor': Color(0xFFEF4444), // Red
      'badgeBg': Color(0xFFFEE2E2),
      'class': 'Class 8A',
      'level': 'Secondary',
      'details': '44 / 40 seats',
    },
    {
      'badge': 'NO CLASS TEACHER',
      'badgeColor': Color(0xFFF59E0B), // Orange
      'badgeBg': Color(0xFFFEF3C7),
      'class': 'Class 2C',
      'level': 'Primary',
      'details': 'Unassigned for 5 days',
    },
    {
      'badge': 'TIMETABLE MISSING',
      'badgeColor': Color(0xFFEF4444),
      'badgeBg': Color(0xFFFEE2E2),
      'class': 'Class 6B',
      'level': 'Secondary',
      'details': 'Term 2 not published',
    },
    {
      'badge': 'LOW ATTENDANCE',
      'badgeColor': Color(0xFFF59E0B),
      'badgeBg': Color(0xFFFEF3C7),
      'class': 'Class 4A',
      'level': 'Primary',
      'details': 'Avg. 78% this week',
    },
    {
      'badge': 'SYLLABUS BEHIND',
      'badgeColor': Color(0xFFEF4444),
      'badgeBg': Color(0xFFFEE2E2),
      'class': 'Class 9A',
      'level': 'Secondary',
      'details': '2 chapters delayed',
    },
    {
      'badge': 'ROOM CONFLICT',
      'badgeColor': Color(0xFFF59E0B),
      'badgeBg': Color(0xFFFEF3C7),
      'class': 'Class 1B',
      'level': 'Primary',
      'details': 'Shared with art club',
    },
  ];

  static const classDistribution = [
    {
      'level': 'PRE-PRIMARY',
      'sections': '6',
      'classes': '3',
      'seats': '30',
      'icon': Icons.school_outlined,
    },
    {
      'level': 'PRIMARY',
      'sections': '15',
      'classes': '5',
      'seats': '58',
      'icon': Icons.school_outlined,
    },
    {
      'level': 'SECONDARY',
      'sections': '12',
      'classes': '7',
      'seats': '21',
      'icon': Icons.arrow_outward_rounded,
    },
  ];

  static const recentlyUpdatedClasses = [
    {
      'avatarText': 'C3',
      'avatarColor': Color(0xFFEBE6FF),
      'avatarTextColor': Color(0xFF8463E9),
      'title': 'Class 3A',
      'subtitle': 'Primary · Ms. Rao (Teacher)',
      'time': 'Today',
      'status': 'Active',
      'statusColor': Colors.green,
      'statusBg': Color(0xFFE8F5E9),
    },
    {
      'avatarText': 'NB',
      'avatarColor': Color(0xFFEBE6FF),
      'avatarTextColor': Color(0xFF8463E9),
      'title': 'Nursery B',
      'subtitle': 'Pre-Primary · Ms. Iyer (Teacher)',
      'time': '3 days ago',
      'status': 'Active',
      'statusColor': Colors.green,
      'statusBg': Color(0xFFE8F5E9),
    },
    {
      'avatarText': 'C2',
      'avatarColor': Color(0xFFF3F0FF),
      'avatarTextColor': Color(0xFF8463E9),
      'title': 'Class 2C',
      'subtitle': 'Primary · Unassigned',
      'time': '1 week ago',
      'status': 'Pending Setup',
      'statusColor': Color(0xFFD97706),
      'statusBg': Color(0xFFFFF7E6),
    },
    {
      'avatarText': 'C5',
      'avatarColor': Color(0xFFF3F0FF),
      'avatarTextColor': Color(0xFF8463E9),
      'title': 'Class 5A',
      'subtitle': 'Primary · Mr. Gupta (Teacher)',
      'time': '1 week ago',
      'status': 'Active',
      'statusColor': Colors.green,
      'statusBg': Color(0xFFE8F5E9),
    },
  ];

  static const classComposition = {
    'boys': '137',
    'girls': '128',
    'total': '265',
    'sections': '8',
  };

  static const classCapacityMonitor = {
    'highestEnrollment': [
      {'class': 'Class 10A', 'seats': '51/50'},
      {'class': 'Class 8B', 'seats': '49/50'},
      {'class': 'Class 8A', 'seats': '48/50'},
    ],
    'availableSeats': [
      {'class': 'UKG C', 'seats': '13 seats open'},
      {'class': 'LKG B', 'seats': '7 seats open'},
      {'class': 'Nursery B', 'seats': '6 seats open'},
    ],
  };

  static const teacherCoverage = {
    'classesWithTeacher': '31 / 33',
    'unassignedClasses': '2',
    'substitutesNeeded': '4',
    'avgTeacherRating': '4.5',
  };

  static const safetyCompliance = [
    {
      'title': 'Room Safety Check Due',
      'subtitle': 'Class 1A · Primary',
      'icon': Icons.error_outline, // Will use red color in UI
      'colorType': 'red',
    },
    {
      'title': 'First-Aid Restock',
      'subtitle': 'Class 4B · Primary · Kit below minimum',
      'icon': Icons.favorite_border, // Will use orange/yellow color in UI
      'colorType': 'orange',
    },
    {
      'title': 'Fire Drill Pending',
      'subtitle': 'Class 2A · Primary · Last drill > 90 days',
      'icon': Icons.security, // Will use orange/yellow color in UI
      'colorType': 'yellow',
    },
  ];

  static const todaysHighlights = [
    {
      'desc': '3 new sections opened this week',
      'icon': Icons.person_add_outlined,
      'colorType': 'green',
    },
    {
      'desc': 'Class 4A reached full capacity',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'orange',
    },
    {
      'desc': '100% of timetables published',
      'icon': Icons.event_available,
      'colorType': 'green',
    },
    {
      'desc': 'Avg. section size up by 4%',
      'icon': Icons.trending_up,
      'colorType': 'blue',
    },
  ];
}
