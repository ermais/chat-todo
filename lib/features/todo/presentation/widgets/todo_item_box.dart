import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class TodoItemBox extends HookConsumerWidget {
  const TodoItemBox({required this.item, this.color, super.key});
  final String item;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.surface!.withOpacity(0.5),
              width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_box,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  item,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )),
        ],
      ),
    );
  }
}
