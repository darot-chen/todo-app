import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';
import 'package:todo_app_challenge/view/search_screen.dart';
import 'package:todo_app_challenge/view/widgets/my_menu.dart';

class TodoAppBar extends StatelessWidget {
  const TodoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);

    return SliverAppBar(
      centerTitle: false,
      pinned: true,
      snap: false,
      floating: false,
      collapsedHeight: 80,
      expandedHeight: 150.0,
      elevation: 1,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(16),
        title: buildAppBarTitle(provider, context),
      ),
      leading: provider.isEdit
          ? IconButton(
              onPressed: () {
                provider.isEdit = false;
                provider.selectAll(cancel: true);
              },
              icon: const Icon(Icons.clear),
            )
          : null,
      actions: [
        if (provider.isEdit)
          IconButton(
            onPressed: () => provider.selectAll(),
            icon: const Icon(Icons.circle_outlined),
          ),
        if (!provider.isEdit)
          IconButton(
            onPressed: () {
              provider.searchTodoList = provider.todoList;
              provider.searchCompletedTodoList = provider.completedTodoList;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        if (!provider.isEdit) const MyMenu(),
      ],
    );
  }

  Column buildAppBarTitle(TodoListProvider provider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          provider.isEdit ? "Select Items" : "To-dos",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 500),
          crossFadeState: provider.isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Text(
            provider.isEdit ? '' : '${provider.totalTodo} to-dos',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          secondChild: Text(
            'Uploading to cloud',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ),
      ],
    );
  }
}
