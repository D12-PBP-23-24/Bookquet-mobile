import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pbp_django_auth.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final int selectedProfilePK;

  EditProfileScreen({required this.selectedProfilePK});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  late CookieRequest request;

  @override
  void initState() {
    super.initState();
    fetchUserProfileData();
  }

  void fetchUserProfileData() async {
    var url = Uri.parse('http://127.0.0.1:8000/dashboard/get_profile_json/');
    final request = context.read<CookieRequest>();
    try {
      // var response = await http.get(
      //   url,
      //   headers: {"Content-Type": "application/json"},
      // );
      var response = await request.get(
        'http://127.0.0.1:8000/dashboard/get_profile_json/'
      );
      nameController.text = response["nickname"];
        phoneController.text = response["phone"].toString();
        ageController.text = response["age"].toString();
        regionController.text = response["region"];
      // if (response.statusCode == 200) {
      //   var userData = jsonDecode(utf8.decode(response.bodyBytes));

      //   nameController.text = userData["nickname"];
      //   phoneController.text = userData["phone"].toString();
      //   ageController.text = userData["age"].toString();
      //   regionController.text = userData["region"];
      // } else {
      //   print('Failed to fetch user profile data');
      // }
    } catch (error) {
      print('Error fetching user profile data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: regionController,
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                String newName = nameController.text;
                String newPhone = phoneController.text;
                String newAge = ageController.text;
                String newRegion = regionController.text;

                // Validate phone and age
                if (!isNonNegativeNumeric(newPhone) || !isNonNegativeNumeric(newAge)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Invalid Input'),
                        content: Text('Please enter valid positive numbers for Phone and Age.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                Map<String, dynamic> updatedData = {
                  'pk': widget.selectedProfilePK,
                  'fields': {
                    'nickname': newName,
                    'phone': newPhone,
                    'age': newAge,
                    'region': newRegion,
                  },
                };

                // Send the update request to the server
                // var url = Uri.parse('http://127.0.0.1:8000/dashboard/update_profile_flutter/');
                // var response = await http.post(
                //   url,
                //   headers: {"Content-Type": "application/json"},
                //   body: jsonEncode(updatedData),
                // );
    //              var response = await request.post('http://127.0.0.1:8000/read-later/add-to-read-later2/$bookId/', {
    //   "priority": priority, 
    // });
                var response = await request.post(
                  'http://127.0.0.1:8000/dashboard/update_profile_flutter/',{"nickname":newName,"phone":newPhone,"age":newAge,"region":newRegion},
                );
                Navigator.pop(context, updatedData);
                // var response = await request.post2(
                //   'http://127.0.0.1:8000/dashboard/update_profile_flutter/',
                //   body: jsonEncode(updatedData),
                //   headers: {"Content-Type": "application/json"},
                // );
                // Handle the response as needed
                // if (response.statusCode == 200) {
                //   print('Profile updated successfully');

                //   // Navigate back to the profile page
                //   Navigator.pop(context, updatedData);
                // } else {
                //   print('Failed to update profile');
                // }
              },
              style: ElevatedButton.styleFrom(
                 backgroundColor: Color.fromRGBO(210, 230, 217, 1),
                 foregroundColor: Colors.black,
              ),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

bool isNonNegativeNumeric(String str) {
  double value = double.tryParse(str) ?? double.nan;
  return value >= 0;
}
}