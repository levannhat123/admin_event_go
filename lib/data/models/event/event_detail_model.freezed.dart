// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventDetailModel _$EventDetailModelFromJson(Map<String, dynamic> json) {
  return _EventDetailModel.fromJson(json);
}

/// @nodoc
mixin _$EventDetailModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get bannerURL => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get venue => throw _privateConstructorUsedError;
  CategoryModel? get categories => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get orgLogoURL => throw _privateConstructorUsedError;
  String? get orgName => throw _privateConstructorUsedError;
  String? get orgDescription => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get minTicketPrice => throw _privateConstructorUsedError;
  bool? get isFree => throw _privateConstructorUsedError;
  List<TicketTypeModel>? get ticketType => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  String? get locationId => throw _privateConstructorUsedError;
  bool? get isHot => throw _privateConstructorUsedError;

  /// Serializes this EventDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventDetailModelCopyWith<EventDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventDetailModelCopyWith<$Res> {
  factory $EventDetailModelCopyWith(
    EventDetailModel value,
    $Res Function(EventDetailModel) then,
  ) = _$EventDetailModelCopyWithImpl<$Res, EventDetailModel>;
  @useResult
  $Res call({
    String id,
    String title,
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
  });

  $CategoryModelCopyWith<$Res>? get categories;
}

