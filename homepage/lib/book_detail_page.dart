import 'package:flutter/material.dart';

class BookDetailPage extends StatelessWidget {
  final String bookTitle;

  const BookDetailPage({required this.bookTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laman Sementara'),
      ),
      body: const Center(
        child: Text('Ini laman sementara. Hapus segera file ini jika sudah selesai dibuat'),
      ),
    );
  }
}
