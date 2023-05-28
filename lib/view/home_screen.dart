import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/model/user_todo_list_model.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';
import 'package:todo_app_challenge/view/widgets/new_to_do_bottom_sheet.dart';
import 'package:todo_app_challenge/view/widgets/todo_app_bar.dart';
import 'package:todo_app_challenge/view/widgets/todo_list_items.dart';

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
          const TodoAppBar(),
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
              if (!provider.isOnline)
                Column(children: [
                  if (provider.todoList.isNotEmpty && !provider.isOnline)
                    TodoListItems(
                      items: provider.todoList,
                    ),
                  if (provider.completedTodoList.isNotEmpty && !provider.isOnline)
                    TodoListItems(
                      items: provider.completedTodoList,
                      completed: true,
                      padding: const EdgeInsets.all(16).copyWith(top: 8),
                    ),
                ]),
              if (provider.isOnline)
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('data').doc(provider.userCode).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) return const Text('Something went wrong');
                    if (!snapshot.hasData) return const SizedBox();

                    UserTodoListModel? userTodo = UserTodoListModel.fromJson(
                      snapshot.data?.data() as Map<String, dynamic>,
                    );
                    provider.streamData(userTodo);

                    return Column(
                      children: [
                        if (provider.todoList.isNotEmpty)
                          TodoListItems(
                            items: provider.todoList,
                          ),
                        if (provider.completedTodoList.isNotEmpty)
                          TodoListItems(
                            items: provider.completedTodoList,
                            completed: true,
                            padding: const EdgeInsets.all(16).copyWith(top: 8),
                          ),
                      ],
                    );
                  },
                ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: provider.isEdit
          ? InkWell(
              onTap: () => provider.deleteTodo(),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide()),
                ),
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.delete),
                    Text('Delete'),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: !provider.isEdit
          ? FloatingActionButton(
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
            )
          : null,
    );
  }

  // Widget buildItemList({
  //   required BuildContext context,
  //   required List<TodoListModel> items,
  //   bool completed = false,
  //   EdgeInsetsGeometry? padding,
  // }) {
  //   final provider = Provider.of<TodoListProvider>(context);
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       if (completed)
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16),
  //           child: Text(
  //             'Done (${provider.completedTodoList.length})',
  //             style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
  //           ),
  //         ),
  //       ListView.separated(
  //         padding: padding ?? const EdgeInsets.all(16),
  //         shrinkWrap: true,
  //         itemCount: items.length,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemBuilder: (context, index) {
  //           Color color = completed
  //               ? Theme.of(context).colorScheme.outline.withOpacity(0.08)
  //               : Theme.of(context).colorScheme.primary.withOpacity(0.08);
  //           return Material(
  //             color: color,
  //             borderRadius: BorderRadius.circular(16),
  //             clipBehavior: Clip.hardEdge,
  //             child: TodoItem(
  //               completed: completed,
  //               index: index,
  //               todo: items[index],
  //             ),
  //           );
  //         },
  //         separatorBuilder: (context, index) => const SizedBox(height: 8),
  //       ),
  //     ],
  //   );
  // }
}
