import 'package:flutter/material.dart';
import 'auth/menu_screen.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;
  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const MenuScreen(activeScreen: ''),
      body: Center(child: Text('$title - Coming Soon')),
    );
  }
}
