import 'package:flutter/material.dart';
import '../../pbp_django_auth.dart';
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
    final request = context.read<CookieRequest>();
    try {
      var response = await request.get(
        'http://127.0.0.1:8000/dashboard/get_profile_json/'
      );
        nameController.text = response["nickname"];
        phoneController.text = response["phone"].toString();
        ageController.text = response["age"].toString();
        regionController.text = response["region"];
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
                var response = await request.post(
                  'http://127.0.0.1:8000/dashboard/update_profile_flutter/',{"nickname":newName,"phone":newPhone,"age":newAge,"region":newRegion},
                );
                Navigator.pop(context, updatedData);
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