import 'package:flutter/material.dart';

class LibraryMockData {
  static const Map<String, dynamic> libraryStatus = {
    'status': 'Library Open - Live',
    'lastUpdated': 'Updated just now',
    'isOperatingNormally': true,
  };

  static const List<Map<String, dynamic>> kpis = [
    {
      'title': 'Total Books',
      'value': '12,450',
      'subtitle': 'Available in library',
      'icon': Icons.menu_book,
      'colorType': 'purple',
    },
    {
      'title': 'Books Issued Today',
      'value': '84',
      'subtitle': 'Books borrowed',
      'icon': Icons.my_library_books,
      'colorType': 'blue',
    },
    {
      'title': 'Pending Returns',
      'value': '132',
      'subtitle': 'Books yet to return',
      'icon': Icons.access_time_filled,
      'colorType': 'orange',
    },
    {
      'title': 'Overdue Books',
      'value': '18',
      'subtitle': 'Require follow-up',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'red',
    },
    {
      'title': 'Reserved Books',
      'value': '27',
      'subtitle': 'Awaiting collection',
      'icon': Icons.bookmark_border,
      'colorType': 'purple',
    },
    {
      'title': 'Damaged / Lost',
      'value': '3',
      'subtitle': 'Require review',
      'icon': Icons.remove_circle_outline,
      'colorType': 'orange',
    },
  ];

  static const List<Map<String, dynamic>> activityBoard = [
    {
      'title': 'Books Issued Today',
      'value': '84',
      'subtitle': 'Most active grade: Grade 7',
      'icon': Icons.my_library_books,
      'colorType': 'blue',
    },
    {
      'title': 'Books Returned Today',
      'value': '67',
      'subtitle': 'Processed successfully',
      'icon': Icons.assignment_return_outlined,
      'colorType': 'green',
    },
    {
      'title': 'New Reservations',
      'value': '12',
      'subtitle': 'Awaiting pickup',
      'icon': Icons.bookmark_border,
      'colorType': 'purple',
    },
    {
      'title': 'New Books Added',
      'value': '18',
      'subtitle': 'Catalog updated',
      'icon': Icons.library_add_outlined,
      'colorType': 'blue',
    },
  ];

  static const List<Map<String, dynamic>> availabilityBoard = [
    {
      'title': 'Harry Potter Collection',
      'author': 'J. K. Rowling · Fiction',
      'status': 'High Demand',
      'statusColor': 'red',
      'available': '2',
      'reserved': '8',
    },
    {
      'title': 'Science Encyclopedia',
      'author': 'DK Publishing · Reference',
      'status': 'Available',
      'statusColor': 'green',
      'available': '12',
      'reserved': '1',
    },
    {
      'title': 'Mathematics Reference Guide',
      'author': 'R. D. Sharma · Academics',
      'status': 'Fully Issued',
      'statusColor': 'orange',
      'available': '0',
      'reserved': '5',
    },
    {
      'title': 'The Diary of a Young Girl',
      'author': 'Anne Frank · Biography',
      'status': 'Available',
      'statusColor': 'green',
      'available': '4',
      'reserved': '2',
    },
    {
      'title': 'Wings of Fire',
      'author': 'A. P. J. Abdul Kalam · Inspiration',
      'status': 'High Demand',
      'statusColor': 'red',
      'available': '1',
      'reserved': '6',
    },
    {
      'title': 'Atlas of the World',
      'author': 'National Geographic · Reference',
      'status': 'Available',
      'statusColor': 'green',
      'available': '7',
      'reserved': '0',
    },
  ];

  static const List<Map<String, dynamic>> followUpCenter = [
    {
      'type': 'Book Overdue',
      'typeColor': 'red',
      'icon': Icons.warning_amber_rounded,
      'studentName': 'Rahul Sharma',
      'studentDetails': 'Grade 8A · 14 days late',
      'bookTitle': 'Physics Fundamentals',
      'action': 'Follow up >',
    },
    {
      'type': 'Lost Book Reported',
      'typeColor': 'orange',
      'icon': Icons.assignment_late_outlined,
      'studentName': 'Aisha Khan',
      'studentDetails': 'Grade 6B · Review required',
      'bookTitle': 'The Great Gatsby',
      'action': 'Follow up >',
    },
    {
      'type': 'Fine Pending',
      'typeColor': 'orange',
      'icon': Icons.currency_rupee,
      'studentName': 'Karan Mehta',
      'studentDetails': 'Grade 9C · ₹250 outstanding',
      'bookTitle': 'Treasure Island',
      'action': 'Follow up >',
    },
    {
      'type': 'Book Overdue',
      'typeColor': 'red',
      'icon': Icons.warning_amber_rounded,
      'studentName': 'Sneha Iyer',
      'studentDetails': 'Grade 7B · 6 days late',
      'bookTitle': 'World History',
      'action': 'Follow up >',
    },
    {
      'type': 'Late Return',
      'typeColor': 'orange',
      'icon': Icons.access_time,
      'studentName': 'Vikram Singh',
      'studentDetails': 'Grade 10A · 2 days late',
      'bookTitle': 'Chemistry Lab Manual',
      'action': 'Follow up >',
    },
  ];

