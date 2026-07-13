import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

void main() {
  runApp(const MobileShell());
}

// MobileShell: the outermost widget that wraps everything in a phone bezel
class MobileShell extends StatefulWidget {
  const MobileShell({super.key});

  @override
  State<MobileShell> createState() => _MobileShellState();
}

class _MobileShellState extends State<MobileShell> {
  late Timer _clockTimer;
  String _timeString = "";

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) => _updateTime());
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final t = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    if (t != _timeString) setState(() => _timeString = t);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitFusion',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: Center(
          child: _buildPhoneBezel(),
        ),
      ),
    );
  }

  Widget _buildPhoneBezel() {
    return Container(
      width: 393,
      height: 852,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(52),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 40,
            spreadRadius: 5,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.15),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(49),
        child: Stack(
          children: [
            // The actual app
            Positioned.fill(
              child: MediaQuery(
                data: const MediaQueryData(
                  size: Size(393, 852),
                  devicePixelRatio: 1.0,
                  padding: EdgeInsets.only(top: 54, bottom: 34),
                  viewPadding: EdgeInsets.only(top: 54, bottom: 34),
                ),
                child: const FitnessApp(),
              ),
            ),

            // Dynamic Island / Status bar background
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 54,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    // Time left
                    Positioned(
                      left: 24,
                      top: 14,
                      child: Text(
                        _timeString,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    // Dynamic Island pill
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 120,
                        height: 34,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    // Status icons right
                    Positioned(
                      right: 20,
                      top: 16,
                      child: Row(
                        children: const [
                          Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black),
                          SizedBox(width: 4),
                          Icon(Icons.wifi, size: 14, color: Colors.black),
                          SizedBox(width: 4),
                          Icon(Icons.battery_full, size: 14, color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Home Indicator bar at bottom
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
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

// The user session storage
class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  String name = "Alex Johnson";
  String email = "alex.johnson@fitfusion.com";
  String fitnessGoal = "Build Muscle & Stay Fit";
  double weight = 72.5;
  double height = 178.0;
  int dailyCalorieGoal = 2200;

  List<MealLog> mealLogs = [
    MealLog(name: "Oatmeal with Berries", calories: 350, type: "Breakfast", time: "08:15 AM"),
    MealLog(name: "Grilled Chicken Salad", calories: 520, type: "Lunch", time: "01:30 PM"),
    MealLog(name: "Protein Shake", calories: 250, type: "Snack", time: "05:00 PM"),
  ];

  List<WorkoutProgress> workoutHistory = [
    WorkoutProgress(day: "Mon", durationMin: 45, caloriesBurned: 320),
    WorkoutProgress(day: "Tue", durationMin: 60, caloriesBurned: 450),
    WorkoutProgress(day: "Wed", durationMin: 30, caloriesBurned: 210),
    WorkoutProgress(day: "Thu", durationMin: 50, caloriesBurned: 380),
    WorkoutProgress(day: "Fri", durationMin: 40, caloriesBurned: 300),
    WorkoutProgress(day: "Sat", durationMin: 75, caloriesBurned: 550),
    WorkoutProgress(day: "Sun", durationMin: 0, caloriesBurned: 0),
  ];

  int get streakCount => 5;
  int get totalWorkouts => 18;
}

class MealLog {
  final String name;
  final int calories;
  final String type;
  final String time;
  MealLog({required this.name, required this.calories, required this.type, required this.time});
}

class WorkoutProgress {
  final String day;
  final int durationMin;
  final int caloriesBurned;
  WorkoutProgress({required this.day, required this.durationMin, required this.caloriesBurned});
}

// SplashScreen widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _loadingProgress = 0.0;
  late Timer _loadingTimer;

  @override
  void initState() {
    super.initState();
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        _loadingProgress += 0.01;
        if (_loadingProgress >= 1.0) {
          _loadingProgress = 1.0;
          _loadingTimer.cancel();
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    });
  }

  @override
  void dispose() {
    _loadingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF0EFFF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.withOpacity(0.06),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEC4899).withOpacity(0.04),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Color(0xFFEC4899)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.bolt,
                      size: 60,
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .scale(duration: 800.ms, curve: Curves.elasticOut)
                      .fadeIn(duration: 500.ms),
                  const SizedBox(height: 24),
                  const Text(
                    "FitFusion",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0.0),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 30,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black54,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'NO EXCUSES. JUST RESULTS.',
                            speed: const Duration(milliseconds: 80),
                            cursor: '|',
                          ),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 200,
                      height: 6,
                      color: Colors.black.withOpacity(0.05),
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 20),
                            width: 200 * _loadingProgress,
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                colors: [Colors.deepPurple, Color(0xFFEC4899)],
                              ),
                            ),
                          ),
                        ],
                      ),
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

