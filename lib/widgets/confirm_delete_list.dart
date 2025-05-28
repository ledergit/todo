import 'package:flutter/material.dart';
import 'package:todo_app/widgets/tappable_container.dart';

class ConfirmDeleteList extends StatelessWidget {
  const ConfirmDeleteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    '"To do" will be permanently deleted',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  Divider(),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Test'),
                  ),

                  /*
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    color: Colors.yellow,
                    child: Text('hello'),
                  ),
                  */
                  /*
                  TappableContainer(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Delete List',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(175, 255, 0, 0),
                      ),
                    ),
                    //child: Text('Delete List'),
                  ),
*/
                  /*
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment(0, 0),
                      width: double.infinity,
                      child: Text(
                        'Delete List',
                        style: TextStyle(
                          color: Color.fromARGB(170, 255, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
*/
                  //Text('Delete List', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Button 2'),
          ),
        ],
      ),
    );
  }
}