  static const List<Map<String, dynamic>> topBorrowers = [
    {'rank': '#1', 'name': 'Riya Sharma', 'grade': 'Grade 7A', 'books': '12 books', 'badge': 'Active Reader'},
    {'rank': '#2', 'name': 'Arjun Patel', 'grade': 'Grade 8B', 'books': '10 books', 'badge': 'Avid Reader'},
    {'rank': '#3', 'name': 'Meera Joshi', 'grade': 'Grade 6C', 'books': '9 books', 'badge': 'Rising Reader'},
    {'rank': '#4', 'name': 'Devansh Roy', 'grade': 'Grade 9A', 'books': '8 books', 'badge': 'Curious Mind'},
  ];

  static const List<Map<String, dynamic>> pendingReturns = [
    {'name': 'Aditya Verma', 'grade': 'Grade 8A', 'badge': '3d pending', 'badgeColor': 'orange'},
    {'name': 'Priya Nair', 'grade': 'Grade 9B', 'badge': '5d pending', 'badgeColor': 'red'},
    {'name': 'Rohan Das', 'grade': 'Grade 7C', 'badge': '2d pending', 'badgeColor': 'orange'},
    {'name': 'Isha Kapoor', 'grade': 'Grade 10A', 'badge': '7d pending', 'badgeColor': 'red'},
  ];

  static const List<Map<String, dynamic>> readingAwards = [
    {'name': 'Ananya Gupta', 'grade': 'Grade 8A', 'badge': 'Bookworm of the Month'},
    {'name': 'Kabir Singh', 'grade': 'Grade 7B', 'badge': 'Most Genres Read'},
    {'name': 'Niharika Rao', 'grade': 'Grade 9A', 'badge': 'Longest Streak - 30d'},
  ];

  static const Map<String, dynamic> inventoryStatus = {
    'available': 11820,
    'issued': 512,
    'reserved': 118,
    'repair': 14,
    'missing': 6,
  };

  static const List<Map<String, dynamic>> librarianOperations = [
    {'title': 'Books Processed Today', 'count': '151', 'icon': Icons.assignment_turned_in_outlined, 'colorType': 'green'},
    {'title': 'Catalog Updates Pending', 'count': '4', 'icon': Icons.note_alt_outlined, 'colorType': 'orange'},
    {'title': 'Book Requests Pending', 'count': '9', 'icon': Icons.forward_to_inbox_outlined, 'colorType': 'blue'},
    {'title': 'Reservation Approvals', 'count': '3', 'icon': Icons.bookmark_border, 'colorType': 'purple'},
    {'title': 'Repair Tickets Open', 'count': '5', 'icon': Icons.build_outlined, 'colorType': 'orange'},
  ];

  static const List<Map<String, dynamic>> newArrivals = [
    {
      'title': 'The Science Explorer',
      'author': 'M. R. Khanna',
      'category': 'Science',
      'date': 'Added Today',
      'colorType': 'blue',
    },
    {
      'title': 'AI for Kids',
      'author': 'Dana Patel',
      'category': 'Technology',
      'date': 'Added Yesterday',
      'colorType': 'purple',
    },
    {
      'title': 'Tales of Panchatantra',
      'author': 'Anonymous',
      'category': 'Folklore',
      'date': '2 days ago',
      'colorType': 'orange',
    },
    {
      'title': 'Junior Atlas',
      'author': 'DK',
      'category': 'Reference',
      'date': '3 days ago',
      'colorType': 'green',
    },
    {
      'title': 'Coding for Beginners',
      'author': 'R. Iyer',
      'category': 'Technology',
      'date': '4 days ago',
      'colorType': 'pink',
    },
    {
      'title': 'Wonders of Space',
      'author': 'N. Bose',
      'category': 'Science',
      'date': '5 days ago',
      'colorType': 'blue',
    },
    {
      'title': 'Young Entrepreneur',
      'author': 'S. Verma',
      'category': 'Business',
      'date': '6 days ago',
      'colorType': 'red',
    },
    {
      'title': 'Earth in Crisis',
      'author': 'L. Menon',
      'category': 'Environment',
      'date': 'Last week',
      'colorType': 'green',
    },
  ];

