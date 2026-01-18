import 'package:flutter/material.dart';
import 'package:flutterflow_taller/pages/register_page.dart';
import '../../Data/entities/group_chat.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/chat_messages.dart';
import '../pages/login.dart';
import '../pages/home_page.dart';
import '../pages/provider/user_provider.dart';
import '../pages/samples_page.dart';
import '../pages/chat_page.dart';
import '../componentes/organism/bottom_bar.dart';
import '../styles/color_templates.dart';
final UserProvider userProvider = UserProvider();

final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  refreshListenable: userProvider,

  redirect: (context, state) {
    final location = state.matchedLocation;

    final isPublicRoute = location == '/login' || location == '/register';

    if (isPublicRoute) {
      return null;
    }

    // Usuario no logueado → forzar login
    if (!userProvider.isLogged) {
      return '/login';
    }

    if (userProvider.isLogged && location == '/login') {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
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
              builder: (context, state) => const HomePageWidget(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/samples',
              builder: (context, state) => const SamplesPageWidget(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/chat',
              builder: (context, state) => ChatPageWidget(),
            ),
          ],
        )
      ],
    ),
    GoRoute(
      path: '/chat/messages',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;

        if (extra == null || extra is! GroupChat) {
          return const Scaffold(
            body: Center(child: Text('Chat inválido')),
          );
        }

        return ChatMessages(chatInfo: extra);
      },
    )
  ],
);
