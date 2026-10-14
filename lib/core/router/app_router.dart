import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:aoun_client/feature/main/contracts/data/model/contract_model.dart';
import 'package:aoun_client/feature/main/contracts/presentation/screens/contract_details_screen.dart';

import '../../feature/intro/onboarding/onboarding_screen.dart';
import '../../feature/intro/splash/splash_screen.dart';
import '../../feature/auth/presentation/screens/forget_password_screen.dart';
import '../../feature/auth/presentation/screens/login_screen.dart';
import '../../feature/auth/presentation/screens/new_password_screen.dart';
import '../../feature/auth/presentation/screens/otp_screen.dart';
import '../../feature/auth/presentation/screens/success_screen.dart';
import '../../feature/main/home/presentation/screens/home_screen.dart';
import '../../feature/main/home/presentation/screens/main_screen.dart';
import '../../feature/main/contracts/presentation/screens/contracts_screen.dart';
import '../../feature/main/payments/presentation/screens/payment_screen.dart';
import '../../feature/main/catalog/presentation/widget/widgets.dart';
import '../../feature/main/statement/presentation/screens/statement_screen.dart';
import '../../feature/main/profile/presentation/screens/profile_screen.dart';

abstract class AppRouter {
  static const String root = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String initialRoot = '/home';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String forgetPassword = '/forgot-password';
  static const String newPassword = '/new-password';
  static const String registerStep1 = '/register/step1';
  static const String registerOtp = '/register/otp';
  static const String registerStep2 = '/register/step2';
  static const String successPassword = '/success/password';
  static const String successRegister = '/success/register';
  static const String home = '/home';
  static const String contracts = '/contracts';
  static const String contractDetail = '/contracts/:id';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment/success';
  static const String catalog = '/catalog';
  static const String cart = '/catalog/cart';
  static const String orderSuccess = '/catalog/order-success';
  static const String statement = '/statement';
  static const String profile = '/profile';

  // Legacy aliases
  static const String register = registerStep1;

  static Page<dynamic> _cupertino(GoRouterState state, Widget child) =>
      CupertinoPage<dynamic>(key: state.pageKey, child: child);

  // ─── Router ──────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        pageBuilder: (_, state) => _cupertino(state, const SplashScreen()),
      ),
      GoRoute(
        path: onboarding,
        pageBuilder: (_, state) => _cupertino(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: login,
        pageBuilder: (_, state) => _cupertino(state, const LoginScreen()),
      ),
      GoRoute(
        path: otp,
        pageBuilder: (_, state) => _cupertino(
          state,
          OtpScreen(
            phone: state.uri.queryParameters['phone'] ?? '',
            type: state.uri.queryParameters['type'] ?? 'login',
          ),
        ),
      ),
      GoRoute(
        path: forgetPassword,
        pageBuilder: (_, state) =>
            _cupertino(state, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: newPassword,
        pageBuilder: (_, state) => _cupertino(state, const NewPasswordScreen()),
      ),
      GoRoute(
        path: successPassword,
        pageBuilder: (_, state) => _cupertino(
          state,
          const SuccessScreen(
            title: 'auth.password_updated',
            subtitle: '',
            buttonLabel: 'auth.log_in',
            nextRoute: login,
            color: 0xFF3B6D11,
          ),
        ),
      ),
      GoRoute(
        path: successRegister,
        pageBuilder: (_, state) => _cupertino(
          state,
          const SuccessScreen(
            title: 'auth.account_created',
            subtitle: '',
            buttonLabel: 'catalog.continue_shopping',
            nextRoute: home,
            color: 0xFF3B6D11,
          ),
        ),
      ),

      // Main app with bottom-nav shell
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            pageBuilder: (_, state) => _cupertino(state, const HomeScreen()),
          ),
          GoRoute(
            path: contracts,
            pageBuilder: (_, state) => _cupertino(state, ContractsScreen()),
          ),
          GoRoute(
            path: contractDetail,
            pageBuilder: (_, state) => _cupertino(
              state,
              ContractDetailScreen(
                id: int.tryParse(state.pathParameters['id'] ?? '0') ?? 0,
                contract: state.extra as ContractModel?,
              ),
            ),
          ),
          GoRoute(
            path: payment,
            pageBuilder: (_, state) => _cupertino(
              state,
              PaymentScreen(
                contractId: int.tryParse(
                  state.uri.queryParameters['contract'] ?? '',
                ),
              ),
            ),
          ),
          GoRoute(
            path: paymentSuccess,
            pageBuilder: (_, state) =>
                _cupertino(state, const PaymentSuccessScreen()),
          ),
          GoRoute(
            path: catalog,
            pageBuilder: (_, state) => _cupertino(state, const CatalogScreen()),
          ),
          GoRoute(
            path: cart,
            pageBuilder: (_, state) =>
                _cupertino(state, const CartDetailsScreen()),
          ),
          GoRoute(
            path: orderSuccess,
            pageBuilder: (_, state) =>
                _cupertino(state, const OrderSuccessScreen()),
          ),
          GoRoute(
            path: statement,
            pageBuilder: (_, state) =>
                _cupertino(state, const StatementScreen()),
          ),
          GoRoute(
            path: profile,
            pageBuilder: (_, state) => _cupertino(state, const ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}
