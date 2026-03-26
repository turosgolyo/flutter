import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Segoe UI',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelStyle: TextStyle(
            color: Color(0xFFE91E63),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const FormPage(),
    );
  }
}

// ─── Page ────────────────────────────────────────────────────────────────────

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  final _ageFocus = FocusNode();

  @override
  void dispose() {
    _nameFocus.dispose();
    _ageFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      showDialog(context: context, builder: (_) => _SuccessDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Rich gradient background ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFCE4EC),
                  Color(0xFFF8BBD0),
                  Color(0xFFE1BEE7),
                  Color(0xFFE8EAF6),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),

          // ── Decorative blurred orbs ───────────────────────────────────────
          Positioned(
            top: -80,
            left: -60,
            child: _Orb(
              size: 280,
              color: const Color(0xFFF48FB1).withOpacity(0.45),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -80,
            child: _Orb(
              size: 320,
              color: const Color(0xFFCE93D8).withOpacity(0.35),
            ),
          ),
          Positioned(
            top: 160,
            right: -50,
            child: _Orb(
              size: 180,
              color: const Color(0xFF90CAF9).withOpacity(0.25),
            ),
          ),

          // ── Form card ─────────────────────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(32, 36, 32, 36),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 1.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE91E63).withOpacity(0.10),
                            blurRadius: 40,
                            spreadRadius: 4,
                            offset: const Offset(0, 16),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Avatar badge
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF80AB),
                                    Color(0xFFE91E63),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFE91E63,
                                    ).withOpacity(0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 34,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Title
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF880E4F),
                                letterSpacing: 0.3,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Subtitle
                            const Text(
                              'Tell us a little about yourself',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFFAD7C8E),
                                letterSpacing: 0.2,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Divider pill
                            Container(
                              width: 40,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF80AB),
                                    Color(0xFFE91E63),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Name field
                            _StyledField(
                              label: 'Full Name',
                              hint: 'e.g. Alexandra Rose',
                              icon: Icons.badge_outlined,
                              focusNode: _nameFocus,
                              nextFocus: _ageFocus,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Please enter your name';
                                if (v.trim().length < 6)
                                  return 'Name must be at least 6 characters';
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Age field
                            _StyledField(
                              label: 'Age',
                              hint: 'Must be 18 or older',
                              icon: Icons.cake_rounded,
                              focusNode: _ageFocus,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Please enter your age';
                                final age = int.tryParse(v);
                                if (age == null)
                                  return 'Must be a valid number';
                                if (age < 18)
                                  return 'You must be at least 18 years old';
                                return null;
                              },
                            ),

                            const SizedBox(height: 32),

                            // Gradient submit button
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF80AB),
                                      Color(0xFFE91E63),
                                      Color(0xFFC2185B),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFE91E63,
                                      ).withOpacity(0.40),
                                      blurRadius: 18,
                                      offset: const Offset(0, 7),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: _submitForm,
                                  icon: const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Footer note
                            Text(
                              'Your information is safe with us 🔒',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.pink.shade300,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable styled field ────────────────────────────────────────────────────

class _StyledField extends StatelessWidget {
  const _StyledField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.focusNode,
    this.nextFocus,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?) validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      onFieldSubmitted: (_) {
        if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
      },
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF4A0030),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.pink.shade200, fontSize: 13.5),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Icon(icon, color: const Color(0xFFE91E63), size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFFFFF5F8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFFCDD2), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.8),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF5252), fontSize: 12),
      ),
      validator: validator,
    );
  }
}

// ─── Decorative blurred orb ───────────────────────────────────────────────────

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

// ─── Success dialog ───────────────────────────────────────────────────────────

class _SuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF80AB), Color(0xFFE91E63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.30),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'All Done! 🎉',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF880E4F),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your form was submitted\nsuccessfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFAD7C8E),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF80AB), Color(0xFFE91E63)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
