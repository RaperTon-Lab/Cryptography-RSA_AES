// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
//import 'dart:io';
// /import 'package:filesystem_picker/filesystem_picker.dart';
//import 'package:permission_handler/permission_handler.dart';

class AesHome extends StatefulWidget {
  const AesHome({super.key});

  @override
  State<AesHome> createState() => _AesHomeState();
}

class _AesHomeState extends State<AesHome> {
  FilePickerResult? result;
  // ignore: non_constant_identifier_names
  String? file_name;
  String? destination;
  String? password;
  String? output;
  final myController = TextEditingController();

  get rootPath => null;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        /*
                        var status = await Permission.storage.status;
                        if (status.isDenied) {
                          // You can request multiple permissions at once.
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                          ].request();
                          print(statuses[Permission
                              .storage]); // it should print PermissionStatus.granted
                        }*/
                        output = '';
                        result = await FilePicker.platform.pickFiles();
                        setState(() {
                          if (result != null) {
                            file_name = result!.files.single.name;
                          } else {
                            final snackBar = SnackBar(
                              content: const Text('File not selected!'),
                              action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  // Some code to undo the change.
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                        });
                      },
                      child: const Text('Select a file')),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: SelectableText.rich(
                    TextSpan(
                      text: file_name,
                      style: const TextStyle(fontStyle: FontStyle.normal),
                    ),
                    showCursor: true,
                    toolbarOptions:
                        const ToolbarOptions(copy: true, selectAll: true),
                    scrollPhysics: const ClampingScrollPhysics(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: myController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter password',
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
                            onPressed: () async {
                              destination =
                                  await FilePicker.platform.getDirectoryPath(
                                dialogTitle:
                                    'Please select the output directory:',
                              );
                              if (destination == null) {
                                final snackBar = SnackBar(
                                  content: const Text('Folder not selected!'),
                                  action: SnackBarAction(
                                    label: 'Ok',
                                    onPressed: () {
                                      // Some code to undo the change.
                                    },
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }

                              setState(() {
                                password = myController.text;
                                //print(password);
                                if (password != '') {
                                  var crypt = AesCrypt(password!);
                                  crypt.setOverwriteMode(AesCryptOwMode.on);

                                  crypt.encryptFileSync(
                                      result!.files.single.path!,
                                      '${destination!}/${file_name!}.aes');
                                  output = '${destination!}/${file_name!}.aes';
                                  //print("encryption successfull!");
                                } else {
                                  final snackBar = SnackBar(
                                    content:
                                        const Text('Please enter password!'),
                                    action: SnackBarAction(
                                      label: 'Ok',
                                      onPressed: () {
                                        // Some code to undo the change.
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
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
                                output = null;
                                myController.clear();
                                result = null;
                                password = '';
                                destination = null;
                                file_name = null;
                              });
                            },
                            child: const Text('Clear')),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        color: Colors.blue,
                        child: ElevatedButton(
                            onPressed: () async {
                              String? selectedDirectory =
                                  await FilePicker.platform.getDirectoryPath(
                                dialogTitle:
                                    'Please select the output directory:',
                              );
                              if (selectedDirectory == null) {
                                destination = selectedDirectory;
                              }
                              setState(() {
                                password = myController.text;
                                //print(password);
                                if (password != null) {
                                  try {
                                    var crypt = AesCrypt(password!);
                                    String rev = file_name!;
                                    rev = rev.split('').reversed.join();
                                    rev = rev.substring(4);
                                    rev = rev.split('').reversed.join();
                                    crypt.setOverwriteMode(AesCryptOwMode.on);
                                    crypt.decryptFileSync(
                                        result!.files.single.path!,
                                        '${destination!}/$rev');
                                    output =
                                        'Decrypted File is saved in: ${destination!}/$rev';
                                  } catch (e) {
                                    final snackBar = SnackBar(
                                      content: const Text(
                                          'Wrong password or corrupt data!'),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {
                                          // Some code to undo the change.
                                        },
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else {
                                  final snackBar = SnackBar(
                                    content:
                                        const Text('Please enter password!'),
                                    action: SnackBarAction(
                                      label: 'Ok',
                                      onPressed: () {
                                        // Some code to undo the change.
                                      },
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
