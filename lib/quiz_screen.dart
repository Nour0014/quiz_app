import 'dart:async';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'question.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  List<Question> _questions = [];
  List<Question> _shuffledQuestions = [];
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _canPressNext = false;
  Timer? _timer;
  int _secondsLeft = 10;

  late AnimationController _timerAnimationController;
  late Animation<double> _timerAnimation;

  @override
  void initState() {
    super.initState();
    _timerAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _timerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_timerAnimationController);
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await DatabaseHelper.instance.getQuestions();
    setState(() {
      _questions = questions;
      _shuffledQuestions = List.from(questions)..shuffle();
      if (_shuffledQuestions.isNotEmpty) {
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _secondsLeft = 10;
    _timerAnimationController.reset();
    _timerAnimationController.forward();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        _nextQuestion(auto: true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _selectAnswer(String answer) {
    if (_isAnswered) return;
    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
      _canPressNext = true;
      if (answer == _shuffledQuestions[_currentIndex].answer) _score++;
    });
  }

  void _nextQuestion({bool auto = false}) {
    _timer?.cancel();
    _timerAnimationController.stop();

    if (_currentIndex < _shuffledQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
        _canPressNext = false;
      });
      _startTimer();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(score: _score, totalQuestions: _shuffledQuestions.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_shuffledQuestions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final current = _shuffledQuestions[_currentIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 1. HEADER (Fixed at top)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Question ${_currentIndex + 1}/${_shuffledQuestions.length}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Score: $_score', style: const TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. SCROLLABLE CONTENT (Takes all available space)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Timer
                        AnimatedBuilder(
                          animation: _timerAnimation,
                          builder: (context, child) {
                            return SizedBox(
                              height: 100,
                              width: 100,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: _timerAnimation.value,
                                    strokeWidth: 8,
                                    backgroundColor: Colors.white24,
                                    valueColor: AlwaysStoppedAnimation(_secondsLeft <= 3 ? Colors.red : Colors.white),
                                  ),
                                  Text('$_secondsLeft', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),

                        // Question Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, 10))],
                          ),
                          child: Text(
                            current.question,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Options List
                        ...current.options.map((option) {
                          final isSelected = option == _selectedAnswer;
                          final isCorrect = option == current.answer;
                          Color? backgroundColor;
                          Color? textColor = Colors.black87;

                          if (_isAnswered) {
                            if (isCorrect) backgroundColor = Colors.green.shade400;
                            if (isSelected && !isCorrect) backgroundColor = Colors.red.shade400;
                            if (isCorrect || (isSelected && !isCorrect)) textColor = Colors.white;
                          } else if (isSelected) {
                            backgroundColor = Colors.blue.shade100;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Material(
                              borderRadius: BorderRadius.circular(16),
                              color: backgroundColor ?? Colors.white,
                              elevation: isSelected ? 12 : 6,
                              child: ListTile(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                leading: _isAnswered
                                    ? Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: textColor)
                                    : null,
                                title: Text(option, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor)),
                                onTap: () => _selectAnswer(option),
                              ),
                            ),
                          );
                        }).toList(),

                        // Add a little bottom padding so options don't touch the button immediately
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // 3. FOOTER (Fixed at bottom)
                // NOTE: Spacer() was removed from here

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canPressNext ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.indigo.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 15,
                      shadowColor: Colors.indigo,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_forward_ios, size: 28),
                        SizedBox(width: 12),
                        Text('Suivant', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Signature
                const Text('© 2025 HAMMAMI Oumaima - ESEN Manouba',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }}