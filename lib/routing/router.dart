import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/notes_page.dart';
import '../pages/topics_page.dart';
import '../pages/note_detail_page.dart';
import '../widgets/shell_layout.dart';

// Custom page transition with horizontal slide
CustomTransitionPage<T> buildPageWithHorizontalTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required bool fromLeft,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const beginReverse = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: fromLeft ? beginReverse : begin, end: end)
          .chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

final router = GoRouter(
  initialLocation: '/notes',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return ShellLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/notes',
          pageBuilder: (context, state) => buildPageWithHorizontalTransition(
            context: context,
            state: state,
            child: const NotesPage(),
            fromLeft: true,
          ),
        ),
        GoRoute(
          path: '/topics',
          pageBuilder: (context, state) => buildPageWithHorizontalTransition(
            context: context,
            state: state,
            child: const TopicsPage(),
            fromLeft: false,
          ),
        ),
        GoRoute(
          path: '/topics/:topicId',
          pageBuilder: (context, state) {
            final topicId = int.parse(state.pathParameters['topicId']!);
            return buildPageWithHorizontalTransition(
              context: context,
              state: state,
              child: NotesPage(topicId: topicId),
              fromLeft: true,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/notes/:noteId',
      builder: (context, state) {
        final noteId = int.parse(state.pathParameters['noteId']!);
        return NoteDetailPage(noteId: noteId);
      },
    ),
  ],
);
