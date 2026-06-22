import 'package:flutter/material.dart';
import '../auth/menu_screen.dart';

class StudentInsightsScreen extends StatelessWidget {
  const StudentInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Insights')),
      drawer: const MenuScreen(activeScreen: 'Students'),
      body: const Center(child: Text('Student Insights Screen')),
    );
  }
}
