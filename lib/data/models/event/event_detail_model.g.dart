// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventDetailModelImpl _$$EventDetailModelImplFromJson(
  Map<String, dynamic> json,
) => _$EventDetailModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  bannerURL: json['bannerURL'] as String?,
  description: json['description'] as String?,
  venue: json['venue'] as String?,
  categories: json['categories'] == null
      ? null
      : CategoryModel.fromJson(json['categories'] as Map<String, dynamic>),
  address: json['address'] as String?,
  orgLogoURL: json['orgLogoURL'] as String?,
  orgName: json['orgName'] as String?,
  orgDescription: json['orgDescription'] as String?,
  status: json['status'] as String?,
  minTicketPrice: (json['minTicketPrice'] as num?)?.toInt(),
  isFree: json['isFree'] as bool?,
  ticketType: (json['ticketType'] as List<dynamic>?)
      ?.map((e) => TicketTypeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
  locationId: json['locationId'] as String?,
  isHot: json['isHot'] as bool?,
);

Map<String, dynamic> _$$EventDetailModelImplToJson(
  _$EventDetailModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'bannerURL': instance.bannerURL,
  'description': instance.description,
  'venue': instance.venue,
  'categories': instance.categories?.toJson(),
  'address': instance.address,
  'orgLogoURL': instance.orgLogoURL,
  'orgName': instance.orgName,
  'orgDescription': instance.orgDescription,
  'status': instance.status,
  'minTicketPrice': instance.minTicketPrice,
  'isFree': instance.isFree,
  'ticketType': instance.ticketType?.map((e) => e.toJson()).toList(),
  'startTime': instance.startTime?.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'locationId': instance.locationId,
  'isHot': instance.isHot,
};
