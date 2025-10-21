// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      day: json['day'] == null ? null : DateTime.parse(json['day'] as String),
      price: (json['price'] as num?)?.toInt(),
      categories: CategoryModel.fromJson(
        json['categories'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'day': instance.day?.toIso8601String(),
      'price': instance.price,
      'categories': instance.categories,
    };
