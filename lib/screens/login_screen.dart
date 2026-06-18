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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _bgColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ── Background that replicates the HTML's rendered mobile appearance ──
          //
          // On a 412px mobile screen the HTML produces:
          //   body mesh-gradient: radial #EDE4FC from top-right corner
          //   blob bottom-left:   #6C63FF at 40% opacity, blur-80px  (strong diffuse)
          //   blob top-right:     #8B84FF at 20% opacity, blur-80px  (softer diffuse)
          //
          // These three compound into a clearly-visible, fairly uniform lavender
          // zone across the top ~30% of the screen. Estimated composited colours
          // from the screenshot: ~#DDD2EE at peak → ~#EBE4F5 mid → #FAF9FF at card edge.
          //
          // We reproduce this with a base fill + a top-positioned radial gradient.

          // Layer 1: base fill
          Positioned.fill(
            child: Container(color: _bgColor),
          ),

          // Layer 2: radial lavender glow in the top portion
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.38,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.3),
                  radius: 1.2,
                  colors: const [
                    Color(0xFFDDD2EE), // Peak: visible lavender (centre of branding)
                    Color(0xFFE5DCF3), // Mid-ring: slightly lighter
                    Color(0xFFEEE8F8), // Outer-ring: fading
                    Color(0xFFFAF9FF), // Edge: merges with base bg
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // ── Main content ──
          SafeArea(
            child: Column(
              children: [
                // Branding section (logo only — subtle background already set above)
                _BrandingSection(size: size),

                // Login card
                Expanded(
                  child: _LoginCard(
                    emailController:    _emailController,
                    passwordController: _passwordController,
                    rememberMe:      _rememberMe,
                    obscurePassword: _obscurePassword,
                    emailFocused:    _emailFocused,
                    passwordFocused: _passwordFocused,
                    onRememberMeChanged: (v) => setState(() => _rememberMe = v ?? false),
                    onTogglePassword:    ()  => setState(() => _obscurePassword = !_obscurePassword),
                    onEmailFocusChange:    (f) => setState(() => _emailFocused = f),
                    onPasswordFocusChange: (f) => setState(() => _passwordFocused = f),
                    onLogin: () async {
                      if (_emailController.text.trim() == 'principal@gmail.com' &&
                          _passwordController.text == 'Principal@123') {
                        
                        // Save login state so the user doesn't have to login again
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Branding Section ────────────────────────────────────────────────────────
// On HTML mobile the top area is clean: just the logo centred on the subtle
// mesh background. No visible blobs. The gradient behind is handled globally.
class _BrandingSection extends StatelessWidget {
  final Size size;
  const _BrandingSection({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.28,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _accent.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/images/graduation logo.png',
              fit: BoxFit.contain,
            ),
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
    required this.onRememberMeChanged,
    required this.onTogglePassword,
    required this.onEmailFocusChange,
    required this.onPasswordFocusChange,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: const BorderRadius.only(
          topLeft:  Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [_cardShadow],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Heading ──
            const Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 30,
                height: 36 / 30,
                fontWeight: FontWeight.w700,
                color: _textDark,
                letterSpacing: -0.02 * 30,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please log in to your account to continue',
              style: TextStyle(
                fontSize: 16,
                color: _textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),

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
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

            // ── Remember Me + Forgot Password ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => onRememberMeChanged(!rememberMe),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      _CustomCheckbox(value: rememberMe),
                      const SizedBox(width: 8),
                      const Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Login Button ──
            _GradientButton(
              label: 'Login',
              onPressed: onLogin,
            ),
            const SizedBox(height: 40),

            // ── Mobile footer ──
            Center(
              child: Text(
                '© 2024 Education Portal. All rights reserved.',
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
        height: 56,
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
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
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
          height: 56,
          decoration: BoxDecoration(
            gradient: _buttonGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [_buttonShadow],
          ),
          alignment: Alignment.center,
          child: const Text(
            'Login',
            style: TextStyle(
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
