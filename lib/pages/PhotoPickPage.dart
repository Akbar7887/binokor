import 'dart:io';
import 'dart:typed_data';

import 'package:binokor/api/HttpService.dart';
import 'package:binokor/models/dom_entity.dart';
import 'package:binokor/models/kompleks_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../domain/Constants.dart';
import 'package:http/http.dart' as http;

class PhotoPickPage extends StatefulWidget {
  const PhotoPickPage({Key? key}) : super(key: key);

  @override
  State<PhotoPickPage> createState() => _PhotoPickPageState();
}

class _PhotoPickPageState extends State<PhotoPickPage> {
  List<KompleksEntity> _komplekslist = [];
  KompleksEntity? _dropdownAdress; //KompleksEntity(name: "", id: "");
  List<DomEntity> _domlist = [];
  DomEntity? _dropdownDom;
  String filename = '';
  var imagePassport;
  File? file;
  double progress = 0;
  String urimain = Constans().uri;
  FlutterSecureStorage storage = FlutterSecureStorage();
  bool sended = false;

  @override
  void initState() {
    super.initState();
    HttpService().getAllkomleks().then((value) {
      setState(() {
        _komplekslist = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          color: Constans().backroundcolors,
          height: 60,
          child: Wrap(
            children: [
              Text(
                "Передача данные",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: Constans().font),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: getImage(),
        ),
        Container(
          child: Text("Выбор комплекса!"),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: firstDropDown(),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: secondDropdown(),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          pickImage(ImageSource.camera);
                          sended = false;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black)),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera,
                                size: 50,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Снять фото",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ))),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    sended = false;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Галерея",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ))
              ]),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 10,
        ),
        linerProgress(),
        SizedBox(
          height: 10,
        ),
        Container(
            height: 100,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black, width: 1)))),
                onPressed: () {
                  if (_dropdownDom == null) {
                    return;
                  }
                  var result = postImage(
                      _dropdownDom!.id, _dropdownDom!.name, imagePassport);
                  if (result != null) {
                    setState(() {
                      imagePassport = null;
                    });
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    child: Text("Отправить",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontFamily: Constans().font))))),
      ],
    );
  }

  Future postImage(String id, String name, var img) async {
    Uint8List data = await img.readAsBytes();
    List<int> list = data.cast();
    final bytes = <int>[];
    String? token = await storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    Map<String, String> mapparam = {"id": id};
    final uri = Uri.parse('$urimain/api/les/postimage');
    // .replace(queryParameters: mapparam);

    var request = await http.MultipartRequest('POST', uri);
    request.fields['id'] = id;
    request.fields['name'] = name;

    request.headers.addAll(hedersWithToken);
    request.files
        .add(http.MultipartFile.fromBytes("image", list, filename: name));
    final contentLength = request.contentLength;

    request.send().then((value) => {
          value.stream.listen((value) {
            bytes.addAll(value);

            double p = (bytes.length / contentLength) * 100;
            setState(() {
              if (p > 100) {
                progress = 100;
                sended = true;
              } else {
                progress = p;
              }
            });
          }, onDone: () {
            setState(() {
              progress = 0;
            });
          }, cancelOnError: true),
          if (value.statusCode == 200) {print('Ok')}
        });
  }

  Widget getImage() {
    if (imagePassport != null && sended == false) {
      return Card(child: Image.file(imagePassport));
    } else if (imagePassport == null && sended == false) {
      return Icon(
        Icons.image,
        size: 80,
        color: Colors.black,
      );
    } else if (sended == true) {
      return Center(
          child: Text(
        "Отправлен!",
        style: TextStyle(fontFamily: Constans().font, fontSize: 20),
      ));
    } else {
      return Icon(
        Icons.image,
        size: 80,
        color: Colors.black,
      );
    }
  }

  Widget firstDropDown() {
    return DropdownButton<KompleksEntity>(
      // borderRadius: BorderRadius.circular(10),
      style: TextStyle(fontSize: 20, color: Colors.black),
      isExpanded: true,
      hint: Text("Комплекс", style: TextStyle(fontFamily: Constans().font)),
      onChanged: (newValue) {
        _dropdownDom = null;
        setState(() {
          _dropdownAdress = newValue!;
        });

        HttpService()
            .getDomByIdKompleks(
                _dropdownAdress == null ? "" : _dropdownAdress!.id)
            .then((value) {
          setState(() {
            _domlist = value;
          });
        });
      },
      items: _komplekslist.map((KompleksEntity e) {
        return DropdownMenuItem<KompleksEntity>(
          child: Text(
            e.name,
            style: TextStyle(fontFamily: Constans().font),
          ),
          value: e,
        );
      }).toList(),
      value: _dropdownAdress,
    );
  }

  Widget secondDropdown() {
    return DropdownButton<DomEntity>(
      borderRadius: BorderRadius.circular(10),
      isExpanded: true,
      style: TextStyle(fontSize: 20, color: Colors.black),
      hint: Text(
        "Дом",
        style: TextStyle(fontFamily: Constans().font),
      ),
      onChanged: (newValue) {
        setState(() {
          _dropdownDom = newValue!;
        });
      },
      items: _domlist
          .map((DomEntity e) => DropdownMenuItem<DomEntity>(
                child: Text(
                  e.name,
                  style: TextStyle(fontFamily: Constans().font),
                ),
                value: e,
              ))
          .toList(),
      value: _dropdownDom,
    );
  }

  Widget linerProgress() {
    return LinearProgressIndicator(
      value: progress,
      valueColor: AlwaysStoppedAnimation(Colors.black),
      backgroundColor: Colors.white,
      minHeight: 10,
    );
  }

  // CircularProgressIndicator(
  // value: progress,
  // valueColor: AlwaysStoppedAnimation(Constans().backroundcolors),
  // // strokeWidth: 10,
  // backgroundColor: Colors.white,
  // )

  Future pickImage(ImageSource source) async {
    XFile? _imageFile =
        await ImagePicker().pickImage(source: source, imageQuality: 30);
    if (_imageFile == null) return;

    filename = _imageFile.name;
    setState(() {
      imagePassport = File(_imageFile.path);
    });
  }
}
