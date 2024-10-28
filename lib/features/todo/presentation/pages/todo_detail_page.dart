import 'dart:io';

import 'package:chat_todo/core/const/constants.dart';
import 'package:chat_todo/core/utils/cal_grid_count.dart';
import 'package:chat_todo/features/todo/domain/models/todo_model.dart';
import 'package:chat_todo/features/todo/presentation/widgets/color_bar.dart';
import 'package:chat_todo/features/todo/presentation/widgets/image_viewer.dart';
import 'package:chat_todo/features/todo/presentation/widgets/todo_check_list_item_text_field.dart';
import 'package:chat_todo/features/todo/provider/todo_detail_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TodoDetailPage extends ConsumerStatefulWidget {
  const TodoDetailPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends ConsumerState<TodoDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _todoTextController;
  List<String> todoItems = [];
  FocusNode _todoFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFiles = [];
  Color? _color;

  @override
  void initState() {
    _titleController = TextEditingController();
    _todoTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoDetailState = ref.watch(todoDetailNotifierProvider);
    final todoDetailNotifier = ref.watch(todoDetailNotifierProvider.notifier);

    todoDetailState.maybeWhen(
        orElse: () => null,
        completed: (todo) {
          _titleController.text = todo!.title;
          _todoTextController.text = todo.description;
        });
    return SafeArea(
        child: todoDetailState.when(
            initial: () => Center(
                  child: CircularProgressIndicator(),
                ),
            loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
            completed: (TodoModel? todo) => Scaffold(
                  backgroundColor: (todo?.color != null)
                      ? todo?.color
                      : Theme.of(context).colorScheme.surface,
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(),
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                StaggeredGrid.count(
                                  axisDirection: AxisDirection.down,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  crossAxisCount: calCrossAxisCount(
                                      todo!.noteImages.length),
                                  children: List.generate(
                                      todo.noteImages.length,
                                      (index) => Container(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: (context),
                                                      builder: (context) =>
                                                          ImageViewer(
                                                            imgaes:
                                                                todo.noteImages,
                                                            currentIndex: index,
                                                          ));
                                                },
                                                child: AspectRatio(
                                                  aspectRatio: 16 / 9,
                                                  child: Image.network(
                                                    todo.noteImages[index],
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextField(
                                      onChanged: (String text) {
                                        debugPrint(
                                            "Text >>>>>>>>>........${text}");
                                        todoDetailNotifier.updateTodo(
                                            todoId: todo.id,
                                            data: {"title": text});
                                      },
                                      controller: _titleController,
                                      decoration: InputDecoration(
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .scrim,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1.05),
                                          border: InputBorder.none,
                                          hintText: "Title"),
                                    ),
                                    TextField(
                                      onChanged: (String text) {
                                        todoDetailNotifier.updateTodo(
                                            todoId: todo.id,
                                            data: {"description": text});
                                      },
                                      minLines: 1,
                                      maxLines: null,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
                                      // focusNode: _todoFocus,
                                      controller: _todoTextController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                    ...List.generate(
                                        todo.noteItems.length,
                                        (index) => TodoCheckListItemTextField(
                                            prevState: todo.noteItems[index],
                                            removeAt: removeTodoAt,
                                            index: index,
                                            onTextChanged: onChangeItem)),
                                    GestureDetector(
                                      onTap: () {
                                        onAddClicked();
                                      },
                                      child: Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: Colors.white),
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Icon(
                                            CupertinoIcons.add,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              ColorBar(
                                  colors: todo_colors, onSelect: selectColor),
                              Container(
                                height: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // _pickMultipleImages();
                                      },
                                      child: Icon(
                                        Icons.image,
                                        size: 32,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.color_lens,
                                        size: 32,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.delete,
                                        size: 32,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.save,
                                        size: 32,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            failure: (String? message) => Center(
                  child: Text(
                    message!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                )));
  }

  removeTodoAt(int index) {
    setState(() {
      todoItems.removeAt(index);
    });
  }

  onAddClicked() {
    setState(() {
      if (todoItems.isNotEmpty) {
        if (todoItems[todoItems.length - 1].isNotEmpty) {
          todoItems = [...todoItems, ""];
        }
      }
      if (todoItems.isEmpty) {
        todoItems = [...todoItems, ""];
      }
    });
    debugPrint("Todo List itmes ${todoItems}");
  }

  onChangeItem(String text, int index) {
    setState(() {
      todoItems[index] = text;
    });
  }

  Future<void> _pickMultipleImages() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final List<XFile>? pickedFiles = await _picker.pickMultipleMedia();
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          _imageFiles =
              pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        });
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Storage permission is required to pick images.")),
      );
    }
  }

  selectColor(Color color) {
    setState(() {
      _color = color;
    });
  }
}