  static const List<Map<String, dynamic>> readingPrograms = [
    {
      'title': 'Reading Challenge',
      'description': 'School-wide 30-day reading sprint',
      'badgeText': 'Starts Next Week',
      'colorType': 'purple',
    },
    {
      'title': 'Annual Book Fair',
      'description': 'Open to all grades - publisher stalls',
      'badgeText': '15 July',
      'colorType': 'blue',
    },
    {
      'title': 'Author Session',
      'description': 'Guest author: Ruskin Bond fan meet',
      'badgeText': 'Scheduled · 22 July',
      'colorType': 'green',
    },
    {
      'title': 'Storytelling Hour',
      'description': 'Grades 1-4 in main hall',
      'badgeText': 'Every Friday',
      'colorType': 'orange',
    },
    {
      'title': 'Library Quiz',
      'description': 'Inter-house literature quiz',
      'badgeText': '08 August',
      'colorType': 'red',
    },
  ];

  static const List<Map<String, dynamic>> activityFeed = [
    {
      'title': 'Book Issued',
      'subtitle': 'Harry Potter Collection · Issued to Riya Sharma (7A)',
      'time': '09:15 AM',
      'icon': Icons.menu_book,
      'colorType': 'blue',
    },
    {
      'title': 'Book Returned',
      'subtitle': 'Science Encyclopedia · Returned by Arjun Patel (8B)',
      'time': '10:20 AM',
      'icon': Icons.assignment_return_outlined,
      'colorType': 'green',
    },
    {
      'title': 'Reservation Approved',
      'subtitle': 'Mathematics Guide · For Meera Joshi (6C)',
      'time': '11:35 AM',
      'icon': Icons.bookmark_border,
      'colorType': 'purple',
    },
    {
      'title': 'Late Return Logged',
      'subtitle': 'Treasure Island · 2 days late · Karan Mehta (9C)',
      'time': '12:40 PM',
      'icon': Icons.access_time,
      'colorType': 'orange',
    },
    {
      'title': 'New Book Added',
      'subtitle': 'Artificial Intelligence for Kids · Catalog updated',
      'time': '01:15 PM',
      'icon': Icons.library_add_outlined,
      'colorType': 'purple',
    },
    {
      'title': 'Damage Reported',
      'subtitle': 'World History · Pages torn · Sent for repair',
      'time': '02:30 PM',
      'icon': Icons.report_problem_outlined,
      'colorType': 'red',
    },
    {
      'title': 'Overdue Reminders Sent',
      'subtitle': 'Notifications dispatched to 8 students',
      'time': '03:00 PM',
      'icon': Icons.campaign_outlined,
      'colorType': 'orange',
    },
  ];

  static const List<Map<String, dynamic>> libraryAlerts = [
    {
      'title': '18 Overdue Books',
      'subtitle': 'Follow-up notices required',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'red',
    },
    {
      'title': '3 Lost Books Reported',
      'subtitle': 'Pending review by librarian',
      'icon': Icons.assignment_late_outlined,
      'colorType': 'orange',
    },
    {
      'title': 'Popular Book Out of Stock',
      'subtitle': 'Mathematics Reference Guide',
      'icon': Icons.layers_outlined,
      'colorType': 'orange',
    },
    {
      'title': 'Catalog Updates Pending',
      'subtitle': '4 entries awaiting approval',
      'icon': Icons.note_alt_outlined,
      'colorType': 'blue',
    },
    {
      'title': 'Fine Collection Pending',
      'subtitle': '₹2,340 across 11 students',
      'icon': Icons.currency_rupee,
      'colorType': 'purple',
    },
  ];

  static const List<Map<String, dynamic>> todaysHighlights = [
    {
      'value': '84',
      'label': 'Books Issued',
      'icon': Icons.menu_book,
      'colorType': 'blue',
    },
    {
      'value': '67',
      'label': 'Books Returned',
      'icon': Icons.save_alt_outlined,
      'colorType': 'green',
    },
    {
      'value': '18',
      'label': 'Overdue Books',
      'icon': Icons.warning_amber_rounded,
      'colorType': 'red',
    },
    {
      'value': '12',
      'label': 'New Reservations',
      'icon': Icons.bookmark_border,
      'colorType': 'purple',
    },
    {
      'value': '18',
      'label': 'New Books Added',
      'icon': Icons.library_add_outlined,
      'colorType': 'blue',
    },
    {
      'value': '0',
      'label': 'Major Issues',
      'icon': Icons.check_circle_outline,
      'colorType': 'green',
    },
  ];
}
