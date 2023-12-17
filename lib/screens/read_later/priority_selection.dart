import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'network_service_for_read_later.dart';
import '../../pbp_django_auth.dart';
import 'read_later.dart';

class PrioritySelectionScreen extends StatefulWidget {
  final int bookId;

  PrioritySelectionScreen({required this.bookId});

  @override
  _PrioritySelectionScreenState createState() => _PrioritySelectionScreenState();
}

class _PrioritySelectionScreenState extends State<PrioritySelectionScreen> {
  String selectedPriority = 'low'; // Default priority value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Your Priority',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Choose the Priority",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width:200,
                  child:DropdownButton<String>(
                    isExpanded: true,
                    value: selectedPriority,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPriority = newValue!;
                      });
                    },
                    items: <String>['low', 'medium', 'high']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _addToReadLater(context, selectedPriority);
                  },
                  child: Text('Add to Read Later',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                      ),
                  ),
                  // style: ElevatedButton.styleFrom(
                  //   primary: Colors.green.shade800,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(30.0),
                  //   ),
                  //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  // ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  void _addToReadLater(BuildContext context, String priority) async {
    final networkService = NetworkService();
    final request = context.read<CookieRequest>();
    bool success = await networkService.addToReadLater(request, widget.bookId, priority);
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReadLaterListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Book has already been added with a different priority"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
