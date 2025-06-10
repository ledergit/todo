import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/selected_list.dart';

class TodoList extends StatelessWidget {
  final SelectedList selectedList;

  const TodoList({required this.selectedList, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('todos')
            .where('listId', isEqualTo: selectedList.id)
            .where('completed', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final todoItems = snapshot.data!.docs;

          return ListView(
            children: todoItems.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      // using this logic so that if TextField has focus, clicking checkbox unfocuses TextField without actually checking box.
                      onTap: () {
                        final currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          currentFocus.unfocus();
                          /*
                            final hasFocus = FocusScope.of(context).hasFocus;
                            if (hasFocus) {
                              FocusScope.of(context).unfocus();
                              */
                        } else {
                          FirebaseFirestore.instance
                              .collection('todos')
                              .doc(doc.id)
                              .update({'completed': true});
                        }
                      },
                      child: Checkbox(
                        value: data['completed'] ?? false,
                        onChanged:
                            null, //logic in GestureDetector that would otherwise be here..
                      ),
                    ),
                    Text(data['title']),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
