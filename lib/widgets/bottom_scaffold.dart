import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomScaffold extends ConsumerStatefulWidget {
  const BottomScaffold({
    required this.child,
    super.key});
  final Widget child;

  @override
  ConsumerState<BottomScaffold> createState() => _BottomScaffoldState();
}

class _BottomScaffoldState extends ConsumerState<BottomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomAppBar(),
    );
  }
}
