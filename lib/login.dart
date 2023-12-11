import 'package:bookquet_mobile/profile.dart';
import 'package:flutter/material.dart';
import 'pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookquet_mobile/main.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.green, // Warna dasar
        scaffoldBackgroundColor: Colors.white, // Warna latar belakang scaffold
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bookquet',
                style: TextStyle(
                  color: Colors.green, // Warna teks
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.green), // Warna label
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.green),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            String username = _usernameController.text;
                            String password = _passwordController.text;

                            final response = await request.login(
                              "http://127.0.0.1:8000//auth/login/",
                              {
                                'username': username,
                                'password': password,
                              },
                            );

                            if (request.loggedIn) {
                              String message = response['message'];
                              String uname = response['username'];
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHomePage(),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(SnackBar(
                                  content: Text(
                                    "$message Selamat datang, $uname.",
                                  ),
                                ));
                            } else {
                              setState(() {
                                _errorText = response['message'];
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green, // Warna tombol
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white), // Warna teks putih
                          ),
                        ),
                        SizedBox(height: 15),
                        if (_errorText != null)
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.redAccent, // Warna kontainer error
                            child: Text(
                              _errorText!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        SizedBox(height: 15),
                        // Text(
                        //   "Don't have an account yet?",
                        //   style: TextStyle(color: Colors.green),
                        // ),
                        // TextButton(
                        //   onPressed: () {
                        //     // Navigasi ke halaman pendaftaran
                        //     Navigator.pushReplacement(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => RegisterPage(),
                        //       ),
                        //     );
                        //   },
                        //   style: TextButton.styleFrom(
                        //     primary: Colors.green, // Warna teks tombol
                        //   ),
                        //   child: Text(
                        //     'Register Now',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class RegisterPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Register'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Registration Page!'),
//       ),
//     );
//   }
// }