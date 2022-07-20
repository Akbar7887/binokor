import 'dart:convert';

import 'package:binokor/domain/Constants.dart';
import 'package:binokor/models/dom_entity.dart';
import 'package:binokor/models/image_data_entity.dart';
import 'package:binokor/models/kompleks_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HttpService {
  late final response;
  String urimain = Constans().uri;
  Map<String, String> headers = {
    "Accept": "application/json",
    "content-type": "application/json"
  };
  FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<KompleksEntity>> getAllkomleks() async {
    String? token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    final uri = Uri.parse('$urimain/api/les/kompleks');

    response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(utf8.decode(response.bodyBytes));
      return List<KompleksEntity>.from(
          l.map((element) => KompleksEntity.fromJson(element)));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<DomEntity>> getDomByIdKompleks(String id) async {
    if (id == '') {
      return [];
    }

    String? token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };

    Map<String, String> param = {"id": id};
    final uri =
        Uri.parse('$urimain/api/les/dom').replace(queryParameters: param);

    response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(utf8.decode(response.bodyBytes));
      return List<DomEntity>.from(l.map((element) => DomEntity.fromJson(element)));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<ImageDataEntity>> getAllImage(String id) async {
    String? token = await _storage.read(key: "token");

    Map<String, String> hedersWithToken = {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    };
    if (id == '') {
      return [];
    }
    Map<String, String> param = {"id": id};
    final uri =
        Uri.parse('$urimain/api/les/imageall').replace(queryParameters: param);

    response = await http.get(uri, headers: hedersWithToken);
    if (response.statusCode == 200) {
      print(response.statusCode);
      Iterable l = jsonDecode(utf8.decode(response.bodyBytes));
      return List<ImageDataEntity>.from(
          l.map((e) => ImageDataEntity.fromJson(e)));
    } else {
      throw Exception(response.statusCode);
    }
  }
}
