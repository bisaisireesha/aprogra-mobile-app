import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _bgColorAnimation;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    
    // Continuous subtle breathing animation for the text and background
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )
    );

    _bgColorAnimation = ColorTween(
      begin: const Color(0xFFF4F0FF), // Original light purple
      end: const Color(0xFFE8E0FF), // Slightly deeper purple for breathing effect
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      )
    );

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigate() {
    if (_isNavigating) return;
    _isNavigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: GestureDetector(
        onTap: _navigate,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _bgColorAnimation.value ?? const Color(0xFFF4F0FF),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: child,
            );
          },
          child: Stack(
            children: [
              // --- Background Decorative Bubbles ---
              
              // Top left hollow bubble
              Positioned(
                top: size.height * 0.20,
                left: size.width * 0.15,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE6DEFF), width: 2.0),
                  ),
                ),
              ),
              
              // Right middle filled bubble
              Positioned(
                top: size.height * 0.40,
                right: size.width * 0.12,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE6DEFF),
                  ),
                ),
              ),
              
              // Left bottom tiny filled bubble
              Positioned(
                bottom: size.height * 0.35,
                left: size.width * 0.25,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDFD6FF),
                  ),
                ),
              ),
              
              // Bottom right hollow bubble
              Positioned(
                bottom: size.height * 0.25,
                right: size.width * 0.20,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE6DEFF), width: 2.0),
                  ),
                ),
              ),

              // --- Main Content ---
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3), // Pushes content down slightly to center it better
                    
                    // The 3D Book Image in a Square
                    Container(
                      height: size.width * 0.45,
                      width: size.width * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24), // Soft rounded square
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B63FF).withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0), // Padding so it fits beautifully inside the circle
                          child: Image.asset(
                            'assets/images/graduation logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32), // Perfect balanced space
                    
                    // LOGO placeholder
                    Container(
                      width: 52,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6E6EB),
                      ),
                      child: const Center(
                        child: Text(
                          'LOGO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32), // Perfect balanced space between LOGO and Title
                    
                    // Title
                    const Text(
                      'Smart School Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3B3B4A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    const SizedBox(height: 24), // Balanced space between Title and Badge
                    
                    // Simplified Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE8FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Simplified',
                        style: TextStyle(
                          color: Color(0xFF8B63FF),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    
                    const Spacer(flex: 4), // Pushes the tap anywhere text to the bottom
                    
                    // Tap Anywhere to Start Text (Animated)
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: child,
                        );
                      },
                      child: const Text(
                        'TAP ANYWHERE TO START',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFA5A5B4),
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Vertical Line
                    Container(
                      width: 1.5,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFDCD2FF),
                            const Color(0xFFDCD2FF).withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
