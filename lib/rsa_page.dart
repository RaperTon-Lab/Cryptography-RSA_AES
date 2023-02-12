import 'package:flutter/material.dart';
import './implementation.dart';
import 'package:share_plus/share_plus.dart';

import 'package:path_provider/path_provider.dart';

class RsaPage extends StatefulWidget {
  const RsaPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RsaPage> createState() => _RsaPageState();
}

class _RsaPageState extends State<RsaPage> {
  final myController = TextEditingController();
  String input = '';
  String output = '';
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hintText2 = 'Enter the plain or encrypted string here';
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          //title: Text(widget.title),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.blue,
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          output = '';
                          GenerateKeys();
                          final snackBar = SnackBar(
                            content: const Text('Key Pair Generated!'),
                            action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      },
                      child: const Text('Generate Key Pair')),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: hintText2,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.blue,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                input = myController.text;
                                print(input);
                                output = Encrypt(input);
                                print(output);
                              });
                            },
                            child: const Text('Encrypt')),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.blue,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                output = '';
                                myController.clear();
                              });
                            },
                            child: const Text('Clear')),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.blue,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                input = myController.text;
                                print(input);
                                output = Decrypt(input);
                                print(output);
                              });
                            },
                            child: const Text('Decrypt')),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: const Text('Output'),
                ),
                Container(
                    margin: const EdgeInsets.all(20.0),
                    child: SelectableText.rich(
                      TextSpan(
                        text: output,
                        style: const TextStyle(fontStyle: FontStyle.normal),
                      ),
                      showCursor: true,
                      toolbarOptions:
                          const ToolbarOptions(copy: true, selectAll: true),
                      scrollPhysics: const ClampingScrollPhysics(),
                    )),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.blue,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Share.share(output);
                        });
                      },
                      child: const Text('Share output')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
