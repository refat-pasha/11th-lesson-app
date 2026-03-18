import '../../data/models/account_model.dart';
import '../../data/models/assignment_model.dart';
import '../../data/models/course_model.dart';
import '../../data/models/group_model.dart';
import '../../data/models/material_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/settings_model.dart';

class DemoData {
  static final student = UserModel(
    id: 'preview-user',
    name: 'Shoeb Nafiz',
    email: 'student@11thlesson.app',
    role: 'student',
    enrolledCourses: const ['cse221', 'cse341', 'math301'],
    createdAt: DateTime(2026, 1, 1),
    xp: 2820,
    streak: 12,
    achievements: const ['Consistency', 'Quiz Master', 'Top Contributor'],
    university: 'DIU',
    department: 'CSE',
    semester: '11th',
    program: 'B.Sc in CSE',
    batch: '63_J',
    subjects: const ['Data Structures', 'Algorithms', 'Statistics'],
    totalCourse: 3,
  );

  static final teacher = UserModel(
    id: 'teacher-1',
    name: 'Tasnim Rahman',
    email: 'teacher@11thlesson.app',
    role: 'teacher',
    enrolledCourses: const ['cse221', 'cse341'],
    createdAt: DateTime(2026, 1, 1),
    xp: 4100,
    streak: 18,
    achievements: const ['Mentor', 'Publisher'],
    university: 'DIU',
    department: 'CSE',
    semester: 'Faculty',
    program: 'Faculty',
    batch: 'CSE',
    subjects: const ['Data Structures', 'Algorithms'],
    totalCourse: 2,
  );

  static final admin = UserModel(
    id: 'admin-1',
    name: 'System Admin',
    email: 'admin@11thlesson.app',
    role: 'admin',
    enrolledCourses: const ['cse221', 'cse341', 'math301'],
    createdAt: DateTime(2026, 1, 1),
    xp: 5200,
    streak: 30,
    achievements: const ['Moderator', 'Operations'],
    university: 'DIU',
    department: 'ICT',
    semester: 'Admin',
    program: 'Admin',
    batch: 'Ops',
    subjects: const ['Operations', 'Analytics'],
    totalCourse: 3,
  );

  static final accounts = [
    const AccountModel(
      userId: 'preview-user',
      email: 'student@11thlesson.app',
      password: 'student123',
      role: 'student',
    ),
    const AccountModel(
      userId: 'teacher-1',
      email: 'teacher@11thlesson.app',
      password: 'teacher123',
      role: 'teacher',
    ),
    const AccountModel(
      userId: 'admin-1',
      email: 'admin@11thlesson.app',
      password: 'admin123',
      role: 'admin',
    ),
  ];

  static List<UserModel> get users => [student, teacher, admin];
  static UserModel get user => student;

  static final courses = [
    CourseModel(
      id: 'cse221',
      title: 'Data Structures',
      code: 'CSE 221',
      description: 'Stacks, queues, trees, graphs, and practical problem solving.',
      teacherId: 'teacher-1',
      createdAt: DateTime(2026, 1, 5),
    ),
    CourseModel(
      id: 'cse341',
      title: 'Algorithm Design',
      code: 'CSE 341',
      description: 'Greedy, dynamic programming, divide-and-conquer, and complexity.',
      teacherId: 'teacher-1',
      createdAt: DateTime(2026, 1, 6),
    ),
    CourseModel(
      id: 'math301',
      title: 'Probability and Statistics',
      code: 'MATH 301',
      description: 'Distributions, sampling, inference, and academic analytics.',
      teacherId: 'teacher-1',
      createdAt: DateTime(2026, 1, 7),
    ),
  ];

  static final assignments = [
    AssignmentModel(
      id: 'asg-1',
      title: 'Binary Search Tree Lab',
      description: 'Implement insertion, deletion, and traversal operations.',
      courseId: 'cse221',
      dueDate: DateTime(2026, 3, 28),
      createdAt: DateTime(2026, 3, 12),
      createdBy: 'teacher-1',
      submissionText: 'GitHub link: https://example.com/bst-lab',
      submittedAt: DateTime(2026, 3, 14),
      score: 84,
      feedback: 'Good recursion. Improve delete case handling.',
    ),
    AssignmentModel(
      id: 'asg-2',
      title: 'Dynamic Programming Set',
      description: 'Solve five optimization problems and justify transitions.',
      courseId: 'cse341',
      dueDate: DateTime(2026, 3, 30),
      createdAt: DateTime(2026, 3, 10),
      createdBy: 'teacher-1',
    ),
    AssignmentModel(
      id: 'asg-3',
      title: 'Sampling Distribution Worksheet',
      description: 'Summarize CLT intuition with two worked problems.',
      courseId: 'math301',
      dueDate: DateTime(2026, 3, 25),
      createdAt: DateTime(2026, 3, 11),
      createdBy: 'teacher-1',
    ),
  ];

