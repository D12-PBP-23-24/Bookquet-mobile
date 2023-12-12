import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:bookquet_mobile/screens/login.dart';
import 'dart:convert' as convert;

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  String confirmPassword = "";
  String nickname = "";
  int phone = 0;
  int age = 0;
  String region = "";
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  'Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20.0),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Username",
                            icon: const Icon(Icons.people),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              username = value!;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          initialValue: null,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            icon: const Icon(Icons.lock_outline),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              password = value!;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          initialValue: null,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Konfirmasi Password",
                            icon: const Icon(Icons.lock_outline),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              confirmPassword = value!;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Nickname",
                            icon: const Icon(Icons.person),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              nickname = value!;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nickname tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Phone",
                            icon: const Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType
                              .number, // Keyboard tipe number untuk input angka
                          onChanged: (String? value) {
                            setState(() {
                              phone = int.tryParse(value!) ?? 0;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nomor telepon tidak boleh kosong';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Masukkan nomor telepon yang valid';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Age",
                            icon: const Icon(Icons.person),
                          ),
                          keyboardType: TextInputType
                              .number, // Keyboard tipe number untuk input angka
                          onChanged: (String? value) {
                            setState(() {
                              age = int.tryParse(value!) ?? 0;
                            });
                          },

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Umur tidak boleh kosong';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Masukkan umur yang valid';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Region",
                            icon: const Icon(Icons.person),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              region = value!;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Region tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/register/",
                                convert.jsonEncode(<String, String>{
                                  'username': username,
                                  'password': password,
                                  'confirmPassword': confirmPassword,
                                  'nickname': nickname,
                                  'phone': phone.toString(),
                                  'age': age.toString(),
                                  'region': region,
                                }),
                              );
                              if (response['status'] == 'Register Berhasil') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Akun berhasil terdaftar!"),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginPage(), // kalo udah selesai, diarain ke login page
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Akun gagal terdaftar! Silahkan coba lagi."),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        if (_errorText != null)
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.redAccent,
                            child: Text(
                              _errorText!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        const SizedBox(height: 15.0),
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.green,
                          ),
                          child: Text(
                            'Login Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
