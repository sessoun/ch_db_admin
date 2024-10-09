import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  bool isMenuOpened = false;
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(
        () {
          setState(() {});
        },
      );
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Stack(
        children: [
          AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn,
              height: MediaQuery.sizeOf(context).height,
              width: 288,
              left: isMenuOpened ? 0 : -288,
              child: const SideMenuView()),
          Transform.translate(
            offset: Offset(animation.value * 288, 0),
            child: Transform.scale(
                scale: isMenuOpened ? .9 : 1,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const HomeBodyView())),
          ),
          AnimatedPositioned(
              left: isMenuOpened ? screenWidth * .8 : 20,
              top: 20,
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: () {
                  if (isMenuOpened) {
                    animationController.reverse();
                  } else {
                    animationController.forward();
                  }
                  setState(() {
                    isMenuOpened = !isMenuOpened;
                  });
                },
                child: CircleAvatar(
                  child: isMenuOpened == true
                      ? const Icon(Icons.close)
                      : const Icon(Icons.menu),
                ),
              ))
        ],
      ),
    );
  }
}

class HomeBodyView extends StatefulWidget {
  const HomeBodyView({super.key});

  @override
  State<HomeBodyView> createState() => _HomeBodyViewState();
}

class _HomeBodyViewState extends State<HomeBodyView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Hello there.')));
  }
}

class SideMenuView extends StatefulWidget {
  const SideMenuView({super.key});

  @override
  State<SideMenuView> createState() => _SideMenuViewState();
}

class _SideMenuViewState extends State<SideMenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: const Center(
              child: Text(
            'Here',
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }
}
