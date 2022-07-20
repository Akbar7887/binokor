import 'package:binokor/generated/json/base/json_convert_content.dart';
import 'package:binokor/models/dom_entity.dart';
import 'package:binokor/models/kompleks_entity.dart';


DomEntity $DomEntityFromJson(Map<String, dynamic> json) {
	final DomEntity domEntity = DomEntity();
	final String? id = jsonConvert.convert<String>(json['id']);
	if (id != null) {
		domEntity.id = id;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		domEntity.name = name;
	}
	final KompleksEntity? kompleks = jsonConvert.convert<KompleksEntity>(json['kompleks']);
	if (kompleks != null) {
		domEntity.kompleks = kompleks;
	}
	return domEntity;
}

Map<String, dynamic> $DomEntityToJson(DomEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['id'] = entity.id;
	data['name'] = entity.name;
	data['kompleks'] = entity.kompleks.toJson();
	return data;
}