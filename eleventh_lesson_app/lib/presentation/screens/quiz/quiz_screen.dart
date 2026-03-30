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

class _QuizScreenState extends State<QuizScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final prov = context.read<QuizProvider>();
    if (prov.activeQuiz == null) {
      prov.startQuiz('q1');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) context.read<QuizProvider>().tickTimer();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<QuizProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _stopTimer();
                      prov.reset();
                      context.pop();
                    },
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: AppTheme.s1,
                          shape: BoxShape.circle, border: Border.all(color: AppTheme.border)),
                      child: const Center(child: Text('←',
                          style: TextStyle(fontSize: 18, color: AppTheme.t1))),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(prov.activeQuiz?.title ?? 'Quiz',
                          style: AppText.h3()),
                    ),
                  ),
                  if (prov.activeQuiz != null)
                    Text(prov.activeQuiz!.course,
                        style: const TextStyle(fontSize: 11, color: AppTheme.t3)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Body
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
  Widget _buildBody(BuildContext context, QuizProvider prov) {
    if (prov.activeQuiz == null) {
      return _QuizPicker(onStart: (id) {
        prov.startQuiz(id);
      });
    }
    switch (prov.state) {
      case QuizState.intro:
        return _QuizIntro(
          quiz: prov.activeQuiz!,
          onStart: () {
            prov.beginQuiz();
            _startTimer();
          },
        );
      case QuizState.inProgress:
      case QuizState.reviewing:
        return _QuizQuestion(
          quiz: prov.activeQuiz!,
          questionIndex: prov.currentQuestionIndex,
          selectedAnswers: prov.selectedAnswers,
          state: prov.state,
          timeRemaining: prov.timeRemaining,
          onSelect: (i) => prov.selectAnswer(i),
          onSubmit: () {
            final correct = prov.submitCurrentAnswer();
            if (prov.isLastQuestion) _stopTimer();
            return correct;
          },
          onNext: () {
            if (prov.isLastQuestion) {
              _stopTimer();
              prov.finishQuiz();
            } else {
              prov.nextQuestion();
            }
          },
          formatTime: _formatTime,
        );
      case QuizState.results:
        return _QuizResults(
          quiz: prov.activeQuiz!,
          attempt: prov.lastAttempt!,
          onRetry: () {
            prov.startQuiz(prov.activeQuiz!.id);
          },
          onDone: () {
            prov.reset();
            context.pop();
          },
        );
    }
  }
}

// ── QUIZ PICKER ──
class _QuizPicker extends StatelessWidget {
  final void Function(String id) onStart;
  const _QuizPicker({required this.onStart});

  @override
  Widget build(BuildContext context) {
    final quizzes = context.read<QuizProvider>().quizzes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available Quizzes', style: AppText.h2()),
        const SizedBox(height: 16),
        ...quizzes.map((q) => GlassCard(
          padding: const EdgeInsets.all(16),
          onTap: () => onStart(q.id),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: AppTheme.brandD,
                    borderRadius: BorderRadius.circular(12)),
                child: const Center(child: Text('🎯', style: TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(q.title, style: AppText.h4()),
                    Text('${q.course} · ${q.totalQuestions} questions',
                        style: AppText.caption()),
                  ],
                ),
              ),
              SmallButton(label: 'Start →', onTap: () => onStart(q.id)),
            ],
          ),
        ).toList()..addAll([const SizedBox(height: 10)]),
      ],
    );
  }
}

// ── INTRO ──
class _QuizIntro extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onStart;
  const _QuizIntro({required this.quiz, required this.onStart});
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('🎯', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(quiz.title, style: AppText.h2(), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('${quiz.course} · ${quiz.totalQuestions} Questions · ~10 minutes',
              style: AppText.caption(), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: StatTile(icon: '❓', value: '${quiz.totalQuestions}', label: 'Questions')),
              const SizedBox(width: 10),
              Expanded(child: StatTile(icon: '⏱', value: '10', label: 'Min')),
              const SizedBox(width: 10),
              Expanded(child: StatTile(icon: '🎯', value: '80%', label: 'Pass')),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.amberD,
              borderRadius: BorderRadius.circular(AppTheme.rSm),
              border: Border.all(color: AppTheme.amber.withOpacity(0.2)),
            ),
            child: const Text(
              '⚠️ Timer starts when you begin. You cannot go back to previous questions.',
              style: TextStyle(fontSize: 12, color: AppTheme.amber, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Start Quiz →', onTap: onStart),
        ],
      ),
    );
  }
}

// ── QUESTION ──
class _QuizQuestion extends StatelessWidget {
  final QuizModel quiz;
  final int questionIndex;
  final List<int?> selectedAnswers;
  final QuizState state;
  final int timeRemaining;
  final void Function(int) onSelect;
  final bool Function() onSubmit;
  final VoidCallback onNext;
  final String Function(int) formatTime;

  const _QuizQuestion({
    required this.quiz, required this.questionIndex, required this.selectedAnswers,
    required this.state, required this.timeRemaining, required this.onSelect,
    required this.onSubmit, required this.onNext, required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final q = quiz.questions[questionIndex];
    final selected = selectedAnswers[questionIndex];
    final reviewed = state == QuizState.reviewing;
    return Column(
      children: [
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${questionIndex + 1} of ${quiz.totalQuestions}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                        color: AppTheme.t3, letterSpacing: 0.5),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                    decoration: BoxDecoration(
                      color: timeRemaining <= 60 ? AppTheme.redD : AppTheme.s2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: timeRemaining <= 60
                              ? AppTheme.red.withOpacity(0.2) : AppTheme.border),
                    ),
                    child: Text('⏱ ${formatTime(timeRemaining)}',
                        style: TextStyle(
                            fontFamily: 'BricolageGrotesque', fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: timeRemaining <= 60 ? AppTheme.red : AppTheme.t1)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: (questionIndex + 1) / quiz.totalQuestions,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.brand),
                  minHeight: 3,
                ),
              ),
              const SizedBox(height: 14),
              Text(q.question,
                  style: const TextStyle(fontFamily: 'BricolageGrotesque',
                      fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.t1, height: 1.45)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Options
        ...q.options.asMap().entries.map((e) {
          final i = e.key;
          final opt = e.value;
          final isSelected = selected == i;
          final isCorrect = reviewed && i == q.correctIndex;
          final isWrong = reviewed && isSelected && i != q.correctIndex;

          Color bg = AppTheme.s1;
          Color border = AppTheme.border;
          Color textColor = AppTheme.t2;

          if (isCorrect) {
            bg = AppTheme.greenD;
            border = AppTheme.green.withOpacity(0.4);
            textColor = AppTheme.green;
          } else if (isWrong) {
            bg = AppTheme.redD;
            border = AppTheme.red.withOpacity(0.3);
            textColor = AppTheme.red;
          } else if (isSelected && !reviewed) {
            bg = AppTheme.brandD;
            border = AppTheme.brand.withOpacity(0.4);
            textColor = AppTheme.t1;
          }