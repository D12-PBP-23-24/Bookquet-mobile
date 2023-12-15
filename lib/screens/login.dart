import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookquet_mobile/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pbp_django_auth.dart';

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
        scaffoldBackgroundColor: Colors.black, // Warna latar belakang scaffold
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
      backgroundColor: const Color(0xffe4fef3),
      appBar: AppBar(
        title: const Text(
          'Bookquet',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bookquet',
                style: TextStyle(
                  color: Colors.green, // Warna teks
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Card(
                  color: Colors.green.shade100,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(height: 8.0),
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black
                            ), // Warna label
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            icon: Icon(Icons.person, color: Colors.black), // Icon username
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            icon: Icon(Icons.lock, color: Colors.black), // Icon password
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
                            backgroundColor: Colors.green.shade400, // Warna tombol
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ), // Warna teks putih
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_errorText != null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.redAccent, // Warna kontainer error
                            child: Text(
                              _errorText!,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        const SizedBox(height: 15),
                        Text(
                          "Don't have an account yet?",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _launchWebsite,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade300, // Warna tombol
                          ),
                          child: const Text(
                            'Register Now',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black
                            ), // Warna teks putih
                          ),
                        )
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
  
  void _launchWebsite() async {
    const url = 'http://127.0.0.1:8000/register/'; // Replace with your website URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
