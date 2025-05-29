import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/selected_list.dart';

class ConfirmDeleteList extends StatelessWidget {
  final SelectedList selectedList;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ConfirmDeleteList({
    required this.selectedList,
    required this.scaffoldKey,
    super.key,
  });

  Future<void> deleteListAndTodos() async {
    //delete all todos
    final todosQuery =
        await FirebaseFirestore.instance
            .collection('todos')
            .where('listId', isEqualTo: selectedList.id)
            .get();

    for (var doc in todosQuery.docs) {
      await doc.reference.delete();
    }

    //delete list itself
    await FirebaseFirestore.instance
        .collection('lists')
        .doc(selectedList.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              //color: Theme.of(context).colorScheme.primary,
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                '"ListName" will be permanently deleted',
                style: TextStyle(
                  //color: Colors.white,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              deleteListAndTodos();
              Navigator.pop(context);
              scaffoldKey.currentState?.openDrawer();
              //Scaffold.of(context).openDrawer();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: EdgeInsets.zero,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  'Delete List',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue[800], fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