  static final groups = [
    GroupModel(
      id: 'grp-1',
      name: 'Trees Study Circle',
      subject: 'CSE 221',
      description: 'Weekly review of trees, heaps, and recursion patterns.',
      createdBy: 'preview-user',
      members: const ['preview-user', 'u2', 'u3'],
      createdAt: DateTime(2026, 2, 18),
      resourceLinks: const ['BST cheat sheet', 'Tree traversal notes'],
      messages: [
        GroupMessageModel(
          author: 'Shoeb Nafiz',
          body: 'Can we revise deletion cases tonight?',
          sentAt: DateTime(2026, 3, 18, 20, 0),
        ),
      ],
    ),
    GroupModel(
      id: 'grp-2',
      name: 'Algo Sprint Team',
      subject: 'CSE 341',
      description: 'Timed practice for greedy and DP contest problems.',
      createdBy: 'u4',
      members: const ['preview-user', 'u4'],
      createdAt: DateTime(2026, 2, 25),
      resourceLinks: const ['Knapsack revision plan'],
      messages: [
        GroupMessageModel(
          author: 'Rafi',
          body: 'Posting a fresh problem set after class.',
          sentAt: DateTime(2026, 3, 18, 16, 30),
        ),
      ],
    ),
  ];

  static final materials = [
    MaterialModel(
      id: 'mat-1',
      title: 'Binary Tree Final Revision',
      description: 'Condensed notes for exam-night revision with examples.',
      courseId: 'cse221',
      uploadedBy: 'teacher-1',
      fileUrl: 'local://binary-tree-final-revision.pdf',
      fileType: 'pdf',
      isPublic: true,
      createdAt: DateTime(2026, 3, 10),
      category: 'Lecture Notes',
      fileName: 'binary_tree_revision.pdf',
      tags: const ['trees', 'exam prep'],
      visibility: 'My Courses',
      isOffline: true,
      downloadCount: 120,
      sizeMb: 6,
    ),
    MaterialModel(
      id: 'mat-2',
      title: 'Dynamic Programming Patterns',
      description: 'Pattern-based breakdown of 0/1 knapsack, LIS, and state design.',
      courseId: 'cse341',
      uploadedBy: 'teacher-1',
      fileUrl: 'local://dp-patterns.pdf',
      fileType: 'pdf',
      isPublic: true,
      createdAt: DateTime(2026, 3, 9),
      category: 'Exam Prep',
      fileName: 'dp_patterns.pdf',
      tags: const ['dp', 'patterns'],
      visibility: 'Public',
      downloadCount: 96,
      sizeMb: 8,
    ),
    MaterialModel(
      id: 'mat-3',
      title: 'Statistics One-Shot Summary',
      description: 'Distributions, hypothesis testing, and likely viva questions.',
      courseId: 'math301',
      uploadedBy: 'teacher-1',
      fileUrl: 'local://statistics-summary.pdf',
      fileType: 'pdf',
      isPublic: true,
      createdAt: DateTime(2026, 3, 8),
      category: 'Slides',
      fileName: 'statistics_summary.pdf',
      tags: const ['statistics', 'summary'],
      visibility: 'My Courses',
      downloadCount: 78,
      sizeMb: 5,
    ),
  ];

  static final quiz = QuizModel(
    id: 'quiz-1',
    title: 'CSE 221 Demo Quiz',
    courseId: 'cse221',
    createdBy: 'teacher-1',
    durationMinutes: 12,
    totalQuestions: 4,
    allowRetake: true,
    createdAt: DateTime(2026, 3, 1),
    description: 'Quick exam-prep quiz focused on trees and complexity.',
  );

  static final questions = [
    QuestionModel(
      id: 'q1',
      quizId: 'quiz-1',
      question: 'Which traversal of a BST returns values in sorted order?',
      options: const ['Preorder', 'Inorder', 'Postorder', 'Level order'],
      correctIndex: 1,
      explanation: 'Inorder traversal visits BST nodes in sorted order.',
      createdAt: DateTime(2026, 3, 1),
    ),
    QuestionModel(
      id: 'q2',
      quizId: 'quiz-1',
      question: 'What is the worst-case height of an unbalanced BST with n nodes?',
      options: const ['log n', 'sqrt(n)', 'n', 'n log n'],
      correctIndex: 2,
      explanation: 'A skewed BST degrades to a linked list of height n.',
      createdAt: DateTime(2026, 3, 1),
    ),
    QuestionModel(
      id: 'q3',
      quizId: 'quiz-1',
      question: 'Which data structure is best suited for BFS?',
      options: const ['Stack', 'Queue', 'Heap', 'Hash map'],
      correctIndex: 1,
      explanation: 'Breadth-first traversal processes nodes FIFO.',
      createdAt: DateTime(2026, 3, 1),
    ),
    QuestionModel(
      id: 'q4',
      quizId: 'quiz-1',
      question: 'Which DP property justifies reusing previous subproblem answers?',
      options: const [
        'Greedy choice',
        'Overlapping subproblems',
        'Binary partitioning',
        'Lazy evaluation'
      ],
      correctIndex: 1,
      explanation: 'Dynamic programming relies on overlapping subproblems.',
      createdAt: DateTime(2026, 3, 1),
    ),
  ];

  static const courseProgress = {
    'cse221': 0.72,
    'cse341': 0.58,
    'math301': 0.84,
  };

  static const notifications = [
    'Your BST Lab was graded with 84/100.',
    'New material published: Dynamic Programming Patterns.',
    'Trees Study Circle has a new discussion message.',
  ];

  static const settings = SettingsModel(
    deadlineReminders: true,
    autoDownload: false,
    streakAlerts: true,
    darkMode: true,
    language: 'English',
    dailyGoalMinutes: 90,
    storageUsedMb: 180,
    storageLimitMb: 512,
  );
}
