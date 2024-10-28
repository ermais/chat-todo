import 'package:chat_todo/features/auth/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/routes/routes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authNotifierProvider, (prev, next) {
      next.maybeWhen(
        orElse: () => null,
        authenticated: (user) {},
        unauthenticated: (message) => null,
      );
    });
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
