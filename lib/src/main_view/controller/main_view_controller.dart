import 'package:flutter/material.dart';

class MainViewController extends ChangeNotifier {
  bool _isMenuOpened = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _scaleAnimation;
  late PageController _pageController;
  int _initialPage = 0;
bool  get isMenuOpened => _isMenuOpened;
  get animationController => _animationController;
  get animation => _animation;
  get scaleAnimation => _scaleAnimation;
  get pageController => _pageController;
  get initialPage => _initialPage;

  //initialization for animations between the main and menu views
  void init(
      {required void Function() setState, required TickerProvider vsync}) {
    _animationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 250))
      ..addListener(
        () {
          setState();
        },
      );

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    ));
    _scaleAnimation = Tween<double>(begin: 1, end: .8).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    ));
  }

  //initialization for pageview builder of the home view
  void initIt({required void Function() setState}) {
    _pageController = PageController(initialPage: _initialPage)
      ..addListener(
        () {
          setState();
        },
      );
  }

  //switch btn pages
  void updatePage(int page) {
    _pageController.jumpToPage(page);
    _initialPage = page;
    notifyListeners();
    toggleMenuOpened();
  }

  //close or open the side menu view
  toggleMenuOpened() {
    if (_isMenuOpened) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    _isMenuOpened = !_isMenuOpened;
    notifyListeners();
  }
}
