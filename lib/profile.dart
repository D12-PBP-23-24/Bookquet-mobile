import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dashboard.dart';
import 'edit_profile.dart';
import 'pbp_django_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<List<dashboard>> fetchProfile(BuildContext context) async {
    var url = Uri.parse('http://127.0.0.1:8000/dashboard/get_profile/');
    final request = context.read<CookieRequest>();
  //    Future<List<Item2>> _fetchBooks(BuildContext context) async {
  //   var response = await request.get('http://127.0.0.1:8000/get-book');
  //   List<Item2> list_product = [];
  //   for (var d in response) {
  //     if (d != null) {
  //       list_product.add(Item2.fromJson(d));
  //     }
  //   }
  //   return list_product;
  // }
    // var response = await http.get(
    //   url,
    //   headers: {"Content-Type": "application/json"},
    // );
    var response = await request.get('http://127.0.0.1:8000/dashboard/get_profile/');
    // var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(response);
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
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder(
        future: fetchProfile(context),
        builder: (context, AsyncSnapshot<List<dashboard>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Tidak ada data profile.",
                style: TextStyle(color: const Color(0xff59A5D8), fontSize: 20),
              ),
            );
          } else {
return ListView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (_, index) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(8), // Sesuaikan dengan preferensi Anda
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
);

          }
        },
      ),
    );
  }
}