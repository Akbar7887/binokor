import 'dart:convert';
import 'package:binokor/generated/json/base/json_field.dart';
import 'package:binokor/generated/json/kompleks_entity.g.dart';

@JsonSerializable()
class KompleksEntity {

	late String id;
	late String name;
  
  KompleksEntity();

  factory KompleksEntity.fromJson(Map<String, dynamic> json) => $KompleksEntityFromJson(json);

  Map<String, dynamic> toJson() => $KompleksEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}