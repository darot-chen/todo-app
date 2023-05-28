import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/todo_list_model.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';

class NewToDoBottomSheet extends StatefulWidget {
  final TodoListModel? todo;

  const NewToDoBottomSheet({
    super.key,
    this.todo,
  });

  @override
  State<NewToDoBottomSheet> createState() => _NewToDoBottomSheetState();
}

class _NewToDoBottomSheetState extends State<NewToDoBottomSheet> {
  final TextEditingController textController = TextEditingController();
  String todoTitle = '';

  @override
  void initState() {
    if (widget.todo != null) {
      textController.text = widget.todo?.todo ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);
    textController.addListener(() {
      todoTitle = textController.text;
    });
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 32, top: 14),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'New To-Do',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              IconButton(
                onPressed: () {
                  if (widget.todo == null) {
                    TodoListModel todo = TodoListModel(
                      id: provider.totalTodo,
                      todo: todoTitle,
                      completed: false,
                    );
                    provider.addTodo(todo);
                  } else {
                    TodoListModel newTodo = widget.todo!.copyWith(todo: todoTitle);
                    provider.updateTodo(newTodo);
                  }

                  textController.clear();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              autofocus: true,
              controller: textController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                border: InputBorder.none,
                hintText: 'New to-do',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