/// @nodoc
class _$EventDetailModelCopyWithImpl<$Res, $Val extends EventDetailModel>
    implements $EventDetailModelCopyWith<$Res> {
  _$EventDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? bannerURL = freezed,
    Object? description = freezed,
    Object? venue = freezed,
    Object? categories = freezed,
    Object? address = freezed,
    Object? orgLogoURL = freezed,
    Object? orgName = freezed,
    Object? orgDescription = freezed,
    Object? status = freezed,
    Object? minTicketPrice = freezed,
    Object? isFree = freezed,
    Object? ticketType = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? locationId = freezed,
    Object? isHot = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            bannerURL: freezed == bannerURL
                ? _value.bannerURL
                : bannerURL // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            venue: freezed == venue
                ? _value.venue
                : venue // ignore: cast_nullable_to_non_nullable
                      as String?,
            categories: freezed == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as CategoryModel?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            orgLogoURL: freezed == orgLogoURL
                ? _value.orgLogoURL
                : orgLogoURL // ignore: cast_nullable_to_non_nullable
                      as String?,
            orgName: freezed == orgName
                ? _value.orgName
                : orgName // ignore: cast_nullable_to_non_nullable
                      as String?,
            orgDescription: freezed == orgDescription
                ? _value.orgDescription
                : orgDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            minTicketPrice: freezed == minTicketPrice
                ? _value.minTicketPrice
                : minTicketPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            isFree: freezed == isFree
                ? _value.isFree
                : isFree // ignore: cast_nullable_to_non_nullable
                      as bool?,
            ticketType: freezed == ticketType
                ? _value.ticketType
                : ticketType // ignore: cast_nullable_to_non_nullable
                      as List<TicketTypeModel>?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            locationId: freezed == locationId
                ? _value.locationId
                : locationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isHot: freezed == isHot
                ? _value.isHot
                : isHot // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }

  /// Create a copy of EventDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get categories {
    if (_value.categories == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.categories!, (value) {
      return _then(_value.copyWith(categories: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventDetailModelImplCopyWith<$Res>
    implements $EventDetailModelCopyWith<$Res> {
  factory _$$EventDetailModelImplCopyWith(
    _$EventDetailModelImpl value,
    $Res Function(_$EventDetailModelImpl) then,
  ) = __$$EventDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
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
  });

  @override
  $CategoryModelCopyWith<$Res>? get categories;
}

/// @nodoc
class __$$EventDetailModelImplCopyWithImpl<$Res>
    extends _$EventDetailModelCopyWithImpl<$Res, _$EventDetailModelImpl>
    implements _$$EventDetailModelImplCopyWith<$Res> {
  __$$EventDetailModelImplCopyWithImpl(
    _$EventDetailModelImpl _value,
    $Res Function(_$EventDetailModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? bannerURL = freezed,
    Object? description = freezed,
    Object? venue = freezed,
    Object? categories = freezed,
    Object? address = freezed,
    Object? orgLogoURL = freezed,
    Object? orgName = freezed,
    Object? orgDescription = freezed,
    Object? status = freezed,
    Object? minTicketPrice = freezed,
    Object? isFree = freezed,
    Object? ticketType = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? locationId = freezed,
    Object? isHot = freezed,
  }) {
    return _then(
      _$EventDetailModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        bannerURL: freezed == bannerURL
            ? _value.bannerURL
            : bannerURL // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        venue: freezed == venue
            ? _value.venue
            : venue // ignore: cast_nullable_to_non_nullable
                  as String?,
        categories: freezed == categories
            ? _value.categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as CategoryModel?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        orgLogoURL: freezed == orgLogoURL
            ? _value.orgLogoURL
            : orgLogoURL // ignore: cast_nullable_to_non_nullable
                  as String?,
        orgName: freezed == orgName
            ? _value.orgName
            : orgName // ignore: cast_nullable_to_non_nullable
                  as String?,
        orgDescription: freezed == orgDescription
            ? _value.orgDescription
            : orgDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        minTicketPrice: freezed == minTicketPrice
            ? _value.minTicketPrice
            : minTicketPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        isFree: freezed == isFree
            ? _value.isFree
            : isFree // ignore: cast_nullable_to_non_nullable
                  as bool?,
        ticketType: freezed == ticketType
            ? _value._ticketType
            : ticketType // ignore: cast_nullable_to_non_nullable
                  as List<TicketTypeModel>?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        locationId: freezed == locationId
            ? _value.locationId
            : locationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isHot: freezed == isHot
            ? _value.isHot
            : isHot // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$EventDetailModelImpl implements _EventDetailModel {
  const _$EventDetailModelImpl({
    required this.id,
    required this.title,
    this.bannerURL,
    this.description,
    this.venue,
    this.categories,
    this.address,
    this.orgLogoURL,
    this.orgName,
    this.orgDescription,
    this.status,
    this.minTicketPrice,
    this.isFree,
    final List<TicketTypeModel>? ticketType,
    this.startTime,
    this.endTime,
    this.locationId,
    this.isHot,
  }) : _ticketType = ticketType;

  factory _$EventDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventDetailModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? bannerURL;
  @override
  final String? description;
  @override
  final String? venue;
  @override
  final CategoryModel? categories;
  @override
  final String? address;
  @override
  final String? orgLogoURL;
  @override
  final String? orgName;
  @override
  final String? orgDescription;
  @override
  final String? status;
  @override
  final int? minTicketPrice;
  @override
  final bool? isFree;
  final List<TicketTypeModel>? _ticketType;
  @override
  List<TicketTypeModel>? get ticketType {
    final value = _ticketType;
    if (value == null) return null;
    if (_ticketType is EqualUnmodifiableListView) return _ticketType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final String? locationId;
  @override
  final bool? isHot;

  @override
  String toString() {
    return 'EventDetailModel(id: $id, title: $title, bannerURL: $bannerURL, description: $description, venue: $venue, categories: $categories, address: $address, orgLogoURL: $orgLogoURL, orgName: $orgName, orgDescription: $orgDescription, status: $status, minTicketPrice: $minTicketPrice, isFree: $isFree, ticketType: $ticketType, startTime: $startTime, endTime: $endTime, locationId: $locationId, isHot: $isHot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventDetailModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.bannerURL, bannerURL) ||
                other.bannerURL == bannerURL) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.categories, categories) ||
                other.categories == categories) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.orgLogoURL, orgLogoURL) ||
                other.orgLogoURL == orgLogoURL) &&
            (identical(other.orgName, orgName) || other.orgName == orgName) &&
            (identical(other.orgDescription, orgDescription) ||
                other.orgDescription == orgDescription) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.minTicketPrice, minTicketPrice) ||
                other.minTicketPrice == minTicketPrice) &&
            (identical(other.isFree, isFree) || other.isFree == isFree) &&
            const DeepCollectionEquality().equals(
              other._ticketType,
              _ticketType,
            ) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.isHot, isHot) || other.isHot == isHot));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    bannerURL,
    description,
    venue,
    categories,
    address,
    orgLogoURL,
    orgName,
    orgDescription,
    status,
    minTicketPrice,
    isFree,
    const DeepCollectionEquality().hash(_ticketType),
    startTime,
    endTime,
    locationId,
    isHot,
  );

  /// Create a copy of EventDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventDetailModelImplCopyWith<_$EventDetailModelImpl> get copyWith =>
      __$$EventDetailModelImplCopyWithImpl<_$EventDetailModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EventDetailModelImplToJson(this);
  }
}

abstract class _EventDetailModel implements EventDetailModel {
  const factory _EventDetailModel({
    required final String id,
    required final String title,
    final String? bannerURL,
    final String? description,
    final String? venue,
    final CategoryModel? categories,
    final String? address,
    final String? orgLogoURL,
    final String? orgName,
    final String? orgDescription,
    final String? status,
    final int? minTicketPrice,
    final bool? isFree,
    final List<TicketTypeModel>? ticketType,
    final DateTime? startTime,
    final DateTime? endTime,
    final String? locationId,
    final bool? isHot,
  }) = _$EventDetailModelImpl;

  factory _EventDetailModel.fromJson(Map<String, dynamic> json) =
      _$EventDetailModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get bannerURL;
  @override
  String? get description;
  @override
  String? get venue;
  @override
  CategoryModel? get categories;
  @override
  String? get address;
  @override
  String? get orgLogoURL;
  @override
  String? get orgName;
  @override
  String? get orgDescription;
  @override
  String? get status;
  @override
  int? get minTicketPrice;
  @override
  bool? get isFree;
  @override
  List<TicketTypeModel>? get ticketType;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  String? get locationId;
  @override
  bool? get isHot;

  /// Create a copy of EventDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventDetailModelImplCopyWith<_$EventDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
