// import 'package:flutter/material.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:bookquet_mobile/screens/login.dart';
// import 'dart:convert' as convert;


// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);
//   static const ROUTE_NAME = '/register';

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   String username = "";
//   String password = "";
//   String confirmPassword = "";

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text(
//             'Register',
//             style: TextStyle(
//               fontWeight: FontWeight.bold
//             ),
//           ),
//           backgroundColor: Colors.orange.shade800,
//           foregroundColor: Colors.white,
//       ),
//       body: Container(
//         child: Form(
//           key: _formKey,
//           child: Stack(
//             children: [
//               Scaffold(
//                 body: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: size.width * 0.1,
//                       ),
//                       Stack(
//                         children: const [
//                           Center(
//                             child: Text('Daftarkan Diri Anda!',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     fontSize: 55,
//                                     fontWeight: FontWeight.bold),
//                                 )
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: size.width * 0.1,
//                       ),
//                       Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 25.0, vertical: 10.0),
//                             child: TextFormField(
//                               decoration: InputDecoration(
//                                 labelText: "Username",
//                                 icon: const Icon(Icons.people),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5.0)),
//                               ),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   username = value!;
//                                 });
//                               },
//                               onSaved: (String? value) {
//                                 setState(() {
//                                   username = value!;
//                                 });
//                               },
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Username tidak boleh kosong';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 25.0, vertical: 10.0),
//                             child: TextFormField(
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                 labelText: "Password",
//                                 icon: const Icon(
//                                   Icons.lock_outline,
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5.0)),
//                               ),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   password = value!;
//                                 });
//                               },
//                               onSaved: (String? value) {
//                                 setState(() {
//                                   password = value!;
//                                 });
//                               },
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Password tidak boleh kosong';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 25.0, vertical: 10.0),
//                             child: TextFormField(
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                 labelText: "Konfirmasi Password",
//                                 icon: const Icon(Icons.lock_outline),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(5.0)),
//                               ),
//                               onChanged: (String? value) {
//                                 setState(() {
//                                   confirmPassword = value!;
//                                 });
//                               },
//                               onSaved: (String? value) {
//                                 setState(() {
//                                   confirmPassword = value!;
//                                 });
//                               },
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Password tidak boleh kosong';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 25,
//                           ),
//                           Container(
//                             height: size.height * 0.08,
//                             width: size.width * 0.8,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16),
//                               color: Colors.orange.shade800,
//                             ),
//                             child: TextButton(
//                               onPressed: () async {
//                                 if (_formKey.currentState!.validate()) {
//                                   // Submit to Django server and wait for response
//                                   final response = await request.postJson(
//                                       "https://akmal-ramadhan21-tugas.pbp.cs.ui.ac.id/auth/register/",
//                                       convert.jsonEncode(<String, String>{
//                                         'username': username,
//                                         'password': password,
//                                         'confirmPassword': confirmPassword,
//                                       }));
//                                   if (response['status'] == 'Berhasil') {
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(const SnackBar(
//                                       content: Text(
//                                           "Akun berhasil terdaftar!"),
//                                     ));
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const LoginPage()),
//                                     );
//                                   } else {
//                                     ScaffoldMessenger.of(context)
//                                         .showSnackBar(const SnackBar(
//                                       content: Text(
//                                           "Akun gagal terdaftar! Silahkan coba lagi."),
//                                     ));
//                                   }
//                                 }
//                               },
//                               child: const Text(
//                                 'Submit',
//                                 style: TextStyle(
//                                     fontSize: 22,
//                                     height: 1.5,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 30,
//                           ),
//                           const SizedBox(
//                             height: 20,
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )
//       )
//     );
//   }
// }













// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController _nicknameController = TextEditingController(); // Add nickname field
//   final TextEditingController _phoneController = TextEditingController(); // Add phone field
//   final TextEditingController _ageController = TextEditingController(); // Add age field
//   final TextEditingController _regionController = TextEditingController(); // Add region field

//   @override
//   Widget build(BuildContext context) {
//     final request = context.watch<CookieRequest>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register'),
//         backgroundColor: Color.fromARGB(255, 206, 237, 199),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white,
//               Colors.white
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 40),
//             Icon(Icons.person_add, size: 100, color: Color.fromARGB(255, 134, 200, 188)),
//             const SizedBox(height: 20),
//             _buildTextField(_nicknameController, 'Nickname', false), // Add nickname field
//             const SizedBox(height: 20),
//             _buildTextField(_phoneController, 'Phone', false), // Add phone field
//             const SizedBox(height: 20),
//             _buildTextField(_ageController, 'Age', false), // Add age field
//             const SizedBox(height: 20),
//             _buildTextField(_regionController, 'Region', false), // Add region field
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () async {
//                 String nickname = _nicknameController.text; // Get nickname
//                 String phone = _phoneController.text; // Get phone
//                 String age = _ageController.text; // Get age
//                 String region = _regionController.text; // Get region

//                 final response = await request.postJson(
//                   "https://localhost:8000/auth/register/",
//                   convert.jsonEncode({
//                     'nickname': nickname, // Include nickname
//                     'phone': phone, // Include phone
//                     'age': age, // Include age
//                     'region': region, // Include region
//                   }),
//                 );

//                 if (request.loggedIn) {
//                   String message = response['message'];
//                   String uname = response['username'];
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                   ScaffoldMessenger.of(context)
//                     ..hideCurrentSnackBar()
//                     ..showSnackBar(SnackBar(
//                       content: Text("$message Welcome, $uname."),
//                     ));
//                 } else {
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       title: const Text('Registration Failed'),
//                       content: Text(response['message']),
//                       actions: [
//                         TextButton(
//                           child: const Text('OK'),
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Register'),
//               style: ElevatedButton.styleFrom(
//                 primary: Color.fromARGB(255, 134, 200, 188),
//                 onPrimary: Colors.white,
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller, String label, bool obscureText) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(color: Color.fromARGB(255, 134, 200, 188)),
//         ),
//         filled: true,
//         fillColor: Colors.white.withAlpha(200),
//       ),
//     );
//   }
// }
