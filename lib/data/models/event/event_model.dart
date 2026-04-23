import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String name,
    String? imageUrl,
    DateTime? day,
    int? price,
    required CategoryModel categories,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
