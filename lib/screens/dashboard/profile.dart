import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookquet_mobile/models/dashboard.dart';
import 'package:bookquet_mobile/screens/dashboard/edit_profile.dart';
import 'package:bookquet_mobile/pbp_django_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<List<dashboard>> fetchProfile(BuildContext context) async {
    final request = context.read<CookieRequest>();
    var response = await request.get('https://bookquet-d12-tk.pbp.cs.ui.ac.id/dashboard/get_profile/');
    List<dashboard> profile = [];
    for (var d in response) {
      if (d != null) {
        profile.add(dashboard.fromJson(d));
      }
    }
    return profile;
  }
  
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Container(
          color: const Color(0xffe4fef3),
          padding: const EdgeInsets.all(24.0),
          width: double.infinity,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Profile',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: fetchProfile(context),
            builder: (context, AsyncSnapshot<List<dashboard>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "Tidak ada data profile.",
                    style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Card(
                      elevation: 4,
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  title: Center(
                                    child: Text(
                                      "Name: ${snapshot.data![index].fields.nickname}",
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          "Phone: ${snapshot.data![index].fields.phone}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          "Age: ${snapshot.data![index].fields.age}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Center(
                                        child: Text(
                                          "Region: ${snapshot.data![index].fields.region}",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  var selectedProfilePK = snapshot.data![index].pk;
                                  var updatedData = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(
                                        selectedProfilePK: selectedProfilePK,
                                      ),
                                    ),
                                  );

                                  if (updatedData != null) {
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    ),
  );
}
}