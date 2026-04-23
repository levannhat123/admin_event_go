import 'package:admin_event_go/data/models/category/category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'ticket_type_model.dart';

part 'event_detail_model.freezed.dart';
part 'event_detail_model.g.dart';

@freezed
class EventDetailModel with _$EventDetailModel {
  @JsonSerializable(explicitToJson: true)
  const factory EventDetailModel({
    required String id,
    required String title,
    String? bannerURL,
    String? description,
    String? venue,
    CategoryModel? categories,
    String? address,
    String? orgLogoURL,
    String? orgName,
    String? orgDescription,
    String? status,
    int? minTicketPrice,
    bool? isFree,
    List<TicketTypeModel>? ticketType,
    DateTime? startTime,
    DateTime? endTime,
    String? locationId,
    bool? isHot,
  }) = _EventDetailModel;

  factory EventDetailModel.fromJson(Map<String, dynamic> json) =>
      _$EventDetailModelFromJson(json);
}
