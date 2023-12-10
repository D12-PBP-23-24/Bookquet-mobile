import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Karena ini adalah StatelessWidget, tampilkan nilai tetap
            Text(
              '0',
              style: TextStyle(fontSize: 24), // Contoh gaya teks
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tidak bisa mengubah state di StatelessWidget
          // Anda bisa melakukan aksi lain di sini
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ...
// // statement if sebelumnya
// // tambahkan else if baru seperti di bawah ini
// else if (item.name == "Logout") {
//         final response = await request.logout(   
//             "http://localhost:8000/auth/logout/");
//         String message = response["message"];
//         if (response['status']) {
//           String uname = response["username"];
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text("$message Sampai jumpa, $uname."),
//           ));
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginPage()),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text("$message"),
//           ));
//         }
//       }
// ...