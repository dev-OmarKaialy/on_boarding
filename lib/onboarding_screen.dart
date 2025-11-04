import 'package:flutter/material.dart';
import 'package:onboarding/onboarding_item_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final List<OnboardingItemModel> items = [
    OnboardingItemModel(
      title: 'Book appointment with us!',
      image: 'assets/images/image-2.png',
      description: 'What do you think? book our veterinarians now.',
    ),
    OnboardingItemModel(
      title: 'Let us give the best treatment',
      image: 'assets/images/image-1.png',
      description: 'Get the best treatment for your animal with us.',
    ),
    OnboardingItemModel(
      title: 'Find petcare around your location',
      image: 'assets/images/image-0.png',
      description: 'Just turn on your location and you will find the nearest pet care you wish.',
    ),
  ];

  final PageController pageController = PageController(initialPage: 0, keepPage: true);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Durations.extralong3);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _backgroundColorAnimation = ColorTween(
      begin: Colors.white10,
      end: Colors.white12,
    ).animate(_animationController);

    // Start animation when widget initializes
    _animationController.forward();

    // Listen to page changes
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < items.length - 1) {
      _animationController.reset();
      pageController.nextPage(duration: Durations.extralong3, curve: Curves.easeInOut).then((_) {
        _animationController.forward();
      });
    } else {
      // Navigrate to home or login screen
      print('Onboarding completed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 15,
                width: MediaQuery.widthOf(context),
                height: MediaQuery.widthOf(context),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _backgroundColorAnimation.value ?? Colors.white12,
                            blurRadius: 200,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_currentPage < items.length - 1)
                          GestureDetector(
                            onTap: () {
                              pageController.animateToPage(
                                items.length - 1,
                                duration: Durations.extralong3,
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              'Skip',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: items.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                        _animationController.reset();
                        _animationController.forward();
                      },
                      itemBuilder: (context, index) => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final pageOffset = pageController.hasClients
                                  ? (pageController.page ?? 0) - index
                                  : 0.0;

                              final rotation = pageOffset * 0.5;
                              final scale = 1 - pageOffset.abs() * 0.3;
                              final opacity = 1 - pageOffset.abs();

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..rotateY(rotation)
                                  ..scale(scale),
                                child: Opacity(opacity: opacity.clamp(0.3, 1.0), child: child),
                              );
                            },
                            child: Image.asset(
                              items[index].image,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Column(
                            children: [
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: SlideTransition(
                                      position: _slideAnimation,
                                      child: ScaleTransition(scale: _scaleAnimation, child: child),
                                    ),
                                  );
                                },
                                child: Text(
                                  items[index].title,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                                      ),
                                    ),
                                    child: SlideTransition(
                                      position:
                                          Tween<Offset>(
                                            begin: const Offset(0.0, 0.3),
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(
                                              parent: _animationController,
                                              curve: const Interval(
                                                0.5,
                                                1.0,
                                                curve: Curves.easeOut,
                                              ),
                                            ),
                                          ),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    items[index].description,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmoothPageIndicator(
                        effect: ExpandingDotsEffect(
                          dotWidth: 8,
                          dotHeight: 8,
                          expansionFactor: 4,
                          activeDotColor: Colors.white,
                          spacing: 10,
                          dotColor: Colors.white60,
                        ),
                        controller: pageController,
                        count: items.length,
                      ),

                      AnimatedContainer(
                        duration: Durations.medium1,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(
                            fixedSize: Size(70, 70),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _goToNextPage,
                          icon: const Icon(Icons.arrow_forward_sharp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Add this import for math functions
