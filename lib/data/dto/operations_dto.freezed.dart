// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operations_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OpsBoardRowDto {

 String? get bookingPublicId; String? get bookingCode; String? get customerName; String? get destination; String? get travelDate; String? get tripEndDate;/// Negative once departure has passed. Computed against the tenant's clock.
 int? get daysToDeparture; String? get status; String? get paymentStatus; Map<String, String> get readiness; Map<String, DimensionCountDto> get dimensionCounts; int? get suppliersConfirmed; int? get suppliersTotal; int? get pax; num? get balanceDue; bool? get needsAttention; String? get overallStatus;/// Null for bookings with no ops record yet — the UI falls back to the
/// readiness map rather than showing a blank severity.
 OpsStandingDto? get ops;
/// Create a copy of OpsBoardRowDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsBoardRowDtoCopyWith<OpsBoardRowDto> get copyWith => _$OpsBoardRowDtoCopyWithImpl<OpsBoardRowDto>(this as OpsBoardRowDto, _$identity);

  /// Serializes this OpsBoardRowDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsBoardRowDto&&(identical(other.bookingPublicId, bookingPublicId) || other.bookingPublicId == bookingPublicId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.tripEndDate, tripEndDate) || other.tripEndDate == tripEndDate)&&(identical(other.daysToDeparture, daysToDeparture) || other.daysToDeparture == daysToDeparture)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other.readiness, readiness)&&const DeepCollectionEquality().equals(other.dimensionCounts, dimensionCounts)&&(identical(other.suppliersConfirmed, suppliersConfirmed) || other.suppliersConfirmed == suppliersConfirmed)&&(identical(other.suppliersTotal, suppliersTotal) || other.suppliersTotal == suppliersTotal)&&(identical(other.pax, pax) || other.pax == pax)&&(identical(other.balanceDue, balanceDue) || other.balanceDue == balanceDue)&&(identical(other.needsAttention, needsAttention) || other.needsAttention == needsAttention)&&(identical(other.overallStatus, overallStatus) || other.overallStatus == overallStatus)&&(identical(other.ops, ops) || other.ops == ops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookingPublicId,bookingCode,customerName,destination,travelDate,tripEndDate,daysToDeparture,status,paymentStatus,const DeepCollectionEquality().hash(readiness),const DeepCollectionEquality().hash(dimensionCounts),suppliersConfirmed,suppliersTotal,pax,balanceDue,needsAttention,overallStatus,ops);

@override
String toString() {
  return 'OpsBoardRowDto(bookingPublicId: $bookingPublicId, bookingCode: $bookingCode, customerName: $customerName, destination: $destination, travelDate: $travelDate, tripEndDate: $tripEndDate, daysToDeparture: $daysToDeparture, status: $status, paymentStatus: $paymentStatus, readiness: $readiness, dimensionCounts: $dimensionCounts, suppliersConfirmed: $suppliersConfirmed, suppliersTotal: $suppliersTotal, pax: $pax, balanceDue: $balanceDue, needsAttention: $needsAttention, overallStatus: $overallStatus, ops: $ops)';
}


}

/// @nodoc
abstract mixin class $OpsBoardRowDtoCopyWith<$Res>  {
  factory $OpsBoardRowDtoCopyWith(OpsBoardRowDto value, $Res Function(OpsBoardRowDto) _then) = _$OpsBoardRowDtoCopyWithImpl;
@useResult
$Res call({
 String? bookingPublicId, String? bookingCode, String? customerName, String? destination, String? travelDate, String? tripEndDate, int? daysToDeparture, String? status, String? paymentStatus, Map<String, String> readiness, Map<String, DimensionCountDto> dimensionCounts, int? suppliersConfirmed, int? suppliersTotal, int? pax, num? balanceDue, bool? needsAttention, String? overallStatus, OpsStandingDto? ops
});


$OpsStandingDtoCopyWith<$Res>? get ops;

}
/// @nodoc
class _$OpsBoardRowDtoCopyWithImpl<$Res>
    implements $OpsBoardRowDtoCopyWith<$Res> {
  _$OpsBoardRowDtoCopyWithImpl(this._self, this._then);

  final OpsBoardRowDto _self;
  final $Res Function(OpsBoardRowDto) _then;

/// Create a copy of OpsBoardRowDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookingPublicId = freezed,Object? bookingCode = freezed,Object? customerName = freezed,Object? destination = freezed,Object? travelDate = freezed,Object? tripEndDate = freezed,Object? daysToDeparture = freezed,Object? status = freezed,Object? paymentStatus = freezed,Object? readiness = null,Object? dimensionCounts = null,Object? suppliersConfirmed = freezed,Object? suppliersTotal = freezed,Object? pax = freezed,Object? balanceDue = freezed,Object? needsAttention = freezed,Object? overallStatus = freezed,Object? ops = freezed,}) {
  return _then(_self.copyWith(
bookingPublicId: freezed == bookingPublicId ? _self.bookingPublicId : bookingPublicId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: freezed == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,tripEndDate: freezed == tripEndDate ? _self.tripEndDate : tripEndDate // ignore: cast_nullable_to_non_nullable
as String?,daysToDeparture: freezed == daysToDeparture ? _self.daysToDeparture : daysToDeparture // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as Map<String, String>,dimensionCounts: null == dimensionCounts ? _self.dimensionCounts : dimensionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, DimensionCountDto>,suppliersConfirmed: freezed == suppliersConfirmed ? _self.suppliersConfirmed : suppliersConfirmed // ignore: cast_nullable_to_non_nullable
as int?,suppliersTotal: freezed == suppliersTotal ? _self.suppliersTotal : suppliersTotal // ignore: cast_nullable_to_non_nullable
as int?,pax: freezed == pax ? _self.pax : pax // ignore: cast_nullable_to_non_nullable
as int?,balanceDue: freezed == balanceDue ? _self.balanceDue : balanceDue // ignore: cast_nullable_to_non_nullable
as num?,needsAttention: freezed == needsAttention ? _self.needsAttention : needsAttention // ignore: cast_nullable_to_non_nullable
as bool?,overallStatus: freezed == overallStatus ? _self.overallStatus : overallStatus // ignore: cast_nullable_to_non_nullable
as String?,ops: freezed == ops ? _self.ops : ops // ignore: cast_nullable_to_non_nullable
as OpsStandingDto?,
  ));
}
/// Create a copy of OpsBoardRowDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsStandingDtoCopyWith<$Res>? get ops {
    if (_self.ops == null) {
    return null;
  }

  return $OpsStandingDtoCopyWith<$Res>(_self.ops!, (value) {
    return _then(_self.copyWith(ops: value));
  });
}
}


