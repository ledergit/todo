import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/models/selected_list.dart';
import 'package:todo_app/widgets/confirm_delete_list.dart';
import 'package:todo_app/widgets/confirm_delete_list2.dart';
import 'package:todo_app/widgets/lists_drawer.dart';
import 'package:todo_app/widgets/todo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        debugShowCheckedModeBanner: false,
        home: StartScreen(),
      ),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();
  SelectedList? _selectedList;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedList == null) {
        _scaffoldKey.currentState?.openDrawer();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSelectedList(SelectedList selectedList) {
    setState(() {
      _selectedList = selectedList;
    });
  }

  Future<void> _saveTask(value) async {
    final taskName = _controller.text;
    if (taskName.isNotEmpty) {
      await FirebaseFirestore.instance.collection('todos').add({
        'listId': _selectedList!.id,
        'title': _controller.text,
        'completed': false,
      });
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task saved!'),
          duration: Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap:
                    () => showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          height: 200,
                          width: double.infinity,
                          child: Column(
                            children: [
                              // WIDGET #1 IN COLUMN
                              Row(
                                children: [
                                  Expanded(child: SizedBox()),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'List Options',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
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
                              Divider(indent: 16, endIndent: 16),
                              // WIDGET #3 IN COLUMN
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => ConfirmDeleteList2(),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete List...',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /*
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'List Options',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Done'),
                                  ),
                                ],
                              ),
                              */
                              /*                             Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'List Options',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Done'),
                                  ),
                                ],
                              ),*/
                            ],
                          ),
                        );
                      },
                    ),
                child: Icon(Icons.more_horiz, color: Colors.grey[700]),
              ),
            ),
          ],
          titleSpacing: 0,
          leading: Padding(
            //padding: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.only(left: 8),

            child: Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      //color: Colors.blue[600],
                      color: Colors.grey[700],
                    ),

                    //icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
            ),
          ),
          title: Text(
            'Select list...',
            style: TextStyle(color: Colors.grey[700]),
          ),
        ),

        drawer: ListsDrawer(onSelectedList: onSelectedList),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _selectedList?.name ?? 'No list selected',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium!.copyWith(color: Colors.grey[700]),
                ),
              ),
              TodoList(
                selectedList:
                    _selectedList ??
                    SelectedList(id: '0dlY7K9YXrki3M0jshZF', name: 'exercises'),
              ),
              TextField(
                focusNode: _focusNode,
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    _focusNode.hasFocus
                        ? Icons.check_box_outline_blank
                        : Icons.add,
                  ),
                  labelText: 'Enter task',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: _saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
