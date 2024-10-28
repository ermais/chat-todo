import 'package:chat_todo/features/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_todo/features/home/presentation/pages/home_page.dart';
import 'package:chat_todo/features/todo/presentation/pages/todo_create_page.dart';
import 'package:chat_todo/features/todo/presentation/pages/todo_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
    initialLocation: "/login",
    navigatorKey: _rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, child) => child,
        parentNavigatorKey: _rootNavigatorKey,
        branches: [
          StatefulShellBranch(navigatorKey: _shellNavigatorKey, routes: [
            GoRoute(
                path: "/",
                builder: ((context, state) => const HomePage()),
                routes: <RouteBase>[
                  GoRoute(
                      path: 'add_todo',
                      builder: (context, state) => TodoCreatePage()),
                  GoRoute(
                      path: 'todo_detail',
                      builder: (context, state) {
                        return TodoDetailPage();
                      })
                ])
          ]),
          StatefulShellBranch(
              // navigatorKey: _shellNavigatorKey,
              routes: [
                GoRoute(
                  path: "/login",
                  builder: (context, state) => SignInPage(),
                ),
              ]),
        ],
      )
    ]);
//
