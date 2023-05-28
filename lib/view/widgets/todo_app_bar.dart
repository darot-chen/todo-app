import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';

class TodoAppBar extends StatelessWidget {
  const TodoAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);
    List<String> menuButtons = ['Edit', "Delete All"];
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              provider.isEdit ? "Select Items" : "To-dos",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            Text(
              provider.isEdit ? '' : '${provider.totalTodo} to-dos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
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
        provider.isEdit
            ? IconButton(
                onPressed: () => provider.selectAll(),
                icon: const Icon(Icons.circle_outlined),
              )
            : MenuAnchor(
                alignmentOffset: const Offset(-70, 0),
                menuChildren: List.generate(menuButtons.length, (index) {
                  return MenuItemButton(
                    onPressed: () {
                      if (index == 1) {
                        provider.clear();
                      } else {
                        provider.isEdit = true;
                      }
                    },
                    child: Text(menuButtons[index]),
                  );
                }),
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return IconButton(
                    onPressed: () async {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
      ],
    );
  }
}
