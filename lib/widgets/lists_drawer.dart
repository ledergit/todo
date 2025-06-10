import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/selected_list.dart';
//import 'package:firebase_core/firebase_core.dart';

class ListsDrawer extends StatefulWidget {
  final void Function(SelectedList selectedList) onSelectedList;
  final void Function() onSignedOut;
  final FirebaseAuth auth;

  const ListsDrawer({
    required this.auth,
    required this.onSelectedList,
    required this.onSignedOut,
    super.key,
  });

  @override
  State<ListsDrawer> createState() => _ListsDrawerState();
}

class _ListsDrawerState extends State<ListsDrawer> {
  bool noListsDialogShown = false;
  List<DocumentSnapshot> listNameDocs = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  late final User currentUser;

  Future<void> _saveListName(value) async {
    final listName = _controller.text;
    if (listName.isNotEmpty) {
      await FirebaseFirestore.instance.collection('lists').add({
        'name': _controller.text,
        'owners': [currentUser.uid],
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': currentUser.uid,
      });
      _controller.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task saved!')));
    }
  }

  Future<void> _signOut() async {
    Navigator.pop(context);
    await widget.auth.signOut();
    widget.onSignedOut();
  }

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser!;
    int time = 400;
    _textFieldFocusNode.addListener(() {
      if (!_textFieldFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: time), () {
          if (listNameDocs.isEmpty) {
            _showNoListsYetDialog(context);
          }
        });
      }
    });
    super.initState();
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 116, 141, 253),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: headerTextStyle.fontSize,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text('Matt\'s Lists', style: headerTextStyle),
                        const Expanded(child: SizedBox()),
                        TextButton(
                          onPressed: _signOut,
                          child: const Text('Sign out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('lists')
                    .where('owners', arrayContains: currentUser.uid)
                    //.orderBy('createdAt')
                    // .where('name', isEqualTo: 'gg')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  listNameDocs = snapshot.data!.docs;
                  if (listNameDocs.isEmpty && noListsDialogShown == false) {
                    noListsDialogShown = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _showNoListsYetDialog(context);
                    });
                  }
                  // print('[DEBUG] currentUser: ${currentUser.uid}');
                  return ListView.builder(
                    itemCount: listNameDocs.length,
                    itemBuilder: (context, index) {
                      final data =
                          listNameDocs[index].data() as Map<String, dynamic>;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            widget.onSelectedList(
                              SelectedList(
                                id: listNameDocs[index].id,
                                name: data['name'],
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.list,
                                color: Color.fromARGB(255, 116, 141, 253),
                              ),
                              const SizedBox(width: 8),
                              Text(data['name']),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                // },
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
              focusNode: _textFieldFocusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Enter list name',
                prefixIcon: const Icon(Icons.add),
              ),
              onSubmitted: _saveListName,
            ),
          ),
        ],
      ),
    );
  }

  void _showNoListsYetDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.only(bottom: 8),
            actionsAlignment: MainAxisAlignment.center,
            title: const Text(
              'No lists yet!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Create your first list to get started!',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _textFieldFocusNode.requestFocus();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          );
        });
  }
}
