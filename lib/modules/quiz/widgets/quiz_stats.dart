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