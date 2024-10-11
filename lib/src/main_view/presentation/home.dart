import 'dart:math';

import 'package:ch_db_admin/src/main_view/controller/main_view_controller.dart';
import 'package:ch_db_admin/src/main_view/presentation/side_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    context.read<MainViewController>().init(setState: update, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    var controller = context.read<MainViewController>();
    var watchController = context.watch<MainViewController>();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                height: MediaQuery.sizeOf(context).height,
                width: 288,
                left: watchController.isMenuOpened ? 0 : -288,
                child: const SideMenuView()),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                //rotate 30 degress
                ..rotateY(controller.animation.value -
                    30 * controller.animation.value * pi / 180),
              child: Transform.translate(
                offset: Offset(controller.animation.value * 265, 0),
                child: Transform.scale(
                    scale: controller.scaleAnimation.value,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const HomeBodyView())),
              ),
            ),
            AnimatedPositioned(
                left: watchController.isMenuOpened ? screenWidth * .8 : 20,
                top: 20,
                duration: const Duration(milliseconds: 250),
                child: GestureDetector(
                  onTap: () {
                    controller.toggleMenuOpened();
                  },
                  child: CircleAvatar(
                    child: watchController.isMenuOpened == true
                        ? const Icon(Icons.close)
                        : const Icon(Icons.menu),
                  ),
                ))
          ],
        ),
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
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    context.read<MainViewController>().initIt(setState: update);
  }

  @override
  Widget build(BuildContext context) {
    var controller = context.read<MainViewController>();
    return Scaffold(
        body: PageView.builder(
      controller: controller.pageController,
      itemBuilder: (context, index) => Center(
        child: Text('This is a page build with $index index.'),
      ),
    ));
  }
}
