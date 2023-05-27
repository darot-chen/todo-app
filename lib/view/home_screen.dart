import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/todo_list_model.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';
import 'package:todo_app_challenge/view/new_to_do_bottom_sheet.dart';
import 'package:todo_app_challenge/view/widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoListProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          buildAppBar(context),
          if (provider.todoList.isEmpty && provider.completedTodoList.isEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task_alt_outlined,
                      size: 100,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    Text(
                      "No to do",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.outline),
                    ),
                  ],
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildListDelegate([
              if (provider.todoList.isNotEmpty)
                buildItemList(
                  context: context,
                  items: provider.todoList,
                ),
              if (provider.completedTodoList.isNotEmpty)
                buildItemList(
                  context: context,
                  items: provider.completedTodoList,
                  completed: true,
                  padding: const EdgeInsets.all(16).copyWith(top: 8),
                ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (context) {
              return const NewToDoBottomSheet();
            },
          );
        },
      ),
    );
  }

  SliverAppBar buildAppBar(BuildContext context) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "To-dos",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              '${provider.totalTodo} to-dos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            provider.clear();
          },
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget buildItemList({
    required BuildContext context,
    required List<TodoListModel> items,
    bool completed = false,
    EdgeInsetsGeometry? padding,
  }) {
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
              child: TodoItem(todo: items[index]),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ],
    );
  }
}
