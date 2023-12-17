import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:bookquet_mobile/screens/login_regsiter/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Register',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          backgroundColor: Colors.orange.shade800,
          foregroundColor: Colors.white,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Stack(
                        children: const [
                          Center(
                            child: Text('Daftarkan Diri Anda!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 55,
                                    fontWeight: FontWeight.bold),
                                )
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Username",
                                icon: const Icon(Icons.people),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  username = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  username = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Nickname",
                                icon: const Icon(Icons.emoji_people_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  nickname = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  nickname = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nickname tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Phone",
                                icon: const Icon(Icons.phone),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  phone = value! as int;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  phone = value! as int;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Age",
                                icon: const Icon(Icons.assignment_ind_rounded),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  age = value! as int;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  age = value! as int;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Age tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Region",
                                icon: const Icon(Icons.people),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  region = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  region = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Region tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                icon: const Icon(
                                  Icons.lock_outline,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  password = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  password = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Konfirmasi Password",
                                icon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  confirmPassword = value!;
                                });
                              },
                              onSaved: (String? value) {
                                setState(() {
                                  confirmPassword = value!;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: size.height * 0.08,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.orange.shade800,
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Submit to Django server and wait for response
                                  final response = await request.postJson(
                                      "https://127.0.0.1:8000/auth/register/",
                                      convert.jsonEncode(<String, String>{
                                        'username': username,
                                        'password': password,
                                        'confirmPassword': confirmPassword,
                                        'nickname': nickname,
                                        'phone': phone.toString(),
                                        'age': age.toString(),
                                        'region': region,
                                      }));
                                  if (response['status'] == 'Berhasil') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Akun berhasil terdaftar!"),
                                    ));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Akun gagal terdaftar! Silahkan coba lagi."),
                                    ));
                                  }
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                    fontSize: 22,
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}