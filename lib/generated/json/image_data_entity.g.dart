import 'package:binokor/generated/json/base/json_convert_content.dart';
import 'package:binokor/models/image_data_entity.dart';
import 'package:binokor/models/dom_entity.dart';


ImageDataEntity $ImageDataEntityFromJson(Map<String, dynamic> json) {
	final ImageDataEntity imageDataEntity = ImageDataEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		imageDataEntity.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		imageDataEntity.name = name;
	}
	final String? datacreate = jsonConvert.convert<String>(json['datacreate']);
	if (datacreate != null) {
		imageDataEntity.datacreate = datacreate;
	}
	return imageDataEntity;
}

Map<String, dynamic> $ImageDataEntityToJson(ImageDataEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['datacreate'] = entity.datacreate;
	return data;
}