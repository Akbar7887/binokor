import 'dart:convert';
import 'dart:typed_data';

import 'package:binokor/domain/Constants.dart';
import 'package:binokor/models/image_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../api/HttpService.dart';
import '../models/dom_entity.dart';
import '../models/kompleks_entity.dart';
import 'package:intl/intl.dart';

class HistoryImagePage extends StatefulWidget {
  const HistoryImagePage({Key? key}) : super(key: key);

  @override
  State<HistoryImagePage> createState() => _HistoryImagePageState();
}

class _HistoryImagePageState extends State<HistoryImagePage> {
  List<KompleksEntity> _komplekslist = [];
  KompleksEntity? _dropdownAdress;
  List<DomEntity> _domlist = [];
  DomEntity? _dropdownDom;
  List<ImageDataEntity> _imagelist = [];
  FlutterSecureStorage storage = FlutterSecureStorage();
  String token = '';

  Future<void> getToken() async {
    token = await storage.read(key: "token") as String;
  }

  @override
  void initState() {
    super.initState();
    HttpService().getAllkomleks().then((value) {
      setState(() {
        _komplekslist = value;
      });
    });
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return mainHistory();
  }

  Widget mainHistory() {
    return Container(
        child: Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        color: Constans().backroundcolors,
        alignment: Alignment.center,
        child: Text(
          "История фото",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontFamily: Constans().font),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
          child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: DropdownButton<KompleksEntity>(
                // borderRadius: BorderRadius.circular(10),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: Constans().font),
                isExpanded: true,
                hint: Text(
                  "Комплекс",
                  style: TextStyle(fontFamily: Constans().font),
                ),
                // hint: Text("Адрес"),
                onChanged: (newValue) {
                  _dropdownDom = null;
                  setState(() {
                    _dropdownAdress = newValue;
                  });
                  HttpService()
                      .getDomByIdKompleks(_dropdownAdress!.id)
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
              ))),
      Container(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: getDropDownDom(),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Divider(
        color: Constans().backroundcolors,
      ),
      _dropdownDom == null ? Container() : getlistView(),
    ]));
  }

  Widget getDropDownDom() {
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
                child:
                    Text(e.name, style: TextStyle(fontFamily: Constans().font)),
                value: e,
              ))
          .toList(),
      value: _dropdownDom,
    );
  }

  Widget getlistView() {
    return FutureBuilder(
        future: HttpService().getAllImage(_dropdownDom!.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Text(
                "Загрузка...",
                style: TextStyle(fontFamily: Constans().font),
              ),
            );
          } else {
            _imagelist = snapshot.data as List<ImageDataEntity>;
            _imagelist
                .sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
            if (_imagelist.length == 0) {
              return (Container());
            } else {
              return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _imagelist.length,
                      shrinkWrap: true,
                      itemBuilder: (context, idx) {
                        String date = '';
                        if (_imagelist[idx].datacreate != null) {
                          DateTime datetime = DateFormat('yyyy-MM-dd')
                              .parse(_imagelist[idx].datacreate!);
                          DateFormat formatter = DateFormat('dd-MM-yyyy');
                          date = formatter.format(datetime);
                        }
                        return Container(
                            child: InkWell(
                          onTap: () {
                            getDialog(idx);
                          },
                          child: Card(
                              elevation: 5,
                              child: Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Text(
                                        date,
                                        style: TextStyle(
                                            fontFamily: Constans().font,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Spacer(),
                                  Container(
                                      width: 200,
                                      height: 100,
                                      child: Image.network(
                                          '${Constans().uri}/api/les/image?id=${_imagelist[idx].id}',
                                          headers: {
                                            "Content-type": "application/x-www-form-urlencoded",
                                            "Authorization": "Bearer $token"
                                          })),
                                ],
                              )),
                        ));
                      }));
            }
          }
        });
  }

  Future<void> getDialog(int idx) {
    return showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          content: Image.network(
              '${Constans().uri}/api/les/image?id=${_imagelist[idx].id}',
              headers: {
                "Content-type": "application/json",
                "Authorization": "Bearer $token"
              },
              fit: BoxFit.fill),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Закрыть',
                style: TextStyle(fontFamily: Constans().font),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}
