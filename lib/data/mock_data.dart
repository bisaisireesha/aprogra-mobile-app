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
      'cardBg': Colors.white,
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

  // ─── Student Insights Data ──────────────────────────────────────────────────

  static const studentInsightsKpi = [
    {
      'title': 'Total Students',
      'value': '770',
      'subtitle': 'Active in 60 classes',
      'icon': Icons.people_outline,
      'colorType': 'purple',
    },
    {
      'title': 'Pre-Primary',
      'value': '167',
      'subtitle': '10 classes',
      'icon': Icons.school_outlined,
      'colorType': 'yellow',
    },
    {
      'title': 'Primary',
      'value': '265',
      'subtitle': '15 classes',
      'icon': Icons.school_outlined,
      'colorType': 'blue',
    },
    {
      'title': 'Secondary',
      'value': '338',
      'subtitle': '25 classes',
      'icon': Icons.arrow_outward_rounded,
      'colorType': 'grey',
    },
  ];

  static const studentInsightsClasses = [
    {
      'name': 'Nursery',
      'sections': '2 Sections',
      'teacher': 'Meera Joshi',
      'students': '49 / 60',
      'progress': 49 / 60,
    },
    {
      'name': 'LKG',
      'sections': '2 Sections',
      'teacher': 'Pooja Rao',
      'students': '50 / 60',
      'progress': 50 / 60,
    },
    {
      'name': 'UKG',
      'sections': '3 Sections',
      'teacher': 'Anita Sharma',
      'students': '68 / 90',
      'progress': 68 / 90,
    },
  ];

  static const studentInsightsClassesPrimary = [
    {
      'name': 'Class 1',
      'sections': '3 Sections',
      'teacher': 'Sneha Patil',
      'students': '85 / 90',
      'progress': 85 / 90,
    },
    {
      'name': 'Class 2',
      'sections': '3 Sections',
      'teacher': 'Ravi Kumar',
      'students': '70 / 90',
      'progress': 70 / 90,
    },
    {
      'name': 'Class 3',
      'sections': '4 Sections',
      'teacher': 'Kavya Singh',
      'students': '110 / 120',
      'progress': 110 / 120,
    },
    {
      'name': 'Class 4',
      'sections': '2 Sections',
      'teacher': 'Manoj Das',
      'students': '55 / 60',
      'progress': 55 / 60,
    },
    {
      'name': 'Class 5',
      'sections': '3 Sections',
      'teacher': 'Sunita Verma',
      'students': '80 / 90',
      'progress': 80 / 90,
    },
  ];

  static const studentInsightsClassesSecondary = [
    {
      'name': 'Class 6',
      'sections': '4 Sections',
      'teacher': 'Arjun Nair',
      'students': '115 / 120',
      'progress': 115 / 120,
    },
    {
      'name': 'Class 7',
      'sections': '3 Sections',
      'teacher': 'Vikram Sethi',
      'students': '88 / 90',
      'progress': 88 / 90,
    },
    {
      'name': 'Class 8',
      'sections': '4 Sections',
      'teacher': 'Priya Das',
      'students': '112 / 120',
      'progress': 112 / 120,
    },
    {
      'name': 'Class 9',
      'sections': '5 Sections',
      'teacher': 'Rahul Khanna',
      'students': '140 / 150',
      'progress': 140 / 150,
    },
    {
      'name': 'Class 10',
      'sections': '5 Sections',
      'teacher': 'Sonia Desai',
      'students': '145 / 150',
      'progress': 145 / 150,
    },
    {
      'name': 'Class 11',
      'sections': '3 Sections',
      'teacher': 'Gaurav Sen',
      'students': '80 / 90',
      'progress': 80 / 90,
    },
    {
      'name': 'Class 12',
      'sections': '3 Sections',
      'teacher': 'Anil Kapoor',
      'students': '85 / 90',
      'progress': 85 / 90,
    },
  ];

  static const studentInsightsActivity = [
    {
      'type': 'Admission',
      'desc': 'Riya Sharma',
      'subDesc': 'Class 1A',
      'time': 'Today, 10:41 AM',
      'icon': Icons.person_add_outlined,
      'color': Color(0xFF8463E9),
    },
    {
      'type': 'Transferred',
      'desc': 'Rahul Verma',
      'subDesc': 'Class 7A → 7B',
      'time': 'Yesterday',
      'icon': Icons.swap_horiz_outlined,
      'color': Color(0xFF595973),
    },
    {
      'type': 'Fee waived',
      'desc': 'Aisha Khan',
      'subDesc': 'Class 10 — 10',
      'time': '2 days ago',
      'icon': Icons.money_off_csred_outlined,
      'color': Color(0xFF595973),
    },
  ];

  static const studentInsightsAttention = [
    {
      'badge': 'Attendance',
      'badgeBg': Color(0xFFE8E0FF),
      'badgeColor': Color(0xFF8463E9),
      'cardBg': Color(0xFFF9F6FF),
      'name': 'Rahul Sharma',
      'desc': 'Class 5A — 70% Attendance',
    },
    {
      'badge': 'Academics',
      'badgeBg': Color(0xFFFFF7E6),
      'badgeColor': Color(0xFFD97706),
      'cardBg': Color(0xFFFFFCF5),
      'name': 'Aarav Singh',
      'desc': 'Class 6B — Failed Mid-Term Exams',
    },
    {
      'badge': 'Discipline',
      'badgeBg': Color(0xFFFFF1F1),
      'badgeColor': Colors.redAccent,
      'cardBg': Color(0xFFFFF6F6),
      'name': 'Ishan Roy',
      'desc': 'Class 9A — 3 incidents this week',
    },
  ];

  static const studentInsightsEnrollment = [
    {
      'level': 'PRE-PRIMARY',
      'total': '150',
      'classes': '12',
      'staff': '28',
      'color': Color(0xFF8463E9),
    },
    {
      'level': 'PRIMARY',
      'total': '540',
      'classes': '15',
      'staff': '55',
      'color': Color(0xFF8463E9),
    },
    {
      'level': 'SECONDARY',
      'total': '350',
      'classes': '10',
      'staff': '42',
      'color': Color(0xFF8463E9),
    },
  ];

  static const studentInsightsAdmissions = [
    {
      'name': 'Riya Sharma',
      'desc': 'Class 1A • Aditi Sharma',
      'status': 'Complete',
      'statusColor': Color(0xFF8463E9),
      'statusBg': Colors.white,
      'avatar': 'https://ui-avatars.com/api/?name=Riya+Sharma&background=EBE6FF&color=6C5CE7',
    },
    {
      'name': 'Kabir Nair',
      'desc': 'Class PreK • Ananya Nair',
      'status': 'On-hold',
      'statusColor': Color(0xFF595973),
      'statusBg': Colors.white,
      'avatar': 'https://ui-avatars.com/api/?name=Kabir+Nair&background=F3F0FF&color=6C5CE7',
    },
    {
      'name': 'Sara Ali',
      'desc': 'Class 2A • Imran Ali',
      'status': 'Pending Docs',
      'statusColor': Color(0xFF595973),
      'statusBg': Colors.white,
      'avatar': 'https://ui-avatars.com/api/?name=Sara+Ali&background=EBE6FF&color=6C5CE7',
    },
  ];

  static const studentInsightsCapacityHighest = [
    {'class': 'Class 10A', 'ratio': '55/50', 'isOver': true},
    {'class': 'Class 6B', 'ratio': '48/50', 'isOver': true},
  ];

  static const studentInsightsCapacityUnder = [
    {'class': 'LKG C', 'desc': '15 seats open'},
    {'class': 'LKG A', 'desc': '7 seats open'},
  ];

  static const studentInsightsHealth = [
    {
      'title': 'Emergency Contact Missing',
      'desc': 'Ayaan Patel • Class 1A',
      'icon': Icons.error_outline_rounded,
      'iconColor': Colors.redAccent,
    },
    {
      'title': 'Medical Alert',
      'desc': 'Tanya Roy • Class 4B • Asthma',
      'icon': Icons.medical_services_outlined,
      'iconColor': Color(0xFF181821),
    },
    {
      'title': 'Pickup Authorization',
      'desc': 'Zoya Khan • Class 2A • Unverified',
      'icon': Icons.person_outline,
      'iconColor': Color(0xFF181821),
    },
  ];

  static const studentInsightsHighlights = [
    {
      'text': '8 new admissions this week',
      'icon': Icons.people_outline,
      'iconColor': Color(0xFF181821),
    },
    {
      'text': 'Class 4A reached full capacity',
      'icon': Icons.error_outline_rounded,
      'iconColor': Color(0xFF181821),
    },
    {
      'text': '95% student attendance today',
      'icon': Icons.calendar_today_outlined,
      'iconColor': Color(0xFF6C5CE7),
    },
  ];
  static const classDetailsOverview = {
    'present': 43,
    'absent': 6,
    'capacity': 60,
    'capacityUsed': 49,
    'teachers': [
      {
        'name': 'Meera Joshi',
        'students': 25,
        'section': 'NURSERY A',
        'avatar': 'https://ui-avatars.com/api/?name=Meera+Joshi&background=EBE6FF&color=6C5CE7',
      },
      {
        'name': 'Riya Kapoor',
        'students': 24,
        'section': 'NURSERY B',
        'avatar': 'https://ui-avatars.com/api/?name=Riya+Kapoor&background=F3F0FF&color=6C5CE7',
      },
    ]
  };

  static const classTimetable = [
    {
      'period': 'P1',
      'subject': 'Music & Rhymes',
      'time': '08:00 - 08:45',
    },
    {
      'period': 'P2',
      'subject': 'Interactive Play',
      'time': '08:45 - 09:30',
    },
    {
      'period': 'P3',
      'subject': 'Story Time',
      'time': '09:30 - 10:15',
    },
    {
      'period': 'P4',
      'subject': 'Snack Break',
      'time': '10:15 - 11:00',
    },
    {
      'period': 'P5',
      'subject': 'Art & Craft',
      'time': '11:00 - 11:45',
    },
  ];

  static const classStudentsList = [
    {'name': 'Aarav Sharma', 'gender': 'BOY', 'status': 'LOW ATTD.', 'avatar': 'https://ui-avatars.com/api/?name=Aarav+Sharma&background=EBE6FF&color=6C5CE7'},
    {'name': 'Ayaan Nair', 'gender': 'BOY', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Ayaan+Nair&background=F3F0FF&color=6C5CE7'},
    {'name': 'Pari Joshi', 'gender': 'GIRL', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Pari+Joshi&background=EBE6FF&color=6C5CE7'},
    {'name': 'Vivaan Gupta', 'gender': 'BOY', 'status': 'LOW ATTD.', 'avatar': 'https://ui-avatars.com/api/?name=Vivaan+Gupta&background=F3F0FF&color=6C5CE7'},
    {'name': 'Krishna Iyer', 'gender': 'BOY', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Krishna+Iyer&background=EBE6FF&color=6C5CE7'},
    {'name': 'Anika Kapoor', 'gender': 'GIRL', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Anika+Kapoor&background=F3F0FF&color=6C5CE7'},
    {'name': 'Aditya Menon', 'gender': 'BOY', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Aditya+Menon&background=EBE6FF&color=6C5CE7'},
    {'name': 'Ishaan Verma', 'gender': 'BOY', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Ishaan+Verma&background=F3F0FF&color=6C5CE7'},
    {'name': 'Navya Reddy', 'gender': 'GIRL', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Navya+Reddy&background=EBE6FF&color=6C5CE7'},
    {'name': 'Vihaan Bhat', 'gender': 'BOY', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Vihaan+Bhat&background=F3F0FF&color=6C5CE7'},
    {'name': 'Buddala Harsha Kumar', 'gender': 'BOY', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Buddala+Harsha+Kumar&background=EBE6FF&color=6C5CE7', 'section': 'NURSERY A'},
    {'name': 'Thungunta Ram Rathan Reddy', 'gender': 'BOY', 'status': 'ACTIVE', 'avatar': 'https://ui-avatars.com/api/?name=Thungunta+Ram+Rathan+Reddy&background=F3F0FF&color=6C5CE7', 'section': 'NURSERY A'},
  ];
}
