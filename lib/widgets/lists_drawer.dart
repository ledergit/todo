import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/selected_list.dart';
//import 'package:firebase_core/firebase_core.dart';

class ListsDrawer extends StatefulWidget {
  final void Function(SelectedList selectedList) onSelectedList;

  const ListsDrawer({required this.onSelectedList, super.key});

  @override
  State<ListsDrawer> createState() => _ListsDrawerState();
}

class _ListsDrawerState extends State<ListsDrawer> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _saveListName(value) async {
    final listName = _controller.text;
    if (listName.isNotEmpty) {
      await FirebaseFirestore.instance.collection('lists').add({
        'name': _controller.text,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': 'matt', // TBD update with actual username
      });
      _controller.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Task saved!')));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerTextStyle = Theme.of(
      context,
    ).textTheme.headlineSmall!.copyWith(color: Colors.white);

    return Drawer(
      backgroundColor: Colors.white,
      width: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: Column(
        //padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 116, 141, 253),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: headerTextStyle.fontSize,
                      //color: Colors.grey[700],
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text('Matt\'s Lists', style: headerTextStyle),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('lists')
                      .orderBy('createdAt')
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final listNameDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: listNameDocs.length,
                  itemBuilder: (context, index) {
                    final data =
                        listNameDocs[index].data() as Map<String, dynamic>;
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          //print('close window');
                          //print('${listNameDocs[index].id}');
                          //print('tapped link');
                          widget.onSelectedList(
                            SelectedList(
                              id: listNameDocs[index].id,
                              name: data['name'],
                            ),
                          );
                          //widget.setListid(listNameDocs[index].id);
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.list,
                              color: Color.fromARGB(255, 116, 141, 253),
                            ),
                            SizedBox(width: 8),
                            Text(data['name']),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              top: 8,
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Enter list name',
                prefixIcon: Icon(Icons.add),
              ),
              onSubmitted: _saveListName,
            ),
          ),
        ],
      ),
    );
  }
}
