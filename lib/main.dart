import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/models/selected_list.dart';
import 'package:todo_app/widgets/list_options_bottom_sheet.dart';
import 'package:todo_app/widgets/lists_drawer.dart';
import 'package:todo_app/widgets/sign_in_screen.dart';
import 'package:todo_app/widgets/todo_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();
  SelectedList? _selectedList;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print('[DEBUG] Selected list: $_selectedList');
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
        'createdBy': _auth.currentUser?.uid,
      });
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task saved!'),
          duration: Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      print('[DEBUG] show signinScreen');
      return SignInScreen(onSignon: () => setState(() {}));
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 116, 141, 253),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ListOptionsBottomSheet(
                      selectedList: _selectedList!,
                      scaffoldKey: _scaffoldKey,
                      auth: _auth,
                      onSignedOut: () {
                        setState(() {});
                      },
                    );
                  },
                ),
                child: const Icon(Icons.more_horiz, color: Colors.white),
              ),
            ),
          ],
          titleSpacing: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          title: const Text(
            'Lists',
            style: TextStyle(color: Colors.white),
          ),
        ),

        //backgroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 116, 141, 253),
        drawer: ListsDrawer(
          onSelectedList: onSelectedList,
          auth: _auth,
          onSignedOut: () {
            setState(() {});
          },
        ),
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
                    //).textTheme.headlineMedium!.copyWith(color: Colors.grey[700]),
                  ).textTheme.headlineMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              TodoList(
                selectedList: _selectedList ??
                    SelectedList(id: '0dlY7K9YXrki3M0jshZF', name: 'exercises'),
              ),
              TextField(
                focusNode: _focusNode,
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 91, 116, 228),
                  prefixIcon: Icon(
                    _focusNode.hasFocus
                        ? Icons.check_box_outline_blank
                        : Icons.add,
                    color: Colors.white,
                  ),
                  labelText: 'Enter task',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
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
