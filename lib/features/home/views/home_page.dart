import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Welcome to Home!', style: TextStyle(fontSize: 18)),
      ),
      // ใส่ floating button หรือ widget อื่น ๆ ตามต้องการได้ที่นี่
    );
  }
}
