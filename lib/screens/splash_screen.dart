import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6FF),
        body: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: 180,
              left: 30,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4CCE8),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 280,
              right: 40,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8E0F5),
                ),
              ),
            ),
            Positioned(
              top: 520,
              left: 80,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8E0F5),
                ),
              ),
            ),
            Positioned(
              top: 480,
              right: 60,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4CCE8),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Graduation books image
                  Image.asset(
                    'assets/images/visily-image.png',
                    width: 280,
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  // Logo placeholder
                  Container(
                    width: 40,
                    height: 40,
                    color: const Color(0xFFE0E0E0),
                    child: const Center(
                      child: Text(
                        'LOGO',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  const Text(
                    'Smart School Management',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF2D2D2D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Simplified badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E0F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Simplified',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9B8EC4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Tap to start
                  const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          'TAP ANYWHERE TO START',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '|',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFD4CCE8),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
