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
      'icon': Icons.person_off_outlined,
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
    'chartPoints': [0.7, 0.4, 0.9, 0.8, 0.2], 
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
      'icon': Icons.info_outline,
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
}
