import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconsax/iconsax.dart';

import 'Controllers/VignetteController.dart';

class AddVignette extends StatefulWidget {
  @override
  _AddVignetteState createState() => _AddVignetteState();
}

class _AddVignetteState extends State<AddVignette>
    with SingleTickerProviderStateMixin {
  AnimationController loadingController;

  File _file;
  PlatformFile _platformFile;

  VignetteController _vignetteController = VignetteController();
  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (file != null) {
      setState(() {
        _file = File(file.files.single.path);
        _platformFile = file.files.first;
      });
    }

    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: Colors.grey.shade700),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        title: Text(
          "Scanner une vignette",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Télécharger votre fichier',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Le fichier doit etre jpg ou png',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: selectFile,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.orange.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 110,
                      decoration: BoxDecoration(
                          color: Colors.orange.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.folder,
                            color: Colors.orange,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Choisissez votre fichier',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            _platformFile != null
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected File',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _file,
                                      fit: BoxFit.cover,
                                      width: 70,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _platformFile.name,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${(_platformFile.size / 1024).ceil()} KB',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          height: 5,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.orange.shade50,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: loadingController.value,
                                            backgroundColor:
                                                Colors.orange.shade200,
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(Colors.orange),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 45,
                          onPressed: () {
                            EasyLoading.show(status: "Chargement");
                            _vignetteController
                                .uploadImage(_file.path)
                                .then((statusCode) {
                              print("statusCode :$statusCode");
                              if (statusCode == 200) {
                                Navigator.pop(context, true);
                              }
                            });
                          },
                          color: Colors.deepOrangeAccent,
                          child: Text(
                            'Upload',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ))
                : Container(),
            SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
