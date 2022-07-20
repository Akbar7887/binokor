import 'dart:convert';
import 'package:binokor/generated/json/base/json_field.dart';
import 'package:binokor/generated/json/dom_entity.g.dart';
import 'package:binokor/models/kompleks_entity.dart';

@JsonSerializable()
class DomEntity {

	late String id;
	late String name;
	late KompleksEntity kompleks;
  
  DomEntity();

  factory DomEntity.fromJson(Map<String, dynamic> json) => $DomEntityFromJson(json);

  Map<String, dynamic> toJson() => $DomEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
