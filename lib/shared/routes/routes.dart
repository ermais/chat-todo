
import 'package:chat_todo/features/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_todo/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router =
    GoRouter(initialLocation: "/login", navigatorKey: _rootNavigatorKey, routes: [
//   GoRoute(path: "/sign-in", builder: (context, state) => ()),
//   GoRoute(
//     path: "/lesson",
//     builder: (context, GoRouterState state){
//       final courseId = state.extra as String;
//     return LessonPage(courseId: courseId ,);
// }
//   ),
//   GoRoute(
//     path: "/learn",
//     builder: (context, state) {
//       final lessonId = state.extra as String;
//       return LearnLesson(lessonId: lessonId,);
// },
//   ),  GoRoute(
//     path: "/exam",
//     builder: (context, state) {
//       final examId = state.extra as String;
//       return  ExamPage(examId: examId,);
// },
//   ),
  StatefulShellRoute.indexedStack(
    builder: (context, state, child) => child,
    parentNavigatorKey: _rootNavigatorKey,
    branches: [
      StatefulShellBranch(navigatorKey: _shellNavigatorKey, routes: [
        GoRoute(
            path: "/",
            builder: ((context, state) => const HomePage()),
            routes: <RouteBase>[
              // GoRoute(
              //     path: "course",
              //     builder: (context, state) => const CoursePage(),
              //     parentNavigatorKey: _shellNavigatorKey),
              // GoRoute(
              //     path: "grade",
              //     builder: (context, state) => const GradeReportPage(),
              //     parentNavigatorKey: _shellNavigatorKey),
              // GoRoute(
              //     path: "exam",
              //     builder: (context, state) => Container(
              //       child: Center(
              //         child: Text("Exam"),
              //       ),
              //     ),
              //     parentNavigatorKey: _shellNavigatorKey),
              // // GoRoute(
              // //     path: "register",
              // //     builder: (context, state) => const ApplyCourse(),
              // //     parentNavigatorKey: _rootNavigatorKey),
              // GoRoute(
              //   parentNavigatorKey: _shellNavigatorKey,
              //   path: "profile",
              //   builder: (context, state) => Container(
              //     child: Center(child: Text("Profile"),),
              //   ),
              // ),
              // GoRoute(
              //     path: "account",
              //     parentNavigatorKey: _shellNavigatorKey,
              //     builder: (context, state) => Container(
              //       child: Center(child: Text("Account"),),
              //     ))
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
      // StatefulShellBranch(
      //     // navigatorKey: _shellNavigatorKey,
      //     routes: [
      //       GoRoute(
      //         path: "/signup",
      //         builder: (context, state) => const SignUpScreen(),
      //       ),
      //     ]),
    ],
  )
]);
//