/// Adds pattern-matching-related methods to [OpsBoardRowDto].
extension OpsBoardRowDtoPatterns on OpsBoardRowDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsBoardRowDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsBoardRowDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsBoardRowDto value)  $default,){
final _that = this;
switch (_that) {
case _OpsBoardRowDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsBoardRowDto value)?  $default,){
final _that = this;
switch (_that) {
case _OpsBoardRowDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? bookingPublicId,  String? bookingCode,  String? customerName,  String? destination,  String? travelDate,  String? tripEndDate,  int? daysToDeparture,  String? status,  String? paymentStatus,  Map<String, String> readiness,  Map<String, DimensionCountDto> dimensionCounts,  int? suppliersConfirmed,  int? suppliersTotal,  int? pax,  num? balanceDue,  bool? needsAttention,  String? overallStatus,  OpsStandingDto? ops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsBoardRowDto() when $default != null:
return $default(_that.bookingPublicId,_that.bookingCode,_that.customerName,_that.destination,_that.travelDate,_that.tripEndDate,_that.daysToDeparture,_that.status,_that.paymentStatus,_that.readiness,_that.dimensionCounts,_that.suppliersConfirmed,_that.suppliersTotal,_that.pax,_that.balanceDue,_that.needsAttention,_that.overallStatus,_that.ops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? bookingPublicId,  String? bookingCode,  String? customerName,  String? destination,  String? travelDate,  String? tripEndDate,  int? daysToDeparture,  String? status,  String? paymentStatus,  Map<String, String> readiness,  Map<String, DimensionCountDto> dimensionCounts,  int? suppliersConfirmed,  int? suppliersTotal,  int? pax,  num? balanceDue,  bool? needsAttention,  String? overallStatus,  OpsStandingDto? ops)  $default,) {final _that = this;
switch (_that) {
case _OpsBoardRowDto():
return $default(_that.bookingPublicId,_that.bookingCode,_that.customerName,_that.destination,_that.travelDate,_that.tripEndDate,_that.daysToDeparture,_that.status,_that.paymentStatus,_that.readiness,_that.dimensionCounts,_that.suppliersConfirmed,_that.suppliersTotal,_that.pax,_that.balanceDue,_that.needsAttention,_that.overallStatus,_that.ops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? bookingPublicId,  String? bookingCode,  String? customerName,  String? destination,  String? travelDate,  String? tripEndDate,  int? daysToDeparture,  String? status,  String? paymentStatus,  Map<String, String> readiness,  Map<String, DimensionCountDto> dimensionCounts,  int? suppliersConfirmed,  int? suppliersTotal,  int? pax,  num? balanceDue,  bool? needsAttention,  String? overallStatus,  OpsStandingDto? ops)?  $default,) {final _that = this;
switch (_that) {
case _OpsBoardRowDto() when $default != null:
return $default(_that.bookingPublicId,_that.bookingCode,_that.customerName,_that.destination,_that.travelDate,_that.tripEndDate,_that.daysToDeparture,_that.status,_that.paymentStatus,_that.readiness,_that.dimensionCounts,_that.suppliersConfirmed,_that.suppliersTotal,_that.pax,_that.balanceDue,_that.needsAttention,_that.overallStatus,_that.ops);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpsBoardRowDto implements OpsBoardRowDto {
  const _OpsBoardRowDto({this.bookingPublicId, this.bookingCode, this.customerName, this.destination, this.travelDate, this.tripEndDate, this.daysToDeparture, this.status, this.paymentStatus, final  Map<String, String> readiness = const <String, String>{}, final  Map<String, DimensionCountDto> dimensionCounts = const <String, DimensionCountDto>{}, this.suppliersConfirmed, this.suppliersTotal, this.pax, this.balanceDue, this.needsAttention, this.overallStatus, this.ops}): _readiness = readiness,_dimensionCounts = dimensionCounts;
  factory _OpsBoardRowDto.fromJson(Map<String, dynamic> json) => _$OpsBoardRowDtoFromJson(json);

@override final  String? bookingPublicId;
@override final  String? bookingCode;
@override final  String? customerName;
@override final  String? destination;
@override final  String? travelDate;
@override final  String? tripEndDate;
/// Negative once departure has passed. Computed against the tenant's clock.
@override final  int? daysToDeparture;
@override final  String? status;
@override final  String? paymentStatus;
 final  Map<String, String> _readiness;
@override@JsonKey() Map<String, String> get readiness {
  if (_readiness is EqualUnmodifiableMapView) return _readiness;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_readiness);
}

 final  Map<String, DimensionCountDto> _dimensionCounts;
@override@JsonKey() Map<String, DimensionCountDto> get dimensionCounts {
  if (_dimensionCounts is EqualUnmodifiableMapView) return _dimensionCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dimensionCounts);
}

@override final  int? suppliersConfirmed;
@override final  int? suppliersTotal;
@override final  int? pax;
@override final  num? balanceDue;
@override final  bool? needsAttention;
@override final  String? overallStatus;
/// Null for bookings with no ops record yet — the UI falls back to the
/// readiness map rather than showing a blank severity.
@override final  OpsStandingDto? ops;

/// Create a copy of OpsBoardRowDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsBoardRowDtoCopyWith<_OpsBoardRowDto> get copyWith => __$OpsBoardRowDtoCopyWithImpl<_OpsBoardRowDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpsBoardRowDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsBoardRowDto&&(identical(other.bookingPublicId, bookingPublicId) || other.bookingPublicId == bookingPublicId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.tripEndDate, tripEndDate) || other.tripEndDate == tripEndDate)&&(identical(other.daysToDeparture, daysToDeparture) || other.daysToDeparture == daysToDeparture)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other._readiness, _readiness)&&const DeepCollectionEquality().equals(other._dimensionCounts, _dimensionCounts)&&(identical(other.suppliersConfirmed, suppliersConfirmed) || other.suppliersConfirmed == suppliersConfirmed)&&(identical(other.suppliersTotal, suppliersTotal) || other.suppliersTotal == suppliersTotal)&&(identical(other.pax, pax) || other.pax == pax)&&(identical(other.balanceDue, balanceDue) || other.balanceDue == balanceDue)&&(identical(other.needsAttention, needsAttention) || other.needsAttention == needsAttention)&&(identical(other.overallStatus, overallStatus) || other.overallStatus == overallStatus)&&(identical(other.ops, ops) || other.ops == ops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookingPublicId,bookingCode,customerName,destination,travelDate,tripEndDate,daysToDeparture,status,paymentStatus,const DeepCollectionEquality().hash(_readiness),const DeepCollectionEquality().hash(_dimensionCounts),suppliersConfirmed,suppliersTotal,pax,balanceDue,needsAttention,overallStatus,ops);

@override
String toString() {
  return 'OpsBoardRowDto(bookingPublicId: $bookingPublicId, bookingCode: $bookingCode, customerName: $customerName, destination: $destination, travelDate: $travelDate, tripEndDate: $tripEndDate, daysToDeparture: $daysToDeparture, status: $status, paymentStatus: $paymentStatus, readiness: $readiness, dimensionCounts: $dimensionCounts, suppliersConfirmed: $suppliersConfirmed, suppliersTotal: $suppliersTotal, pax: $pax, balanceDue: $balanceDue, needsAttention: $needsAttention, overallStatus: $overallStatus, ops: $ops)';
}


}

/// @nodoc
abstract mixin class _$OpsBoardRowDtoCopyWith<$Res> implements $OpsBoardRowDtoCopyWith<$Res> {
  factory _$OpsBoardRowDtoCopyWith(_OpsBoardRowDto value, $Res Function(_OpsBoardRowDto) _then) = __$OpsBoardRowDtoCopyWithImpl;
@override @useResult
$Res call({
 String? bookingPublicId, String? bookingCode, String? customerName, String? destination, String? travelDate, String? tripEndDate, int? daysToDeparture, String? status, String? paymentStatus, Map<String, String> readiness, Map<String, DimensionCountDto> dimensionCounts, int? suppliersConfirmed, int? suppliersTotal, int? pax, num? balanceDue, bool? needsAttention, String? overallStatus, OpsStandingDto? ops
});


@override $OpsStandingDtoCopyWith<$Res>? get ops;

}
/// @nodoc
class __$OpsBoardRowDtoCopyWithImpl<$Res>
    implements _$OpsBoardRowDtoCopyWith<$Res> {
  __$OpsBoardRowDtoCopyWithImpl(this._self, this._then);

  final _OpsBoardRowDto _self;
  final $Res Function(_OpsBoardRowDto) _then;

/// Create a copy of OpsBoardRowDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookingPublicId = freezed,Object? bookingCode = freezed,Object? customerName = freezed,Object? destination = freezed,Object? travelDate = freezed,Object? tripEndDate = freezed,Object? daysToDeparture = freezed,Object? status = freezed,Object? paymentStatus = freezed,Object? readiness = null,Object? dimensionCounts = null,Object? suppliersConfirmed = freezed,Object? suppliersTotal = freezed,Object? pax = freezed,Object? balanceDue = freezed,Object? needsAttention = freezed,Object? overallStatus = freezed,Object? ops = freezed,}) {
  return _then(_OpsBoardRowDto(
bookingPublicId: freezed == bookingPublicId ? _self.bookingPublicId : bookingPublicId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: freezed == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,tripEndDate: freezed == tripEndDate ? _self.tripEndDate : tripEndDate // ignore: cast_nullable_to_non_nullable
as String?,daysToDeparture: freezed == daysToDeparture ? _self.daysToDeparture : daysToDeparture // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,readiness: null == readiness ? _self._readiness : readiness // ignore: cast_nullable_to_non_nullable
as Map<String, String>,dimensionCounts: null == dimensionCounts ? _self._dimensionCounts : dimensionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, DimensionCountDto>,suppliersConfirmed: freezed == suppliersConfirmed ? _self.suppliersConfirmed : suppliersConfirmed // ignore: cast_nullable_to_non_nullable
as int?,suppliersTotal: freezed == suppliersTotal ? _self.suppliersTotal : suppliersTotal // ignore: cast_nullable_to_non_nullable
as int?,pax: freezed == pax ? _self.pax : pax // ignore: cast_nullable_to_non_nullable
as int?,balanceDue: freezed == balanceDue ? _self.balanceDue : balanceDue // ignore: cast_nullable_to_non_nullable
as num?,needsAttention: freezed == needsAttention ? _self.needsAttention : needsAttention // ignore: cast_nullable_to_non_nullable
as bool?,overallStatus: freezed == overallStatus ? _self.overallStatus : overallStatus // ignore: cast_nullable_to_non_nullable
as String?,ops: freezed == ops ? _self.ops : ops // ignore: cast_nullable_to_non_nullable
as OpsStandingDto?,
  ));
}

/// Create a copy of OpsBoardRowDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OpsStandingDtoCopyWith<$Res>? get ops {
    if (_self.ops == null) {
    return null;
  }

  return $OpsStandingDtoCopyWith<$Res>(_self.ops!, (value) {
    return _then(_self.copyWith(ops: value));
  });
}
}


