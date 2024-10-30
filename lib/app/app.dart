import 'package:chat_todo/features/auth/domain/state/auth_state.dart';
import 'package:chat_todo/features/auth/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../shared/routes/routes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    if (authState.runtimeType == AuthState.authenticated) {
      Future.delayed(Duration.zero, () {
        context.go('/');
      });
    }

    if (authState.runtimeType == AuthState.unauthenticated) {
      Future.delayed(Duration.zero, () {
        context.go('/login');
      });
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
