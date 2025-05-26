import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/models/selected_list.dart';
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
  /*
  void setListid(String selectedList) {
    print('selectedList: $selectedList');
    setState(() {
      _selectedListId = selectedList;
    });
  }
  */

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
        appBar: AppBar(title: Text('To do')),

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
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              TodoList(selectedList: _selectedList!),
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
