// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeadDto {

/// The lead's public UUID (the server never exposes internal ids).
 String? get id; String? get leadCode; String? get customerName; String? get phone; String? get email; String? get customerWhatsapp; String? get customerCity; String? get customerState; String? get customerCountry; String? get leadSource; String? get leadType; String? get leadStage; AssignedUserDto? get assignedUser; String? get birthDate; String? get followUpDate; String? get travelDate; String? get returnDate; num? get budget; String? get budgetBasis; int? get logCount; String? get lastActivityAt; String? get departCountry; String? get departCity; String? get departureMode; int? get rooms; int? get adults; int? get children; int? get infants; int? get extraBeds; List<String> get services; String? get notes; List<LeadItineraryDto> get itinerary; String? get createdAt; QuotationRefDto? get latestQuotation; String? get convertedBookingPublicId; bool? get openToClaim; int? get claimVersion;
/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadDtoCopyWith<LeadDto> get copyWith => _$LeadDtoCopyWithImpl<LeadDto>(this as LeadDto, _$identity);

  /// Serializes this LeadDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadDto&&(identical(other.id, id) || other.id == id)&&(identical(other.leadCode, leadCode) || other.leadCode == leadCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.customerWhatsapp, customerWhatsapp) || other.customerWhatsapp == customerWhatsapp)&&(identical(other.customerCity, customerCity) || other.customerCity == customerCity)&&(identical(other.customerState, customerState) || other.customerState == customerState)&&(identical(other.customerCountry, customerCountry) || other.customerCountry == customerCountry)&&(identical(other.leadSource, leadSource) || other.leadSource == leadSource)&&(identical(other.leadType, leadType) || other.leadType == leadType)&&(identical(other.leadStage, leadStage) || other.leadStage == leadStage)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.returnDate, returnDate) || other.returnDate == returnDate)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.budgetBasis, budgetBasis) || other.budgetBasis == budgetBasis)&&(identical(other.logCount, logCount) || other.logCount == logCount)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.departCountry, departCountry) || other.departCountry == departCountry)&&(identical(other.departCity, departCity) || other.departCity == departCity)&&(identical(other.departureMode, departureMode) || other.departureMode == departureMode)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.infants, infants) || other.infants == infants)&&(identical(other.extraBeds, extraBeds) || other.extraBeds == extraBeds)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.itinerary, itinerary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.latestQuotation, latestQuotation) || other.latestQuotation == latestQuotation)&&(identical(other.convertedBookingPublicId, convertedBookingPublicId) || other.convertedBookingPublicId == convertedBookingPublicId)&&(identical(other.openToClaim, openToClaim) || other.openToClaim == openToClaim)&&(identical(other.claimVersion, claimVersion) || other.claimVersion == claimVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,leadCode,customerName,phone,email,customerWhatsapp,customerCity,customerState,customerCountry,leadSource,leadType,leadStage,assignedUser,birthDate,followUpDate,travelDate,returnDate,budget,budgetBasis,logCount,lastActivityAt,departCountry,departCity,departureMode,rooms,adults,children,infants,extraBeds,const DeepCollectionEquality().hash(services),notes,const DeepCollectionEquality().hash(itinerary),createdAt,latestQuotation,convertedBookingPublicId,openToClaim,claimVersion]);

@override
String toString() {
  return 'LeadDto(id: $id, leadCode: $leadCode, customerName: $customerName, phone: $phone, email: $email, customerWhatsapp: $customerWhatsapp, customerCity: $customerCity, customerState: $customerState, customerCountry: $customerCountry, leadSource: $leadSource, leadType: $leadType, leadStage: $leadStage, assignedUser: $assignedUser, birthDate: $birthDate, followUpDate: $followUpDate, travelDate: $travelDate, returnDate: $returnDate, budget: $budget, budgetBasis: $budgetBasis, logCount: $logCount, lastActivityAt: $lastActivityAt, departCountry: $departCountry, departCity: $departCity, departureMode: $departureMode, rooms: $rooms, adults: $adults, children: $children, infants: $infants, extraBeds: $extraBeds, services: $services, notes: $notes, itinerary: $itinerary, createdAt: $createdAt, latestQuotation: $latestQuotation, convertedBookingPublicId: $convertedBookingPublicId, openToClaim: $openToClaim, claimVersion: $claimVersion)';
}


}

/// @nodoc
abstract mixin class $LeadDtoCopyWith<$Res>  {
  factory $LeadDtoCopyWith(LeadDto value, $Res Function(LeadDto) _then) = _$LeadDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? leadCode, String? customerName, String? phone, String? email, String? customerWhatsapp, String? customerCity, String? customerState, String? customerCountry, String? leadSource, String? leadType, String? leadStage, AssignedUserDto? assignedUser, String? birthDate, String? followUpDate, String? travelDate, String? returnDate, num? budget, String? budgetBasis, int? logCount, String? lastActivityAt, String? departCountry, String? departCity, String? departureMode, int? rooms, int? adults, int? children, int? infants, int? extraBeds, List<String> services, String? notes, List<LeadItineraryDto> itinerary, String? createdAt, QuotationRefDto? latestQuotation, String? convertedBookingPublicId, bool? openToClaim, int? claimVersion
});


