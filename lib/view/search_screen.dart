import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';
import 'package:todo_app_challenge/view/widgets/todo_list_items.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
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
    int searchResultTotal = provider.searchTodoList.length + provider.searchCompletedTodoList.length;

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: TextField(
            controller: textController,
            autofocus: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Search to do ",
            ),
            onChanged: (keyword) {
              provider.searchTodo(keyword.trim());
            },
          ),
        ),
        body: Builder(builder: (context) {
          if (provider.searchTodoList.isEmpty && provider.searchCompletedTodoList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 100,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  Text(
                    "No Result",
                    style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
                  child: Text(
                    "Results ($searchResultTotal)",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (provider.searchTodoList.isNotEmpty)
                  TodoListItems(
                    items: provider.searchTodoList,
                  ),
                if (provider.searchCompletedTodoList.isNotEmpty)
                  TodoListItems(
                    items: provider.searchCompletedTodoList,
                    completed: true,
                    padding: const EdgeInsets.all(16).copyWith(top: 8),
                  ),
              ],
            ),
          );
        }));
  }
}
