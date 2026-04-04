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