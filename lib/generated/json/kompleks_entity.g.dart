import 'package:binokor/generated/json/base/json_convert_content.dart';
import 'package:binokor/models/kompleks_entity.dart';

KompleksEntity $KompleksEntityFromJson(Map<String, dynamic> json) {
	final KompleksEntity kompleksEntity = KompleksEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		kompleksEntity.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		kompleksEntity.name = name;
	}
	return kompleksEntity;
}

Map<String, dynamic> $KompleksEntityToJson(KompleksEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	return data;
}