import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Design Tokens (from HTML mobile rendering) ─────────────────────────────
// Colors
const _bgColor       = Color(0xFFFAF9FF); // mesh-gradient base
const _cardColor     = Color(0xFFF9F9FB); // login card background
const _textDark      = Color(0xFF181821); // primary text
const _textMuted     = Color(0xFF595973); // secondary / label text
const _accent        = Color(0xFF8463E9); // purple accent
const _accentLight   = Color(0xFF8B84FF); // gradient end
const _borderColor   = Color(0xFFF3F3F6); // input borders
const _inputBg       = Colors.white;

// Button gradient: #8463E9 → #8B84FF
const _buttonGradient = LinearGradient(
  colors: [_accent, _accentLight],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

// Shadows
final _cardShadow = BoxShadow(
  color: const Color(0xFF6C63FF).withValues(alpha: 0.12),
  blurRadius: 40,
  offset: const Offset(0, -12),
);

final _buttonShadow = BoxShadow(
  color: _accent.withValues(alpha: 0.25),
  blurRadius: 24,
  offset: const Offset(0, 12),
);

// ─── Login Screen ────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe      = false;
  bool _obscurePassword = true;
  bool _emailFocused    = false;
  bool _passwordFocused = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // [Responsive Fix]: Get screen size and keyboard visibility using MediaQuery
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: _bgColor,
      resizeToAvoidBottomInset: true,
      // [Responsive Fix]: Use LayoutBuilder to dynamically adapt to constraints
      body: LayoutBuilder(
        builder: (context, constraints) {
          // [Responsive Fix]: Define breakpoints for tablets and wide screens
          final isTablet = constraints.maxWidth >= 600;
          // [Responsive Fix]: Prevent logo overlap on tiny screens or when keyboard is open
          final showLogo = constraints.maxHeight > 400 && !isKeyboardOpen;

          return Stack(
            children: [
              // Layer 1: base fill
              Positioned.fill(
                child: Container(color: _bgColor),
              ),

              // Layer 2: radial lavender glow in the top portion
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                // [Responsive Fix]: Use FractionallySizedBox equivalent via constraints to scale properly
                height: constraints.maxHeight * 0.4,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0.0, -0.3),
                      radius: 1.2,
                      colors: [
                        Color(0xFFDDD2EE),
                        Color(0xFFE5DCF3),
                        Color(0xFFEEE8F8),
                        Color(0xFFFAF9FF),
                      ],
                      stops: [0.0, 0.35, 0.65, 1.0],
                    ),
                  ),
                ),
              ),

              // ── Main content ──
              // [Responsive Fix]: Wrap main layout in SafeArea to prevent notch/system UI clipping
              SafeArea(
                child: Center(
                  // [Responsive Fix]: Limit max width so ultra-wide tablets don't stretch forms excessively
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        // Branding section
                        if (showLogo)
                          // [Responsive Fix]: Wrap in Flexible so it shrinks gracefully if space is needed
                          Flexible(
                            flex: 3,
                            child: _BrandingSection(constraints: constraints),
                          ),

                        // Login card
                        // [Responsive Fix]: Use Expanded so the card takes all remaining screen space naturally
                        Expanded(
                          flex: 7,
                          child: Container(
                            // [Responsive Fix]: Center the card on tablets, dock to bottom on phones
                            alignment: isTablet ? Alignment.center : Alignment.bottomCenter,
                            padding: isTablet ? const EdgeInsets.all(24) : EdgeInsets.zero,
                            child: ConstrainedBox(
                              // [Responsive Fix]: Give the card a maximum width on tablets for better UX
                              constraints: BoxConstraints(
                                maxWidth: isTablet ? 500 : double.infinity,
                              ),
                              child: _LoginCard(
                                emailController:    _emailController,
                                passwordController: _passwordController,
                                rememberMe:      _rememberMe,
                                obscurePassword: _obscurePassword,
                                emailFocused:    _emailFocused,
                                passwordFocused: _passwordFocused,
                                isTablet:        isTablet, // Pass responsive state
                                onRememberMeChanged: (v) => setState(() => _rememberMe = v ?? false),
                                onTogglePassword:    ()  => setState(() => _obscurePassword = !_obscurePassword),
                                onEmailFocusChange:    (f) => setState(() => _emailFocused = f),
                                onPasswordFocusChange: (f) => setState(() => _passwordFocused = f),
                                onLogin: () async {
                                  if (_emailController.text.trim() == 'principal@gmail.com' &&
                                      _passwordController.text == 'Principal@123') {
                                    
                                    final prefs = await SharedPreferences.getInstance();
                                    await prefs.setBool('isLoggedIn', true);
                                    
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(context, '/home');
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Invalid credentials. Use principal@gmail.com / Principal@123'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Branding Section ────────────────────────────────────────────────────────
class _BrandingSection extends StatelessWidget {
  final BoxConstraints constraints;
  const _BrandingSection({required this.constraints});

  @override
  Widget build(BuildContext context) {
    // [Responsive Fix]: Dynamically adjust logo size based on available screen width
    final double logoSize = constraints.maxWidth > 600 ? 100 : 80;
    
    return Center(
      child: Container(
        width: logoSize,
        height: logoSize,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(logoSize * 0.25),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(logoSize * 0.15),
          child: Image.asset(
            'assets/images/graduation logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

// ─── Login Card ──────────────────────────────────────────────────────────────
class _LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final bool obscurePassword;
  final bool emailFocused;
  final bool passwordFocused;
  final bool isTablet;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onTogglePassword;
  final ValueChanged<bool> onEmailFocusChange;
  final ValueChanged<bool> onPasswordFocusChange;
  final VoidCallback onLogin;

  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.obscurePassword,
    required this.emailFocused,
    required this.passwordFocused,
    required this.isTablet,
    required this.onRememberMeChanged,
    required this.onTogglePassword,
    required this.onEmailFocusChange,
    required this.onPasswordFocusChange,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    // [Responsive Fix]: Adjust inner padding dynamically so it feels spacious on tablets but compact on phones
    final EdgeInsets padding = isTablet 
        ? const EdgeInsets.fromLTRB(40, 48, 40, 48)
        : const EdgeInsets.fromLTRB(20, 32, 20, 32);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        // [Responsive Fix]: Fully rounded corners on tablet floating card, docked corners on mobile
        borderRadius: isTablet
            ? BorderRadius.circular(40)
            : const BorderRadius.only(
                topLeft:  Radius.circular(40),
                topRight: Radius.circular(40),
              ),
        boxShadow: [_cardShadow],
      ),
      // [Responsive Fix]: Wrap forms in SingleChildScrollView to guarantee no bottom overflow when keyboard opens
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // [Responsive Fix]: Prevent scroll view from stretching infinitely by wrapping tight
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Heading ──
            Text(
              'Welcome back',
              // [Responsive Fix]: Scale typography gracefully
              style: TextStyle(
                fontSize: isTablet ? 36 : 30,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: _textDark,
                letterSpacing: -0.02 * (isTablet ? 36 : 30),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please log in to your account to continue',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: _textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: isTablet ? 40 : 32),

            // ── Email Field ──
            const _FieldLabel(text: 'Email Address'),
            const SizedBox(height: 8),
            _InputField(
              controller: emailController,
              hintText: 'teacher@school.edu',
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              prefixIcon: const Icon(Icons.mail_outline_rounded, color: _textMuted, size: 20),
              isFocused: emailFocused,
              onFocusChange: onEmailFocusChange,
            ),
            SizedBox(height: isTablet ? 32 : 24),

            // ── Password Field ──
            const _FieldLabel(text: 'Password'),
            const SizedBox(height: 8),
            _InputField(
              controller: passwordController,
              hintText: '••••••••',
              keyboardType: TextInputType.visiblePassword,
              obscureText: obscurePassword,
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: _textMuted, size: 20),
              isFocused: passwordFocused,
              onFocusChange: onPasswordFocusChange,
              suffixIcon: GestureDetector(
                onTap: onTogglePassword,
                child: Icon(
                  obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                  color: _textMuted,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: isTablet ? 32 : 24),

            // ── Remember Me + Forgot Password ──
            // [Responsive Fix]: Wrap row children in Flexible to prevent RenderFlex overflow on small devices
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () => onRememberMeChanged(!rememberMe),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CustomCheckbox(value: rememberMe),
                        const SizedBox(width: 8),
                        const Flexible(
                          child: Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _textMuted,
                            ),
                            // [Responsive Fix]: Prevent text clipping
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _accent,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 32 : 24),

            // ── Login Button ──
            _GradientButton(
              label: 'Login',
              onPressed: onLogin,
            ),
            SizedBox(height: isTablet ? 48 : 40),

            // ── Mobile footer ──
            const Center(
              child: Text(
                '© 2024 Education Portal. All rights reserved.',
                textAlign: TextAlign.center, // [Responsive Fix]: Ensure it wraps perfectly on narrow screens
                style: TextStyle(
                  fontSize: 12,
                  color: _textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Field Label ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: _textDark,
        ),
      ),
    );
  }
}

// ─── Input Field ─────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final bool isFocused;
  final ValueChanged<bool> onFocusChange;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.obscureText,
    required this.prefixIcon,
    required this.isFocused,
    required this.onFocusChange,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: onFocusChange,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // [Responsive Fix]: Used BoxConstraints(minHeight) instead of fixed height so OS text scaling doesn't clip
        constraints: const BoxConstraints(minHeight: 56),
        decoration: BoxDecoration(
          color: _inputBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFocused ? _accent : _borderColor,
            width: 1.5,
          ),
          boxShadow: isFocused
            ? [BoxShadow(color: _accent.withValues(alpha: 0.10), blurRadius: 0, spreadRadius: 4)]
            : [],
        ),
        // [Responsive Fix]: Ensure Center vertical alignment of text field content
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 16,
            color: _textDark,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Color(0xFF94A3B8),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: prefixIcon,
            ),
            prefixIconConstraints: const BoxConstraints(),
            suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: suffixIcon,
                )
              : null,
            suffixIconConstraints: const BoxConstraints(),
            border: InputBorder.none,
            // [Responsive Fix]: Removed vertical hard padding to let text scale organically
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ),
    );
  }
}

// ─── Custom Checkbox ─────────────────────────────────────────────────────────
class _CustomCheckbox extends StatelessWidget {
  final bool value;
  const _CustomCheckbox({required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: value ? _accent : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: value ? _accent : _textMuted.withValues(alpha: 0.30),
          width: 2,
        ),
      ),
      child: value
        ? const Icon(Icons.check, size: 13, color: Colors.white)
        : null,
    );
  }
}

// ─── Gradient Login Button ───────────────────────────────────────────────────
class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  const _GradientButton({required this.label, required this.onPressed});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          // [Responsive Fix]: Used constraints so button text scaling doesn't overflow
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(
            gradient: _buttonGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [_buttonShadow],
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
