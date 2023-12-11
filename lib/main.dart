import 'package:bookquet_mobile/homepageEdbert.dart';

import 'loginEdbert.dart';
import 'package:flutter/material.dart';
import 'pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'read_later_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            },
            child: MaterialApp(
                title: 'Flutter App',
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
                    useMaterial3: true,
                ),
                home: LoginApp() ),
            );
    }
}
