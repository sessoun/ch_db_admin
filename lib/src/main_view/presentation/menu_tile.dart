
import 'package:flutter/material.dart';

class MenuTile extends StatefulWidget {
  const MenuTile(
      {super.key,
      this.onTap,
      required this.title,
      this.leading,
      this.icon,
      this.showTrailingIcon = true});
  final void Function()? onTap;
  final String title;
  final Widget? leading;
  final IconData? icon;
  final bool? showTrailingIcon;

  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.bounceInOut,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      leading: widget.icon == null ? widget.leading : Icon(widget.icon),
      title: Text(widget.title),
      trailing: widget.showTrailingIcon == true
          ? const Icon(Icons.arrow_forward_sharp)
          : null,
    );
  }
}
