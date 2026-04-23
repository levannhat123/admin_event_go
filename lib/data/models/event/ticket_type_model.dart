import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_type_model.freezed.dart';
part 'ticket_type_model.g.dart';

@freezed
class TicketTypeModel with _$TicketTypeModel {
  const factory TicketTypeModel({
    required String id,
    required String name,
    String? description,
    bool? isFree,
    int? price,
    int? maxQtyPerOrder,
    int? minQtyPerOrder,
    String? status,
    DateTime? startTime,
    DateTime? endTime,
    int? totalQuantity,
  }) = _TicketTypeModel;

  factory TicketTypeModel.fromJson(Map<String, dynamic> json) =>
      _$TicketTypeModelFromJson(json);
}