// LoginScreen widget
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      UserSession().email = email;
      if (email.contains('@')) {
        final parts = email.split('@');
        UserSession().name = parts[0].toUpperCase();
      } else {
        UserSession().name = "USER";
      }
      
      Navigator.pushReplacementNamed(context, '/home');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text("Welcome back, ${UserSession().name}!"),
            ],
          ),
          backgroundColor: Colors.deepPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF0EFFF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.withOpacity(0.06),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEC4899).withOpacity(0.04),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.deepPurple, Color(0xFFEC4899)],
                                ),
                              ),
                              child: const Icon(
                                Icons.bolt,
                                size: 40,
                                color: Colors.white,
                              ),
                            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                            const SizedBox(height: 16),
                            const Text(
                              "FitFusion",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Log in to continue your journey",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.deepPurple),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.03),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(color: Colors.black87),
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.03),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 4) {
                                  return 'Password must be at least 4 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Password reset email sent (simulation)."),
                                      backgroundColor: Colors.pinkAccent,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color(0xFFEC4899),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [Colors.deepPurple, Color(0xFFEC4899)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(delay: 150.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 30),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13),
                              children: const [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                    color: Color(0xFFEC4899),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}

// SignUpScreen widget
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      UserSession().name = _nameController.text.trim();
      UserSession().email = _emailController.text.trim();
      
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text("Account created! Welcome, ${UserSession().name}!"),
            ],
          ),
          backgroundColor: Colors.deepPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFF0EFFF)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -40,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple.withOpacity(0.06),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEC4899).withOpacity(0.04),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Sign up to start tracking your health goals",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.1),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person_outline, color: Colors.deepPurple),
                                hintText: 'Full Name',
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.03),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.deepPurple),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.03),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(color: Colors.black87),
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple),
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.03),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 4) {
                                  return 'Password must be at least 4 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _confirmPasswordController,
                              style: const TextStyle(color: Colors.black87),
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple),
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(color: Colors.black.withOpacity(0.35)),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.03),
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(0.05)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: const LinearGradient(
                                  colors: [Colors.deepPurple, Color(0xFFEC4899)],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(delay: 150.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 30),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13),
                              children: const [
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                    color: Color(0xFFEC4899),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}

// The actual app content (no phone chrome here)
class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitFusion',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/home': (_) => const HomeScreen(),
      },
    );
  }
}

