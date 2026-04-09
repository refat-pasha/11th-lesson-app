import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/quiz_provider.dart';
import '../../../data/models/quiz_model.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/common/app_widgets.dart';


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Delay provider access until the first frame is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = context.read<QuizProvider>();

      // Start a quiz only if there is no active quiz
      if (prov.activeQuiz == null) {
        prov.startQuiz('q1');
      }

      // Start timer after quiz is initialized
      _startTimer();
    });
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
    super.dispose();
  }

  /// Handles app lifecycle changes.
  /// Stops timer when app is inactive or in background.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      _startTimer();
    }
  }

  /// Starts the countdown timer.
  void _startTimer() {
    if (_timerStarted) return;

    _timer?.cancel();
    _timerStarted = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      final prov = context.read<QuizProvider>();

      // Call provider method every second
      prov.tickTimer();

      // Optional: stop timer automatically if time is over
      if (prov.remainingSeconds <= 0) {
        _stopTimer();

        // If you have a submit function, you can call it here
        // prov.submitQuiz();
      }
    });
  }

/// Stops the timer safely.
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _timerStarted = false;
  }

  /// Formats seconds into mm:ss
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  /// Handles back navigation with confirmation dialog
  Future<void> _handleExitQuiz(BuildContext context, QuizProvider prov) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.s1,
          title: const Text(
            'Exit Quiz?',
            style: TextStyle(color: AppTheme.t1),
          ),
          content: const Text(
            'Your current quiz progress may be lost. Do you want to exit?',
            style: TextStyle(color: AppTheme.t2),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );

if (shouldExit == true && mounted) {
      _stopTimer();
      prov.reset();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<QuizProvider>();
    final quiz = prov.activeQuiz;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: quiz == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  _buildTopBar(context, prov, quiz),
                  const SizedBox(height: 8),
                  _buildQuizInfoCard(prov),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: _buildBody(context, prov),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// Top app bar section
  Widget _buildTopBar(
      BuildContext context, QuizProvider prov, QuizModel quiz) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _handleExitQuiz(context, prov),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.s1,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border),
              ),
              child: const Center(
                child: Text(
                  '←',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.t1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                quiz.title,
                style: AppText.h3(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Text(
            quiz.course,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.t3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Quiz info card section
  Widget _buildQuizInfoCard(QuizProvider prov) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.s1,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoItem(
            label: 'Question',
            value:
                '${prov.currentQuestionIndex + 1}/${prov.activeQuiz?.questions.length ?? 0}',
          ),
          _buildInfoItem(
            label: 'Time Left',
            value: _formatTime(prov.remainingSeconds),
          ),
          _buildInfoItem(
            label: 'Answered',
            value: '${prov.answers.length}',
          ),
        ],
      ),
    );
  }

  /// Reusable small info widget
  Widget _buildInfoItem({
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.t3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.t1,
          ),
        ),
      ],
    );
  }

  /// Main quiz body
  Widget _buildBody(BuildContext context, QuizProvider prov) {
    final quiz = prov.activeQuiz;

    if (quiz == null || quiz.questions.isEmpty) {
      return const Center(
        child: Text(
          'No quiz available.',
          style: TextStyle(color: AppTheme.t2, fontSize: 16),
        ),
      );
    }

    final question = quiz.questions[prov.currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.s1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${prov.currentQuestionIndex + 1}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.t3,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppTheme.t1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Options
        ...List.generate(question.options.length, (index) {
          final option = question.options[index];
          final selectedAnswer = prov.answers[question.id];
          final isSelected = selectedAnswer == option;

          return GestureDetector(
            onTap: () {
              prov.selectAnswer(question.id, option);
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.s1,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.border,
                  width: 1.2,
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.white : AppTheme.t1,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 12),

        // Navigation buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: prov.currentQuestionIndex > 0
                    ? () => prov.previousQuestion()
                    : null,
                child: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final isLastQuestion = prov.currentQuestionIndex ==
                      quiz.questions.length - 1;

                  if (isLastQuestion) {
                    _stopTimer();

                    // Replace this with your result route if needed
                    // prov.submitQuiz();
                    // context.push('/quiz-result');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Quiz submitted successfully'),
                      ),
                    );
                  } else {
                    prov.nextQuestion();
                  }
                },
                child: Text(
                  prov.currentQuestionIndex == quiz.questions.length - 1
                      ? 'Submit'
                      : 'Next',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}