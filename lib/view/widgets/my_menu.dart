import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';

class MyMenu extends StatefulWidget {
  const MyMenu({
    super.key,
  });

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
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
    List<String> menuButtons = [
      'Edit',
      provider.isOnline && provider.isOwner ? "Stop Online" : "Share online",
      provider.isOnline && !provider.isOwner ? "Quit" : "Join online",
    ];
    return MenuAnchor(
      alignmentOffset: const Offset(-70, 0),
      menuChildren: List.generate(menuButtons.length, (index) {
        return MenuItemButton(
          onPressed: () async {
            if (index == 0) {
              provider.isEdit = true;
            } else if (index == 1) {
              if (provider.isOnline) {
                await provider.stopShareOnline();
              } else {
                showShareCodeDialog(context, provider.userCode);
                await provider.shareOnline();
              }
            } else if (index == 2) {
              if (provider.isOnline && !provider.isOwner) {
                provider.isOwner = false;
                provider.isOnline = false;
              } else {
                provider.isOwner = false;
                showInputUserDialog(context, provider);
              }
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
    );
  }

  void showShareCodeDialog(BuildContext context, String userCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Share Todo LIst'),
          content: Text('Input this code to other device to sync the data: $userCode'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Copy'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: userCode));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showInputUserDialog(BuildContext context, TodoListProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter user code'),
          content: TextField(
            autofocus: true,
            controller: textController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              border: InputBorder.none,
              hintText: 'User code',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                provider.userCode = textController.text;
                provider.isOnline = !provider.isOnline;
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