// AppDrawer widget
class AppDrawer extends StatelessWidget {
  final Function(int)? onTabSelected;
  const AppDrawer({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final session = UserSession();
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurpleAccent, Color(0xFFEC4899)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  session.name.isNotEmpty ? session.name[0] : "U",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
              accountName: Text(
                session.name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                session.email,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_outlined,
                    title: "Home",
                    onTap: () {
                      Navigator.pop(context);
                      if (onTabSelected != null) onTabSelected!(0);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite_border,
                    title: "Favorites",
                    onTap: () {
                      Navigator.pop(context);
                      if (onTabSelected != null) onTabSelected!(1);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.restaurant_menu_outlined,
                    title: "Nutrition",
                    onTap: () {
                      Navigator.pop(context);
                      if (onTabSelected != null) onTabSelected!(2);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.bar_chart_outlined,
                    title: "Progress Tracker",
                    onTap: () {
                      Navigator.pop(context);
                      if (onTabSelected != null) onTabSelected!(3);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: "My Profile",
                    onTap: () {
                      Navigator.pop(context);
                      if (onTabSelected != null) onTabSelected!(4);
                    },
                  ),
                  const Divider(color: Colors.black12, thickness: 1),
                  _buildDrawerItem(
                    icon: Icons.calendar_today_outlined,
                    title: "Workout Plans",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.white,
                              leading: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
                                onPressed: () => Navigator.pop(context),
                              ),
                              title: const Text(
                                "Workout Plans",
                                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                              ),
                              elevation: 0,
                            ),
                            body: const WorkoutPlansScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.info_outline,
                    title: "About",
                    onTap: () {
                      Navigator.pop(context);
                      showAboutDialog(
                        context: context,
                        applicationName: "FitFusion",
                        applicationVersion: "2.0.0",
                        applicationIcon: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.deepPurpleAccent, Color(0xFFEC4899)],
                            ),
                          ),
                          child: const Icon(Icons.bolt, color: Colors.white),
                        ),
                        children: const [
                          Text("FitFusion is your premium fitness companion app to track workouts, diet, and progress with beautiful charts and stats."),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SafeArea(
              child: _buildDrawerItem(
                icon: Icons.logout_outlined,
                title: "Log Out",
                textColor: Colors.redAccent,
                iconColor: Colors.redAccent,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = Colors.deepPurple,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Poppins',
          fontSize: 15,
        ),
      ),
      onTap: onTap,
    );
  }
}

// SettingsScreen widget
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  bool _weeklyReminders = true;
  double _targetWeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Account"),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                child: Text(
                  UserSession().name.isNotEmpty ? UserSession().name[0] : "U",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
              title: Text(
                UserSession().name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(UserSession().email),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showEditProfileDialog();
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("Preferences"),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: Colors.deepPurple,
                  title: const Text("Push Notifications", style: TextStyle(fontSize: 14)),
                  subtitle: const Text("Receive daily quotes and workout logs", style: TextStyle(fontSize: 12)),
                  value: _notificationsEnabled,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  activeColor: Colors.deepPurple,
                  title: const Text("Dark Theme Mode (UI Only)", style: TextStyle(fontSize: 14)),
                  value: _darkModeEnabled,
                  onChanged: (val) {
                    setState(() => _darkModeEnabled = val);
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  activeColor: Colors.deepPurple,
                  title: const Text("Weekly Progress Summary", style: TextStyle(fontSize: 14)),
                  value: _weeklyReminders,
                  onChanged: (val) {
                    setState(() => _weeklyReminders = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader("Fitness Goals"),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Fitness Goal", style: TextStyle(fontSize: 14)),
                    trailing: Text(
                      UserSession().fitnessGoal,
                      style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onTap: _showEditGoalDialog,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text("Daily Calorie Goal", style: TextStyle(fontSize: 14)),
                    trailing: Text(
                      "${UserSession().dailyCalorieGoal} kcal",
                      style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onTap: _showEditCalorieDialog,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text("Target Weight", style: TextStyle(fontSize: 14)),
                    trailing: Text(
                      "$_targetWeight kg",
                      style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onTap: () {
                      _showWeightSliderDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                UserSession().name = "Alex Johnson";
                UserSession().email = "alex.johnson@fitfusion.com";
                UserSession().fitnessGoal = "Build Muscle & Stay Fit";
                UserSession().dailyCalorieGoal = 2200;
                _targetWeight = 70.0;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Settings reset to defaults.")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.redAccent,
              elevation: 0,
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text("Reset Session Data", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: UserSession().name);
    final emailCtrl = TextEditingController(text: UserSession().email);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email Address"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                UserSession().name = nameCtrl.text;
                UserSession().email = emailCtrl.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditGoalDialog() {
    final list = ["Lose Weight", "Gain Muscle", "Stay Fit", "Endurance Training"];
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Select Fitness Goal"),
        children: list.map((g) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                UserSession().fitnessGoal = g;
              });
              Navigator.pop(context);
            },
            child: Text(g),
          );
        }).toList(),
      ),
    );
  }

  void _showEditCalorieDialog() {
    final ctrl = TextEditingController(text: UserSession().dailyCalorieGoal.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Daily Calorie Goal (kcal)"),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "e.g. 2000"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              final val = int.tryParse(ctrl.text);
              if (val != null) {
                setState(() {
                  UserSession().dailyCalorieGoal = val;
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showWeightSliderDialog() {
    double tempWeight = _targetWeight;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Select Target Weight"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${tempWeight.toStringAsFixed(1)} kg", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Slider(
                activeColor: Colors.deepPurple,
                min: 40.0,
                max: 150.0,
                value: tempWeight,
                onChanged: (val) {
                  setDialogState(() => tempWeight = val);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                setState(() {
                  _targetWeight = tempWeight;
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

// WorkoutBarChart custom painter widgets
class WorkoutBarChart extends StatelessWidget {
  final List<WorkoutProgress> history;
  const WorkoutBarChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: CustomPaint(
        size: Size.infinite,
        painter: BarChartPainter(history),
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<WorkoutProgress> history;
  BarChartPainter(this.history);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final maxVal = history.map((e) => e.caloriesBurned).reduce((a, b) => a > b ? a : b);
    final maxCal = maxVal > 0 ? maxVal : 500;
    
    final width = size.width;
    final height = size.height;
    final padding = 20.0;
    
    final usableWidth = width;
    final usableHeight = height - padding;
    
    final barWidth = (usableWidth / history.length) * 0.6;
    final spaceWidth = (usableWidth / history.length) * 0.4;
    
    for (int i = 0; i < history.length; i++) {
      final item = history[i];
      final barHeight = item.caloriesBurned > 0 
          ? (item.caloriesBurned / maxCal) * usableHeight
          : 0.0;
      
      final left = i * (barWidth + spaceWidth) + (spaceWidth / 2);
      final top = usableHeight - barHeight;
      final right = left + barWidth;
      final bottom = usableHeight;
      
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTRB(left, top, right, bottom),
        const Radius.circular(6),
      );
      
      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.deepPurpleAccent, Colors.deepPurple.withOpacity(0.4)],
      ).createShader(Rect.fromLTRB(left, top, right, bottom));
      
      canvas.drawRRect(rect, paint);
      
      textPainter.text = TextSpan(
        text: item.day,
        style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(left + (barWidth - textPainter.width) / 2, usableHeight + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// NutritionScreen widget
class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final session = UserSession();

  void _showAddMealBottomSheet() {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    String selectedCategory = "Breakfast";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Log a Meal",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Meal Name",
                  hintText: "e.g. Oatmeal, Caesar Salad",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Meal Type",
                  border: OutlineInputBorder(),
                ),
                items: ["Breakfast", "Lunch", "Dinner", "Snack"]
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => selectedCategory = val);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories (kcal)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final cal = int.tryParse(caloriesController.text.trim());
                    if (name.isNotEmpty && cal != null) {
                      final now = DateTime.now();
                      final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
                      setState(() {
                        session.mealLogs.add(
                          MealLog(name: name, calories: cal, type: selectedCategory, time: timeStr),
                        );
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$name added successfully!")),
                      );
                    }
                  },
                  child: const Text("Save Meal", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalLogged = session.mealLogs.fold(0, (sum, item) => sum + item.calories);
    double progress = totalLogged / session.dailyCalorieGoal;
    if (progress > 1.0) progress = 1.0;
    
    int proteinLogged = (totalLogged * 0.15).round();
    int carbsLogged = (totalLogged * 0.55).round();
    int fatsLogged = (totalLogged * 0.30).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Calorie Budget",
                            style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "$totalLogged / ${session.dailyCalorieGoal} kcal",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            totalLogged >= session.dailyCalorieGoal
                                ? "Daily budget reached! 🎉"
                                : "${session.dailyCalorieGoal - totalLogged} kcal remaining",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: totalLogged >= session.dailyCalorieGoal ? Colors.green : Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 10,
                                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                              ),
                              Center(
                                child: Text(
                                  "${(progress * 100).round()}%",
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Macros Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildMacroRow("Protein", "${proteinLogged}g / 150g", proteinLogged / 150, Colors.cyan),
                    const SizedBox(height: 12),
                    _buildMacroRow("Carbohydrates", "${carbsLogged}g / 220g", carbsLogged / 220, Colors.purple),
                    const SizedBox(height: 12),
                    _buildMacroRow("Fats", "${fatsLogged}g / 70g", fatsLogged / 70, Colors.pink),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Meals",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextButton.icon(
                  onPressed: _showAddMealBottomSheet,
                  icon: const Icon(Icons.add, size: 18, color: Colors.deepPurple),
                  label: const Text("Log Meal", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (session.mealLogs.isEmpty)
              Container(
                height: 150,
                alignment: Alignment.center,
                child: const Text("No meals logged for today. Let's log one!", style: TextStyle(color: Colors.grey)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: session.mealLogs.length,
                itemBuilder: (context, index) {
                  final meal = session.mealLogs[index];
                  IconData categoryIcon = Icons.fastfood_outlined;
                  Color categoryColor = Colors.orange;

                  if (meal.type == "Breakfast") {
                    categoryIcon = Icons.free_breakfast_outlined;
                    categoryColor = Colors.amber;
                  } else if (meal.type == "Lunch") {
                    categoryIcon = Icons.lunch_dining_outlined;
                    categoryColor = Colors.blue;
                  } else if (meal.type == "Dinner") {
                    categoryIcon = Icons.dinner_dining_outlined;
                    categoryColor = Colors.indigo;
                  }

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: categoryColor.withOpacity(0.1),
                        child: Icon(categoryIcon, color: categoryColor),
                      ),
                      title: Text(
                        meal.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${meal.type} • ${meal.time}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${meal.calories} kcal",
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                session.mealLogs.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRow(String label, String value, double ratio, Color color) {
    double progress = ratio;
    if (progress > 1.0) progress = 1.0;
    if (progress < 0.0) progress = 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ProgressScreen widget
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final session = UserSession();
  int _activeStreak = 5;

  void _handleDailyCheckIn() {
    setState(() {
      _activeStreak++;
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Text("Streak Confirmed! ", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("🔥", style: TextStyle(fontSize: 24)),
          ],
        ),
        content: Text(
          "Great job check-in! Your streak is now $_activeStreak days. Keep pushing your limits!",
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Awesome"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 4,
              shadowColor: Colors.deepPurple.withOpacity(0.2),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurpleAccent, Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Fitness Streak",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$_activeStreak Days Active!",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: _handleDailyCheckIn,
                            child: const Text("Daily Check-In", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "🔥",
                          style: TextStyle(fontSize: 42),
                        ),
                      ),
                    ).animate().shake(delay: 500.ms, duration: 1.seconds),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "This Week's Stats",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard("Workouts", "${session.totalWorkouts}", Icons.fitness_center, Colors.amber),
                const SizedBox(width: 10),
                _buildStatCard("Active Mins", "340", Icons.timer_outlined, Colors.cyan),
                const SizedBox(width: 10),
                _buildStatCard("Calories", "4.2k", Icons.local_fire_department, Colors.pink),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daily Calories Burned (Mon - Sun)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    WorkoutBarChart(history: session.workoutHistory),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Recent Achievements",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildAchievementTile("Early Bird", "Completed a workout before 7:00 AM", Icons.wb_sunny_outlined, true),
                  const Divider(height: 1, indent: 64),
                  _buildAchievementTile("Calorie Crusher", "Burned over 500 calories in a single plan", Icons.local_fire_department, true),
                  const Divider(height: 1, indent: 64),
                  _buildAchievementTile("Century Rider", "Reach 100 total workouts session logs", Icons.emoji_events_outlined, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementTile(String title, String desc, IconData icon, bool unlocked) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: unlocked ? Colors.amber.withOpacity(0.15) : Colors.grey.withOpacity(0.1),
        child: Icon(icon, color: unlocked ? Colors.amber : Colors.grey),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: unlocked ? Colors.black87 : Colors.grey,
        ),
      ),
      subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      trailing: unlocked
          ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
          : const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
    );
  }
}

// HomeScreen widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: AppDrawer(
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.deepPurple),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'FitFusion',
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          isRepeatingAnimation: false,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.deepPurple),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No new notifications! Have a nice workout!"),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.deepPurple),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ExerciseSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          WorkoutCategoriesScreen(),
          FavoritesScreen(),
          NutritionScreen(),
          ProgressScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: 'Nutrition',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCategoriesScreen extends StatelessWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF6B4EFF), Color(0xFFEC4899)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B4EFF).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, ${UserSession().name}! 👋",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Let's crush your fitness goals today!",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 22,
                      child: Icon(Icons.flash_on, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.lightbulb_outline, color: Colors.amber, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Tip: Drinking water before workouts boosts energy!",
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.1, end: 0),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Popular Workouts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: popularWorkouts.length,
              itemBuilder: (context, index) {
                return WorkoutCard(workout: popularWorkouts[index])
                    .animate()
                    .fade(delay: (index * 100).ms, duration: 400.ms)
                    .slideX(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'Workout Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: workoutCategories.length,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemBuilder: (context, index) {
              return CategoryCard(category: workoutCategories[index])
                  .animate()
                  .fade(delay: (index * 100).ms, duration: 400.ms)
                  .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.0, 1.0), curve: Curves.easeOutBack);
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'Quick Workouts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...quickWorkouts.map((workout) => QuickWorkoutTile(workout: workout)).toList(),
        ],
      ),
    );
  }
}

class WorkoutCard extends StatefulWidget {
  final Workout workout;

  const WorkoutCard({super.key, required this.workout});

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailScreen(workout: widget.workout),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    Image.asset(
                      widget.workout.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.workout.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.workout.duration} min',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 100.ms).slideX(),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final WorkoutCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              category.color.withOpacity(0.9),
              category.color.withOpacity(0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category.icon,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: 200.ms).scale(),
    );
  }
}

class QuickWorkoutTile extends StatelessWidget {
  final Workout workout;

  const QuickWorkoutTile({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: SizedBox(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              workout.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          workout.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${workout.duration} min • ${workout.difficulty}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutTimerScreen(workout: workout),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.workout.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : Image.asset(
                    widget.workout.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                        if (_isPlaying) {
                          _controller.play();
                        } else {
                          _controller.pause();
                        }
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 50,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: Colors.deepPurple,
                    bufferedColor: Colors.grey,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.workout.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.workout.duration} min',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.fitness_center, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.workout.difficulty,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.star, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.workout.calories} cal',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.workout.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Exercises',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.workout.exercises.map((exercise) => ExerciseStepItem(
                    exercise: exercise,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailScreen(
                            exercise: exercise,
                          ),
                        ),
                      );
                    },
                  )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WorkoutTimerScreen(workout: widget.workout),
                          ),
                        );
                      },
                      child: const Text(
                        'Start Workout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

class ExerciseStepItem extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseStepItem({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                exercise.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exercise.duration} sec • ${exercise.repetitions} reps',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              exercise.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${exercise.duration} seconds',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${exercise.repetitions} reps',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...exercise.instructions.map((instruction) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• '),
                        Expanded(
                          child: Text(
                            instruction,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  if (exercise.tips.isNotEmpty) ...[
                    const Text(
                      'Tips',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...exercise.tips.map((tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutTimerScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutTimerScreen({super.key, required this.workout});

  @override
  State<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends State<WorkoutTimerScreen> {
  int _currentExerciseIndex = 0;
  int _secondsRemaining = 0;
  bool _isRunning = false;
  late Timer _timer;
  bool _isWorkoutComplete = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.workout.exercises[_currentExerciseIndex].duration;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _nextExercise();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer.cancel();
  }

  void _nextExercise() {
    _timer.cancel();
    setState(() {
      if (_currentExerciseIndex < widget.workout.exercises.length - 1) {
        _currentExerciseIndex++;
        _secondsRemaining = widget.workout.exercises[_currentExerciseIndex].duration;
        _isRunning = false;
      } else {
        _isWorkoutComplete = true;
      }
    });
  }

  void _previousExercise() {
    _timer.cancel();
    setState(() {
      if (_currentExerciseIndex > 0) {
        _currentExerciseIndex--;
        _secondsRemaining = widget.workout.exercises[_currentExerciseIndex].duration;
        _isRunning = false;
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isWorkoutComplete) {
      return WorkoutCompleteScreen(workout: widget.workout);
    }

    final currentExercise = widget.workout.exercises[_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Timer'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentExerciseIndex + 1) / widget.workout.exercises.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Exercise ${_currentExerciseIndex + 1} of ${widget.workout.exercises.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      _formatTime(_secondsRemaining),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  currentExercise.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${currentExercise.repetitions} repetitions',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  currentExercise.imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _previousExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.skip_previous, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                  ),
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                ElevatedButton(
                  onPressed: _nextExercise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.skip_next, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutCompleteScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutCompleteScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Workout Complete!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You finished ${workout.name}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Total time: ${workout.duration} minutes',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Calories burned: ~${workout.calories} cal',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

class CategoryDetailScreen extends StatelessWidget {
  final WorkoutCategory category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final categoryWorkouts = workouts
        .where((workout) => workout.category == category.name)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: categoryWorkouts.length,
        itemBuilder: (context, index) {
          return WorkoutCard(workout: categoryWorkouts[index]);
        },
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteWorkouts = workouts.where((workout) => workout.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteWorkouts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the heart icon to add workouts to your favorites',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: favoriteWorkouts.length,
        itemBuilder: (context, index) {
          return QuickWorkoutTile(workout: favoriteWorkouts[index]);
        },
      ),
    );
  }
}

class WorkoutPlansScreen extends StatelessWidget {
  const WorkoutPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plans'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PlanCard(
            title: 'Beginner Full Body',
            description: '4-week plan for beginners',
            duration: '28 days',
            difficulty: 'Easy',
            workouts: workouts.take(3).toList(),
          ),
          const SizedBox(height: 16),
          PlanCard(
            title: 'Intermediate Strength',
            description: '6-week strength building plan',
            duration: '42 days',
            difficulty: 'Medium',
            workouts: workouts.skip(3).take(3).toList(),
          ),
          const SizedBox(height: 16),
          PlanCard(
            title: 'Advanced HIIT',
            description: '8-week high intensity interval training',
            duration: '56 days',
            difficulty: 'Hard',
            workouts: workouts.skip(6).take(3).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePlanDialog(context);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreatePlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Plan Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final List<Workout> workouts;

  const PlanCard({
    super.key,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.fitness_center, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  difficulty,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Included Workouts:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: workouts
                  .map((workout) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, size: 16),
                    const SizedBox(width: 8),
                    Text(workout.name),
                  ],
                ),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text('Start Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage:
              AssetImage('assets/images/misc/profile_placeholder.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Member since June 2023',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stats',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.bar_chart),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Workouts', '24'),
                        _buildStatItem('Hours', '18.5'),
                        _buildStatItem('Calories', '12.4k'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Achievements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.emoji_events),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildAchievementItem(
                              'First Workout', Icons.fitness_center),
                          _buildAchievementItem(
                              '5 Day Streak', Icons.local_fire_department),
                          _buildAchievementItem(
                              'Marathon', Icons.directions_run),
                          _buildAchievementItem('Early Bird', Icons.wb_sunny),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.settings),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsItem(
                        Icons.notifications, 'Notifications', true),
                    _buildSettingsItem(
                        Icons.dark_mode, 'Dark Mode', false),
                    _buildSettingsItem(
                        Icons.volume_up, 'Sound', true),
                    _buildSettingsItem(
                        Icons.privacy_tip, 'Privacy', false),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.deepPurple.withOpacity(0.1),
            child: Icon(
              icon,
              size: 30,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, bool isActive) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Switch(
        value: isActive,
        onChanged: (value) {},
        activeColor: Colors.deepPurple,
      ),
    );
  }
}

class ExerciseSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = workouts
        .where((workout) =>
        workout.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return QuickWorkoutTile(workout: results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? workouts.take(5).toList()
        : workouts
        .where((workout) =>
        workout.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              suggestions[index].imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(suggestions[index].name),
          onTap: () {
            query = suggestions[index].name;
            showResults(context);
          },
        );
      },
    );
  }
}

// Data Models and Sample Data
class Workout {
  final String id;
  final String name;
  final String imageUrl;
  final String videoUrl;
  final String description;
  final int duration;
  final String difficulty;
  final String category;
  final int calories;
  final bool isFavorite;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.videoUrl,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.category,
    required this.calories,
    this.isFavorite = false,
    required this.exercises,
  });
}

class Exercise {
  final String name;
  final String imageUrl;
  final int duration;
  final String repetitions;
  final List<String> instructions;
  final List<String> tips;

  Exercise({
    required this.name,
    required this.imageUrl,
    required this.duration,
    required this.repetitions,
    required this.instructions,
    required this.tips,
  });
}

class WorkoutCategory {
  final String name;
  final IconData icon;
  final Color color;

  WorkoutCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Sample data
final workoutCategories = [
  WorkoutCategory(
    name: 'Cardio',
    icon: Icons.directions_run,
    color: Colors.blue,
  ),
  WorkoutCategory(
    name: 'Strength',
    icon: Icons.fitness_center,
    color: Colors.red,
  ),
  WorkoutCategory(
    name: 'Yoga',
    icon: Icons.self_improvement,
    color: Colors.green,
  ),
  WorkoutCategory(
    name: 'HIIT',
    icon: Icons.timer,
    color: Colors.orange,
  ),
  WorkoutCategory(
    name: 'Pilates',
    icon: Icons.accessibility,
    color: Colors.purple,
  ),
  WorkoutCategory(
    name: 'Stretching',
    icon: Icons.open_in_full,
    color: Colors.teal,
  ),
];

final exercises = [
  Exercise(
    name: 'Jumping Jacks',
    imageUrl: 'assets/images/exercises/jumping_jacks.png',
    duration: 30,
    repetitions: '30 reps',
    instructions: [
      'Stand with your feet together and your hands at your sides.',
      'Jump up, spreading your feet shoulder-width apart and raising your arms above your head.',
      'Jump again, returning to the starting position.',
      'Repeat for the specified duration.',
    ],
    tips: [
      'Keep your knees slightly bent to reduce impact.',
      'Maintain a steady pace throughout the exercise.',
    ],
  ),
  Exercise(
    name: 'Push Ups',
    imageUrl: 'assets/images/exercises/push_ups.webp',
    duration: 45,
    repetitions: '15 reps',
    instructions: [
      'Start in a plank position with your hands shoulder-width apart.',
      'Lower your body until your chest nearly touches the floor.',
      'Push yourself back up to the starting position.',
      'Repeat for the specified duration.',
    ],
    tips: [
      'Keep your body in a straight line from head to heels.',
      'Engage your core throughout the movement.',
    ],
  ),
  Exercise(
    name: 'Squats',
    imageUrl: 'assets/images/exercises/squats.webp',
    duration: 40,
    repetitions: '20 reps',
    instructions: [
      'Stand with your feet shoulder-width apart.',
      'Lower your body as if sitting back into a chair.',
      'Keep your chest up and your knees behind your toes.',
      'Push through your heels to return to the starting position.',
      'Repeat for the specified duration.',
    ],
    tips: [
      'Go as low as you can while maintaining good form.',
      'Keep your weight in your heels, not your toes.',
    ],
  ),
  Exercise(
    name: 'Plank',
    imageUrl: 'assets/images/exercises/plank.webp',
    duration: 60,
    repetitions: 'Hold',
    instructions: [
      'Start in a push-up position but with your weight on your forearms.',
      'Keep your body in a straight line from head to heels.',
      'Hold this position for the specified duration.',
    ],
    tips: [
      'Engage your core and glutes to maintain position.',
      'Don\'t let your hips sag or rise too high.',
    ],
  ),
  Exercise(
    name: 'Lunges',
    imageUrl: 'assets/images/exercises/lunges.jpg',
    duration: 45,
    repetitions: '12 reps each leg',
    instructions: [
      'Stand with your feet hip-width apart.',
      'Step forward with one leg and lower your hips until both knees are bent at about 90 degrees.',
      'Push back up to the starting position.',
      'Repeat on the other leg.',
    ],
    tips: [
      'Keep your front knee directly above your ankle.',
      'Don\'t let your knee go past your toes.',
    ],
  ),
  Exercise(
    name: 'Burpees',
    imageUrl: 'assets/images/exercises/burpees.webp',
    duration: 30,
    repetitions: '10 reps',
    instructions: [
      'Start in a standing position.',
      'Drop into a squat position with your hands on the ground.',
      'Kick your feet back into a plank position.',
      'Do a push-up, then return to the plank position.',
      'Jump your feet back to the squat position.',
      'Jump up into the air with your arms overhead.',
    ],
    tips: [
      'Maintain a steady pace throughout the exercise.',
      'Modify by stepping back instead of jumping if needed.',
    ],
  ),
];

final workouts = [
  Workout(
    id: '1',
    name: 'Full Body Burn',
    imageUrl: 'assets/images/workouts/full_body.jpg',
    videoUrl: 'assets/full_body.mp4',
    description:
    'A complete full body workout that targets all major muscle groups for a balanced fitness routine.',
    duration: 30,
    difficulty: 'Intermediate',
    category: 'HIIT',
    calories: 300,
    exercises: exercises.sublist(0, 3),
  ),
  Workout(
    id: '2',
    name: 'Core Crusher',
    imageUrl: 'assets/images/workouts/core.jpg',
    videoUrl: 'assets/core.mp4',
    description:
    'Intense core workout to strengthen your abs, obliques, and lower back.',
    duration: 20,
    difficulty: 'Beginner',
    category: 'Strength',
    calories: 200,
    exercises: exercises.sublist(2, 5),
  ),
  Workout(
    id: '3',
    name: 'Cardio Blast',
    imageUrl: 'assets/images/workouts/cardio.webp',
    videoUrl: 'assets/cardio.mp4',
    description:
    'High energy cardio workout to get your heart pumping and burn calories.',
    duration: 25,
    difficulty: 'Advanced',
    category: 'Cardio',
    calories: 350,
    exercises: [exercises[0], exercises[5], exercises[3]],
  ),
  Workout(
    id: '4',
    name: 'Yoga Flow',
    imageUrl: 'assets/images/workouts/yoga.webp',
    videoUrl: 'assets/yoga.mp4',
    description:
    'Gentle yoga sequence to improve flexibility, balance, and mindfulness.',
    duration: 40,
    difficulty: 'Beginner',
    category: 'Yoga',
    calories: 150,
    exercises: [],
  ),
  Workout(
    id: '5',
    name: 'Leg Day',
    imageUrl: 'assets/images/workouts/legs.jpg',
    videoUrl: 'assets/legs.mp4',
    description:
    'Focus on building strength and endurance in your lower body muscles.',
    duration: 35,
    difficulty: 'Intermediate',
    category: 'Strength',
    calories: 280,
    exercises: [exercises[2], exercises[4], exercises[1]],
  ),
  Workout(
    id: '6',
    name: 'Quick HIIT',
    imageUrl: 'assets/images/workouts/hiit.webp',
    videoUrl: 'assets/hiit.mp4',
    description:
    'Short but intense high-intensity interval training workout for maximum calorie burn.',
    duration: 15,
    difficulty: 'Advanced',
    category: 'HIIT',
    calories: 180,
    exercises: [exercises[5], exercises[0], exercises[3]],
  ),
  Workout(
    id: '7',
    name: 'Morning Stretch',
    imageUrl: 'assets/images/workouts/stretch.jpg',
    videoUrl: 'assets/stretch.mp4',
    description:
    'Gentle stretching routine to wake up your body and improve flexibility.',
    duration: 10,
    difficulty: 'Beginner',
    category: 'Stretching',
    calories: 50,
    exercises: [],
  ),
  Workout(
    id: '8',
    name: 'Pilates Basics',
    imageUrl: 'assets/images/workouts/pilates.jpg',
    videoUrl: 'assets/pilates.mp4',
    description:
    'Fundamental pilates exercises to strengthen your core and improve posture.',
    duration: 25,
    difficulty: 'Beginner',
    category: 'Pilates',
    calories: 120,
    exercises: [],
  ),
];

final popularWorkouts = workouts.sublist(0, 4);
final quickWorkouts = workouts.sublist(4, 8);