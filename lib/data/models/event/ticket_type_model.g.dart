// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketTypeModelImpl _$$TicketTypeModelImplFromJson(
  Map<String, dynamic> json,
) => _$TicketTypeModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isFree: json['isFree'] as bool?,
  price: (json['price'] as num?)?.toInt(),
  maxQtyPerOrder: (json['maxQtyPerOrder'] as num?)?.toInt(),
  minQtyPerOrder: (json['minQtyPerOrder'] as num?)?.toInt(),
  status: json['status'] as String?,
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  totalQuantity: (json['totalQuantity'] as num?)?.toInt(),
);

Map<String, dynamic> _$$TicketTypeModelImplToJson(
  _$TicketTypeModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'isFree': instance.isFree,
  'price': instance.price,
  'maxQtyPerOrder': instance.maxQtyPerOrder,
  'minQtyPerOrder': instance.minQtyPerOrder,
  'status': instance.status,
  'startTime': instance.startTime?.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'totalQuantity': instance.totalQuantity,
};
