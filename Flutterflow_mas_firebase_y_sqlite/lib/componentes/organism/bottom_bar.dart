import 'package:flutter/material.dart';
import "package:go_router/go_router.dart";
import '../../styles/color_templates.dart';
import '../atoms/page_button.dart';

class BottomBar extends StatelessWidget {
  final templateColors colors;
  final StatefulNavigationShell navigationShell;

  const BottomBar({
    super.key,
    required this.colors,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.menu,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: PageButton(
              text: "Samples",
              icon: Icons.upload_file_outlined,
              onPressed: () => _goBranch(1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PageButton(
              text: "Home",
              icon: Icons.music_note,
              onPressed: () => _goBranch(0),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PageButton(
              text: "Chat",
              icon: Icons.chat,
              onPressed: () => _goBranch(2),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}