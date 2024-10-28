import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class TodoCheckListItemTextField extends StatefulHookConsumerWidget {
  const TodoCheckListItemTextField(
      {required this.onTextChanged,
      required this.removeAt,
      this.prevState = "",
      required this.index,
      super.key});
  final String prevState;
  final Function(String text, int index) onTextChanged;
  final Function(int index) removeAt;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodoCheckListItemTextFieldState();
}

class _TodoCheckListItemTextFieldState
    extends ConsumerState<TodoCheckListItemTextField> {
  late TextEditingController _textEditingController;
  FocusNode _itemFocus = FocusNode();

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.prevState);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_itemFocus);
    });
    _itemFocus.addListener(() {
      if (_textEditingController.text.isEmpty && !_itemFocus.hasFocus) {
        widget.removeAt(widget.index);
      }
    });
    _textEditingController.addListener(() {
      widget.onTextChanged(_textEditingController.text, widget.index);
    });
  }

  @override
  void dispose() {
    _itemFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_box,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          Flexible(
            flex: 1,
            child: TextField(
              minLines: 1,
              maxLines: null,
              textAlign: TextAlign.start,
              style: TextStyle(),
              focusNode: _itemFocus,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              controller: _textEditingController,
            ),
          ),
        ],
      ),
    );
  }
}
