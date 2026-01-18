import 'package:flutter/material.dart';
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

final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',

  redirect: (context, state) {
    final user = context.read<UserProvider>();
    final isLogin = state.matchedLocation == '/login';

    if (!user.isLogged && !isLogin) {
      return '/login';
    }

    if (user.isLogged && isLogin) {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
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
