import 'dart:convert';
import 'package:binokor/generated/json/base/json_field.dart';
import 'package:binokor/generated/json/image_data_entity.g.dart';
import 'package:binokor/models/dom_entity.dart';

@JsonSerializable()
class ImageDataEntity {

	late String id;
	late String name;
	// late String image;
  String? datacreate;
  // late DomEntity dom;

  ImageDataEntity();

  factory ImageDataEntity.fromJson(Map<String, dynamic> json) => $ImageDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $ImageDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