$AssignedUserDtoCopyWith<$Res>? get assignedUser;$QuotationRefDtoCopyWith<$Res>? get latestQuotation;

}
/// @nodoc
class _$LeadDtoCopyWithImpl<$Res>
    implements $LeadDtoCopyWith<$Res> {
  _$LeadDtoCopyWithImpl(this._self, this._then);

  final LeadDto _self;
  final $Res Function(LeadDto) _then;

/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? leadCode = freezed,Object? customerName = freezed,Object? phone = freezed,Object? email = freezed,Object? customerWhatsapp = freezed,Object? customerCity = freezed,Object? customerState = freezed,Object? customerCountry = freezed,Object? leadSource = freezed,Object? leadType = freezed,Object? leadStage = freezed,Object? assignedUser = freezed,Object? birthDate = freezed,Object? followUpDate = freezed,Object? travelDate = freezed,Object? returnDate = freezed,Object? budget = freezed,Object? budgetBasis = freezed,Object? logCount = freezed,Object? lastActivityAt = freezed,Object? departCountry = freezed,Object? departCity = freezed,Object? departureMode = freezed,Object? rooms = freezed,Object? adults = freezed,Object? children = freezed,Object? infants = freezed,Object? extraBeds = freezed,Object? services = null,Object? notes = freezed,Object? itinerary = null,Object? createdAt = freezed,Object? latestQuotation = freezed,Object? convertedBookingPublicId = freezed,Object? openToClaim = freezed,Object? claimVersion = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,leadCode: freezed == leadCode ? _self.leadCode : leadCode // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,customerWhatsapp: freezed == customerWhatsapp ? _self.customerWhatsapp : customerWhatsapp // ignore: cast_nullable_to_non_nullable
as String?,customerCity: freezed == customerCity ? _self.customerCity : customerCity // ignore: cast_nullable_to_non_nullable
as String?,customerState: freezed == customerState ? _self.customerState : customerState // ignore: cast_nullable_to_non_nullable
as String?,customerCountry: freezed == customerCountry ? _self.customerCountry : customerCountry // ignore: cast_nullable_to_non_nullable
as String?,leadSource: freezed == leadSource ? _self.leadSource : leadSource // ignore: cast_nullable_to_non_nullable
as String?,leadType: freezed == leadType ? _self.leadType : leadType // ignore: cast_nullable_to_non_nullable
as String?,leadStage: freezed == leadStage ? _self.leadStage : leadStage // ignore: cast_nullable_to_non_nullable
as String?,assignedUser: freezed == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as AssignedUserDto?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,returnDate: freezed == returnDate ? _self.returnDate : returnDate // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as num?,budgetBasis: freezed == budgetBasis ? _self.budgetBasis : budgetBasis // ignore: cast_nullable_to_non_nullable
as String?,logCount: freezed == logCount ? _self.logCount : logCount // ignore: cast_nullable_to_non_nullable
as int?,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as String?,departCountry: freezed == departCountry ? _self.departCountry : departCountry // ignore: cast_nullable_to_non_nullable
as String?,departCity: freezed == departCity ? _self.departCity : departCity // ignore: cast_nullable_to_non_nullable
as String?,departureMode: freezed == departureMode ? _self.departureMode : departureMode // ignore: cast_nullable_to_non_nullable
as String?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,adults: freezed == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int?,children: freezed == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int?,infants: freezed == infants ? _self.infants : infants // ignore: cast_nullable_to_non_nullable
as int?,extraBeds: freezed == extraBeds ? _self.extraBeds : extraBeds // ignore: cast_nullable_to_non_nullable
as int?,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,itinerary: null == itinerary ? _self.itinerary : itinerary // ignore: cast_nullable_to_non_nullable
as List<LeadItineraryDto>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,latestQuotation: freezed == latestQuotation ? _self.latestQuotation : latestQuotation // ignore: cast_nullable_to_non_nullable
as QuotationRefDto?,convertedBookingPublicId: freezed == convertedBookingPublicId ? _self.convertedBookingPublicId : convertedBookingPublicId // ignore: cast_nullable_to_non_nullable
as String?,openToClaim: freezed == openToClaim ? _self.openToClaim : openToClaim // ignore: cast_nullable_to_non_nullable
as bool?,claimVersion: freezed == claimVersion ? _self.claimVersion : claimVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignedUserDtoCopyWith<$Res>? get assignedUser {
    if (_self.assignedUser == null) {
    return null;
  }

  return $AssignedUserDtoCopyWith<$Res>(_self.assignedUser!, (value) {
    return _then(_self.copyWith(assignedUser: value));
  });
}/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationRefDtoCopyWith<$Res>? get latestQuotation {
    if (_self.latestQuotation == null) {
    return null;
  }

  return $QuotationRefDtoCopyWith<$Res>(_self.latestQuotation!, (value) {
    return _then(_self.copyWith(latestQuotation: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeadDto].
extension LeadDtoPatterns on LeadDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadDto value)  $default,){
final _that = this;
switch (_that) {
case _LeadDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadDto value)?  $default,){
final _that = this;
switch (_that) {
case _LeadDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? leadCode,  String? customerName,  String? phone,  String? email,  String? customerWhatsapp,  String? customerCity,  String? customerState,  String? customerCountry,  String? leadSource,  String? leadType,  String? leadStage,  AssignedUserDto? assignedUser,  String? birthDate,  String? followUpDate,  String? travelDate,  String? returnDate,  num? budget,  String? budgetBasis,  int? logCount,  String? lastActivityAt,  String? departCountry,  String? departCity,  String? departureMode,  int? rooms,  int? adults,  int? children,  int? infants,  int? extraBeds,  List<String> services,  String? notes,  List<LeadItineraryDto> itinerary,  String? createdAt,  QuotationRefDto? latestQuotation,  String? convertedBookingPublicId,  bool? openToClaim,  int? claimVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadDto() when $default != null:
return $default(_that.id,_that.leadCode,_that.customerName,_that.phone,_that.email,_that.customerWhatsapp,_that.customerCity,_that.customerState,_that.customerCountry,_that.leadSource,_that.leadType,_that.leadStage,_that.assignedUser,_that.birthDate,_that.followUpDate,_that.travelDate,_that.returnDate,_that.budget,_that.budgetBasis,_that.logCount,_that.lastActivityAt,_that.departCountry,_that.departCity,_that.departureMode,_that.rooms,_that.adults,_that.children,_that.infants,_that.extraBeds,_that.services,_that.notes,_that.itinerary,_that.createdAt,_that.latestQuotation,_that.convertedBookingPublicId,_that.openToClaim,_that.claimVersion);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? leadCode,  String? customerName,  String? phone,  String? email,  String? customerWhatsapp,  String? customerCity,  String? customerState,  String? customerCountry,  String? leadSource,  String? leadType,  String? leadStage,  AssignedUserDto? assignedUser,  String? birthDate,  String? followUpDate,  String? travelDate,  String? returnDate,  num? budget,  String? budgetBasis,  int? logCount,  String? lastActivityAt,  String? departCountry,  String? departCity,  String? departureMode,  int? rooms,  int? adults,  int? children,  int? infants,  int? extraBeds,  List<String> services,  String? notes,  List<LeadItineraryDto> itinerary,  String? createdAt,  QuotationRefDto? latestQuotation,  String? convertedBookingPublicId,  bool? openToClaim,  int? claimVersion)  $default,) {final _that = this;
switch (_that) {
case _LeadDto():
return $default(_that.id,_that.leadCode,_that.customerName,_that.phone,_that.email,_that.customerWhatsapp,_that.customerCity,_that.customerState,_that.customerCountry,_that.leadSource,_that.leadType,_that.leadStage,_that.assignedUser,_that.birthDate,_that.followUpDate,_that.travelDate,_that.returnDate,_that.budget,_that.budgetBasis,_that.logCount,_that.lastActivityAt,_that.departCountry,_that.departCity,_that.departureMode,_that.rooms,_that.adults,_that.children,_that.infants,_that.extraBeds,_that.services,_that.notes,_that.itinerary,_that.createdAt,_that.latestQuotation,_that.convertedBookingPublicId,_that.openToClaim,_that.claimVersion);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? leadCode,  String? customerName,  String? phone,  String? email,  String? customerWhatsapp,  String? customerCity,  String? customerState,  String? customerCountry,  String? leadSource,  String? leadType,  String? leadStage,  AssignedUserDto? assignedUser,  String? birthDate,  String? followUpDate,  String? travelDate,  String? returnDate,  num? budget,  String? budgetBasis,  int? logCount,  String? lastActivityAt,  String? departCountry,  String? departCity,  String? departureMode,  int? rooms,  int? adults,  int? children,  int? infants,  int? extraBeds,  List<String> services,  String? notes,  List<LeadItineraryDto> itinerary,  String? createdAt,  QuotationRefDto? latestQuotation,  String? convertedBookingPublicId,  bool? openToClaim,  int? claimVersion)?  $default,) {final _that = this;
switch (_that) {
case _LeadDto() when $default != null:
return $default(_that.id,_that.leadCode,_that.customerName,_that.phone,_that.email,_that.customerWhatsapp,_that.customerCity,_that.customerState,_that.customerCountry,_that.leadSource,_that.leadType,_that.leadStage,_that.assignedUser,_that.birthDate,_that.followUpDate,_that.travelDate,_that.returnDate,_that.budget,_that.budgetBasis,_that.logCount,_that.lastActivityAt,_that.departCountry,_that.departCity,_that.departureMode,_that.rooms,_that.adults,_that.children,_that.infants,_that.extraBeds,_that.services,_that.notes,_that.itinerary,_that.createdAt,_that.latestQuotation,_that.convertedBookingPublicId,_that.openToClaim,_that.claimVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadDto implements LeadDto {
  const _LeadDto({this.id, this.leadCode, this.customerName, this.phone, this.email, this.customerWhatsapp, this.customerCity, this.customerState, this.customerCountry, this.leadSource, this.leadType, this.leadStage, this.assignedUser, this.birthDate, this.followUpDate, this.travelDate, this.returnDate, this.budget, this.budgetBasis, this.logCount, this.lastActivityAt, this.departCountry, this.departCity, this.departureMode, this.rooms, this.adults, this.children, this.infants, this.extraBeds, final  List<String> services = const <String>[], this.notes, final  List<LeadItineraryDto> itinerary = const <LeadItineraryDto>[], this.createdAt, this.latestQuotation, this.convertedBookingPublicId, this.openToClaim, this.claimVersion}): _services = services,_itinerary = itinerary;
  factory _LeadDto.fromJson(Map<String, dynamic> json) => _$LeadDtoFromJson(json);

/// The lead's public UUID (the server never exposes internal ids).
@override final  String? id;
@override final  String? leadCode;
@override final  String? customerName;
@override final  String? phone;
@override final  String? email;
@override final  String? customerWhatsapp;
@override final  String? customerCity;
@override final  String? customerState;
@override final  String? customerCountry;
@override final  String? leadSource;
@override final  String? leadType;
@override final  String? leadStage;
@override final  AssignedUserDto? assignedUser;
@override final  String? birthDate;
@override final  String? followUpDate;
@override final  String? travelDate;
@override final  String? returnDate;
@override final  num? budget;
@override final  String? budgetBasis;
@override final  int? logCount;
@override final  String? lastActivityAt;
@override final  String? departCountry;
@override final  String? departCity;
@override final  String? departureMode;
@override final  int? rooms;
@override final  int? adults;
@override final  int? children;
@override final  int? infants;
@override final  int? extraBeds;
 final  List<String> _services;
@override@JsonKey() List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override final  String? notes;
 final  List<LeadItineraryDto> _itinerary;
@override@JsonKey() List<LeadItineraryDto> get itinerary {
  if (_itinerary is EqualUnmodifiableListView) return _itinerary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itinerary);
}

@override final  String? createdAt;
@override final  QuotationRefDto? latestQuotation;
@override final  String? convertedBookingPublicId;
@override final  bool? openToClaim;
@override final  int? claimVersion;

/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadDtoCopyWith<_LeadDto> get copyWith => __$LeadDtoCopyWithImpl<_LeadDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadDto&&(identical(other.id, id) || other.id == id)&&(identical(other.leadCode, leadCode) || other.leadCode == leadCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.customerWhatsapp, customerWhatsapp) || other.customerWhatsapp == customerWhatsapp)&&(identical(other.customerCity, customerCity) || other.customerCity == customerCity)&&(identical(other.customerState, customerState) || other.customerState == customerState)&&(identical(other.customerCountry, customerCountry) || other.customerCountry == customerCountry)&&(identical(other.leadSource, leadSource) || other.leadSource == leadSource)&&(identical(other.leadType, leadType) || other.leadType == leadType)&&(identical(other.leadStage, leadStage) || other.leadStage == leadStage)&&(identical(other.assignedUser, assignedUser) || other.assignedUser == assignedUser)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.returnDate, returnDate) || other.returnDate == returnDate)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.budgetBasis, budgetBasis) || other.budgetBasis == budgetBasis)&&(identical(other.logCount, logCount) || other.logCount == logCount)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.departCountry, departCountry) || other.departCountry == departCountry)&&(identical(other.departCity, departCity) || other.departCity == departCity)&&(identical(other.departureMode, departureMode) || other.departureMode == departureMode)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.infants, infants) || other.infants == infants)&&(identical(other.extraBeds, extraBeds) || other.extraBeds == extraBeds)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._itinerary, _itinerary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.latestQuotation, latestQuotation) || other.latestQuotation == latestQuotation)&&(identical(other.convertedBookingPublicId, convertedBookingPublicId) || other.convertedBookingPublicId == convertedBookingPublicId)&&(identical(other.openToClaim, openToClaim) || other.openToClaim == openToClaim)&&(identical(other.claimVersion, claimVersion) || other.claimVersion == claimVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,leadCode,customerName,phone,email,customerWhatsapp,customerCity,customerState,customerCountry,leadSource,leadType,leadStage,assignedUser,birthDate,followUpDate,travelDate,returnDate,budget,budgetBasis,logCount,lastActivityAt,departCountry,departCity,departureMode,rooms,adults,children,infants,extraBeds,const DeepCollectionEquality().hash(_services),notes,const DeepCollectionEquality().hash(_itinerary),createdAt,latestQuotation,convertedBookingPublicId,openToClaim,claimVersion]);

@override
String toString() {
  return 'LeadDto(id: $id, leadCode: $leadCode, customerName: $customerName, phone: $phone, email: $email, customerWhatsapp: $customerWhatsapp, customerCity: $customerCity, customerState: $customerState, customerCountry: $customerCountry, leadSource: $leadSource, leadType: $leadType, leadStage: $leadStage, assignedUser: $assignedUser, birthDate: $birthDate, followUpDate: $followUpDate, travelDate: $travelDate, returnDate: $returnDate, budget: $budget, budgetBasis: $budgetBasis, logCount: $logCount, lastActivityAt: $lastActivityAt, departCountry: $departCountry, departCity: $departCity, departureMode: $departureMode, rooms: $rooms, adults: $adults, children: $children, infants: $infants, extraBeds: $extraBeds, services: $services, notes: $notes, itinerary: $itinerary, createdAt: $createdAt, latestQuotation: $latestQuotation, convertedBookingPublicId: $convertedBookingPublicId, openToClaim: $openToClaim, claimVersion: $claimVersion)';
}


}

