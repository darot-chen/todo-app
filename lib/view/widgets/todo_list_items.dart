import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/todo_list_model.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';
import 'package:todo_app_challenge/view/widgets/todo_item.dart';

class TodoListItems extends StatelessWidget {
  final List<TodoListModel> items;
  final bool completed;
  final EdgeInsetsGeometry? padding;

  const TodoListItems({
    super.key,
    required this.items,
    this.padding,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (completed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Done (${provider.completedTodoList.length})',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ListView.separated(
          padding: padding ?? const EdgeInsets.all(16),
          shrinkWrap: true,
          itemCount: items.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Color color = completed
                ? Theme.of(context).colorScheme.outline.withOpacity(0.08)
                : Theme.of(context).colorScheme.primary.withOpacity(0.08);
            return Material(
              color: color,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.hardEdge,
              child: TodoItem(
                completed: completed,
                index: index,
                todo: items[index],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ],
    );
  }
}
