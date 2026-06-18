import 'package:flutter/material.dart';

class MockData {
  static const kpiData = {
    'students': '1,284',
    'studentsTrend': '12',
    'studentsProgress': 0.65,
    'staff': '94',
    'staffTrend': '3',
    'staffProgress': 0.8,
    'attendance': '91.4%',
    'attendanceTrend': '2.6%',
    'fees': '₹8.2L',
    'feesBadge': '-0.4L',
  };

  static const actionRequired = [
    {
      'type': 'URGENT',
      'title': 'Student Attendance',
      'value': '111 absent',
      'subtitle': '5 classes below 80%',
      'action': 'Review →',
      'colorType': 'red',
      'icon': Icons.cancel_outlined,
    },
    {
      'type': 'ATTENTION',
      'title': 'Staff Availability',
      'value': '5 absent',
      'subtitle': '2 requests pending',
      'action': 'View →',
      'colorType': 'purple',
      'icon': Icons.schedule_outlined,
    },
    {
      'type': 'REVIEW',
      'title': 'Fee Defaulters',
      'value': '₹1.2L pending',
      'subtitle': 'from 42 students',
      'action': 'Remind →',
      'colorType': 'blue',
      'icon': Icons.receipt_long_outlined,
    },
    {
      'type': 'NOTICE',
      'title': 'Exam Prep',
      'value': 'Syllabus lagging',
      'subtitle': 'Class 10 Science',
      'action': 'Details →',
      'colorType': 'grey',
      'icon': Icons.library_books_outlined,
    },
  ];

  static const attendanceInsights = {
    'percentage': '90.6%',
    'trend': '+2.6%',
    'subtitle': 'Last 7 days · School-wide',
    'topPerforming': [
      {'class': 'Class 10', 'value': '96%'},
      {'class': 'Class 9', 'value': '93%'},
    ],
    'belowThreshold': [
      {'class': 'Class 5', 'value': '79%'},
      {'class': 'Class 4', 'value': '76%'},
    ],
    // Dummy values for 5 days: Tue, Wed, Thu, Fri, Sat
    // We will normalize these to draw the curve: 0.0 to 1.0
    'chartPoints': [0.55, 0.35, 0.85, 0.65, 0.15], 
  };

  static const financialInsights = {
    'total': '₹8.23L',
    'trend': '+18.6%',
    'subtitle': 'Fee collection · 6 months',
    'outstanding': '₹1.24L',
    'thisMonth': '₹1.98L',
    'recovery': '82%',
    // Dummy values for Dec to Apr (5 bars)
    'chartValues': [0.4, 0.6, 0.7, 0.9, 0.75, 0.85], // wait, screenshot shows Dec, Jan, Feb, Mar, Apr
  };

  static const upcomingEvents = [
    {
      'date': 'TODAY',
      'time': '11:00\nAM',
      'title': 'Staff briefing',
      'location': 'Conference room',
    },
    {
      'date': 'TMRW',
      'time': '02:30\nPM',
      'title': 'Class 10 mock review',
      'location': 'Auditorium',
    },
    {
      'date': 'TMRW',
      'time': '10:00\nAM',
      'title': 'Parent-Teacher Meeting',
      'location': 'Classes 6-10',
    },
  ];

  static const aiInsights = [
    {
      'type': 'FORECAST',
      'icon': Icons.error_outline_rounded,
      'description': 'Fee collection may miss this month\'s target by ₹45,000 at current recovery rate.',
      'action': 'Plan recovery →',
    },
    {
      'type': 'OPPORTUNITY',
      'icon': Icons.trending_up,
      'description': 'Admissions are 18% ahead of last year — momentum strongest in Class 1 and Class 6.',
      'action': 'Explore funnel →',
    },
  ];

  static const quickActions = [
    {'icon': Icons.person_add_alt, 'label': 'Admit'},
    {'icon': Icons.credit_card, 'label': 'Collect'},
    {'icon': Icons.check_circle_outline, 'label': 'Attend'},
    {'icon': Icons.campaign_outlined, 'label': 'Notice'},
    {'icon': Icons.calendar_today_outlined, 'label': 'Event'},
    {'icon': Icons.description_outlined, 'label': 'Report'},
    {'icon': Icons.groups_outlined, 'label': 'Staff'},
    {'icon': Icons.add, 'label': 'More'},
  ];

