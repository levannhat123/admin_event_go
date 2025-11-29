import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: "full_name") String? fullName,
    @JsonKey(name: "avatar_url") String? avatarUrl,
    String? phone,
    String? email,
    String? role,
    @JsonKey(name: "created_at") DateTime? createdAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
