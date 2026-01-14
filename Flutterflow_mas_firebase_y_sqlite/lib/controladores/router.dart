import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Tus pantallas
import '../pages/home_page.dart';
import '../pages/samples_page.dart';
import '../pages/chat_page.dart';
import '../componentes/organism/bottom_bar.dart';
import '../styles/color_templates.dart';
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final templateColors colors = new templateColors();
final GoRouter router = GoRouter(

  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomBar(
            colors: templateColors(),
            navigationShell: navigationShell,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: HomePageWidget.routeName,
              builder: (context, state) => const HomePageWidget(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/samples',
              name: 'samples',
              builder: (context, state) => const SamplesPageWidget(),
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat',
              name: 'chat',
              builder: (context, state) => const ChatPageWidget(),
            ),
          ],
        ),
      ],
    ),

  ],
);