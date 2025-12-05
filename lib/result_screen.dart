import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage = (score / totalQuestions) * 100;
    final bool isSuccess = percentage >= 70;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSuccess
                ? [Colors.teal.shade400, Colors.green.shade600]
                : [Colors.orange.shade400, Colors.red.shade600],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre animé et moderne
                Text(
                  'Quiz Terminé !',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Grand cercle du pourcentage (super cute et pro)
                Container(
                  height: 220,
                  width: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white, width: 8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$score / $totalQuestions',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Message personnalisé très doux
                Text(
                  isSuccess
                      ? 'Bravo Oumaima !'
                      : 'Presque là !',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isSuccess
                      ? 'Tu as excellé, continue comme ça !'
                      : 'Un peu d’entraînement et ce sera parfait !',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),

                // Bouton Rejouer magnifique
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 32),
                  label: const Text(
                    'Rejouer',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 20,
                    shadowColor: Colors.black.withOpacity(0.4),
                  ),
                ),
                const SizedBox(height: 50),

                // Signature discrète mais élégante
                const Text(
                  '© 2025 HAMMAMI Oumaima - ESEN Manouba',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}