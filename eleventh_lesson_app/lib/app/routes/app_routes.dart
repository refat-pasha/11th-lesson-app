// lib/app/routes/app_routes.dart

abstract class Routes {
  Routes._();

  static const splash = '/splash';

  static const login = '/login';
  static const register = '/register';
  static const setupProfile = '/setup-profile';

  static const dashboard = '/dashboard';

  static const assignment = '/assignment';
  static const quiz = '/quiz';
  static const publication = '/publication';
  static const collaborative = '/collaborative';

  static const offline = '/offline';
  static const progress = '/progress';

  static const profile = '/profile';
  static const settings = '/settings';
  static const accountSettings = '/account-settings';
  static const academicProfile = '/academic-profile';
  static const appearance = '/appearance';
}