/// @nodoc
mixin _$DimensionCountDto {

 int? get confirmed; int? get total;
/// Create a copy of DimensionCountDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DimensionCountDtoCopyWith<DimensionCountDto> get copyWith => _$DimensionCountDtoCopyWithImpl<DimensionCountDto>(this as DimensionCountDto, _$identity);

  /// Serializes this DimensionCountDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DimensionCountDto&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,confirmed,total);

@override
String toString() {
  return 'DimensionCountDto(confirmed: $confirmed, total: $total)';
}


}

/// @nodoc
abstract mixin class $DimensionCountDtoCopyWith<$Res>  {
  factory $DimensionCountDtoCopyWith(DimensionCountDto value, $Res Function(DimensionCountDto) _then) = _$DimensionCountDtoCopyWithImpl;
@useResult
$Res call({
 int? confirmed, int? total
});




}
/// @nodoc
class _$DimensionCountDtoCopyWithImpl<$Res>
    implements $DimensionCountDtoCopyWith<$Res> {
  _$DimensionCountDtoCopyWithImpl(this._self, this._then);

  final DimensionCountDto _self;
  final $Res Function(DimensionCountDto) _then;

/// Create a copy of DimensionCountDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? confirmed = freezed,Object? total = freezed,}) {
  return _then(_self.copyWith(
confirmed: freezed == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DimensionCountDto].
extension DimensionCountDtoPatterns on DimensionCountDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DimensionCountDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DimensionCountDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DimensionCountDto value)  $default,){
final _that = this;
switch (_that) {
case _DimensionCountDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DimensionCountDto value)?  $default,){
final _that = this;
switch (_that) {
case _DimensionCountDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? confirmed,  int? total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DimensionCountDto() when $default != null:
return $default(_that.confirmed,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? confirmed,  int? total)  $default,) {final _that = this;
switch (_that) {
case _DimensionCountDto():
return $default(_that.confirmed,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? confirmed,  int? total)?  $default,) {final _that = this;
switch (_that) {
case _DimensionCountDto() when $default != null:
return $default(_that.confirmed,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DimensionCountDto implements DimensionCountDto {
  const _DimensionCountDto({this.confirmed, this.total});
  factory _DimensionCountDto.fromJson(Map<String, dynamic> json) => _$DimensionCountDtoFromJson(json);

@override final  int? confirmed;
@override final  int? total;

/// Create a copy of DimensionCountDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DimensionCountDtoCopyWith<_DimensionCountDto> get copyWith => __$DimensionCountDtoCopyWithImpl<_DimensionCountDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DimensionCountDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DimensionCountDto&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,confirmed,total);

@override
String toString() {
  return 'DimensionCountDto(confirmed: $confirmed, total: $total)';
}


}

/// @nodoc
abstract mixin class _$DimensionCountDtoCopyWith<$Res> implements $DimensionCountDtoCopyWith<$Res> {
  factory _$DimensionCountDtoCopyWith(_DimensionCountDto value, $Res Function(_DimensionCountDto) _then) = __$DimensionCountDtoCopyWithImpl;
@override @useResult
$Res call({
 int? confirmed, int? total
});




}
/// @nodoc
class __$DimensionCountDtoCopyWithImpl<$Res>
    implements _$DimensionCountDtoCopyWith<$Res> {
  __$DimensionCountDtoCopyWithImpl(this._self, this._then);

  final _DimensionCountDto _self;
  final $Res Function(_DimensionCountDto) _then;

/// Create a copy of DimensionCountDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? confirmed = freezed,Object? total = freezed,}) {
  return _then(_DimensionCountDto(
confirmed: freezed == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int?,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$OpsStandingDto {

 String? get severity; int? get hoursToDeparture; String? get departureAt; String? get departureAtSourceLabel; String? get opsOwnerPublicId; String? get opsOwnerName; bool? get readyToTravel;
/// Create a copy of OpsStandingDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsStandingDtoCopyWith<OpsStandingDto> get copyWith => _$OpsStandingDtoCopyWithImpl<OpsStandingDto>(this as OpsStandingDto, _$identity);

  /// Serializes this OpsStandingDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsStandingDto&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.hoursToDeparture, hoursToDeparture) || other.hoursToDeparture == hoursToDeparture)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.departureAtSourceLabel, departureAtSourceLabel) || other.departureAtSourceLabel == departureAtSourceLabel)&&(identical(other.opsOwnerPublicId, opsOwnerPublicId) || other.opsOwnerPublicId == opsOwnerPublicId)&&(identical(other.opsOwnerName, opsOwnerName) || other.opsOwnerName == opsOwnerName)&&(identical(other.readyToTravel, readyToTravel) || other.readyToTravel == readyToTravel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,severity,hoursToDeparture,departureAt,departureAtSourceLabel,opsOwnerPublicId,opsOwnerName,readyToTravel);

@override
String toString() {
  return 'OpsStandingDto(severity: $severity, hoursToDeparture: $hoursToDeparture, departureAt: $departureAt, departureAtSourceLabel: $departureAtSourceLabel, opsOwnerPublicId: $opsOwnerPublicId, opsOwnerName: $opsOwnerName, readyToTravel: $readyToTravel)';
}


}

/// @nodoc
abstract mixin class $OpsStandingDtoCopyWith<$Res>  {
  factory $OpsStandingDtoCopyWith(OpsStandingDto value, $Res Function(OpsStandingDto) _then) = _$OpsStandingDtoCopyWithImpl;
@useResult
$Res call({
 String? severity, int? hoursToDeparture, String? departureAt, String? departureAtSourceLabel, String? opsOwnerPublicId, String? opsOwnerName, bool? readyToTravel
});




}
/// @nodoc
class _$OpsStandingDtoCopyWithImpl<$Res>
    implements $OpsStandingDtoCopyWith<$Res> {
  _$OpsStandingDtoCopyWithImpl(this._self, this._then);

  final OpsStandingDto _self;
  final $Res Function(OpsStandingDto) _then;

/// Create a copy of OpsStandingDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? severity = freezed,Object? hoursToDeparture = freezed,Object? departureAt = freezed,Object? departureAtSourceLabel = freezed,Object? opsOwnerPublicId = freezed,Object? opsOwnerName = freezed,Object? readyToTravel = freezed,}) {
  return _then(_self.copyWith(
severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,hoursToDeparture: freezed == hoursToDeparture ? _self.hoursToDeparture : hoursToDeparture // ignore: cast_nullable_to_non_nullable
as int?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String?,departureAtSourceLabel: freezed == departureAtSourceLabel ? _self.departureAtSourceLabel : departureAtSourceLabel // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerPublicId: freezed == opsOwnerPublicId ? _self.opsOwnerPublicId : opsOwnerPublicId // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerName: freezed == opsOwnerName ? _self.opsOwnerName : opsOwnerName // ignore: cast_nullable_to_non_nullable
as String?,readyToTravel: freezed == readyToTravel ? _self.readyToTravel : readyToTravel // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsStandingDto].
extension OpsStandingDtoPatterns on OpsStandingDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsStandingDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsStandingDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsStandingDto value)  $default,){
final _that = this;
switch (_that) {
case _OpsStandingDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsStandingDto value)?  $default,){
final _that = this;
switch (_that) {
case _OpsStandingDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? severity,  int? hoursToDeparture,  String? departureAt,  String? departureAtSourceLabel,  String? opsOwnerPublicId,  String? opsOwnerName,  bool? readyToTravel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsStandingDto() when $default != null:
return $default(_that.severity,_that.hoursToDeparture,_that.departureAt,_that.departureAtSourceLabel,_that.opsOwnerPublicId,_that.opsOwnerName,_that.readyToTravel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? severity,  int? hoursToDeparture,  String? departureAt,  String? departureAtSourceLabel,  String? opsOwnerPublicId,  String? opsOwnerName,  bool? readyToTravel)  $default,) {final _that = this;
switch (_that) {
case _OpsStandingDto():
return $default(_that.severity,_that.hoursToDeparture,_that.departureAt,_that.departureAtSourceLabel,_that.opsOwnerPublicId,_that.opsOwnerName,_that.readyToTravel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? severity,  int? hoursToDeparture,  String? departureAt,  String? departureAtSourceLabel,  String? opsOwnerPublicId,  String? opsOwnerName,  bool? readyToTravel)?  $default,) {final _that = this;
switch (_that) {
case _OpsStandingDto() when $default != null:
return $default(_that.severity,_that.hoursToDeparture,_that.departureAt,_that.departureAtSourceLabel,_that.opsOwnerPublicId,_that.opsOwnerName,_that.readyToTravel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpsStandingDto implements OpsStandingDto {
  const _OpsStandingDto({this.severity, this.hoursToDeparture, this.departureAt, this.departureAtSourceLabel, this.opsOwnerPublicId, this.opsOwnerName, this.readyToTravel});
  factory _OpsStandingDto.fromJson(Map<String, dynamic> json) => _$OpsStandingDtoFromJson(json);

@override final  String? severity;
@override final  int? hoursToDeparture;
@override final  String? departureAt;
@override final  String? departureAtSourceLabel;
@override final  String? opsOwnerPublicId;
@override final  String? opsOwnerName;
@override final  bool? readyToTravel;

/// Create a copy of OpsStandingDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsStandingDtoCopyWith<_OpsStandingDto> get copyWith => __$OpsStandingDtoCopyWithImpl<_OpsStandingDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpsStandingDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsStandingDto&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.hoursToDeparture, hoursToDeparture) || other.hoursToDeparture == hoursToDeparture)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.departureAtSourceLabel, departureAtSourceLabel) || other.departureAtSourceLabel == departureAtSourceLabel)&&(identical(other.opsOwnerPublicId, opsOwnerPublicId) || other.opsOwnerPublicId == opsOwnerPublicId)&&(identical(other.opsOwnerName, opsOwnerName) || other.opsOwnerName == opsOwnerName)&&(identical(other.readyToTravel, readyToTravel) || other.readyToTravel == readyToTravel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,severity,hoursToDeparture,departureAt,departureAtSourceLabel,opsOwnerPublicId,opsOwnerName,readyToTravel);

@override
String toString() {
  return 'OpsStandingDto(severity: $severity, hoursToDeparture: $hoursToDeparture, departureAt: $departureAt, departureAtSourceLabel: $departureAtSourceLabel, opsOwnerPublicId: $opsOwnerPublicId, opsOwnerName: $opsOwnerName, readyToTravel: $readyToTravel)';
}


}

/// @nodoc
abstract mixin class _$OpsStandingDtoCopyWith<$Res> implements $OpsStandingDtoCopyWith<$Res> {
  factory _$OpsStandingDtoCopyWith(_OpsStandingDto value, $Res Function(_OpsStandingDto) _then) = __$OpsStandingDtoCopyWithImpl;
@override @useResult
$Res call({
 String? severity, int? hoursToDeparture, String? departureAt, String? departureAtSourceLabel, String? opsOwnerPublicId, String? opsOwnerName, bool? readyToTravel
});




}
/// @nodoc
class __$OpsStandingDtoCopyWithImpl<$Res>
    implements _$OpsStandingDtoCopyWith<$Res> {
  __$OpsStandingDtoCopyWithImpl(this._self, this._then);

  final _OpsStandingDto _self;
  final $Res Function(_OpsStandingDto) _then;

/// Create a copy of OpsStandingDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? severity = freezed,Object? hoursToDeparture = freezed,Object? departureAt = freezed,Object? departureAtSourceLabel = freezed,Object? opsOwnerPublicId = freezed,Object? opsOwnerName = freezed,Object? readyToTravel = freezed,}) {
  return _then(_OpsStandingDto(
severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,hoursToDeparture: freezed == hoursToDeparture ? _self.hoursToDeparture : hoursToDeparture // ignore: cast_nullable_to_non_nullable
as int?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String?,departureAtSourceLabel: freezed == departureAtSourceLabel ? _self.departureAtSourceLabel : departureAtSourceLabel // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerPublicId: freezed == opsOwnerPublicId ? _self.opsOwnerPublicId : opsOwnerPublicId // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerName: freezed == opsOwnerName ? _self.opsOwnerName : opsOwnerName // ignore: cast_nullable_to_non_nullable
as String?,readyToTravel: freezed == readyToTravel ? _self.readyToTravel : readyToTravel // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$OpsSummaryDto {

 String? get from; String? get to; int? get totalBookings; int? get ready; int? get actionNeeded; int? get urgent; num? get balancePending;
/// Create a copy of OpsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsSummaryDtoCopyWith<OpsSummaryDto> get copyWith => _$OpsSummaryDtoCopyWithImpl<OpsSummaryDto>(this as OpsSummaryDto, _$identity);

  /// Serializes this OpsSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsSummaryDto&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.actionNeeded, actionNeeded) || other.actionNeeded == actionNeeded)&&(identical(other.urgent, urgent) || other.urgent == urgent)&&(identical(other.balancePending, balancePending) || other.balancePending == balancePending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,totalBookings,ready,actionNeeded,urgent,balancePending);

@override
String toString() {
  return 'OpsSummaryDto(from: $from, to: $to, totalBookings: $totalBookings, ready: $ready, actionNeeded: $actionNeeded, urgent: $urgent, balancePending: $balancePending)';
}


}

/// @nodoc
abstract mixin class $OpsSummaryDtoCopyWith<$Res>  {
  factory $OpsSummaryDtoCopyWith(OpsSummaryDto value, $Res Function(OpsSummaryDto) _then) = _$OpsSummaryDtoCopyWithImpl;
@useResult
$Res call({
 String? from, String? to, int? totalBookings, int? ready, int? actionNeeded, int? urgent, num? balancePending
});




}
/// @nodoc
class _$OpsSummaryDtoCopyWithImpl<$Res>
    implements $OpsSummaryDtoCopyWith<$Res> {
  _$OpsSummaryDtoCopyWithImpl(this._self, this._then);

  final OpsSummaryDto _self;
  final $Res Function(OpsSummaryDto) _then;

/// Create a copy of OpsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = freezed,Object? to = freezed,Object? totalBookings = freezed,Object? ready = freezed,Object? actionNeeded = freezed,Object? urgent = freezed,Object? balancePending = freezed,}) {
  return _then(_self.copyWith(
from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String?,totalBookings: freezed == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int?,ready: freezed == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as int?,actionNeeded: freezed == actionNeeded ? _self.actionNeeded : actionNeeded // ignore: cast_nullable_to_non_nullable
as int?,urgent: freezed == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as int?,balancePending: freezed == balancePending ? _self.balancePending : balancePending // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsSummaryDto].
extension OpsSummaryDtoPatterns on OpsSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _OpsSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _OpsSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? from,  String? to,  int? totalBookings,  int? ready,  int? actionNeeded,  int? urgent,  num? balancePending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsSummaryDto() when $default != null:
return $default(_that.from,_that.to,_that.totalBookings,_that.ready,_that.actionNeeded,_that.urgent,_that.balancePending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? from,  String? to,  int? totalBookings,  int? ready,  int? actionNeeded,  int? urgent,  num? balancePending)  $default,) {final _that = this;
switch (_that) {
case _OpsSummaryDto():
return $default(_that.from,_that.to,_that.totalBookings,_that.ready,_that.actionNeeded,_that.urgent,_that.balancePending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? from,  String? to,  int? totalBookings,  int? ready,  int? actionNeeded,  int? urgent,  num? balancePending)?  $default,) {final _that = this;
switch (_that) {
case _OpsSummaryDto() when $default != null:
return $default(_that.from,_that.to,_that.totalBookings,_that.ready,_that.actionNeeded,_that.urgent,_that.balancePending);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpsSummaryDto implements OpsSummaryDto {
  const _OpsSummaryDto({this.from, this.to, this.totalBookings, this.ready, this.actionNeeded, this.urgent, this.balancePending});
  factory _OpsSummaryDto.fromJson(Map<String, dynamic> json) => _$OpsSummaryDtoFromJson(json);

@override final  String? from;
@override final  String? to;
@override final  int? totalBookings;
@override final  int? ready;
@override final  int? actionNeeded;
@override final  int? urgent;
@override final  num? balancePending;

/// Create a copy of OpsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsSummaryDtoCopyWith<_OpsSummaryDto> get copyWith => __$OpsSummaryDtoCopyWithImpl<_OpsSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpsSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsSummaryDto&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.ready, ready) || other.ready == ready)&&(identical(other.actionNeeded, actionNeeded) || other.actionNeeded == actionNeeded)&&(identical(other.urgent, urgent) || other.urgent == urgent)&&(identical(other.balancePending, balancePending) || other.balancePending == balancePending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,totalBookings,ready,actionNeeded,urgent,balancePending);

@override
String toString() {
  return 'OpsSummaryDto(from: $from, to: $to, totalBookings: $totalBookings, ready: $ready, actionNeeded: $actionNeeded, urgent: $urgent, balancePending: $balancePending)';
}


}

/// @nodoc
abstract mixin class _$OpsSummaryDtoCopyWith<$Res> implements $OpsSummaryDtoCopyWith<$Res> {
  factory _$OpsSummaryDtoCopyWith(_OpsSummaryDto value, $Res Function(_OpsSummaryDto) _then) = __$OpsSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String? from, String? to, int? totalBookings, int? ready, int? actionNeeded, int? urgent, num? balancePending
});




}
/// @nodoc
class __$OpsSummaryDtoCopyWithImpl<$Res>
    implements _$OpsSummaryDtoCopyWith<$Res> {
  __$OpsSummaryDtoCopyWithImpl(this._self, this._then);

  final _OpsSummaryDto _self;
  final $Res Function(_OpsSummaryDto) _then;

/// Create a copy of OpsSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = freezed,Object? to = freezed,Object? totalBookings = freezed,Object? ready = freezed,Object? actionNeeded = freezed,Object? urgent = freezed,Object? balancePending = freezed,}) {
  return _then(_OpsSummaryDto(
from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String?,totalBookings: freezed == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int?,ready: freezed == ready ? _self.ready : ready // ignore: cast_nullable_to_non_nullable
as int?,actionNeeded: freezed == actionNeeded ? _self.actionNeeded : actionNeeded // ignore: cast_nullable_to_non_nullable
as int?,urgent: freezed == urgent ? _self.urgent : urgent // ignore: cast_nullable_to_non_nullable
as int?,balancePending: freezed == balancePending ? _self.balancePending : balancePending // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$OpsDetailDto {

 String? get publicId; String? get bookingPublicId; String? get bookingCode; String? get opsOwnerPublicId; String? get opsOwnerName; String? get departureAt; String? get departureAtSourceLabel; String? get tripEndDate; String? get pickupLocation; String? get pickupAt; String? get dropLocation; String? get dropAt; String? get severity; int? get hoursToDeparture; bool? get readyToTravel; List<OpsCheckpointDto> get checkpoints;
/// Create a copy of OpsDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsDetailDtoCopyWith<OpsDetailDto> get copyWith => _$OpsDetailDtoCopyWithImpl<OpsDetailDto>(this as OpsDetailDto, _$identity);

  /// Serializes this OpsDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsDetailDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.bookingPublicId, bookingPublicId) || other.bookingPublicId == bookingPublicId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&(identical(other.opsOwnerPublicId, opsOwnerPublicId) || other.opsOwnerPublicId == opsOwnerPublicId)&&(identical(other.opsOwnerName, opsOwnerName) || other.opsOwnerName == opsOwnerName)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.departureAtSourceLabel, departureAtSourceLabel) || other.departureAtSourceLabel == departureAtSourceLabel)&&(identical(other.tripEndDate, tripEndDate) || other.tripEndDate == tripEndDate)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.pickupAt, pickupAt) || other.pickupAt == pickupAt)&&(identical(other.dropLocation, dropLocation) || other.dropLocation == dropLocation)&&(identical(other.dropAt, dropAt) || other.dropAt == dropAt)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.hoursToDeparture, hoursToDeparture) || other.hoursToDeparture == hoursToDeparture)&&(identical(other.readyToTravel, readyToTravel) || other.readyToTravel == readyToTravel)&&const DeepCollectionEquality().equals(other.checkpoints, checkpoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,bookingPublicId,bookingCode,opsOwnerPublicId,opsOwnerName,departureAt,departureAtSourceLabel,tripEndDate,pickupLocation,pickupAt,dropLocation,dropAt,severity,hoursToDeparture,readyToTravel,const DeepCollectionEquality().hash(checkpoints));

@override
String toString() {
  return 'OpsDetailDto(publicId: $publicId, bookingPublicId: $bookingPublicId, bookingCode: $bookingCode, opsOwnerPublicId: $opsOwnerPublicId, opsOwnerName: $opsOwnerName, departureAt: $departureAt, departureAtSourceLabel: $departureAtSourceLabel, tripEndDate: $tripEndDate, pickupLocation: $pickupLocation, pickupAt: $pickupAt, dropLocation: $dropLocation, dropAt: $dropAt, severity: $severity, hoursToDeparture: $hoursToDeparture, readyToTravel: $readyToTravel, checkpoints: $checkpoints)';
}


}

/// @nodoc
abstract mixin class $OpsDetailDtoCopyWith<$Res>  {
  factory $OpsDetailDtoCopyWith(OpsDetailDto value, $Res Function(OpsDetailDto) _then) = _$OpsDetailDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, String? bookingPublicId, String? bookingCode, String? opsOwnerPublicId, String? opsOwnerName, String? departureAt, String? departureAtSourceLabel, String? tripEndDate, String? pickupLocation, String? pickupAt, String? dropLocation, String? dropAt, String? severity, int? hoursToDeparture, bool? readyToTravel, List<OpsCheckpointDto> checkpoints
});




}
/// @nodoc
class _$OpsDetailDtoCopyWithImpl<$Res>
    implements $OpsDetailDtoCopyWith<$Res> {
  _$OpsDetailDtoCopyWithImpl(this._self, this._then);

  final OpsDetailDto _self;
  final $Res Function(OpsDetailDto) _then;

/// Create a copy of OpsDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? bookingPublicId = freezed,Object? bookingCode = freezed,Object? opsOwnerPublicId = freezed,Object? opsOwnerName = freezed,Object? departureAt = freezed,Object? departureAtSourceLabel = freezed,Object? tripEndDate = freezed,Object? pickupLocation = freezed,Object? pickupAt = freezed,Object? dropLocation = freezed,Object? dropAt = freezed,Object? severity = freezed,Object? hoursToDeparture = freezed,Object? readyToTravel = freezed,Object? checkpoints = null,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,bookingPublicId: freezed == bookingPublicId ? _self.bookingPublicId : bookingPublicId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: freezed == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerPublicId: freezed == opsOwnerPublicId ? _self.opsOwnerPublicId : opsOwnerPublicId // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerName: freezed == opsOwnerName ? _self.opsOwnerName : opsOwnerName // ignore: cast_nullable_to_non_nullable
as String?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String?,departureAtSourceLabel: freezed == departureAtSourceLabel ? _self.departureAtSourceLabel : departureAtSourceLabel // ignore: cast_nullable_to_non_nullable
as String?,tripEndDate: freezed == tripEndDate ? _self.tripEndDate : tripEndDate // ignore: cast_nullable_to_non_nullable
as String?,pickupLocation: freezed == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String?,pickupAt: freezed == pickupAt ? _self.pickupAt : pickupAt // ignore: cast_nullable_to_non_nullable
as String?,dropLocation: freezed == dropLocation ? _self.dropLocation : dropLocation // ignore: cast_nullable_to_non_nullable
as String?,dropAt: freezed == dropAt ? _self.dropAt : dropAt // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,hoursToDeparture: freezed == hoursToDeparture ? _self.hoursToDeparture : hoursToDeparture // ignore: cast_nullable_to_non_nullable
as int?,readyToTravel: freezed == readyToTravel ? _self.readyToTravel : readyToTravel // ignore: cast_nullable_to_non_nullable
as bool?,checkpoints: null == checkpoints ? _self.checkpoints : checkpoints // ignore: cast_nullable_to_non_nullable
as List<OpsCheckpointDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsDetailDto].
extension OpsDetailDtoPatterns on OpsDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _OpsDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _OpsDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  String? bookingPublicId,  String? bookingCode,  String? opsOwnerPublicId,  String? opsOwnerName,  String? departureAt,  String? departureAtSourceLabel,  String? tripEndDate,  String? pickupLocation,  String? pickupAt,  String? dropLocation,  String? dropAt,  String? severity,  int? hoursToDeparture,  bool? readyToTravel,  List<OpsCheckpointDto> checkpoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsDetailDto() when $default != null:
return $default(_that.publicId,_that.bookingPublicId,_that.bookingCode,_that.opsOwnerPublicId,_that.opsOwnerName,_that.departureAt,_that.departureAtSourceLabel,_that.tripEndDate,_that.pickupLocation,_that.pickupAt,_that.dropLocation,_that.dropAt,_that.severity,_that.hoursToDeparture,_that.readyToTravel,_that.checkpoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  String? bookingPublicId,  String? bookingCode,  String? opsOwnerPublicId,  String? opsOwnerName,  String? departureAt,  String? departureAtSourceLabel,  String? tripEndDate,  String? pickupLocation,  String? pickupAt,  String? dropLocation,  String? dropAt,  String? severity,  int? hoursToDeparture,  bool? readyToTravel,  List<OpsCheckpointDto> checkpoints)  $default,) {final _that = this;
switch (_that) {
case _OpsDetailDto():
return $default(_that.publicId,_that.bookingPublicId,_that.bookingCode,_that.opsOwnerPublicId,_that.opsOwnerName,_that.departureAt,_that.departureAtSourceLabel,_that.tripEndDate,_that.pickupLocation,_that.pickupAt,_that.dropLocation,_that.dropAt,_that.severity,_that.hoursToDeparture,_that.readyToTravel,_that.checkpoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  String? bookingPublicId,  String? bookingCode,  String? opsOwnerPublicId,  String? opsOwnerName,  String? departureAt,  String? departureAtSourceLabel,  String? tripEndDate,  String? pickupLocation,  String? pickupAt,  String? dropLocation,  String? dropAt,  String? severity,  int? hoursToDeparture,  bool? readyToTravel,  List<OpsCheckpointDto> checkpoints)?  $default,) {final _that = this;
switch (_that) {
case _OpsDetailDto() when $default != null:
return $default(_that.publicId,_that.bookingPublicId,_that.bookingCode,_that.opsOwnerPublicId,_that.opsOwnerName,_that.departureAt,_that.departureAtSourceLabel,_that.tripEndDate,_that.pickupLocation,_that.pickupAt,_that.dropLocation,_that.dropAt,_that.severity,_that.hoursToDeparture,_that.readyToTravel,_that.checkpoints);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpsDetailDto implements OpsDetailDto {
  const _OpsDetailDto({this.publicId, this.bookingPublicId, this.bookingCode, this.opsOwnerPublicId, this.opsOwnerName, this.departureAt, this.departureAtSourceLabel, this.tripEndDate, this.pickupLocation, this.pickupAt, this.dropLocation, this.dropAt, this.severity, this.hoursToDeparture, this.readyToTravel, final  List<OpsCheckpointDto> checkpoints = const <OpsCheckpointDto>[]}): _checkpoints = checkpoints;
  factory _OpsDetailDto.fromJson(Map<String, dynamic> json) => _$OpsDetailDtoFromJson(json);

@override final  String? publicId;
@override final  String? bookingPublicId;
@override final  String? bookingCode;
@override final  String? opsOwnerPublicId;
@override final  String? opsOwnerName;
@override final  String? departureAt;
@override final  String? departureAtSourceLabel;
@override final  String? tripEndDate;
@override final  String? pickupLocation;
@override final  String? pickupAt;
@override final  String? dropLocation;
@override final  String? dropAt;
@override final  String? severity;
@override final  int? hoursToDeparture;
@override final  bool? readyToTravel;
 final  List<OpsCheckpointDto> _checkpoints;
@override@JsonKey() List<OpsCheckpointDto> get checkpoints {
  if (_checkpoints is EqualUnmodifiableListView) return _checkpoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checkpoints);
}


/// Create a copy of OpsDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsDetailDtoCopyWith<_OpsDetailDto> get copyWith => __$OpsDetailDtoCopyWithImpl<_OpsDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpsDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsDetailDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.bookingPublicId, bookingPublicId) || other.bookingPublicId == bookingPublicId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&(identical(other.opsOwnerPublicId, opsOwnerPublicId) || other.opsOwnerPublicId == opsOwnerPublicId)&&(identical(other.opsOwnerName, opsOwnerName) || other.opsOwnerName == opsOwnerName)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.departureAtSourceLabel, departureAtSourceLabel) || other.departureAtSourceLabel == departureAtSourceLabel)&&(identical(other.tripEndDate, tripEndDate) || other.tripEndDate == tripEndDate)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.pickupAt, pickupAt) || other.pickupAt == pickupAt)&&(identical(other.dropLocation, dropLocation) || other.dropLocation == dropLocation)&&(identical(other.dropAt, dropAt) || other.dropAt == dropAt)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.hoursToDeparture, hoursToDeparture) || other.hoursToDeparture == hoursToDeparture)&&(identical(other.readyToTravel, readyToTravel) || other.readyToTravel == readyToTravel)&&const DeepCollectionEquality().equals(other._checkpoints, _checkpoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,bookingPublicId,bookingCode,opsOwnerPublicId,opsOwnerName,departureAt,departureAtSourceLabel,tripEndDate,pickupLocation,pickupAt,dropLocation,dropAt,severity,hoursToDeparture,readyToTravel,const DeepCollectionEquality().hash(_checkpoints));

@override
String toString() {
  return 'OpsDetailDto(publicId: $publicId, bookingPublicId: $bookingPublicId, bookingCode: $bookingCode, opsOwnerPublicId: $opsOwnerPublicId, opsOwnerName: $opsOwnerName, departureAt: $departureAt, departureAtSourceLabel: $departureAtSourceLabel, tripEndDate: $tripEndDate, pickupLocation: $pickupLocation, pickupAt: $pickupAt, dropLocation: $dropLocation, dropAt: $dropAt, severity: $severity, hoursToDeparture: $hoursToDeparture, readyToTravel: $readyToTravel, checkpoints: $checkpoints)';
}


}

/// @nodoc
abstract mixin class _$OpsDetailDtoCopyWith<$Res> implements $OpsDetailDtoCopyWith<$Res> {
  factory _$OpsDetailDtoCopyWith(_OpsDetailDto value, $Res Function(_OpsDetailDto) _then) = __$OpsDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, String? bookingPublicId, String? bookingCode, String? opsOwnerPublicId, String? opsOwnerName, String? departureAt, String? departureAtSourceLabel, String? tripEndDate, String? pickupLocation, String? pickupAt, String? dropLocation, String? dropAt, String? severity, int? hoursToDeparture, bool? readyToTravel, List<OpsCheckpointDto> checkpoints
});




}
/// @nodoc
class __$OpsDetailDtoCopyWithImpl<$Res>
    implements _$OpsDetailDtoCopyWith<$Res> {
  __$OpsDetailDtoCopyWithImpl(this._self, this._then);

  final _OpsDetailDto _self;
  final $Res Function(_OpsDetailDto) _then;

/// Create a copy of OpsDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? bookingPublicId = freezed,Object? bookingCode = freezed,Object? opsOwnerPublicId = freezed,Object? opsOwnerName = freezed,Object? departureAt = freezed,Object? departureAtSourceLabel = freezed,Object? tripEndDate = freezed,Object? pickupLocation = freezed,Object? pickupAt = freezed,Object? dropLocation = freezed,Object? dropAt = freezed,Object? severity = freezed,Object? hoursToDeparture = freezed,Object? readyToTravel = freezed,Object? checkpoints = null,}) {
  return _then(_OpsDetailDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,bookingPublicId: freezed == bookingPublicId ? _self.bookingPublicId : bookingPublicId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: freezed == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerPublicId: freezed == opsOwnerPublicId ? _self.opsOwnerPublicId : opsOwnerPublicId // ignore: cast_nullable_to_non_nullable
as String?,opsOwnerName: freezed == opsOwnerName ? _self.opsOwnerName : opsOwnerName // ignore: cast_nullable_to_non_nullable
as String?,departureAt: freezed == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String?,departureAtSourceLabel: freezed == departureAtSourceLabel ? _self.departureAtSourceLabel : departureAtSourceLabel // ignore: cast_nullable_to_non_nullable
as String?,tripEndDate: freezed == tripEndDate ? _self.tripEndDate : tripEndDate // ignore: cast_nullable_to_non_nullable
as String?,pickupLocation: freezed == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String?,pickupAt: freezed == pickupAt ? _self.pickupAt : pickupAt // ignore: cast_nullable_to_non_nullable
as String?,dropLocation: freezed == dropLocation ? _self.dropLocation : dropLocation // ignore: cast_nullable_to_non_nullable
as String?,dropAt: freezed == dropAt ? _self.dropAt : dropAt // ignore: cast_nullable_to_non_nullable
as String?,severity: freezed == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String?,hoursToDeparture: freezed == hoursToDeparture ? _self.hoursToDeparture : hoursToDeparture // ignore: cast_nullable_to_non_nullable
as int?,readyToTravel: freezed == readyToTravel ? _self.readyToTravel : readyToTravel // ignore: cast_nullable_to_non_nullable
as bool?,checkpoints: null == checkpoints ? _self._checkpoints : checkpoints // ignore: cast_nullable_to_non_nullable
as List<OpsCheckpointDto>,
  ));
}


}


/// @nodoc
mixin _$OpsCheckpointDto {

 String? get publicId; String? get checkpoint; String? get status; String? get source; String? get vendorName; String? get referenceNo; String? get notes; String? get dueAt; bool? get mandatory;
/// Create a copy of OpsCheckpointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpsCheckpointDtoCopyWith<OpsCheckpointDto> get copyWith => _$OpsCheckpointDtoCopyWithImpl<OpsCheckpointDto>(this as OpsCheckpointDto, _$identity);

  /// Serializes this OpsCheckpointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpsCheckpointDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.checkpoint, checkpoint) || other.checkpoint == checkpoint)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.mandatory, mandatory) || other.mandatory == mandatory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,checkpoint,status,source,vendorName,referenceNo,notes,dueAt,mandatory);

@override
String toString() {
  return 'OpsCheckpointDto(publicId: $publicId, checkpoint: $checkpoint, status: $status, source: $source, vendorName: $vendorName, referenceNo: $referenceNo, notes: $notes, dueAt: $dueAt, mandatory: $mandatory)';
}


}

/// @nodoc
abstract mixin class $OpsCheckpointDtoCopyWith<$Res>  {
  factory $OpsCheckpointDtoCopyWith(OpsCheckpointDto value, $Res Function(OpsCheckpointDto) _then) = _$OpsCheckpointDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, String? checkpoint, String? status, String? source, String? vendorName, String? referenceNo, String? notes, String? dueAt, bool? mandatory
});




}
/// @nodoc
class _$OpsCheckpointDtoCopyWithImpl<$Res>
    implements $OpsCheckpointDtoCopyWith<$Res> {
  _$OpsCheckpointDtoCopyWithImpl(this._self, this._then);

  final OpsCheckpointDto _self;
  final $Res Function(OpsCheckpointDto) _then;

/// Create a copy of OpsCheckpointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? checkpoint = freezed,Object? status = freezed,Object? source = freezed,Object? vendorName = freezed,Object? referenceNo = freezed,Object? notes = freezed,Object? dueAt = freezed,Object? mandatory = freezed,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,checkpoint: freezed == checkpoint ? _self.checkpoint : checkpoint // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as String?,mandatory: freezed == mandatory ? _self.mandatory : mandatory // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [OpsCheckpointDto].
extension OpsCheckpointDtoPatterns on OpsCheckpointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpsCheckpointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpsCheckpointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpsCheckpointDto value)  $default,){
final _that = this;
switch (_that) {
case _OpsCheckpointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpsCheckpointDto value)?  $default,){
final _that = this;
switch (_that) {
case _OpsCheckpointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  String? checkpoint,  String? status,  String? source,  String? vendorName,  String? referenceNo,  String? notes,  String? dueAt,  bool? mandatory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpsCheckpointDto() when $default != null:
return $default(_that.publicId,_that.checkpoint,_that.status,_that.source,_that.vendorName,_that.referenceNo,_that.notes,_that.dueAt,_that.mandatory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  String? checkpoint,  String? status,  String? source,  String? vendorName,  String? referenceNo,  String? notes,  String? dueAt,  bool? mandatory)  $default,) {final _that = this;
switch (_that) {
case _OpsCheckpointDto():
return $default(_that.publicId,_that.checkpoint,_that.status,_that.source,_that.vendorName,_that.referenceNo,_that.notes,_that.dueAt,_that.mandatory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  String? checkpoint,  String? status,  String? source,  String? vendorName,  String? referenceNo,  String? notes,  String? dueAt,  bool? mandatory)?  $default,) {final _that = this;
switch (_that) {
case _OpsCheckpointDto() when $default != null:
return $default(_that.publicId,_that.checkpoint,_that.status,_that.source,_that.vendorName,_that.referenceNo,_that.notes,_that.dueAt,_that.mandatory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OpsCheckpointDto implements OpsCheckpointDto {
  const _OpsCheckpointDto({this.publicId, this.checkpoint, this.status, this.source, this.vendorName, this.referenceNo, this.notes, this.dueAt, this.mandatory});
  factory _OpsCheckpointDto.fromJson(Map<String, dynamic> json) => _$OpsCheckpointDtoFromJson(json);

@override final  String? publicId;
@override final  String? checkpoint;
@override final  String? status;
@override final  String? source;
@override final  String? vendorName;
@override final  String? referenceNo;
@override final  String? notes;
@override final  String? dueAt;
@override final  bool? mandatory;

/// Create a copy of OpsCheckpointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpsCheckpointDtoCopyWith<_OpsCheckpointDto> get copyWith => __$OpsCheckpointDtoCopyWithImpl<_OpsCheckpointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OpsCheckpointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpsCheckpointDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.checkpoint, checkpoint) || other.checkpoint == checkpoint)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.mandatory, mandatory) || other.mandatory == mandatory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,checkpoint,status,source,vendorName,referenceNo,notes,dueAt,mandatory);

@override
String toString() {
  return 'OpsCheckpointDto(publicId: $publicId, checkpoint: $checkpoint, status: $status, source: $source, vendorName: $vendorName, referenceNo: $referenceNo, notes: $notes, dueAt: $dueAt, mandatory: $mandatory)';
}


}

/// @nodoc
abstract mixin class _$OpsCheckpointDtoCopyWith<$Res> implements $OpsCheckpointDtoCopyWith<$Res> {
  factory _$OpsCheckpointDtoCopyWith(_OpsCheckpointDto value, $Res Function(_OpsCheckpointDto) _then) = __$OpsCheckpointDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, String? checkpoint, String? status, String? source, String? vendorName, String? referenceNo, String? notes, String? dueAt, bool? mandatory
});




}
/// @nodoc
class __$OpsCheckpointDtoCopyWithImpl<$Res>
    implements _$OpsCheckpointDtoCopyWith<$Res> {
  __$OpsCheckpointDtoCopyWithImpl(this._self, this._then);

  final _OpsCheckpointDto _self;
  final $Res Function(_OpsCheckpointDto) _then;

/// Create a copy of OpsCheckpointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? checkpoint = freezed,Object? status = freezed,Object? source = freezed,Object? vendorName = freezed,Object? referenceNo = freezed,Object? notes = freezed,Object? dueAt = freezed,Object? mandatory = freezed,}) {
  return _then(_OpsCheckpointDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,checkpoint: freezed == checkpoint ? _self.checkpoint : checkpoint // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as String?,mandatory: freezed == mandatory ? _self.mandatory : mandatory // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