  static const activityFeedKpi = [
    {
      'title': 'Activities Today',
      'value': '1,284',
      'subtitle': '',
      'trend': '+18%',
      'icon': Icons.show_chart, // Using a similar looking icon since exact wave is custom
      'iconBg': Color(0xFFF3F0FF),
      'iconColor': Color(0xFF8463E9),
    },
    {
      'title': 'Active Users',
      'value': '142',
      'subtitle': 'Staff & admin online',
      'trend': '',
      'icon': Icons.people_outline,
      'iconBg': Color(0xFFF9F9FB),
      'iconColor': Color(0xFF595973),
    },
    {
      'title': 'New Admissions',
      'value': '9',
      'subtitle': '3 awaiting confirmation',
      'trend': '',
      'icon': Icons.person_add_outlined,
      'iconBg': Color(0xFFF9F9FB),
      'iconColor': Color(0xFF595973),
    },
    {
      'title': 'Transactions Processed',
      'value': '₹6.4L',
      'subtitle': '127 receipts generated',
      'trend': '',
      'icon': Icons.credit_card,
      'iconBg': Color(0xFFF9F9FB),
      'iconColor': Color(0xFF595973),
    },
  ];

  static final activityHighlights = [
    {
      'title': 'Admissions',
      'value': '112 events today',
      'icon': Icons.trending_up,
      'iconColor': Color(0xFF8463E9),
      'iconBg': Color(0xFFF3F0FF),
      'cardBg': Color(0xFFF9F6FF),
    },
    {
      'title': 'Finance',
      'value': '₹1.8L collected',
      'icon': Icons.account_balance_wallet_outlined,
      'iconColor': Color(0xFF595973),
      'iconBg': Color(0xFFF4F4F6),
      'cardBg': Color(0xFFF9F9FB),
    },
    {
      'title': 'Academics',
      'value': '100% Attendance',
      'icon': Icons.check_circle_outline_rounded,
      'iconColor': Colors.green,
      'iconBg': Colors.green.withValues(alpha: 0.1),
      'cardBg': Color(0xFFF0FAF4),
    },
    {
      'title': 'Transport',
      'value': 'All routes active',
      'icon': Icons.directions_bus_outlined,
      'iconColor': Colors.redAccent,
      'iconBg': Colors.redAccent.withValues(alpha: 0.1),
      'cardBg': Color(0xFFFFF1F1),
    },
  ];

  static final activityEvents = [
    {
      'groupTime': '11:00 AM',
      'groupCount': '3 events',
      'events': [
        {
          'init': 'FO',
          'initColor': Colors.redAccent,
          'title': 'Front Office',
          'subtitle': 'Reception',
          'time': '11:42 AM',
          'badge': 'SECURITY',
          'badgeColor': Colors.redAccent,
          'main': 'Visitor checked in at Main Gate',
          'detail1Label': 'Visitor:',
          'detail1Value': 'R. Mehra',
          'detail2Label': 'Purpose:',
          'detail2Value': 'Parent meeting — 7B',
          'action': 'View pass v',
        },
        {
          'init': 'AI',
          'initColor': Colors.redAccent,
          'title': 'AI Camera 02',
          'subtitle': 'Face Recognition',
          'time': '11:38 AM',
          'badge': 'SECURITY',
          'badgeColor': Colors.redAccent,
          'main': 'Face recognition alert triggered',
          'detail1Label': 'Location:',
          'detail1Value': 'Block C corridor',
          'detail2Label': 'Match:',
          'detail2Value': 'Unknown — flagged',
          'action': 'Review footage v',
        },
        {
          'init': 'AD',
          'initColor': Color(0xFF8463E9),
          'title': 'Accounts Desk',
          'subtitle': 'Finance',
          'time': '11:30 AM',
          'badge': 'FINANCE',
          'badgeColor': Color(0xFF8463E9),
          'main': 'Highest fee collection of the day recorded',
          'detail1Label': 'Amount:',
          'detail1Value': '₹1.8L',
          'detail2Label': 'Receipts:',
          'detail2Value': '42',
          'action': 'Open ledger v',
        },
      ]
    },
    {
      'groupTime': '10:00 AM',
      'groupCount': '2 events',
      'events': [
        {
          'init': 'TC',
          'initColor': Color(0xFF595973),
          'title': 'Transport Cell',
          'subtitle': 'Operations',
          'time': '10:54 AM',
          'badge': 'TRANSPORT',
          'badgeColor': Color(0xFF595973),
          'main': 'Vehicle maintenance logged',
          'detail1Label': 'Bus:',
          'detail1Value': 'DL-8472',
          'detail2Label': 'Type:',
          'detail2Value': 'Brake servicing',
          'action': 'Service log v',
        },
        {
          'init': 'LB',
          'initColor': Color(0xFF595973),
          'title': 'Library Desk',
          'subtitle': 'Library',
          'time': '10:41 AM',
          'badge': 'LIBRARY',
          'badgeColor': Color(0xFF595973),
          'main': 'Book issued',
          'detail1Label': 'Title:',
          'detail1Value': 'Wings of Fire',
          'detail2Label': 'To:',
          'detail2Value': 'Ananya S. — 9A',
          'action': '',
        },
      ]
    }
  ];

