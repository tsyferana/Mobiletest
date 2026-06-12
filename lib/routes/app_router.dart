import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:review/views/auth/login_screen.dart';
import 'package:review/views/auth/register_screen.dart';
import 'package:review/views/auth/forgot_password_screen.dart';
import 'package:review/views/client/home_screen.dart';
import 'package:review/views/client/profile_screen.dart';
import 'package:review/views/business/business_create_screen.dart';
import 'package:review/views/business/business_dashboard_screen.dart';
import 'package:review/views/business/business_edit_screen.dart';
import 'package:review/views/business/business_statistics_screen.dart';
import 'package:review/views/business/review_management_screen.dart';
import 'package:review/views/admin/admin_dashboard_screen.dart';
import 'package:review/views/admin/user_management_screen.dart';
import 'package:review/views/admin/business_approval_screen.dart';
import 'package:review/views/admin/reports_management_screen.dart';
import 'package:review/views/admin/category_management_screen.dart';
import 'package:review/widgets/app_drawer.dart';
import 'package:review/widgets/custom_bottom_nav.dart';

// ===========================
// AUTH STATE PROVIDERS
// ===========================

/// Mock Auth State for navigation redirection
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.userRole = 'guest', // 'guest', 'client', 'business', 'admin'
    this.userId = '',
  });

  final bool isAuthenticated;
  final String userRole;
  final String userId;

  AuthState copyWith({
    bool? isAuthenticated,
    String? userRole,
    String? userId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userRole: userRole ?? this.userRole,
      userId: userId ?? this.userId,
    );
  }
}

/// Mock Auth Provider - in real app, use Firebase/API
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState());

  void loginAsClient(String userId) {
    state = state.copyWith(
      isAuthenticated: true,
      userRole: 'client',
      userId: userId,
    );
  }

  void loginAsBusiness(String userId) {
    state = state.copyWith(
      isAuthenticated: true,
      userRole: 'business',
      userId: userId,
    );
  }

  void loginAsAdmin(String userId) {
    state = state.copyWith(
      isAuthenticated: true,
      userRole: 'admin',
      userId: userId,
    );
  }

  void logout() {
    state = const AuthState();
  }
}

// ===========================
// PLACEHOLDER SCREENS
// ===========================

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text('ReviewApp', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text(
              'Découvrez les meilleurs avis',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text('Bienvenue', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 16),
            Text(
              'Explorez les entreprises et partagez vos avis',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => context.go('/login'),
              child: const Text('Commencer'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher')),
      body: Center(
        child: Text(
          'Recherche écran',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: Center(
        child: Text(
          'Favoris écran',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Center(
        child: Text(
          'Notifications écran',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class BusinessDetailScreen extends StatelessWidget {
  final String businessId;

  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détails entreprise')),
      body: Center(
        child: Text(
          'Entreprise: $businessId',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class ReviewsListScreen extends StatelessWidget {
  final String businessId;

  const ReviewsListScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Avis')),
      body: Center(
        child: Text(
          'Avis de: $businessId',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erreur')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================
// SHELL ROUTE WRAPPERS
// ===========================

/// Client Shell - with BottomNavigationBar
class ClientShell extends ConsumerStatefulWidget {
  final Widget child;

  const ClientShell({super.key, required this.child});

  @override
  ConsumerState<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends ConsumerState<ClientShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/favorites');
              break;
            case 3:
              context.go('/notifications');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
        items: const [
          CustomBottomNavItem(icon: Icons.home_rounded, label: 'Accueil'),
          CustomBottomNavItem(icon: Icons.search_rounded, label: 'Chercher'),
          CustomBottomNavItem(icon: Icons.favorite_rounded, label: 'Favoris'),
          CustomBottomNavItem(icon: Icons.notifications_rounded, label: 'Avis'),
          CustomBottomNavItem(icon: Icons.person_rounded, label: 'Profil'),
        ],
      ),
    );
  }
}

/// Business Shell - with Drawer
class BusinessShell extends StatelessWidget {
  final Widget child;

  const BusinessShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        userRole: 'business',
        userName: 'Mon Entreprise',
        userEmail: 'business@email.com',
      ),
      body: child,
    );
  }
}

/// Admin Shell - with Drawer
class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        userRole: 'admin',
        userName: 'Administrateur',
        userEmail: 'admin@email.com',
      ),
      body: child,
    );
  }
}

// ===========================
// GO ROUTER CONFIGURATION
// ===========================

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final userRole = authState.userRole;
      final location = state.uri.path;

      // Public routes accessible to all
      final publicRoutes = [
        '/splash',
        '/onboarding',
        '/login',
        '/register',
        '/forgot-password',
      ];

      // If not authenticated, redirect to login (except public routes)
      if (!isAuthenticated && !publicRoutes.contains(location)) {
        return '/login';
      }

      // If authenticated, redirect from login/register to appropriate home
      if (isAuthenticated && publicRoutes.contains(location)) {
        switch (userRole) {
          case 'client':
            return '/home';
          case 'business':
            return '/business/dashboard';
          case 'admin':
            return '/admin/dashboard';
          default:
            return '/login';
        }
      }

      // Route protection by role
      if (isAuthenticated) {
        if (location.startsWith('/admin') && userRole != 'admin') {
          return '/home';
        }
        if (location.startsWith('/business') &&
            userRole != 'business' &&
            userRole != 'admin') {
          return '/home';
        }
      }

      return null;
    },
    routes: [
      // ========================
      // PUBLIC ROUTES
      // ========================
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // ========================
      // CLIENT ROUTES
      // ========================
      ShellRoute(
        builder: (context, state, child) => ClientShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'business/:id',
                builder: (context, state) {
                  final businessId = state.pathParameters['id'] ?? '';
                  return BusinessDetailScreen(businessId: businessId);
                },
              ),
              GoRoute(
                path: 'reviews/:businessId',
                builder: (context, state) {
                  final businessId = state.pathParameters['businessId'] ?? '';
                  return ReviewsListScreen(businessId: businessId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // ========================
      // BUSINESS ROUTES
      // ========================
      ShellRoute(
        builder: (context, state, child) => BusinessShell(child: child),
        routes: [
          GoRoute(
            path: '/business/create',
            builder: (context, state) => const BusinessCreateScreen(),
          ),
          GoRoute(
            path: '/business/dashboard',
            builder: (context, state) => const BusinessDashboardScreen(),
          ),
          GoRoute(
            path: '/business/edit',
            builder: (context, state) => const BusinessEditScreen(),
          ),
          GoRoute(
            path: '/business/statistics',
            builder: (context, state) => const BusinessStatisticsScreen(),
          ),
          GoRoute(
            path: '/business/reviews',
            builder: (context, state) => const ReviewManagementScreen(),
          ),
        ],
      ),

      // ========================
      // ADMIN ROUTES
      // ========================
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const UserManagementScreen(),
          ),
          GoRoute(
            path: '/admin/approvals',
            builder: (context, state) => const BusinessApprovalScreen(),
          ),
          GoRoute(
            path: '/admin/reports',
            builder: (context, state) => const ReportsManagementScreen(),
          ),
          GoRoute(
            path: '/admin/categories',
            builder: (context, state) => const CategoryManagementScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        ErrorScreen(error: state.error.toString()),
  );
});
