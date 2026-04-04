import 'package:get/get.dart';

import 'app_routes.dart';

import '../../modules/splash/views/splash_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';

import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/auth/views/setup_profile_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';

import '../../modules/navigation/views/main_navigation_view.dart';

import '../../modules/profile/views/profile_view.dart';
import '../../modules/profile/views/settings_view.dart';
import '../../modules/profile/views/account_settings_view.dart';
import '../../modules/profile/views/academic_profile_view.dart';
import '../../modules/profile/views/appearance_view.dart';

import '../../modules/profile/bindings/profile_binding.dart';
import '../../modules/profile/bindings/account_settings_binding.dart';
import '../../modules/profile/bindings/academic_profile_binding.dart';
import '../../modules/profile/bindings/appearance_binding.dart';

import '../../modules/quiz/views/quiz_view.dart';
import '../../modules/quiz/bindings/quiz_binding.dart';

import '../../modules/assignment/views/assignment_view.dart';
import '../../modules/assignment/bindings/assignment_binding.dart';

import '../../modules/publication/views/upload_material_view.dart';
import '../../modules/publication/bindings/publication_binding.dart';

import '../../modules/offline/views/offline_view.dart';
import '../../modules/offline/bindings/offline_binding.dart';

import '../../modules/progress/views/progress_view.dart';
import '../../modules/progress/bindings/progress_binding.dart';

import '../../modules/collaborative/views/study_groups_view.dart';
import '../../modules/collaborative/bindings/collaborative_binding.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.setupProfile,
      page: () => const SetupProfileView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const MainNavigationView(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.quiz,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: Routes.assignment,
      page: () => const AssignmentView(),
      binding: AssignmentBinding(),
    ),
    GetPage(
      name: Routes.publication,
      page: () => const UploadMaterialView(),
      binding: PublicationBinding(),
    ),
    GetPage(
      name: Routes.offline,
      page: () => const OfflineView(),
      binding: OfflineBinding(),
    ),
    GetPage(
      name: Routes.progress,
      page: () => const ProgressView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: Routes.collaborative,
      page: () => const StudyGroupsView(),
      binding: CollaborativeBinding(),
    ),
    GetPage(
      name: Routes.accountSettings,
      page: () => const AccountSettingsView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: Routes.academicProfile,
      page: () => const AcademicProfileView(),
      binding: AcademicProfileBinding(),
    ),
    GetPage(
      name: Routes.appearance,
      page: () => const AppearanceView(),
      binding: AppearanceBinding(),
    ),
  ];
}