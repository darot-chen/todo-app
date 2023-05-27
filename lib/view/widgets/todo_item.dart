import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/todo_list_model.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';
import 'package:todo_app_challenge/view/new_to_do_bottom_sheet.dart';

class TodoItem extends StatelessWidget {
  final TodoListModel todo;

  const TodoItem({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);
    return ListTile(
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0).copyWith(right: 16),
      leading: IconButton(
        onPressed: () {
          provider.markStatus(todo: todo, completed: !(todo.completed == true));
        },
        icon: todo.completed == true
            ? Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            : const Icon(Icons.circle_outlined),
      ),
      title: Text(
        todo.todo ?? '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: todo.completed == true
            ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                )
            : null,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (context) {
            return NewToDoBottomSheet(
              todo: todo,
            );
          },
        );
      },
      onLongPress: () {},
    );
  }
}
