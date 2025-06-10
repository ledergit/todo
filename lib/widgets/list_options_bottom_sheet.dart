import 'package:flutter/material.dart';
import 'package:todo_app/models/selected_list.dart';
import 'package:todo_app/widgets/confirm_delete_list.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListOptionsBottomSheet extends StatelessWidget {
  final SelectedList selectedList;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FirebaseAuth auth;
  final void Function() onSignedOut;

  const ListOptionsBottomSheet({
    required this.selectedList,
    required this.scaffoldKey,
    required this.auth,
    required this.onSignedOut,
    super.key,
  });

  Future<void> _signOut(BuildContext context) async {
    Navigator.pop(context);
    await auth.signOut();
    onSignedOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 200,
      width: double.infinity,
      child: Column(
        children: [
          // WIDGET #1 IN COLUMN
          Row(
            children: [
              const Expanded(child: SizedBox()),
              const Expanded(
                child: Center(
                  child: Text(
                    'List Options',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Done'),
                  ),
                ),
              ),
            ],
          ),
          // WIDGET #2 IN COLUMN
          const Divider(indent: 16, endIndent: 16),
          // WIDGET #3 IN COLUMN
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => ConfirmDeleteList(
                  selectedList: selectedList,
                  scaffoldKey: scaffoldKey,
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.delete_outline, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text(
                  'Delete List...',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _signOut(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.blue[800],
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Log out',
                  style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
