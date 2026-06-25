class TimetablesMockData {
  static final List<Map<String, dynamic>> allTimetables = [
    {
      'title': 'Class 1A — Weekly',
      'level': 'Primary',
      'time': '08:00 - 12:05',
      'class': 'Class 1A',
      'teacher': 'Kavita Menon',
      'periods': 5,
      'breaks': 1,
      'duration': '4h 5m',
    },
    {
      'title': 'Nursery A — Daily Flow',
      'level': 'Pre Primary',
      'time': '08:30 - 11:50',
      'class': 'Nursery A',
      'teacher': 'Meera Joshi',
      'periods': 4,
      'breaks': 1,
      'duration': '3h 20m',
    },
    {
      'title': 'Class 8A — Core',
      'level': 'Secondary',
      'time': '08:00 - 12:30',
      'class': 'Class 8A',
      'teacher': 'Rohit Malhotra',
      'periods': 5,
      'breaks': 1,
      'duration': '4h 30m',
    },
  ];

  static List<Map<String, dynamic>> get prePrimaryTimetables => 
      allTimetables.where((t) => t['level'] == 'Pre Primary').toList();

  static List<Map<String, dynamic>> get primaryTimetables => 
      allTimetables.where((t) => t['level'] == 'Primary').toList();

  static List<Map<String, dynamic>> get secondaryTimetables => 
      allTimetables.where((t) => t['level'] == 'Secondary').toList();
}
