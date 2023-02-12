import 'package:flutter/material.dart';
import 'package:rsa/aes_home.dart';
import 'package:rsa/rsa_page.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  //final directory = await getApplicationDocumentsDirectory();

  //String path = directory.path;
  //print('Inside main Doc Directory: $path');
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'RSA Cryptography'),
                Tab(text: 'AES File Cryptography'),
              ],
            ),
            title: const Text('Cryptography'),
          ),
          body: const TabBarView(
            children: [
              RsaPage(
                title: 'RSA',
              ),
              AesHome(),
            ],
          ),
        ),
      ),
    );
  }
}