/// @nodoc
abstract mixin class _$LeadDtoCopyWith<$Res> implements $LeadDtoCopyWith<$Res> {
  factory _$LeadDtoCopyWith(_LeadDto value, $Res Function(_LeadDto) _then) = __$LeadDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? leadCode, String? customerName, String? phone, String? email, String? customerWhatsapp, String? customerCity, String? customerState, String? customerCountry, String? leadSource, String? leadType, String? leadStage, AssignedUserDto? assignedUser, String? birthDate, String? followUpDate, String? travelDate, String? returnDate, num? budget, String? budgetBasis, int? logCount, String? lastActivityAt, String? departCountry, String? departCity, String? departureMode, int? rooms, int? adults, int? children, int? infants, int? extraBeds, List<String> services, String? notes, List<LeadItineraryDto> itinerary, String? createdAt, QuotationRefDto? latestQuotation, String? convertedBookingPublicId, bool? openToClaim, int? claimVersion
});


@override $AssignedUserDtoCopyWith<$Res>? get assignedUser;@override $QuotationRefDtoCopyWith<$Res>? get latestQuotation;

}
/// @nodoc
class __$LeadDtoCopyWithImpl<$Res>
    implements _$LeadDtoCopyWith<$Res> {
  __$LeadDtoCopyWithImpl(this._self, this._then);

  final _LeadDto _self;
  final $Res Function(_LeadDto) _then;

/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? leadCode = freezed,Object? customerName = freezed,Object? phone = freezed,Object? email = freezed,Object? customerWhatsapp = freezed,Object? customerCity = freezed,Object? customerState = freezed,Object? customerCountry = freezed,Object? leadSource = freezed,Object? leadType = freezed,Object? leadStage = freezed,Object? assignedUser = freezed,Object? birthDate = freezed,Object? followUpDate = freezed,Object? travelDate = freezed,Object? returnDate = freezed,Object? budget = freezed,Object? budgetBasis = freezed,Object? logCount = freezed,Object? lastActivityAt = freezed,Object? departCountry = freezed,Object? departCity = freezed,Object? departureMode = freezed,Object? rooms = freezed,Object? adults = freezed,Object? children = freezed,Object? infants = freezed,Object? extraBeds = freezed,Object? services = null,Object? notes = freezed,Object? itinerary = null,Object? createdAt = freezed,Object? latestQuotation = freezed,Object? convertedBookingPublicId = freezed,Object? openToClaim = freezed,Object? claimVersion = freezed,}) {
  return _then(_LeadDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,leadCode: freezed == leadCode ? _self.leadCode : leadCode // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,customerWhatsapp: freezed == customerWhatsapp ? _self.customerWhatsapp : customerWhatsapp // ignore: cast_nullable_to_non_nullable
as String?,customerCity: freezed == customerCity ? _self.customerCity : customerCity // ignore: cast_nullable_to_non_nullable
as String?,customerState: freezed == customerState ? _self.customerState : customerState // ignore: cast_nullable_to_non_nullable
as String?,customerCountry: freezed == customerCountry ? _self.customerCountry : customerCountry // ignore: cast_nullable_to_non_nullable
as String?,leadSource: freezed == leadSource ? _self.leadSource : leadSource // ignore: cast_nullable_to_non_nullable
as String?,leadType: freezed == leadType ? _self.leadType : leadType // ignore: cast_nullable_to_non_nullable
as String?,leadStage: freezed == leadStage ? _self.leadStage : leadStage // ignore: cast_nullable_to_non_nullable
as String?,assignedUser: freezed == assignedUser ? _self.assignedUser : assignedUser // ignore: cast_nullable_to_non_nullable
as AssignedUserDto?,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String?,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,returnDate: freezed == returnDate ? _self.returnDate : returnDate // ignore: cast_nullable_to_non_nullable
as String?,budget: freezed == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as num?,budgetBasis: freezed == budgetBasis ? _self.budgetBasis : budgetBasis // ignore: cast_nullable_to_non_nullable
as String?,logCount: freezed == logCount ? _self.logCount : logCount // ignore: cast_nullable_to_non_nullable
as int?,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as String?,departCountry: freezed == departCountry ? _self.departCountry : departCountry // ignore: cast_nullable_to_non_nullable
as String?,departCity: freezed == departCity ? _self.departCity : departCity // ignore: cast_nullable_to_non_nullable
as String?,departureMode: freezed == departureMode ? _self.departureMode : departureMode // ignore: cast_nullable_to_non_nullable
as String?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,adults: freezed == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int?,children: freezed == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int?,infants: freezed == infants ? _self.infants : infants // ignore: cast_nullable_to_non_nullable
as int?,extraBeds: freezed == extraBeds ? _self.extraBeds : extraBeds // ignore: cast_nullable_to_non_nullable
as int?,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,itinerary: null == itinerary ? _self._itinerary : itinerary // ignore: cast_nullable_to_non_nullable
as List<LeadItineraryDto>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,latestQuotation: freezed == latestQuotation ? _self.latestQuotation : latestQuotation // ignore: cast_nullable_to_non_nullable
as QuotationRefDto?,convertedBookingPublicId: freezed == convertedBookingPublicId ? _self.convertedBookingPublicId : convertedBookingPublicId // ignore: cast_nullable_to_non_nullable
as String?,openToClaim: freezed == openToClaim ? _self.openToClaim : openToClaim // ignore: cast_nullable_to_non_nullable
as bool?,claimVersion: freezed == claimVersion ? _self.claimVersion : claimVersion // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssignedUserDtoCopyWith<$Res>? get assignedUser {
    if (_self.assignedUser == null) {
    return null;
  }

  return $AssignedUserDtoCopyWith<$Res>(_self.assignedUser!, (value) {
    return _then(_self.copyWith(assignedUser: value));
  });
}/// Create a copy of LeadDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationRefDtoCopyWith<$Res>? get latestQuotation {
    if (_self.latestQuotation == null) {
    return null;
  }

  return $QuotationRefDtoCopyWith<$Res>(_self.latestQuotation!, (value) {
    return _then(_self.copyWith(latestQuotation: value));
  });
}
}


/// @nodoc
mixin _$AssignedUserDto {

 String? get publicId; String? get fullName; String? get role; String? get email;
/// Create a copy of AssignedUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignedUserDtoCopyWith<AssignedUserDto> get copyWith => _$AssignedUserDtoCopyWithImpl<AssignedUserDto>(this as AssignedUserDto, _$identity);

  /// Serializes this AssignedUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignedUserDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,fullName,role,email);

@override
String toString() {
  return 'AssignedUserDto(publicId: $publicId, fullName: $fullName, role: $role, email: $email)';
}


}