  static final actionCenterKpi = [
    {
      'title': 'Critical\nIssues',
      'value': '7',
      'subtitle': '+2 since morning',
      'subtitleColor': Colors.redAccent,
      'icon': Icons.error_outline_rounded,
      'iconBg': const Color(0xFFFFF1F1),
      'iconColor': Colors.redAccent,
    },
    {
      'title': 'Pending\nApprovals',
      'value': '23',
      'subtitle': '8 due today',
      'subtitleColor': const Color(0xFF595973),
      'icon': Icons.access_time_rounded,
      'iconBg': const Color(0xFFF9F9FB),
      'iconColor': const Color(0xFF595973),
    },
    {
      'title': 'Overdue\nTasks',
      'value': '14',
      'subtitle': '3 escalated',
      'subtitleColor': const Color(0xFF595973),
      'icon': Icons.cancel_outlined,
      'iconBg': const Color(0xFFF9F9FB),
      'iconColor': const Color(0xFF595973),
    },
    {
      'title': 'Resolved\nToday',
      'value': '41',
      'subtitle': '+12 vs yesterday',
      'subtitleColor': Colors.green,
      'icon': Icons.check_circle_outline_rounded,
      'iconBg': const Color(0xFFF9F9FB),
      'iconColor': const Color(0xFF595973),
    },
  ];

  static final actionCenterAlerts = [
    {
      'sectionTitle': 'Critical Alerts',
      'sectionBadge': '2',
      'sectionIcon': Icons.gpp_maybe_outlined,
      'sectionIconColor': Colors.redAccent,
      'sectionIconBg': const Color(0xFFFFF1F1),
      'items': [
        {
          'isCritical': true,
          'badge': 'CRITICAL',
          'badgeColor': Colors.redAccent,
          'category': 'SAFETY',
          'time': 'Just now',
          'title': 'Unauthorized pickup attempt — Aarav (Class 5B)',
          'subtitle': 'Reported 4 min ago • Gate 2',
          'btn1': 'View Details',
          'btn2': 'Escalate',
          'btn2Color': Colors.redAccent,
        }
      ]
    },
    {
      'sectionTitle': 'Attendance Actions',
      'sectionBadge': '4',
      'sectionIcon': Icons.person_search_outlined,
      'sectionIconColor': const Color(0xFF595973),
      'sectionIconBg': Colors.white,
      'items': [
        {
          'isCritical': false,
          'badge': 'HIGH',
          'badgeColor': Colors.redAccent,
          'category': 'ATTENDANCE',
          'time': '1h ago',
          'title': 'Severe attendance drop in Grade 8 — 32% absent',
          'subtitle': 'Detected 1 hr ago. Class 8B, 8A most affected.',
          'btn1': 'Notify',
          'btn2': 'Resolve',
          'btn2Color': Colors.redAccent,
        }
      ]
    },
    {
      'sectionTitle': 'Financial Actions',
      'sectionBadge': '4',
      'sectionIcon': Icons.currency_rupee_rounded,
      'sectionIconColor': const Color(0xFF595973),
      'sectionIconBg': Colors.white,
      'items': [
        {
          'isCritical': false,
          'badge': 'HIGH',
          'badgeColor': Colors.redAccent,
          'category': 'FINANCE',
          'time': '1d ago',
          'title': 'Fee defaulters — Term 2',
          'subtitle': '₹4.8L outstanding • 38 students. Due Nov 30.',
          'btn1': 'Review',
          'btn2': 'Remind All',
          'btn2Color': Colors.redAccent,
        }
      ]
    },
    {
      'sectionTitle': 'Academic Actions',
      'sectionBadge': '4',
      'sectionIcon': Icons.school_outlined,
      'sectionIconColor': const Color(0xFF595973),
      'sectionIconBg': Colors.white,
      'items': [
        {
          'isCritical': false,
          'badge': 'MEDIUM',
          'badgeColor': const Color(0xFF595973),
          'category': 'ACADEMICS',
          'time': '3h ago',
          'title': 'Marks not submitted — Mid Term',
          'subtitle': '5 subjects pending • Grades 6-10 • Math, Science, Hindi',
          'btn1': 'View',
          'btn2': 'Remind Teacher',
          'btn2Color': const Color(0xFF8463E9),
        }
      ]
    }
  ];

  static final actionCenterRecommendations = [
    {
      'title': 'Attendance in Grade 8 has declined for 5 consecutive days',
      'subtitle': 'Recommend scheduling a class review with grade coordinator.',
      'btn': 'Apply Suggestion',
    },
    {
      'title': 'Fee collection may miss monthly target by ₹50,000',
      'subtitle': 'Recommend contacting top 20 defaulters this week.',
      'btn': 'Apply Suggestion',
    }
  ];
}
