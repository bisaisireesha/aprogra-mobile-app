class StudentAttendanceMockData {
  static final List<Map<String, dynamic>> attendanceRoster = [
    // Pre-Primary Data
    { 'roll': '1', 'name': 'Kiaan Verma', 'admNo': 'ADM-25-2011', 'class': 'LKG', 'section': 'A', 'status': 'Present', 'checkIn': '08:30', 'remarks': '', 'category': 'Pre-Primary' },
    { 'roll': '2', 'name': 'Myra Iyer', 'admNo': 'ADM-25-2012', 'class': 'Nursery', 'section': 'B', 'status': 'Late', 'checkIn': '08:45', 'remarks': 'Traffic', 'category': 'Pre-Primary' },
    { 'roll': '3', 'name': 'Kabir Kapoor', 'admNo': 'ADM-25-2013', 'class': 'UKG', 'section': 'A', 'status': 'Absent', 'checkIn': '—', 'remarks': '', 'category': 'Pre-Primary' },
    { 'roll': '4', 'name': 'Navya Patel', 'admNo': 'ADM-25-2014', 'class': 'LKG', 'section': 'B', 'status': 'Present', 'checkIn': '08:25', 'remarks': '', 'category': 'Pre-Primary' },
    { 'roll': '5', 'name': 'Vivaan Reddy', 'admNo': 'ADM-25-2015', 'class': 'UKG', 'section': 'C', 'status': 'On Leave', 'checkIn': '—', 'remarks': 'Sick leave', 'category': 'Pre-Primary' },
    { 'roll': '6', 'name': 'Aarohi Das', 'admNo': 'ADM-25-2016', 'class': 'Nursery', 'section': 'A', 'status': 'Present', 'checkIn': '08:29', 'remarks': '', 'category': 'Pre-Primary' },
    { 'roll': '7', 'name': 'Aditya Sharma', 'admNo': 'ADM-25-2017', 'class': 'LKG', 'section': 'C', 'status': 'Late', 'checkIn': '08:50', 'remarks': '', 'category': 'Pre-Primary' },

    // Primary Data
    { 'roll': '1', 'name': 'Diya Khan', 'admNo': 'ADM-20-1011', 'class': 'Class 5', 'section': 'A', 'status': 'Present', 'checkIn': '08:15', 'remarks': '', 'category': 'Primary' },
    { 'roll': '2', 'name': 'Sara Sharma', 'admNo': 'ADM-21-1018', 'class': 'Class 1', 'section': 'A', 'status': 'Present', 'checkIn': '08:16', 'remarks': '', 'category': 'Primary' },
    { 'roll': '3', 'name': 'Aarav Nair', 'admNo': 'ADM-22-1025', 'class': 'Class 1', 'section': 'B', 'status': 'Present', 'checkIn': '08:17', 'remarks': '', 'category': 'Primary' },
    { 'roll': '4', 'name': 'Ayaan Joshi', 'admNo': 'ADM-23-1032', 'class': 'Class 2', 'section': 'A', 'status': 'Absent', 'checkIn': '—', 'remarks': '', 'category': 'Primary' },
    { 'roll': '5', 'name': 'Pari Gupta', 'admNo': 'ADM-24-1039', 'class': 'Class 3', 'section': 'A', 'status': 'Present', 'checkIn': '08:19', 'remarks': '', 'category': 'Primary' },
    { 'roll': '6', 'name': 'Vihaan Mehta', 'admNo': 'ADM-22-1040', 'class': 'Class 4', 'section': 'B', 'status': 'Late', 'checkIn': '08:35', 'remarks': '', 'category': 'Primary' },
    { 'roll': '7', 'name': 'Ishita Agarwal', 'admNo': 'ADM-21-1041', 'class': 'Class 5', 'section': 'C', 'status': 'Present', 'checkIn': '08:10', 'remarks': '', 'category': 'Primary' },
    { 'roll': '8', 'name': 'Krish Jain', 'admNo': 'ADM-24-1042', 'class': 'Class 2', 'section': 'B', 'status': 'On Leave', 'checkIn': '—', 'remarks': 'Fever', 'category': 'Primary' },
    { 'roll': '9', 'name': 'Saanvi Chatterjee', 'admNo': 'ADM-23-1043', 'class': 'Class 3', 'section': 'C', 'status': 'Present', 'checkIn': '08:12', 'remarks': '', 'category': 'Primary' },
    { 'roll': '10', 'name': 'Shaurya Singh', 'admNo': 'ADM-22-1044', 'class': 'Class 4', 'section': 'A', 'status': 'Absent', 'checkIn': '—', 'remarks': '', 'category': 'Primary' },

    // Secondary Data
    { 'roll': '1', 'name': 'Rohan Das', 'admNo': 'ADM-18-3011', 'class': 'Class 9', 'section': 'A', 'status': 'Present', 'checkIn': '07:50', 'remarks': '', 'category': 'Secondary' },
    { 'roll': '2', 'name': 'Ananya Singh', 'admNo': 'ADM-17-3012', 'class': 'Class 10', 'section': 'B', 'status': 'On Leave', 'checkIn': '—', 'remarks': 'Sick leave', 'category': 'Secondary' },
    { 'roll': '3', 'name': 'Arjun Malhotra', 'admNo': 'ADM-19-3013', 'class': 'Class 8', 'section': 'C', 'status': 'Present', 'checkIn': '07:45', 'remarks': '', 'category': 'Secondary' },
    { 'roll': '4', 'name': 'Meera Kumar', 'admNo': 'ADM-16-3014', 'class': 'Class 11', 'section': 'A', 'status': 'Late', 'checkIn': '08:05', 'remarks': 'Bus delay', 'category': 'Secondary' },
    { 'roll': '5', 'name': 'Kabir Bhatia', 'admNo': 'ADM-15-3015', 'class': 'Class 12', 'section': 'B', 'status': 'Present', 'checkIn': '07:40', 'remarks': '', 'category': 'Secondary' },
    { 'roll': '6', 'name': 'Nisha Desai', 'admNo': 'ADM-20-3016', 'class': 'Class 6', 'section': 'A', 'status': 'Absent', 'checkIn': '—', 'remarks': '', 'category': 'Secondary' },
    { 'roll': '7', 'name': 'Rahul Thakur', 'admNo': 'ADM-19-3017', 'class': 'Class 7', 'section': 'C', 'status': 'Present', 'checkIn': '07:48', 'remarks': '', 'category': 'Secondary' },
    { 'roll': '8', 'name': 'Sneha Rao', 'admNo': 'ADM-18-3018', 'class': 'Class 9', 'section': 'B', 'status': 'Present', 'checkIn': '07:52', 'remarks': '', 'category': 'Secondary' },
    { 'roll': '9', 'name': 'Ayush Gupta', 'admNo': 'ADM-17-3019', 'class': 'Class 10', 'section': 'A', 'status': 'On Leave', 'checkIn': '—', 'remarks': '', 'category': 'Secondary' },
    { 'roll': '10', 'name': 'Pooja Sharma', 'admNo': 'ADM-16-3020', 'class': 'Class 11', 'section': 'C', 'status': 'Late', 'checkIn': '08:10', 'remarks': '', 'category': 'Secondary' },
  ];
}