/// @nodoc
abstract mixin class $AssignedUserDtoCopyWith<$Res>  {
  factory $AssignedUserDtoCopyWith(AssignedUserDto value, $Res Function(AssignedUserDto) _then) = _$AssignedUserDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, String? fullName, String? role, String? email
});




}
/// @nodoc
class _$AssignedUserDtoCopyWithImpl<$Res>
    implements $AssignedUserDtoCopyWith<$Res> {
  _$AssignedUserDtoCopyWithImpl(this._self, this._then);

  final AssignedUserDto _self;
  final $Res Function(AssignedUserDto) _then;

/// Create a copy of AssignedUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? fullName = freezed,Object? role = freezed,Object? email = freezed,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssignedUserDto].
extension AssignedUserDtoPatterns on AssignedUserDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignedUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignedUserDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignedUserDto value)  $default,){
final _that = this;
switch (_that) {
case _AssignedUserDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignedUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _AssignedUserDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  String? fullName,  String? role,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignedUserDto() when $default != null:
return $default(_that.publicId,_that.fullName,_that.role,_that.email);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  String? fullName,  String? role,  String? email)  $default,) {final _that = this;
switch (_that) {
case _AssignedUserDto():
return $default(_that.publicId,_that.fullName,_that.role,_that.email);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  String? fullName,  String? role,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _AssignedUserDto() when $default != null:
return $default(_that.publicId,_that.fullName,_that.role,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignedUserDto implements AssignedUserDto {
  const _AssignedUserDto({this.publicId, this.fullName, this.role, this.email});
  factory _AssignedUserDto.fromJson(Map<String, dynamic> json) => _$AssignedUserDtoFromJson(json);

@override final  String? publicId;
@override final  String? fullName;
@override final  String? role;
@override final  String? email;

/// Create a copy of AssignedUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignedUserDtoCopyWith<_AssignedUserDto> get copyWith => __$AssignedUserDtoCopyWithImpl<_AssignedUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignedUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignedUserDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,fullName,role,email);

@override
String toString() {
  return 'AssignedUserDto(publicId: $publicId, fullName: $fullName, role: $role, email: $email)';
}


}

/// @nodoc
abstract mixin class _$AssignedUserDtoCopyWith<$Res> implements $AssignedUserDtoCopyWith<$Res> {
  factory _$AssignedUserDtoCopyWith(_AssignedUserDto value, $Res Function(_AssignedUserDto) _then) = __$AssignedUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, String? fullName, String? role, String? email
});




}
/// @nodoc
class __$AssignedUserDtoCopyWithImpl<$Res>
    implements _$AssignedUserDtoCopyWith<$Res> {
  __$AssignedUserDtoCopyWithImpl(this._self, this._then);

  final _AssignedUserDto _self;
  final $Res Function(_AssignedUserDto) _then;

/// Create a copy of AssignedUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? fullName = freezed,Object? role = freezed,Object? email = freezed,}) {
  return _then(_AssignedUserDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuotationRefDto {

 String? get publicId; num? get grandTotal;/// A **label**, not a number: the server sends `"v1.0"`.
 String? get version;
/// Create a copy of QuotationRefDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationRefDtoCopyWith<QuotationRefDto> get copyWith => _$QuotationRefDtoCopyWithImpl<QuotationRefDto>(this as QuotationRefDto, _$identity);

  /// Serializes this QuotationRefDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationRefDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,grandTotal,version);

@override
String toString() {
  return 'QuotationRefDto(publicId: $publicId, grandTotal: $grandTotal, version: $version)';
}


}

/// @nodoc
abstract mixin class $QuotationRefDtoCopyWith<$Res>  {
  factory $QuotationRefDtoCopyWith(QuotationRefDto value, $Res Function(QuotationRefDto) _then) = _$QuotationRefDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, num? grandTotal, String? version
});




}
/// @nodoc
class _$QuotationRefDtoCopyWithImpl<$Res>
    implements $QuotationRefDtoCopyWith<$Res> {
  _$QuotationRefDtoCopyWithImpl(this._self, this._then);

  final QuotationRefDto _self;
  final $Res Function(QuotationRefDto) _then;

/// Create a copy of QuotationRefDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? grandTotal = freezed,Object? version = freezed,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as num?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationRefDto].
extension QuotationRefDtoPatterns on QuotationRefDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationRefDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationRefDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationRefDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationRefDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationRefDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationRefDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  num? grandTotal,  String? version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationRefDto() when $default != null:
return $default(_that.publicId,_that.grandTotal,_that.version);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  num? grandTotal,  String? version)  $default,) {final _that = this;
switch (_that) {
case _QuotationRefDto():
return $default(_that.publicId,_that.grandTotal,_that.version);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  num? grandTotal,  String? version)?  $default,) {final _that = this;
switch (_that) {
case _QuotationRefDto() when $default != null:
return $default(_that.publicId,_that.grandTotal,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationRefDto implements QuotationRefDto {
  const _QuotationRefDto({this.publicId, this.grandTotal, this.version});
  factory _QuotationRefDto.fromJson(Map<String, dynamic> json) => _$QuotationRefDtoFromJson(json);

@override final  String? publicId;
@override final  num? grandTotal;
/// A **label**, not a number: the server sends `"v1.0"`.
@override final  String? version;

/// Create a copy of QuotationRefDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationRefDtoCopyWith<_QuotationRefDto> get copyWith => __$QuotationRefDtoCopyWithImpl<_QuotationRefDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationRefDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationRefDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,grandTotal,version);

@override
String toString() {
  return 'QuotationRefDto(publicId: $publicId, grandTotal: $grandTotal, version: $version)';
}


}

/// @nodoc
abstract mixin class _$QuotationRefDtoCopyWith<$Res> implements $QuotationRefDtoCopyWith<$Res> {
  factory _$QuotationRefDtoCopyWith(_QuotationRefDto value, $Res Function(_QuotationRefDto) _then) = __$QuotationRefDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, num? grandTotal, String? version
});




}
/// @nodoc
class __$QuotationRefDtoCopyWithImpl<$Res>
    implements _$QuotationRefDtoCopyWith<$Res> {
  __$QuotationRefDtoCopyWithImpl(this._self, this._then);

  final _QuotationRefDto _self;
  final $Res Function(_QuotationRefDto) _then;

/// Create a copy of QuotationRefDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? grandTotal = freezed,Object? version = freezed,}) {
  return _then(_QuotationRefDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as num?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LeadItineraryDto {

/// A UUID string, like every other public id the server exposes.
 String? get id; String? get destination; String? get city; int? get nights; int? get dayNumber;
/// Create a copy of LeadItineraryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadItineraryDtoCopyWith<LeadItineraryDto> get copyWith => _$LeadItineraryDtoCopyWithImpl<LeadItineraryDto>(this as LeadItineraryDto, _$identity);

  /// Serializes this LeadItineraryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadItineraryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.city, city) || other.city == city)&&(identical(other.nights, nights) || other.nights == nights)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,destination,city,nights,dayNumber);

@override
String toString() {
  return 'LeadItineraryDto(id: $id, destination: $destination, city: $city, nights: $nights, dayNumber: $dayNumber)';
}


}

/// @nodoc
abstract mixin class $LeadItineraryDtoCopyWith<$Res>  {
  factory $LeadItineraryDtoCopyWith(LeadItineraryDto value, $Res Function(LeadItineraryDto) _then) = _$LeadItineraryDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? destination, String? city, int? nights, int? dayNumber
});




}
/// @nodoc
class _$LeadItineraryDtoCopyWithImpl<$Res>
    implements $LeadItineraryDtoCopyWith<$Res> {
  _$LeadItineraryDtoCopyWithImpl(this._self, this._then);

  final LeadItineraryDto _self;
  final $Res Function(LeadItineraryDto) _then;

/// Create a copy of LeadItineraryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? destination = freezed,Object? city = freezed,Object? nights = freezed,Object? dayNumber = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,nights: freezed == nights ? _self.nights : nights // ignore: cast_nullable_to_non_nullable
as int?,dayNumber: freezed == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadItineraryDto].
extension LeadItineraryDtoPatterns on LeadItineraryDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadItineraryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadItineraryDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadItineraryDto value)  $default,){
final _that = this;
switch (_that) {
case _LeadItineraryDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadItineraryDto value)?  $default,){
final _that = this;
switch (_that) {
case _LeadItineraryDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? destination,  String? city,  int? nights,  int? dayNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadItineraryDto() when $default != null:
return $default(_that.id,_that.destination,_that.city,_that.nights,_that.dayNumber);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? destination,  String? city,  int? nights,  int? dayNumber)  $default,) {final _that = this;
switch (_that) {
case _LeadItineraryDto():
return $default(_that.id,_that.destination,_that.city,_that.nights,_that.dayNumber);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? destination,  String? city,  int? nights,  int? dayNumber)?  $default,) {final _that = this;
switch (_that) {
case _LeadItineraryDto() when $default != null:
return $default(_that.id,_that.destination,_that.city,_that.nights,_that.dayNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadItineraryDto implements LeadItineraryDto {
  const _LeadItineraryDto({this.id, this.destination, this.city, this.nights, this.dayNumber});
  factory _LeadItineraryDto.fromJson(Map<String, dynamic> json) => _$LeadItineraryDtoFromJson(json);

/// A UUID string, like every other public id the server exposes.
@override final  String? id;
@override final  String? destination;
@override final  String? city;
@override final  int? nights;
@override final  int? dayNumber;

/// Create a copy of LeadItineraryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadItineraryDtoCopyWith<_LeadItineraryDto> get copyWith => __$LeadItineraryDtoCopyWithImpl<_LeadItineraryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadItineraryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadItineraryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.city, city) || other.city == city)&&(identical(other.nights, nights) || other.nights == nights)&&(identical(other.dayNumber, dayNumber) || other.dayNumber == dayNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,destination,city,nights,dayNumber);

@override
String toString() {
  return 'LeadItineraryDto(id: $id, destination: $destination, city: $city, nights: $nights, dayNumber: $dayNumber)';
}


}

/// @nodoc
abstract mixin class _$LeadItineraryDtoCopyWith<$Res> implements $LeadItineraryDtoCopyWith<$Res> {
  factory _$LeadItineraryDtoCopyWith(_LeadItineraryDto value, $Res Function(_LeadItineraryDto) _then) = __$LeadItineraryDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? destination, String? city, int? nights, int? dayNumber
});




}
/// @nodoc
class __$LeadItineraryDtoCopyWithImpl<$Res>
    implements _$LeadItineraryDtoCopyWith<$Res> {
  __$LeadItineraryDtoCopyWithImpl(this._self, this._then);

  final _LeadItineraryDto _self;
  final $Res Function(_LeadItineraryDto) _then;

/// Create a copy of LeadItineraryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? destination = freezed,Object? city = freezed,Object? nights = freezed,Object? dayNumber = freezed,}) {
  return _then(_LeadItineraryDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,nights: freezed == nights ? _self.nights : nights // ignore: cast_nullable_to_non_nullable
as int?,dayNumber: freezed == dayNumber ? _self.dayNumber : dayNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LeadLogDto {

 String? get id; String? get comment; String? get stage; String? get followUpDate; String? get addedBy; String? get createdAt;
/// Create a copy of LeadLogDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadLogDtoCopyWith<LeadLogDto> get copyWith => _$LeadLogDtoCopyWithImpl<LeadLogDto>(this as LeadLogDto, _$identity);

  /// Serializes this LeadLogDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadLogDto&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comment,stage,followUpDate,addedBy,createdAt);

@override
String toString() {
  return 'LeadLogDto(id: $id, comment: $comment, stage: $stage, followUpDate: $followUpDate, addedBy: $addedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LeadLogDtoCopyWith<$Res>  {
  factory $LeadLogDtoCopyWith(LeadLogDto value, $Res Function(LeadLogDto) _then) = _$LeadLogDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? comment, String? stage, String? followUpDate, String? addedBy, String? createdAt
});




}
/// @nodoc
class _$LeadLogDtoCopyWithImpl<$Res>
    implements $LeadLogDtoCopyWith<$Res> {
  _$LeadLogDtoCopyWithImpl(this._self, this._then);

  final LeadLogDto _self;
  final $Res Function(LeadLogDto) _then;

/// Create a copy of LeadLogDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? comment = freezed,Object? stage = freezed,Object? followUpDate = freezed,Object? addedBy = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as String?,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadLogDto].
extension LeadLogDtoPatterns on LeadLogDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadLogDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadLogDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadLogDto value)  $default,){
final _that = this;
switch (_that) {
case _LeadLogDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadLogDto value)?  $default,){
final _that = this;
switch (_that) {
case _LeadLogDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? comment,  String? stage,  String? followUpDate,  String? addedBy,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadLogDto() when $default != null:
return $default(_that.id,_that.comment,_that.stage,_that.followUpDate,_that.addedBy,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? comment,  String? stage,  String? followUpDate,  String? addedBy,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _LeadLogDto():
return $default(_that.id,_that.comment,_that.stage,_that.followUpDate,_that.addedBy,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? comment,  String? stage,  String? followUpDate,  String? addedBy,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _LeadLogDto() when $default != null:
return $default(_that.id,_that.comment,_that.stage,_that.followUpDate,_that.addedBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadLogDto implements LeadLogDto {
  const _LeadLogDto({this.id, this.comment, this.stage, this.followUpDate, this.addedBy, this.createdAt});
  factory _LeadLogDto.fromJson(Map<String, dynamic> json) => _$LeadLogDtoFromJson(json);

@override final  String? id;
@override final  String? comment;
@override final  String? stage;
@override final  String? followUpDate;
@override final  String? addedBy;
@override final  String? createdAt;

/// Create a copy of LeadLogDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadLogDtoCopyWith<_LeadLogDto> get copyWith => __$LeadLogDtoCopyWithImpl<_LeadLogDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadLogDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadLogDto&&(identical(other.id, id) || other.id == id)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.addedBy, addedBy) || other.addedBy == addedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,comment,stage,followUpDate,addedBy,createdAt);

@override
String toString() {
  return 'LeadLogDto(id: $id, comment: $comment, stage: $stage, followUpDate: $followUpDate, addedBy: $addedBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LeadLogDtoCopyWith<$Res> implements $LeadLogDtoCopyWith<$Res> {
  factory _$LeadLogDtoCopyWith(_LeadLogDto value, $Res Function(_LeadLogDto) _then) = __$LeadLogDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? comment, String? stage, String? followUpDate, String? addedBy, String? createdAt
});




}
/// @nodoc
class __$LeadLogDtoCopyWithImpl<$Res>
    implements _$LeadLogDtoCopyWith<$Res> {
  __$LeadLogDtoCopyWithImpl(this._self, this._then);

  final _LeadLogDto _self;
  final $Res Function(_LeadLogDto) _then;

/// Create a copy of LeadLogDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? comment = freezed,Object? stage = freezed,Object? followUpDate = freezed,Object? addedBy = freezed,Object? createdAt = freezed,}) {
  return _then(_LeadLogDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as String?,addedBy: freezed == addedBy ? _self.addedBy : addedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LeadStatsSummaryDto {

 int? get totalLeads; int? get activeLeads; int? get convertedLeads; int? get lostLeads; int? get proposalSentLeads; List<StageCountDto> get byStage; List<TypeCountDto> get byType; num? get activePipelineValue; int? get activeWithBudget; num? get quotedValue; int? get followUpsOverdue; int? get followUpsDueToday; int? get createdInPeriod; int? get convertedInPeriod; double? get conversionRate;
/// Create a copy of LeadStatsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadStatsSummaryDtoCopyWith<LeadStatsSummaryDto> get copyWith => _$LeadStatsSummaryDtoCopyWithImpl<LeadStatsSummaryDto>(this as LeadStatsSummaryDto, _$identity);

  /// Serializes this LeadStatsSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadStatsSummaryDto&&(identical(other.totalLeads, totalLeads) || other.totalLeads == totalLeads)&&(identical(other.activeLeads, activeLeads) || other.activeLeads == activeLeads)&&(identical(other.convertedLeads, convertedLeads) || other.convertedLeads == convertedLeads)&&(identical(other.lostLeads, lostLeads) || other.lostLeads == lostLeads)&&(identical(other.proposalSentLeads, proposalSentLeads) || other.proposalSentLeads == proposalSentLeads)&&const DeepCollectionEquality().equals(other.byStage, byStage)&&const DeepCollectionEquality().equals(other.byType, byType)&&(identical(other.activePipelineValue, activePipelineValue) || other.activePipelineValue == activePipelineValue)&&(identical(other.activeWithBudget, activeWithBudget) || other.activeWithBudget == activeWithBudget)&&(identical(other.quotedValue, quotedValue) || other.quotedValue == quotedValue)&&(identical(other.followUpsOverdue, followUpsOverdue) || other.followUpsOverdue == followUpsOverdue)&&(identical(other.followUpsDueToday, followUpsDueToday) || other.followUpsDueToday == followUpsDueToday)&&(identical(other.createdInPeriod, createdInPeriod) || other.createdInPeriod == createdInPeriod)&&(identical(other.convertedInPeriod, convertedInPeriod) || other.convertedInPeriod == convertedInPeriod)&&(identical(other.conversionRate, conversionRate) || other.conversionRate == conversionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalLeads,activeLeads,convertedLeads,lostLeads,proposalSentLeads,const DeepCollectionEquality().hash(byStage),const DeepCollectionEquality().hash(byType),activePipelineValue,activeWithBudget,quotedValue,followUpsOverdue,followUpsDueToday,createdInPeriod,convertedInPeriod,conversionRate);

@override
String toString() {
  return 'LeadStatsSummaryDto(totalLeads: $totalLeads, activeLeads: $activeLeads, convertedLeads: $convertedLeads, lostLeads: $lostLeads, proposalSentLeads: $proposalSentLeads, byStage: $byStage, byType: $byType, activePipelineValue: $activePipelineValue, activeWithBudget: $activeWithBudget, quotedValue: $quotedValue, followUpsOverdue: $followUpsOverdue, followUpsDueToday: $followUpsDueToday, createdInPeriod: $createdInPeriod, convertedInPeriod: $convertedInPeriod, conversionRate: $conversionRate)';
}


}

/// @nodoc
abstract mixin class $LeadStatsSummaryDtoCopyWith<$Res>  {
  factory $LeadStatsSummaryDtoCopyWith(LeadStatsSummaryDto value, $Res Function(LeadStatsSummaryDto) _then) = _$LeadStatsSummaryDtoCopyWithImpl;
@useResult
$Res call({
 int? totalLeads, int? activeLeads, int? convertedLeads, int? lostLeads, int? proposalSentLeads, List<StageCountDto> byStage, List<TypeCountDto> byType, num? activePipelineValue, int? activeWithBudget, num? quotedValue, int? followUpsOverdue, int? followUpsDueToday, int? createdInPeriod, int? convertedInPeriod, double? conversionRate
});




}
/// @nodoc
class _$LeadStatsSummaryDtoCopyWithImpl<$Res>
    implements $LeadStatsSummaryDtoCopyWith<$Res> {
  _$LeadStatsSummaryDtoCopyWithImpl(this._self, this._then);

  final LeadStatsSummaryDto _self;
  final $Res Function(LeadStatsSummaryDto) _then;

/// Create a copy of LeadStatsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalLeads = freezed,Object? activeLeads = freezed,Object? convertedLeads = freezed,Object? lostLeads = freezed,Object? proposalSentLeads = freezed,Object? byStage = null,Object? byType = null,Object? activePipelineValue = freezed,Object? activeWithBudget = freezed,Object? quotedValue = freezed,Object? followUpsOverdue = freezed,Object? followUpsDueToday = freezed,Object? createdInPeriod = freezed,Object? convertedInPeriod = freezed,Object? conversionRate = freezed,}) {
  return _then(_self.copyWith(
totalLeads: freezed == totalLeads ? _self.totalLeads : totalLeads // ignore: cast_nullable_to_non_nullable
as int?,activeLeads: freezed == activeLeads ? _self.activeLeads : activeLeads // ignore: cast_nullable_to_non_nullable
as int?,convertedLeads: freezed == convertedLeads ? _self.convertedLeads : convertedLeads // ignore: cast_nullable_to_non_nullable
as int?,lostLeads: freezed == lostLeads ? _self.lostLeads : lostLeads // ignore: cast_nullable_to_non_nullable
as int?,proposalSentLeads: freezed == proposalSentLeads ? _self.proposalSentLeads : proposalSentLeads // ignore: cast_nullable_to_non_nullable
as int?,byStage: null == byStage ? _self.byStage : byStage // ignore: cast_nullable_to_non_nullable
as List<StageCountDto>,byType: null == byType ? _self.byType : byType // ignore: cast_nullable_to_non_nullable
as List<TypeCountDto>,activePipelineValue: freezed == activePipelineValue ? _self.activePipelineValue : activePipelineValue // ignore: cast_nullable_to_non_nullable
as num?,activeWithBudget: freezed == activeWithBudget ? _self.activeWithBudget : activeWithBudget // ignore: cast_nullable_to_non_nullable
as int?,quotedValue: freezed == quotedValue ? _self.quotedValue : quotedValue // ignore: cast_nullable_to_non_nullable
as num?,followUpsOverdue: freezed == followUpsOverdue ? _self.followUpsOverdue : followUpsOverdue // ignore: cast_nullable_to_non_nullable
as int?,followUpsDueToday: freezed == followUpsDueToday ? _self.followUpsDueToday : followUpsDueToday // ignore: cast_nullable_to_non_nullable
as int?,createdInPeriod: freezed == createdInPeriod ? _self.createdInPeriod : createdInPeriod // ignore: cast_nullable_to_non_nullable
as int?,convertedInPeriod: freezed == convertedInPeriod ? _self.convertedInPeriod : convertedInPeriod // ignore: cast_nullable_to_non_nullable
as int?,conversionRate: freezed == conversionRate ? _self.conversionRate : conversionRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadStatsSummaryDto].
extension LeadStatsSummaryDtoPatterns on LeadStatsSummaryDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadStatsSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadStatsSummaryDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadStatsSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _LeadStatsSummaryDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadStatsSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _LeadStatsSummaryDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? totalLeads,  int? activeLeads,  int? convertedLeads,  int? lostLeads,  int? proposalSentLeads,  List<StageCountDto> byStage,  List<TypeCountDto> byType,  num? activePipelineValue,  int? activeWithBudget,  num? quotedValue,  int? followUpsOverdue,  int? followUpsDueToday,  int? createdInPeriod,  int? convertedInPeriod,  double? conversionRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadStatsSummaryDto() when $default != null:
return $default(_that.totalLeads,_that.activeLeads,_that.convertedLeads,_that.lostLeads,_that.proposalSentLeads,_that.byStage,_that.byType,_that.activePipelineValue,_that.activeWithBudget,_that.quotedValue,_that.followUpsOverdue,_that.followUpsDueToday,_that.createdInPeriod,_that.convertedInPeriod,_that.conversionRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? totalLeads,  int? activeLeads,  int? convertedLeads,  int? lostLeads,  int? proposalSentLeads,  List<StageCountDto> byStage,  List<TypeCountDto> byType,  num? activePipelineValue,  int? activeWithBudget,  num? quotedValue,  int? followUpsOverdue,  int? followUpsDueToday,  int? createdInPeriod,  int? convertedInPeriod,  double? conversionRate)  $default,) {final _that = this;
switch (_that) {
case _LeadStatsSummaryDto():
return $default(_that.totalLeads,_that.activeLeads,_that.convertedLeads,_that.lostLeads,_that.proposalSentLeads,_that.byStage,_that.byType,_that.activePipelineValue,_that.activeWithBudget,_that.quotedValue,_that.followUpsOverdue,_that.followUpsDueToday,_that.createdInPeriod,_that.convertedInPeriod,_that.conversionRate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? totalLeads,  int? activeLeads,  int? convertedLeads,  int? lostLeads,  int? proposalSentLeads,  List<StageCountDto> byStage,  List<TypeCountDto> byType,  num? activePipelineValue,  int? activeWithBudget,  num? quotedValue,  int? followUpsOverdue,  int? followUpsDueToday,  int? createdInPeriod,  int? convertedInPeriod,  double? conversionRate)?  $default,) {final _that = this;
switch (_that) {
case _LeadStatsSummaryDto() when $default != null:
return $default(_that.totalLeads,_that.activeLeads,_that.convertedLeads,_that.lostLeads,_that.proposalSentLeads,_that.byStage,_that.byType,_that.activePipelineValue,_that.activeWithBudget,_that.quotedValue,_that.followUpsOverdue,_that.followUpsDueToday,_that.createdInPeriod,_that.convertedInPeriod,_that.conversionRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadStatsSummaryDto implements LeadStatsSummaryDto {
  const _LeadStatsSummaryDto({this.totalLeads, this.activeLeads, this.convertedLeads, this.lostLeads, this.proposalSentLeads, final  List<StageCountDto> byStage = const <StageCountDto>[], final  List<TypeCountDto> byType = const <TypeCountDto>[], this.activePipelineValue, this.activeWithBudget, this.quotedValue, this.followUpsOverdue, this.followUpsDueToday, this.createdInPeriod, this.convertedInPeriod, this.conversionRate}): _byStage = byStage,_byType = byType;
  factory _LeadStatsSummaryDto.fromJson(Map<String, dynamic> json) => _$LeadStatsSummaryDtoFromJson(json);

@override final  int? totalLeads;
@override final  int? activeLeads;
@override final  int? convertedLeads;
@override final  int? lostLeads;
@override final  int? proposalSentLeads;
 final  List<StageCountDto> _byStage;
@override@JsonKey() List<StageCountDto> get byStage {
  if (_byStage is EqualUnmodifiableListView) return _byStage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byStage);
}

 final  List<TypeCountDto> _byType;
@override@JsonKey() List<TypeCountDto> get byType {
  if (_byType is EqualUnmodifiableListView) return _byType;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_byType);
}

@override final  num? activePipelineValue;
@override final  int? activeWithBudget;
@override final  num? quotedValue;
@override final  int? followUpsOverdue;
@override final  int? followUpsDueToday;
@override final  int? createdInPeriod;
@override final  int? convertedInPeriod;
@override final  double? conversionRate;

/// Create a copy of LeadStatsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadStatsSummaryDtoCopyWith<_LeadStatsSummaryDto> get copyWith => __$LeadStatsSummaryDtoCopyWithImpl<_LeadStatsSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadStatsSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadStatsSummaryDto&&(identical(other.totalLeads, totalLeads) || other.totalLeads == totalLeads)&&(identical(other.activeLeads, activeLeads) || other.activeLeads == activeLeads)&&(identical(other.convertedLeads, convertedLeads) || other.convertedLeads == convertedLeads)&&(identical(other.lostLeads, lostLeads) || other.lostLeads == lostLeads)&&(identical(other.proposalSentLeads, proposalSentLeads) || other.proposalSentLeads == proposalSentLeads)&&const DeepCollectionEquality().equals(other._byStage, _byStage)&&const DeepCollectionEquality().equals(other._byType, _byType)&&(identical(other.activePipelineValue, activePipelineValue) || other.activePipelineValue == activePipelineValue)&&(identical(other.activeWithBudget, activeWithBudget) || other.activeWithBudget == activeWithBudget)&&(identical(other.quotedValue, quotedValue) || other.quotedValue == quotedValue)&&(identical(other.followUpsOverdue, followUpsOverdue) || other.followUpsOverdue == followUpsOverdue)&&(identical(other.followUpsDueToday, followUpsDueToday) || other.followUpsDueToday == followUpsDueToday)&&(identical(other.createdInPeriod, createdInPeriod) || other.createdInPeriod == createdInPeriod)&&(identical(other.convertedInPeriod, convertedInPeriod) || other.convertedInPeriod == convertedInPeriod)&&(identical(other.conversionRate, conversionRate) || other.conversionRate == conversionRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalLeads,activeLeads,convertedLeads,lostLeads,proposalSentLeads,const DeepCollectionEquality().hash(_byStage),const DeepCollectionEquality().hash(_byType),activePipelineValue,activeWithBudget,quotedValue,followUpsOverdue,followUpsDueToday,createdInPeriod,convertedInPeriod,conversionRate);

@override
String toString() {
  return 'LeadStatsSummaryDto(totalLeads: $totalLeads, activeLeads: $activeLeads, convertedLeads: $convertedLeads, lostLeads: $lostLeads, proposalSentLeads: $proposalSentLeads, byStage: $byStage, byType: $byType, activePipelineValue: $activePipelineValue, activeWithBudget: $activeWithBudget, quotedValue: $quotedValue, followUpsOverdue: $followUpsOverdue, followUpsDueToday: $followUpsDueToday, createdInPeriod: $createdInPeriod, convertedInPeriod: $convertedInPeriod, conversionRate: $conversionRate)';
}


}

/// @nodoc
abstract mixin class _$LeadStatsSummaryDtoCopyWith<$Res> implements $LeadStatsSummaryDtoCopyWith<$Res> {
  factory _$LeadStatsSummaryDtoCopyWith(_LeadStatsSummaryDto value, $Res Function(_LeadStatsSummaryDto) _then) = __$LeadStatsSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 int? totalLeads, int? activeLeads, int? convertedLeads, int? lostLeads, int? proposalSentLeads, List<StageCountDto> byStage, List<TypeCountDto> byType, num? activePipelineValue, int? activeWithBudget, num? quotedValue, int? followUpsOverdue, int? followUpsDueToday, int? createdInPeriod, int? convertedInPeriod, double? conversionRate
});




}
/// @nodoc
class __$LeadStatsSummaryDtoCopyWithImpl<$Res>
    implements _$LeadStatsSummaryDtoCopyWith<$Res> {
  __$LeadStatsSummaryDtoCopyWithImpl(this._self, this._then);

  final _LeadStatsSummaryDto _self;
  final $Res Function(_LeadStatsSummaryDto) _then;

/// Create a copy of LeadStatsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalLeads = freezed,Object? activeLeads = freezed,Object? convertedLeads = freezed,Object? lostLeads = freezed,Object? proposalSentLeads = freezed,Object? byStage = null,Object? byType = null,Object? activePipelineValue = freezed,Object? activeWithBudget = freezed,Object? quotedValue = freezed,Object? followUpsOverdue = freezed,Object? followUpsDueToday = freezed,Object? createdInPeriod = freezed,Object? convertedInPeriod = freezed,Object? conversionRate = freezed,}) {
  return _then(_LeadStatsSummaryDto(
totalLeads: freezed == totalLeads ? _self.totalLeads : totalLeads // ignore: cast_nullable_to_non_nullable
as int?,activeLeads: freezed == activeLeads ? _self.activeLeads : activeLeads // ignore: cast_nullable_to_non_nullable
as int?,convertedLeads: freezed == convertedLeads ? _self.convertedLeads : convertedLeads // ignore: cast_nullable_to_non_nullable
as int?,lostLeads: freezed == lostLeads ? _self.lostLeads : lostLeads // ignore: cast_nullable_to_non_nullable
as int?,proposalSentLeads: freezed == proposalSentLeads ? _self.proposalSentLeads : proposalSentLeads // ignore: cast_nullable_to_non_nullable
as int?,byStage: null == byStage ? _self._byStage : byStage // ignore: cast_nullable_to_non_nullable
as List<StageCountDto>,byType: null == byType ? _self._byType : byType // ignore: cast_nullable_to_non_nullable
as List<TypeCountDto>,activePipelineValue: freezed == activePipelineValue ? _self.activePipelineValue : activePipelineValue // ignore: cast_nullable_to_non_nullable
as num?,activeWithBudget: freezed == activeWithBudget ? _self.activeWithBudget : activeWithBudget // ignore: cast_nullable_to_non_nullable
as int?,quotedValue: freezed == quotedValue ? _self.quotedValue : quotedValue // ignore: cast_nullable_to_non_nullable
as num?,followUpsOverdue: freezed == followUpsOverdue ? _self.followUpsOverdue : followUpsOverdue // ignore: cast_nullable_to_non_nullable
as int?,followUpsDueToday: freezed == followUpsDueToday ? _self.followUpsDueToday : followUpsDueToday // ignore: cast_nullable_to_non_nullable
as int?,createdInPeriod: freezed == createdInPeriod ? _self.createdInPeriod : createdInPeriod // ignore: cast_nullable_to_non_nullable
as int?,convertedInPeriod: freezed == convertedInPeriod ? _self.convertedInPeriod : convertedInPeriod // ignore: cast_nullable_to_non_nullable
as int?,conversionRate: freezed == conversionRate ? _self.conversionRate : conversionRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$StageCountDto {

 String? get stage; int? get count;
/// Create a copy of StageCountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StageCountDtoCopyWith<StageCountDto> get copyWith => _$StageCountDtoCopyWithImpl<StageCountDto>(this as StageCountDto, _$identity);

  /// Serializes this StageCountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StageCountDto&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stage,count);

@override
String toString() {
  return 'StageCountDto(stage: $stage, count: $count)';
}


}

/// @nodoc
abstract mixin class $StageCountDtoCopyWith<$Res>  {
  factory $StageCountDtoCopyWith(StageCountDto value, $Res Function(StageCountDto) _then) = _$StageCountDtoCopyWithImpl;
@useResult
$Res call({
 String? stage, int? count
});




}
/// @nodoc
class _$StageCountDtoCopyWithImpl<$Res>
    implements $StageCountDtoCopyWith<$Res> {
  _$StageCountDtoCopyWithImpl(this._self, this._then);

  final StageCountDto _self;
  final $Res Function(StageCountDto) _then;

/// Create a copy of StageCountDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = freezed,Object? count = freezed,}) {
  return _then(_self.copyWith(
stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StageCountDto].
extension StageCountDtoPatterns on StageCountDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StageCountDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StageCountDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StageCountDto value)  $default,){
final _that = this;
switch (_that) {
case _StageCountDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StageCountDto value)?  $default,){
final _that = this;
switch (_that) {
case _StageCountDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? stage,  int? count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StageCountDto() when $default != null:
return $default(_that.stage,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? stage,  int? count)  $default,) {final _that = this;
switch (_that) {
case _StageCountDto():
return $default(_that.stage,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? stage,  int? count)?  $default,) {final _that = this;
switch (_that) {
case _StageCountDto() when $default != null:
return $default(_that.stage,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StageCountDto implements StageCountDto {
  const _StageCountDto({this.stage, this.count});
  factory _StageCountDto.fromJson(Map<String, dynamic> json) => _$StageCountDtoFromJson(json);

@override final  String? stage;
@override final  int? count;

/// Create a copy of StageCountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StageCountDtoCopyWith<_StageCountDto> get copyWith => __$StageCountDtoCopyWithImpl<_StageCountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StageCountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StageCountDto&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stage,count);

@override
String toString() {
  return 'StageCountDto(stage: $stage, count: $count)';
}


}

/// @nodoc
abstract mixin class _$StageCountDtoCopyWith<$Res> implements $StageCountDtoCopyWith<$Res> {
  factory _$StageCountDtoCopyWith(_StageCountDto value, $Res Function(_StageCountDto) _then) = __$StageCountDtoCopyWithImpl;
@override @useResult
$Res call({
 String? stage, int? count
});




}
/// @nodoc
class __$StageCountDtoCopyWithImpl<$Res>
    implements _$StageCountDtoCopyWith<$Res> {
  __$StageCountDtoCopyWithImpl(this._self, this._then);

  final _StageCountDto _self;
  final $Res Function(_StageCountDto) _then;

/// Create a copy of StageCountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = freezed,Object? count = freezed,}) {
  return _then(_StageCountDto(
stage: freezed == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$TypeCountDto {

 String? get type; int? get count;
/// Create a copy of TypeCountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TypeCountDtoCopyWith<TypeCountDto> get copyWith => _$TypeCountDtoCopyWithImpl<TypeCountDto>(this as TypeCountDto, _$identity);

  /// Serializes this TypeCountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TypeCountDto&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,count);

@override
String toString() {
  return 'TypeCountDto(type: $type, count: $count)';
}


}

/// @nodoc
abstract mixin class $TypeCountDtoCopyWith<$Res>  {
  factory $TypeCountDtoCopyWith(TypeCountDto value, $Res Function(TypeCountDto) _then) = _$TypeCountDtoCopyWithImpl;
@useResult
$Res call({
 String? type, int? count
});




}
/// @nodoc
class _$TypeCountDtoCopyWithImpl<$Res>
    implements $TypeCountDtoCopyWith<$Res> {
  _$TypeCountDtoCopyWithImpl(this._self, this._then);

  final TypeCountDto _self;
  final $Res Function(TypeCountDto) _then;

/// Create a copy of TypeCountDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? count = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TypeCountDto].
extension TypeCountDtoPatterns on TypeCountDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TypeCountDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TypeCountDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TypeCountDto value)  $default,){
final _that = this;
switch (_that) {
case _TypeCountDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TypeCountDto value)?  $default,){
final _that = this;
switch (_that) {
case _TypeCountDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  int? count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TypeCountDto() when $default != null:
return $default(_that.type,_that.count);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  int? count)  $default,) {final _that = this;
switch (_that) {
case _TypeCountDto():
return $default(_that.type,_that.count);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  int? count)?  $default,) {final _that = this;
switch (_that) {
case _TypeCountDto() when $default != null:
return $default(_that.type,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TypeCountDto implements TypeCountDto {
  const _TypeCountDto({this.type, this.count});
  factory _TypeCountDto.fromJson(Map<String, dynamic> json) => _$TypeCountDtoFromJson(json);

@override final  String? type;
@override final  int? count;

/// Create a copy of TypeCountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TypeCountDtoCopyWith<_TypeCountDto> get copyWith => __$TypeCountDtoCopyWithImpl<_TypeCountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TypeCountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TypeCountDto&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,count);

@override
String toString() {
  return 'TypeCountDto(type: $type, count: $count)';
}


}

/// @nodoc
abstract mixin class _$TypeCountDtoCopyWith<$Res> implements $TypeCountDtoCopyWith<$Res> {
  factory _$TypeCountDtoCopyWith(_TypeCountDto value, $Res Function(_TypeCountDto) _then) = __$TypeCountDtoCopyWithImpl;
@override @useResult
$Res call({
 String? type, int? count
});




}
/// @nodoc
class __$TypeCountDtoCopyWithImpl<$Res>
    implements _$TypeCountDtoCopyWith<$Res> {
  __$TypeCountDtoCopyWithImpl(this._self, this._then);

  final _TypeCountDto _self;
  final $Res Function(_TypeCountDto) _then;

/// Create a copy of TypeCountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? count = freezed,}) {
  return _then(_TypeCountDto(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AssignmentRecommendationDto {

 String? get strategy; String? get strategyLabel; bool get forcedSelf; EligibleUserDto? get self; String? get recommendedUserId; String? get recommendedUserName; List<EligibleUserDto> get eligibleUsers;
/// Create a copy of AssignmentRecommendationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssignmentRecommendationDtoCopyWith<AssignmentRecommendationDto> get copyWith => _$AssignmentRecommendationDtoCopyWithImpl<AssignmentRecommendationDto>(this as AssignmentRecommendationDto, _$identity);

  /// Serializes this AssignmentRecommendationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssignmentRecommendationDto&&(identical(other.strategy, strategy) || other.strategy == strategy)&&(identical(other.strategyLabel, strategyLabel) || other.strategyLabel == strategyLabel)&&(identical(other.forcedSelf, forcedSelf) || other.forcedSelf == forcedSelf)&&(identical(other.self, self) || other.self == self)&&(identical(other.recommendedUserId, recommendedUserId) || other.recommendedUserId == recommendedUserId)&&(identical(other.recommendedUserName, recommendedUserName) || other.recommendedUserName == recommendedUserName)&&const DeepCollectionEquality().equals(other.eligibleUsers, eligibleUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,strategy,strategyLabel,forcedSelf,self,recommendedUserId,recommendedUserName,const DeepCollectionEquality().hash(eligibleUsers));

@override
String toString() {
  return 'AssignmentRecommendationDto(strategy: $strategy, strategyLabel: $strategyLabel, forcedSelf: $forcedSelf, self: $self, recommendedUserId: $recommendedUserId, recommendedUserName: $recommendedUserName, eligibleUsers: $eligibleUsers)';
}


}

/// @nodoc
abstract mixin class $AssignmentRecommendationDtoCopyWith<$Res>  {
  factory $AssignmentRecommendationDtoCopyWith(AssignmentRecommendationDto value, $Res Function(AssignmentRecommendationDto) _then) = _$AssignmentRecommendationDtoCopyWithImpl;
@useResult
$Res call({
 String? strategy, String? strategyLabel, bool forcedSelf, EligibleUserDto? self, String? recommendedUserId, String? recommendedUserName, List<EligibleUserDto> eligibleUsers
});


$EligibleUserDtoCopyWith<$Res>? get self;

}
/// @nodoc
class _$AssignmentRecommendationDtoCopyWithImpl<$Res>
    implements $AssignmentRecommendationDtoCopyWith<$Res> {
  _$AssignmentRecommendationDtoCopyWithImpl(this._self, this._then);

  final AssignmentRecommendationDto _self;
  final $Res Function(AssignmentRecommendationDto) _then;

/// Create a copy of AssignmentRecommendationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? strategy = freezed,Object? strategyLabel = freezed,Object? forcedSelf = null,Object? self = freezed,Object? recommendedUserId = freezed,Object? recommendedUserName = freezed,Object? eligibleUsers = null,}) {
  return _then(_self.copyWith(
strategy: freezed == strategy ? _self.strategy : strategy // ignore: cast_nullable_to_non_nullable
as String?,strategyLabel: freezed == strategyLabel ? _self.strategyLabel : strategyLabel // ignore: cast_nullable_to_non_nullable
as String?,forcedSelf: null == forcedSelf ? _self.forcedSelf : forcedSelf // ignore: cast_nullable_to_non_nullable
as bool,self: freezed == self ? _self.self : self // ignore: cast_nullable_to_non_nullable
as EligibleUserDto?,recommendedUserId: freezed == recommendedUserId ? _self.recommendedUserId : recommendedUserId // ignore: cast_nullable_to_non_nullable
as String?,recommendedUserName: freezed == recommendedUserName ? _self.recommendedUserName : recommendedUserName // ignore: cast_nullable_to_non_nullable
as String?,eligibleUsers: null == eligibleUsers ? _self.eligibleUsers : eligibleUsers // ignore: cast_nullable_to_non_nullable
as List<EligibleUserDto>,
  ));
}
/// Create a copy of AssignmentRecommendationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EligibleUserDtoCopyWith<$Res>? get self {
    if (_self.self == null) {
    return null;
  }

  return $EligibleUserDtoCopyWith<$Res>(_self.self!, (value) {
    return _then(_self.copyWith(self: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssignmentRecommendationDto].
extension AssignmentRecommendationDtoPatterns on AssignmentRecommendationDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssignmentRecommendationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssignmentRecommendationDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssignmentRecommendationDto value)  $default,){
final _that = this;
switch (_that) {
case _AssignmentRecommendationDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssignmentRecommendationDto value)?  $default,){
final _that = this;
switch (_that) {
case _AssignmentRecommendationDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? strategy,  String? strategyLabel,  bool forcedSelf,  EligibleUserDto? self,  String? recommendedUserId,  String? recommendedUserName,  List<EligibleUserDto> eligibleUsers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssignmentRecommendationDto() when $default != null:
return $default(_that.strategy,_that.strategyLabel,_that.forcedSelf,_that.self,_that.recommendedUserId,_that.recommendedUserName,_that.eligibleUsers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? strategy,  String? strategyLabel,  bool forcedSelf,  EligibleUserDto? self,  String? recommendedUserId,  String? recommendedUserName,  List<EligibleUserDto> eligibleUsers)  $default,) {final _that = this;
switch (_that) {
case _AssignmentRecommendationDto():
return $default(_that.strategy,_that.strategyLabel,_that.forcedSelf,_that.self,_that.recommendedUserId,_that.recommendedUserName,_that.eligibleUsers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? strategy,  String? strategyLabel,  bool forcedSelf,  EligibleUserDto? self,  String? recommendedUserId,  String? recommendedUserName,  List<EligibleUserDto> eligibleUsers)?  $default,) {final _that = this;
switch (_that) {
case _AssignmentRecommendationDto() when $default != null:
return $default(_that.strategy,_that.strategyLabel,_that.forcedSelf,_that.self,_that.recommendedUserId,_that.recommendedUserName,_that.eligibleUsers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssignmentRecommendationDto implements AssignmentRecommendationDto {
  const _AssignmentRecommendationDto({this.strategy, this.strategyLabel, this.forcedSelf = false, this.self, this.recommendedUserId, this.recommendedUserName, final  List<EligibleUserDto> eligibleUsers = const <EligibleUserDto>[]}): _eligibleUsers = eligibleUsers;
  factory _AssignmentRecommendationDto.fromJson(Map<String, dynamic> json) => _$AssignmentRecommendationDtoFromJson(json);

@override final  String? strategy;
@override final  String? strategyLabel;
@override@JsonKey() final  bool forcedSelf;
@override final  EligibleUserDto? self;
@override final  String? recommendedUserId;
@override final  String? recommendedUserName;
 final  List<EligibleUserDto> _eligibleUsers;
@override@JsonKey() List<EligibleUserDto> get eligibleUsers {
  if (_eligibleUsers is EqualUnmodifiableListView) return _eligibleUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eligibleUsers);
}


/// Create a copy of AssignmentRecommendationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssignmentRecommendationDtoCopyWith<_AssignmentRecommendationDto> get copyWith => __$AssignmentRecommendationDtoCopyWithImpl<_AssignmentRecommendationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssignmentRecommendationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssignmentRecommendationDto&&(identical(other.strategy, strategy) || other.strategy == strategy)&&(identical(other.strategyLabel, strategyLabel) || other.strategyLabel == strategyLabel)&&(identical(other.forcedSelf, forcedSelf) || other.forcedSelf == forcedSelf)&&(identical(other.self, self) || other.self == self)&&(identical(other.recommendedUserId, recommendedUserId) || other.recommendedUserId == recommendedUserId)&&(identical(other.recommendedUserName, recommendedUserName) || other.recommendedUserName == recommendedUserName)&&const DeepCollectionEquality().equals(other._eligibleUsers, _eligibleUsers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,strategy,strategyLabel,forcedSelf,self,recommendedUserId,recommendedUserName,const DeepCollectionEquality().hash(_eligibleUsers));

@override
String toString() {
  return 'AssignmentRecommendationDto(strategy: $strategy, strategyLabel: $strategyLabel, forcedSelf: $forcedSelf, self: $self, recommendedUserId: $recommendedUserId, recommendedUserName: $recommendedUserName, eligibleUsers: $eligibleUsers)';
}


}

/// @nodoc
abstract mixin class _$AssignmentRecommendationDtoCopyWith<$Res> implements $AssignmentRecommendationDtoCopyWith<$Res> {
  factory _$AssignmentRecommendationDtoCopyWith(_AssignmentRecommendationDto value, $Res Function(_AssignmentRecommendationDto) _then) = __$AssignmentRecommendationDtoCopyWithImpl;
@override @useResult
$Res call({
 String? strategy, String? strategyLabel, bool forcedSelf, EligibleUserDto? self, String? recommendedUserId, String? recommendedUserName, List<EligibleUserDto> eligibleUsers
});


@override $EligibleUserDtoCopyWith<$Res>? get self;

}
/// @nodoc
class __$AssignmentRecommendationDtoCopyWithImpl<$Res>
    implements _$AssignmentRecommendationDtoCopyWith<$Res> {
  __$AssignmentRecommendationDtoCopyWithImpl(this._self, this._then);

  final _AssignmentRecommendationDto _self;
  final $Res Function(_AssignmentRecommendationDto) _then;

/// Create a copy of AssignmentRecommendationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? strategy = freezed,Object? strategyLabel = freezed,Object? forcedSelf = null,Object? self = freezed,Object? recommendedUserId = freezed,Object? recommendedUserName = freezed,Object? eligibleUsers = null,}) {
  return _then(_AssignmentRecommendationDto(
strategy: freezed == strategy ? _self.strategy : strategy // ignore: cast_nullable_to_non_nullable
as String?,strategyLabel: freezed == strategyLabel ? _self.strategyLabel : strategyLabel // ignore: cast_nullable_to_non_nullable
as String?,forcedSelf: null == forcedSelf ? _self.forcedSelf : forcedSelf // ignore: cast_nullable_to_non_nullable
as bool,self: freezed == self ? _self.self : self // ignore: cast_nullable_to_non_nullable
as EligibleUserDto?,recommendedUserId: freezed == recommendedUserId ? _self.recommendedUserId : recommendedUserId // ignore: cast_nullable_to_non_nullable
as String?,recommendedUserName: freezed == recommendedUserName ? _self.recommendedUserName : recommendedUserName // ignore: cast_nullable_to_non_nullable
as String?,eligibleUsers: null == eligibleUsers ? _self._eligibleUsers : eligibleUsers // ignore: cast_nullable_to_non_nullable
as List<EligibleUserDto>,
  ));
}

/// Create a copy of AssignmentRecommendationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EligibleUserDtoCopyWith<$Res>? get self {
    if (_self.self == null) {
    return null;
  }

  return $EligibleUserDtoCopyWith<$Res>(_self.self!, (value) {
    return _then(_self.copyWith(self: value));
  });
}
}


/// @nodoc
mixin _$EligibleUserDto {

 String? get id; String? get name; String? get email; int? get activeLeads;
/// Create a copy of EligibleUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EligibleUserDtoCopyWith<EligibleUserDto> get copyWith => _$EligibleUserDtoCopyWithImpl<EligibleUserDto>(this as EligibleUserDto, _$identity);

  /// Serializes this EligibleUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EligibleUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.activeLeads, activeLeads) || other.activeLeads == activeLeads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,activeLeads);

@override
String toString() {
  return 'EligibleUserDto(id: $id, name: $name, email: $email, activeLeads: $activeLeads)';
}


}

/// @nodoc
abstract mixin class $EligibleUserDtoCopyWith<$Res>  {
  factory $EligibleUserDtoCopyWith(EligibleUserDto value, $Res Function(EligibleUserDto) _then) = _$EligibleUserDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? email, int? activeLeads
});




}
/// @nodoc
class _$EligibleUserDtoCopyWithImpl<$Res>
    implements $EligibleUserDtoCopyWith<$Res> {
  _$EligibleUserDtoCopyWithImpl(this._self, this._then);

  final EligibleUserDto _self;
  final $Res Function(EligibleUserDto) _then;

/// Create a copy of EligibleUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? email = freezed,Object? activeLeads = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,activeLeads: freezed == activeLeads ? _self.activeLeads : activeLeads // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EligibleUserDto].
extension EligibleUserDtoPatterns on EligibleUserDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EligibleUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EligibleUserDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EligibleUserDto value)  $default,){
final _that = this;
switch (_that) {
case _EligibleUserDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EligibleUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _EligibleUserDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? email,  int? activeLeads)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EligibleUserDto() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.activeLeads);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? email,  int? activeLeads)  $default,) {final _that = this;
switch (_that) {
case _EligibleUserDto():
return $default(_that.id,_that.name,_that.email,_that.activeLeads);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? email,  int? activeLeads)?  $default,) {final _that = this;
switch (_that) {
case _EligibleUserDto() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.activeLeads);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EligibleUserDto implements EligibleUserDto {
  const _EligibleUserDto({this.id, this.name, this.email, this.activeLeads});
  factory _EligibleUserDto.fromJson(Map<String, dynamic> json) => _$EligibleUserDtoFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? email;
@override final  int? activeLeads;

/// Create a copy of EligibleUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EligibleUserDtoCopyWith<_EligibleUserDto> get copyWith => __$EligibleUserDtoCopyWithImpl<_EligibleUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EligibleUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EligibleUserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.activeLeads, activeLeads) || other.activeLeads == activeLeads));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,activeLeads);

@override
String toString() {
  return 'EligibleUserDto(id: $id, name: $name, email: $email, activeLeads: $activeLeads)';
}


}

/// @nodoc
abstract mixin class _$EligibleUserDtoCopyWith<$Res> implements $EligibleUserDtoCopyWith<$Res> {
  factory _$EligibleUserDtoCopyWith(_EligibleUserDto value, $Res Function(_EligibleUserDto) _then) = __$EligibleUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? email, int? activeLeads
});




}
/// @nodoc
class __$EligibleUserDtoCopyWithImpl<$Res>
    implements _$EligibleUserDtoCopyWith<$Res> {
  __$EligibleUserDtoCopyWithImpl(this._self, this._then);

  final _EligibleUserDto _self;
  final $Res Function(_EligibleUserDto) _then;

/// Create a copy of EligibleUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? email = freezed,Object? activeLeads = freezed,}) {
  return _then(_EligibleUserDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,activeLeads: freezed == activeLeads ? _self.activeLeads : activeLeads // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
