import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _hasSeenOnboardingKey = 'hasSeenOnboarding';

  final _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      icon: Icons.explore_rounded,
      title: 'Découvrez',
      description: 'Trouvez rapidement des services locaux près de vous.',
    ),
    _OnboardingSlide(
      icon: Icons.verified_rounded,
      title: 'Avis vérifiés',
      description: 'Lisez et donnez des avis fiables pour choisir sereinement.',
    ),
    _OnboardingSlide(
      icon: Icons.favorite_rounded,
      title: 'Favoris',
      description: 'Sauvegardez vos lieux préférés et retrouvez-les facilement.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_hasSeenOnboardingKey, true);

    if (!mounted) return;

    context.go('/login');
  }

  Future<void> _goToNextPage() async {
    if (_currentPage == _slides.length - 1) {
      await _finishOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: 360.ms,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('Passer'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemBuilder: (context, index) {
                  return _OnboardingSlideView(
                    slide: _slides[index],
                    isActive: index == _currentPage,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: _PageDots(
                      currentPage: _currentPage,
                      pageCount: _slides.length,
                    ),
                  ),
                  FilledButton(
                    onPressed: _goToNextPage,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(132, 52),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: Text(
                      _currentPage == _slides.length - 1
                          ? 'Commencer'
                          : 'Suivant',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({
    required this.slide,
    required this.isActive,
  });

  final _OnboardingSlide slide;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 148,
            height: 148,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.icon,
              color: colorScheme.onPrimaryContainer,
              size: 72,
            ),
          )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(duration: 420.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
                duration: 420.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(duration: 360.ms)
              .slideX(
                begin: 0.12,
                end: 0,
                duration: 360.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Text(
              slide.description,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          )
              .animate(target: isActive ? 1 : 0)
              .fadeIn(duration: 360.ms, delay: 90.ms)
              .slideX(
                begin: 0.12,
                end: 0,
                duration: 360.ms,
                curve: Curves.easeOutCubic,
              ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({
    required this.currentPage,
    required this.pageCount,
  });

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: 250.ms,
          curve: Curves.easeOutCubic,
          width: isActive ? 28 : 9,
          height: 9,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
