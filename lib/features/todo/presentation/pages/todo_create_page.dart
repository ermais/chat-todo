import 'dart:io';

import 'package:chat_todo/core/const/constants.dart';
import 'package:chat_todo/core/providers/firebase_providers.dart';
import 'package:chat_todo/core/providers/go_router_provider.dart';
import 'package:chat_todo/core/utils/cal_grid_count.dart';
import 'package:chat_todo/features/todo/domain/models/todo_model.dart';
import 'package:chat_todo/features/todo/presentation/widgets/color_bar.dart';
import 'package:chat_todo/features/todo/presentation/widgets/todo_check_list_item_text_field.dart';
import 'package:chat_todo/features/todo/provider/add_todo_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TodoCreatePage extends StatefulHookConsumerWidget {
  const TodoCreatePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoCreatePageState();
}

class _TodoCreatePageState extends ConsumerState<TodoCreatePage> {
  late TextEditingController _titleController;
  late TextEditingController _todoTextController;
  List<String> todoItems = [];
  FocusNode _todoFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();
  List<File> _imageFiles = [];
  Color? _color;
  bool loading = false;

  @override
  void initState() {
    _titleController = TextEditingController();
    _todoTextController = TextEditingController();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_todoFocus);
    });
  }

  @override
  void dispose() {
    _todoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addTodoState = ref.watch(addTodoNotifierProvider);
    final addTodoNotifier = ref.watch(addTodoNotifierProvider.notifier);
    addTodoState.maybeWhen(
        orElse: () => null,
        uploading: () {
          loading = true;
        },
        completed: () {
          loading = false;
          ref.read(goRouterProvider).pop();
        },
        failure: (String? message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message ?? "upload failed!"),
            behavior: SnackBarBehavior.floating,
          ));

          loading = false;
        });
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            (_color != null) ? _color : Theme.of(context).colorScheme.surface,
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
                        crossAxisCount: calCrossAxisCount(_imageFiles.length),
                        children: List.generate(
                            _imageFiles.length,
                            (index) => ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.file(
                                      _imageFiles[index],
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                )),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.scrim,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.05),
                                border: InputBorder.none,
                                hintText: "Title"),
                          ),
                          TextField(
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
                              todoItems.length,
                              (index) => TodoCheckListItemTextField(
                                  prevState: todoItems[index],
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
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
                    ColorBar(colors: todo_colors, onSelect: selectColor),
                    Container(
                      height: 64,
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickMultipleImages();
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
                            onTap: () {
                              addTodoNotifier.addTodo(
                                  toTodoModel(), _imageFiles);
                            },
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
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
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
    Map<Permission, PermissionStatus> _permissions =
        await [Permission.storage, Permission.photos].request();
    var status = await Permission.photos.request();
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

  toTodoModel() => TodoModel(
      id: "",
      title: _titleController.text,
      description: _todoTextController.text,
      createdAt: DateTime.now(),
      dueDate: DateTime.now(),
      noteItems: todoItems,
      noteImages: _imageFiles.map((file) => file.path).toList(),
      color: _color ?? Theme.of(context).colorScheme.surface,
      userId: ref.read(firebaseAuthProvider).currentUser!.uid,
      collaborators: []);
}
