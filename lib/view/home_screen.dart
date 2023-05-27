import 'package:flutter/material.dart';
import 'package:todo_app_challenge/view/new_to_do_bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          buildAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                buildItemList(
                  length: 2,
                  item: ListTile(
                    horizontalTitleGap: 0,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: const Icon(Icons.circle_outlined),
                    title: const Text("Design"),
                    onTap: () => print('Tap'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Done (5)',
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                buildItemList(
                  length: 10,
                  isDone: true,
                  padding: const EdgeInsets.all(16).copyWith(top: 8),
                  item: ListTile(
                    horizontalTitleGap: 0,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: Icon(
                      Icons.check_circle_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      "Design",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    onTap: () => print('Tap'),
                  ),
                ),
              ],
            ),
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
              '16 to-dos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  ListView buildItemList({
    required int length,
    required Widget item,
    bool isDone = false,
    EdgeInsetsGeometry? padding,
  }) {
    return ListView.separated(
      padding: padding ?? const EdgeInsets.all(16),
      shrinkWrap: true,
      itemCount: length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Color color = isDone
            ? Theme.of(context).colorScheme.outline.withOpacity(0.08)
            : Theme.of(context).colorScheme.primary.withOpacity(0.08);
        return Material(
          color: color,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.hardEdge,
          child: item,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
    );
  }
}
