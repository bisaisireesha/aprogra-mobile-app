class ExamsMockData {
  static final List<Map<String, dynamic>> examsPrePrimary = [
    {
      'name': 'Term 1 Assessment',
      'papers': 2,
      'class': 'UKG',
      'type': 'Term Exam',
      'schedule': 'Aug 10 - Aug 12',
      'status': 'Scheduled',
      'subjectPapers': [
        {
          'subject': 'Rhymes',
          'date': 'Mon, Aug 10, 2026',
          'time': '09:00 • 45m',
          'invigilator': 'Mrs. Iyer',
          'room': 'Block A: Room 1',
          'syllabus': 'Chapters 1-4 of Rhymes',
          'notes': 'Bring your own stationery.',
          'marks': '25 marks',
          'passMarks': '10',
        },
        {
          'subject': 'Drawing',
          'date': 'Tue, Aug 11, 2026',
          'time': '10:00 • 45m',
          'invigilator': 'Ms. Gupta',
          'room': 'Block A: Room 2',
          'syllabus': 'Basic coloring and shapes.',
          'notes': 'Crayons are provided.',
          'marks': '25 marks',
          'passMarks': '10',
        },
      ],
    }
  ];

  static final List<Map<String, dynamic>> examsPrimary = [
    {
      'name': 'Unit Test 1',
      'papers': 3,
      'class': 'Class 5A',
      'type': 'Unit Test',
      'schedule': 'Jul 01 - Jul 05',
      'status': 'Scheduled',
      'subjectPapers': [
        {
          'subject': 'English',
          'date': 'Wed, Jul 01, 2026',
          'time': '09:00 • 60m',
          'invigilator': 'Vikram Singh',
          'room': 'Hall A',
          'syllabus': 'Chapters 1-3 Grammar',
          'notes': 'Calculators not allowed.',
          'marks': '50 marks',
          'passMarks': '20',
        },
        {
          'subject': 'Mathematics',
          'date': 'Fri, Jul 03, 2026',
          'time': '10:30 • 60m',
          'invigilator': 'Sunita Reddy',
          'room': 'Hall B',
          'syllabus': 'Algebra and Geometry basics',
          'notes': 'Bring geometry box.',
          'marks': '50 marks',
          'passMarks': '20',
        },
      ],
    },
    {
      'name': 'Cycle Test',
      'papers': 2,
      'class': 'Class 3A',
      'type': 'Unit Test',
      'schedule': 'Jul 03 - Jul 05',
      'status': 'Scheduled',
    },
  ];

  static final List<Map<String, dynamic>> examsSecondary = [
    {
      'name': 'Mid Term Exams',
      'papers': 6,
      'class': 'Class 10A',
      'type': 'Mid Term',
      'schedule': 'Sep 15 - Sep 25',
      'status': 'Draft',
      'subjectPapers': [
        {
          'subject': 'Physics',
          'date': 'Tue, Sep 15, 2026',
          'time': '09:00 • 120m',
          'invigilator': 'Mr. Sharma',
          'room': 'Senior Block: Hall 1',
          'syllabus': 'Mechanics and Thermodynamics',
          'notes': 'Scientific calculators permitted.',
          'marks': '100 marks',
          'passMarks': '33',
        },
        {
          'subject': 'Chemistry',
          'date': 'Thu, Sep 17, 2026',
          'time': '09:00 • 120m',
          'invigilator': 'Ms. Kaur',
          'room': 'Senior Block: Hall 2',
          'syllabus': 'Organic Chemistry basics',
          'notes': 'No calculators allowed.',
          'marks': '100 marks',
          'passMarks': '33',
        },
      ],
    },
    {
      'name': 'Weekly Test',
      'papers': 1,
      'class': 'Class 12B',
      'type': 'Weekly Test',
      'schedule': 'Jul 10',
      'status': 'Published',
    },
    {
      'name': 'Mock Board',
      'papers': 5,
      'class': 'Class 10B',
      'type': 'Mock',
      'schedule': 'Oct 01 - Oct 10',
      'status': 'Scheduled',
    },
  ];

  static final List<Map<String, dynamic>> seatingPrimary = [
    {
      'subject': 'English',
      'date': '2026-07-01 · 09:00',
      'building': 'Primary: Hall A',
      'room': 'Hall A-1',
      'roll': 'Roll 1 - 67',
      'students': 12,
      'color': 0xFF8463E9, // Purple
      'bgColor': 0xFFF4F1FF,
    },
    {
      'subject': 'Mathematics',
      'date': '2026-07-03 · 10:30',
      'building': 'Primary: Hall B',
      'room': 'Hall B-1',
      'roll': 'Roll 1 - 67',
      'students': 12,
      'color': 0xFF22C55E, // Green
      'bgColor': 0xFFDCFCE7,
    },
    {
      'subject': 'EVS',
      'date': '2026-07-05 · 11:30',
      'building': 'Primary: Hall C',
      'room': 'Hall C-1',
      'roll': 'Roll 1 - 67',
      'students': 12,
      'color': 0xFFF59E0B, // Orange
      'bgColor': 0xFFFEF3C7,
    }
  ];

  static final List<Map<String, dynamic>> seatingPrePrimary = [
    {
      'subject': 'Rhymes',
      'date': '2026-08-10 · 09:00',
      'building': 'Block A: Room 1',
      'room': 'Room 1A',
      'roll': 'Roll 1 - 25',
      'students': 25,
      'color': 0xFF0EA5E9, // Blue
      'bgColor': 0xFFE0F2FE,
    },
    {
      'subject': 'Drawing',
      'date': '2026-08-11 · 10:00',
      'building': 'Block A: Room 2',
      'room': 'Room 2A',
      'roll': 'Roll 26 - 50',
      'students': 25,
      'color': 0xFFEC4899, // Pink
      'bgColor': 0xFFFCE7F3,
    }
  ];

  static final List<Map<String, dynamic>> seatingSecondary = [
    {
      'subject': 'Physics',
      'date': '2026-09-15 · 09:00',
      'building': 'Senior Block: Hall 1',
      'room': 'Hall 1-A',
      'roll': 'Roll 1 - 50',
      'students': 50,
      'color': 0xFF8463E9, // Purple
      'bgColor': 0xFFF4F1FF,
    },
    {
      'subject': 'Chemistry',
      'date': '2026-09-17 · 09:00',
      'building': 'Senior Block: Hall 2',
      'room': 'Hall 2-A',
      'roll': 'Roll 1 - 50',
      'students': 50,
      'color': 0xFFEAB308, // Yellow
      'bgColor': 0xFFFEF08A,
    }
  ];

  static final Map<String, dynamic> resultsKpis = {
    'average': '0/50',
    'highest': '0/50',
    'lowest': '0/50',
    'passRate': '0%',
  };

  static final List<Map<String, dynamic>> resultsStudentsPrimary = [
    {
      'roll': '#1',
      'name': 'Diya Khan',
      'marks': '0',
      'status': 'Fail',
    },
    {
      'roll': '#7',
      'name': 'Vihaan Verma',
      'marks': '0',
      'status': 'Fail',
    },
    {
      'roll': '#3',
      'name': 'Kabir Kapoor',
      'marks': '0',
      'status': 'Fail',
    },
    {
      'roll': '#19',
      'name': 'Saanvi Gupta',
      'marks': '0',
      'status': 'Fail',
    },
  ];

  static final List<Map<String, dynamic>> resultsStudentsPrePrimary = [
    {
      'roll': '#1',
      'name': 'Aarav Nair',
      'marks': '45',
      'status': 'Pass',
    },
    {
      'roll': '#2',
      'name': 'Bhavya Singh',
      'marks': '42',
      'status': 'Pass',
    },
  ];

  static final List<Map<String, dynamic>> resultsStudentsSecondary = [
    {
      'roll': '#101',
      'name': 'Rohan Das',
      'marks': '85',
      'status': 'Pass',
    },
    {
      'roll': '#102',
      'name': 'Meera Joshi',
      'marks': '92',
      'status': 'Pass',
    },
  ];
}
