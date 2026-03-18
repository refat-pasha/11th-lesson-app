// ignore_for_file: constant_identifier_names

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
import '../../modules/profile/bindings/profile_binding.dart';

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
import '../../modules/profile/views/account_settings_view.dart';
import '../../modules/profile/views/academic_profile_view.dart';
import '../../modules/profile/views/appearance_view.dart';
import '../../modules/profile/bindings/academic_profile_binding.dart';
import '../../modules/profile/bindings/account_settings_binding.dart';

import '../../modules/profile/bindings/appearance_binding.dart';


class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SETUP_PROFILE,
      page: () => const SetupProfileView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const MainNavigationView(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.QUIZ,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: Routes.ASSIGNMENT,
      page: () => const AssignmentView(),
      binding: AssignmentBinding(),
    ),
    GetPage(
      name: Routes.PUBLICATION,
      page: () => const UploadMaterialView(),
      binding: PublicationBinding(),
    ),
    GetPage(
      name: Routes.OFFLINE,
      page: () => const OfflineView(),
      binding: OfflineBinding(),
    ),
    GetPage(
      name: Routes.PROGRESS,
      page: () => const ProgressView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: Routes.COLLABORATIVE,
      page: () => const StudyGroupsView(),
      binding: CollaborativeBinding(),
    ),
    GetPage(
      name: Routes.ACCOUNT_SETTINGS,
      page: () => const AccountSettingsView(),
      binding: AccountSettingsBinding(),
    ),
    GetPage(
      name: Routes.ACADEMIC_PROFILE,
      page: () => const AcademicProfileView(),
      binding: AcademicProfileBinding(),
    ),
    GetPage(
      name: Routes.APPEARANCE,
      page: () => const AppearanceView(),
      binding: AppearanceBinding(),
    ),
  ];
}
