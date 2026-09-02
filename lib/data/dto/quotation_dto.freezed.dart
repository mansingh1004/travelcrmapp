// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quotation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuotationSummaryDto {

 String? get publicId; String? get leadId; String? get title; int? get versionNumber; String? get pdfUrl; String? get templateStyle; String? get quotationStage; String? get leadStage; String? get customerName; String? get destination; String? get travelDate; num? get grandTotal; String? get createdAt;
/// Create a copy of QuotationSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationSummaryDtoCopyWith<QuotationSummaryDto> get copyWith => _$QuotationSummaryDtoCopyWithImpl<QuotationSummaryDto>(this as QuotationSummaryDto, _$identity);

  /// Serializes this QuotationSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationSummaryDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.title, title) || other.title == title)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.templateStyle, templateStyle) || other.templateStyle == templateStyle)&&(identical(other.quotationStage, quotationStage) || other.quotationStage == quotationStage)&&(identical(other.leadStage, leadStage) || other.leadStage == leadStage)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,leadId,title,versionNumber,pdfUrl,templateStyle,quotationStage,leadStage,customerName,destination,travelDate,grandTotal,createdAt);

@override
String toString() {
  return 'QuotationSummaryDto(publicId: $publicId, leadId: $leadId, title: $title, versionNumber: $versionNumber, pdfUrl: $pdfUrl, templateStyle: $templateStyle, quotationStage: $quotationStage, leadStage: $leadStage, customerName: $customerName, destination: $destination, travelDate: $travelDate, grandTotal: $grandTotal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $QuotationSummaryDtoCopyWith<$Res>  {
  factory $QuotationSummaryDtoCopyWith(QuotationSummaryDto value, $Res Function(QuotationSummaryDto) _then) = _$QuotationSummaryDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, String? leadId, String? title, int? versionNumber, String? pdfUrl, String? templateStyle, String? quotationStage, String? leadStage, String? customerName, String? destination, String? travelDate, num? grandTotal, String? createdAt
});




}
/// @nodoc
class _$QuotationSummaryDtoCopyWithImpl<$Res>
    implements $QuotationSummaryDtoCopyWith<$Res> {
  _$QuotationSummaryDtoCopyWithImpl(this._self, this._then);

  final QuotationSummaryDto _self;
  final $Res Function(QuotationSummaryDto) _then;

/// Create a copy of QuotationSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? leadId = freezed,Object? title = freezed,Object? versionNumber = freezed,Object? pdfUrl = freezed,Object? templateStyle = freezed,Object? quotationStage = freezed,Object? leadStage = freezed,Object? customerName = freezed,Object? destination = freezed,Object? travelDate = freezed,Object? grandTotal = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,leadId: freezed == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,versionNumber: freezed == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int?,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,templateStyle: freezed == templateStyle ? _self.templateStyle : templateStyle // ignore: cast_nullable_to_non_nullable
as String?,quotationStage: freezed == quotationStage ? _self.quotationStage : quotationStage // ignore: cast_nullable_to_non_nullable
as String?,leadStage: freezed == leadStage ? _self.leadStage : leadStage // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as num?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationSummaryDto].
extension QuotationSummaryDtoPatterns on QuotationSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  String? leadId,  String? title,  int? versionNumber,  String? pdfUrl,  String? templateStyle,  String? quotationStage,  String? leadStage,  String? customerName,  String? destination,  String? travelDate,  num? grandTotal,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationSummaryDto() when $default != null:
return $default(_that.publicId,_that.leadId,_that.title,_that.versionNumber,_that.pdfUrl,_that.templateStyle,_that.quotationStage,_that.leadStage,_that.customerName,_that.destination,_that.travelDate,_that.grandTotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  String? leadId,  String? title,  int? versionNumber,  String? pdfUrl,  String? templateStyle,  String? quotationStage,  String? leadStage,  String? customerName,  String? destination,  String? travelDate,  num? grandTotal,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _QuotationSummaryDto():
return $default(_that.publicId,_that.leadId,_that.title,_that.versionNumber,_that.pdfUrl,_that.templateStyle,_that.quotationStage,_that.leadStage,_that.customerName,_that.destination,_that.travelDate,_that.grandTotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  String? leadId,  String? title,  int? versionNumber,  String? pdfUrl,  String? templateStyle,  String? quotationStage,  String? leadStage,  String? customerName,  String? destination,  String? travelDate,  num? grandTotal,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _QuotationSummaryDto() when $default != null:
return $default(_that.publicId,_that.leadId,_that.title,_that.versionNumber,_that.pdfUrl,_that.templateStyle,_that.quotationStage,_that.leadStage,_that.customerName,_that.destination,_that.travelDate,_that.grandTotal,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationSummaryDto implements QuotationSummaryDto {
  const _QuotationSummaryDto({this.publicId, this.leadId, this.title, this.versionNumber, this.pdfUrl, this.templateStyle, this.quotationStage, this.leadStage, this.customerName, this.destination, this.travelDate, this.grandTotal, this.createdAt});
  factory _QuotationSummaryDto.fromJson(Map<String, dynamic> json) => _$QuotationSummaryDtoFromJson(json);

@override final  String? publicId;
@override final  String? leadId;
@override final  String? title;
@override final  int? versionNumber;
@override final  String? pdfUrl;
@override final  String? templateStyle;
@override final  String? quotationStage;
@override final  String? leadStage;
@override final  String? customerName;
@override final  String? destination;
@override final  String? travelDate;
@override final  num? grandTotal;
@override final  String? createdAt;

/// Create a copy of QuotationSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationSummaryDtoCopyWith<_QuotationSummaryDto> get copyWith => __$QuotationSummaryDtoCopyWithImpl<_QuotationSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationSummaryDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.title, title) || other.title == title)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.templateStyle, templateStyle) || other.templateStyle == templateStyle)&&(identical(other.quotationStage, quotationStage) || other.quotationStage == quotationStage)&&(identical(other.leadStage, leadStage) || other.leadStage == leadStage)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,leadId,title,versionNumber,pdfUrl,templateStyle,quotationStage,leadStage,customerName,destination,travelDate,grandTotal,createdAt);

@override
String toString() {
  return 'QuotationSummaryDto(publicId: $publicId, leadId: $leadId, title: $title, versionNumber: $versionNumber, pdfUrl: $pdfUrl, templateStyle: $templateStyle, quotationStage: $quotationStage, leadStage: $leadStage, customerName: $customerName, destination: $destination, travelDate: $travelDate, grandTotal: $grandTotal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$QuotationSummaryDtoCopyWith<$Res> implements $QuotationSummaryDtoCopyWith<$Res> {
  factory _$QuotationSummaryDtoCopyWith(_QuotationSummaryDto value, $Res Function(_QuotationSummaryDto) _then) = __$QuotationSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, String? leadId, String? title, int? versionNumber, String? pdfUrl, String? templateStyle, String? quotationStage, String? leadStage, String? customerName, String? destination, String? travelDate, num? grandTotal, String? createdAt
});




}
/// @nodoc
class __$QuotationSummaryDtoCopyWithImpl<$Res>
    implements _$QuotationSummaryDtoCopyWith<$Res> {
  __$QuotationSummaryDtoCopyWithImpl(this._self, this._then);

  final _QuotationSummaryDto _self;
  final $Res Function(_QuotationSummaryDto) _then;

/// Create a copy of QuotationSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? leadId = freezed,Object? title = freezed,Object? versionNumber = freezed,Object? pdfUrl = freezed,Object? templateStyle = freezed,Object? quotationStage = freezed,Object? leadStage = freezed,Object? customerName = freezed,Object? destination = freezed,Object? travelDate = freezed,Object? grandTotal = freezed,Object? createdAt = freezed,}) {
  return _then(_QuotationSummaryDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,leadId: freezed == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,versionNumber: freezed == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int?,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,templateStyle: freezed == templateStyle ? _self.templateStyle : templateStyle // ignore: cast_nullable_to_non_nullable
as String?,quotationStage: freezed == quotationStage ? _self.quotationStage : quotationStage // ignore: cast_nullable_to_non_nullable
as String?,leadStage: freezed == leadStage ? _self.leadStage : leadStage // ignore: cast_nullable_to_non_nullable
as String?,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as num?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuotationDto {

 String? get publicId; String? get leadId; String? get title;/// A **number** on the wire — `"quoteNo": 24` — even though it reads as a
/// reference. Typed loosely so a server that later pads it ("Q-0024")
/// still parses.
@JsonKey(readValue: _readQuoteNo) String? get quoteNo; int? get versionNumber; String? get pdfUrl; String? get quotationStage; String? get templateStyle; String? get notes; int? get nights; int? get days; int? get rooms; QuotationCustomerDto? get customer; QuotationTotalsDto? get totals; QuotationHotelBlockDto? get hotel; QuotationVehicleBlockDto? get vehicle; QuotationFlightBlockDto? get flight; QuotationSightseeingBlockDto? get sightseeing; List<String> get inclusions; List<String> get exclusions; List<String> get paymentPolicies; List<String> get cancellationPolicies; List<String> get bookingTerms; String? get createdBy; String? get createdAt;
/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationDtoCopyWith<QuotationDto> get copyWith => _$QuotationDtoCopyWithImpl<QuotationDto>(this as QuotationDto, _$identity);

  /// Serializes this QuotationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.title, title) || other.title == title)&&(identical(other.quoteNo, quoteNo) || other.quoteNo == quoteNo)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.quotationStage, quotationStage) || other.quotationStage == quotationStage)&&(identical(other.templateStyle, templateStyle) || other.templateStyle == templateStyle)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.nights, nights) || other.nights == nights)&&(identical(other.days, days) || other.days == days)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.hotel, hotel) || other.hotel == hotel)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.flight, flight) || other.flight == flight)&&(identical(other.sightseeing, sightseeing) || other.sightseeing == sightseeing)&&const DeepCollectionEquality().equals(other.inclusions, inclusions)&&const DeepCollectionEquality().equals(other.exclusions, exclusions)&&const DeepCollectionEquality().equals(other.paymentPolicies, paymentPolicies)&&const DeepCollectionEquality().equals(other.cancellationPolicies, cancellationPolicies)&&const DeepCollectionEquality().equals(other.bookingTerms, bookingTerms)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,publicId,leadId,title,quoteNo,versionNumber,pdfUrl,quotationStage,templateStyle,notes,nights,days,rooms,customer,totals,hotel,vehicle,flight,sightseeing,const DeepCollectionEquality().hash(inclusions),const DeepCollectionEquality().hash(exclusions),const DeepCollectionEquality().hash(paymentPolicies),const DeepCollectionEquality().hash(cancellationPolicies),const DeepCollectionEquality().hash(bookingTerms),createdBy,createdAt]);

@override
String toString() {
  return 'QuotationDto(publicId: $publicId, leadId: $leadId, title: $title, quoteNo: $quoteNo, versionNumber: $versionNumber, pdfUrl: $pdfUrl, quotationStage: $quotationStage, templateStyle: $templateStyle, notes: $notes, nights: $nights, days: $days, rooms: $rooms, customer: $customer, totals: $totals, hotel: $hotel, vehicle: $vehicle, flight: $flight, sightseeing: $sightseeing, inclusions: $inclusions, exclusions: $exclusions, paymentPolicies: $paymentPolicies, cancellationPolicies: $cancellationPolicies, bookingTerms: $bookingTerms, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $QuotationDtoCopyWith<$Res>  {
  factory $QuotationDtoCopyWith(QuotationDto value, $Res Function(QuotationDto) _then) = _$QuotationDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, String? leadId, String? title,@JsonKey(readValue: _readQuoteNo) String? quoteNo, int? versionNumber, String? pdfUrl, String? quotationStage, String? templateStyle, String? notes, int? nights, int? days, int? rooms, QuotationCustomerDto? customer, QuotationTotalsDto? totals, QuotationHotelBlockDto? hotel, QuotationVehicleBlockDto? vehicle, QuotationFlightBlockDto? flight, QuotationSightseeingBlockDto? sightseeing, List<String> inclusions, List<String> exclusions, List<String> paymentPolicies, List<String> cancellationPolicies, List<String> bookingTerms, String? createdBy, String? createdAt
});


$QuotationCustomerDtoCopyWith<$Res>? get customer;$QuotationTotalsDtoCopyWith<$Res>? get totals;$QuotationHotelBlockDtoCopyWith<$Res>? get hotel;$QuotationVehicleBlockDtoCopyWith<$Res>? get vehicle;$QuotationFlightBlockDtoCopyWith<$Res>? get flight;$QuotationSightseeingBlockDtoCopyWith<$Res>? get sightseeing;

}
/// @nodoc
class _$QuotationDtoCopyWithImpl<$Res>
    implements $QuotationDtoCopyWith<$Res> {
  _$QuotationDtoCopyWithImpl(this._self, this._then);

  final QuotationDto _self;
  final $Res Function(QuotationDto) _then;

/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? leadId = freezed,Object? title = freezed,Object? quoteNo = freezed,Object? versionNumber = freezed,Object? pdfUrl = freezed,Object? quotationStage = freezed,Object? templateStyle = freezed,Object? notes = freezed,Object? nights = freezed,Object? days = freezed,Object? rooms = freezed,Object? customer = freezed,Object? totals = freezed,Object? hotel = freezed,Object? vehicle = freezed,Object? flight = freezed,Object? sightseeing = freezed,Object? inclusions = null,Object? exclusions = null,Object? paymentPolicies = null,Object? cancellationPolicies = null,Object? bookingTerms = null,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,leadId: freezed == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,quoteNo: freezed == quoteNo ? _self.quoteNo : quoteNo // ignore: cast_nullable_to_non_nullable
as String?,versionNumber: freezed == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int?,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,quotationStage: freezed == quotationStage ? _self.quotationStage : quotationStage // ignore: cast_nullable_to_non_nullable
as String?,templateStyle: freezed == templateStyle ? _self.templateStyle : templateStyle // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,nights: freezed == nights ? _self.nights : nights // ignore: cast_nullable_to_non_nullable
as int?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as QuotationCustomerDto?,totals: freezed == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as QuotationTotalsDto?,hotel: freezed == hotel ? _self.hotel : hotel // ignore: cast_nullable_to_non_nullable
as QuotationHotelBlockDto?,vehicle: freezed == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as QuotationVehicleBlockDto?,flight: freezed == flight ? _self.flight : flight // ignore: cast_nullable_to_non_nullable
as QuotationFlightBlockDto?,sightseeing: freezed == sightseeing ? _self.sightseeing : sightseeing // ignore: cast_nullable_to_non_nullable
as QuotationSightseeingBlockDto?,inclusions: null == inclusions ? _self.inclusions : inclusions // ignore: cast_nullable_to_non_nullable
as List<String>,exclusions: null == exclusions ? _self.exclusions : exclusions // ignore: cast_nullable_to_non_nullable
as List<String>,paymentPolicies: null == paymentPolicies ? _self.paymentPolicies : paymentPolicies // ignore: cast_nullable_to_non_nullable
as List<String>,cancellationPolicies: null == cancellationPolicies ? _self.cancellationPolicies : cancellationPolicies // ignore: cast_nullable_to_non_nullable
as List<String>,bookingTerms: null == bookingTerms ? _self.bookingTerms : bookingTerms // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationCustomerDtoCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $QuotationCustomerDtoCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationTotalsDtoCopyWith<$Res>? get totals {
    if (_self.totals == null) {
    return null;
  }

  return $QuotationTotalsDtoCopyWith<$Res>(_self.totals!, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationHotelBlockDtoCopyWith<$Res>? get hotel {
    if (_self.hotel == null) {
    return null;
  }

  return $QuotationHotelBlockDtoCopyWith<$Res>(_self.hotel!, (value) {
    return _then(_self.copyWith(hotel: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationVehicleBlockDtoCopyWith<$Res>? get vehicle {
    if (_self.vehicle == null) {
    return null;
  }

  return $QuotationVehicleBlockDtoCopyWith<$Res>(_self.vehicle!, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationFlightBlockDtoCopyWith<$Res>? get flight {
    if (_self.flight == null) {
    return null;
  }

  return $QuotationFlightBlockDtoCopyWith<$Res>(_self.flight!, (value) {
    return _then(_self.copyWith(flight: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationSightseeingBlockDtoCopyWith<$Res>? get sightseeing {
    if (_self.sightseeing == null) {
    return null;
  }

  return $QuotationSightseeingBlockDtoCopyWith<$Res>(_self.sightseeing!, (value) {
    return _then(_self.copyWith(sightseeing: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuotationDto].
extension QuotationDtoPatterns on QuotationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  String? leadId,  String? title, @JsonKey(readValue: _readQuoteNo)  String? quoteNo,  int? versionNumber,  String? pdfUrl,  String? quotationStage,  String? templateStyle,  String? notes,  int? nights,  int? days,  int? rooms,  QuotationCustomerDto? customer,  QuotationTotalsDto? totals,  QuotationHotelBlockDto? hotel,  QuotationVehicleBlockDto? vehicle,  QuotationFlightBlockDto? flight,  QuotationSightseeingBlockDto? sightseeing,  List<String> inclusions,  List<String> exclusions,  List<String> paymentPolicies,  List<String> cancellationPolicies,  List<String> bookingTerms,  String? createdBy,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationDto() when $default != null:
return $default(_that.publicId,_that.leadId,_that.title,_that.quoteNo,_that.versionNumber,_that.pdfUrl,_that.quotationStage,_that.templateStyle,_that.notes,_that.nights,_that.days,_that.rooms,_that.customer,_that.totals,_that.hotel,_that.vehicle,_that.flight,_that.sightseeing,_that.inclusions,_that.exclusions,_that.paymentPolicies,_that.cancellationPolicies,_that.bookingTerms,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  String? leadId,  String? title, @JsonKey(readValue: _readQuoteNo)  String? quoteNo,  int? versionNumber,  String? pdfUrl,  String? quotationStage,  String? templateStyle,  String? notes,  int? nights,  int? days,  int? rooms,  QuotationCustomerDto? customer,  QuotationTotalsDto? totals,  QuotationHotelBlockDto? hotel,  QuotationVehicleBlockDto? vehicle,  QuotationFlightBlockDto? flight,  QuotationSightseeingBlockDto? sightseeing,  List<String> inclusions,  List<String> exclusions,  List<String> paymentPolicies,  List<String> cancellationPolicies,  List<String> bookingTerms,  String? createdBy,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _QuotationDto():
return $default(_that.publicId,_that.leadId,_that.title,_that.quoteNo,_that.versionNumber,_that.pdfUrl,_that.quotationStage,_that.templateStyle,_that.notes,_that.nights,_that.days,_that.rooms,_that.customer,_that.totals,_that.hotel,_that.vehicle,_that.flight,_that.sightseeing,_that.inclusions,_that.exclusions,_that.paymentPolicies,_that.cancellationPolicies,_that.bookingTerms,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  String? leadId,  String? title, @JsonKey(readValue: _readQuoteNo)  String? quoteNo,  int? versionNumber,  String? pdfUrl,  String? quotationStage,  String? templateStyle,  String? notes,  int? nights,  int? days,  int? rooms,  QuotationCustomerDto? customer,  QuotationTotalsDto? totals,  QuotationHotelBlockDto? hotel,  QuotationVehicleBlockDto? vehicle,  QuotationFlightBlockDto? flight,  QuotationSightseeingBlockDto? sightseeing,  List<String> inclusions,  List<String> exclusions,  List<String> paymentPolicies,  List<String> cancellationPolicies,  List<String> bookingTerms,  String? createdBy,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _QuotationDto() when $default != null:
return $default(_that.publicId,_that.leadId,_that.title,_that.quoteNo,_that.versionNumber,_that.pdfUrl,_that.quotationStage,_that.templateStyle,_that.notes,_that.nights,_that.days,_that.rooms,_that.customer,_that.totals,_that.hotel,_that.vehicle,_that.flight,_that.sightseeing,_that.inclusions,_that.exclusions,_that.paymentPolicies,_that.cancellationPolicies,_that.bookingTerms,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationDto implements QuotationDto {
  const _QuotationDto({this.publicId, this.leadId, this.title, @JsonKey(readValue: _readQuoteNo) this.quoteNo, this.versionNumber, this.pdfUrl, this.quotationStage, this.templateStyle, this.notes, this.nights, this.days, this.rooms, this.customer, this.totals, this.hotel, this.vehicle, this.flight, this.sightseeing, final  List<String> inclusions = const <String>[], final  List<String> exclusions = const <String>[], final  List<String> paymentPolicies = const <String>[], final  List<String> cancellationPolicies = const <String>[], final  List<String> bookingTerms = const <String>[], this.createdBy, this.createdAt}): _inclusions = inclusions,_exclusions = exclusions,_paymentPolicies = paymentPolicies,_cancellationPolicies = cancellationPolicies,_bookingTerms = bookingTerms;
  factory _QuotationDto.fromJson(Map<String, dynamic> json) => _$QuotationDtoFromJson(json);

@override final  String? publicId;
@override final  String? leadId;
@override final  String? title;
/// A **number** on the wire — `"quoteNo": 24` — even though it reads as a
/// reference. Typed loosely so a server that later pads it ("Q-0024")
/// still parses.
@override@JsonKey(readValue: _readQuoteNo) final  String? quoteNo;
@override final  int? versionNumber;
@override final  String? pdfUrl;
@override final  String? quotationStage;
@override final  String? templateStyle;
@override final  String? notes;
@override final  int? nights;
@override final  int? days;
@override final  int? rooms;
@override final  QuotationCustomerDto? customer;
@override final  QuotationTotalsDto? totals;
@override final  QuotationHotelBlockDto? hotel;
@override final  QuotationVehicleBlockDto? vehicle;
@override final  QuotationFlightBlockDto? flight;
@override final  QuotationSightseeingBlockDto? sightseeing;
 final  List<String> _inclusions;
@override@JsonKey() List<String> get inclusions {
  if (_inclusions is EqualUnmodifiableListView) return _inclusions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inclusions);
}

 final  List<String> _exclusions;
@override@JsonKey() List<String> get exclusions {
  if (_exclusions is EqualUnmodifiableListView) return _exclusions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exclusions);
}

 final  List<String> _paymentPolicies;
@override@JsonKey() List<String> get paymentPolicies {
  if (_paymentPolicies is EqualUnmodifiableListView) return _paymentPolicies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentPolicies);
}

 final  List<String> _cancellationPolicies;
@override@JsonKey() List<String> get cancellationPolicies {
  if (_cancellationPolicies is EqualUnmodifiableListView) return _cancellationPolicies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cancellationPolicies);
}

 final  List<String> _bookingTerms;
@override@JsonKey() List<String> get bookingTerms {
  if (_bookingTerms is EqualUnmodifiableListView) return _bookingTerms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookingTerms);
}

@override final  String? createdBy;
@override final  String? createdAt;

/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationDtoCopyWith<_QuotationDto> get copyWith => __$QuotationDtoCopyWithImpl<_QuotationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.title, title) || other.title == title)&&(identical(other.quoteNo, quoteNo) || other.quoteNo == quoteNo)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl)&&(identical(other.quotationStage, quotationStage) || other.quotationStage == quotationStage)&&(identical(other.templateStyle, templateStyle) || other.templateStyle == templateStyle)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.nights, nights) || other.nights == nights)&&(identical(other.days, days) || other.days == days)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.hotel, hotel) || other.hotel == hotel)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.flight, flight) || other.flight == flight)&&(identical(other.sightseeing, sightseeing) || other.sightseeing == sightseeing)&&const DeepCollectionEquality().equals(other._inclusions, _inclusions)&&const DeepCollectionEquality().equals(other._exclusions, _exclusions)&&const DeepCollectionEquality().equals(other._paymentPolicies, _paymentPolicies)&&const DeepCollectionEquality().equals(other._cancellationPolicies, _cancellationPolicies)&&const DeepCollectionEquality().equals(other._bookingTerms, _bookingTerms)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,publicId,leadId,title,quoteNo,versionNumber,pdfUrl,quotationStage,templateStyle,notes,nights,days,rooms,customer,totals,hotel,vehicle,flight,sightseeing,const DeepCollectionEquality().hash(_inclusions),const DeepCollectionEquality().hash(_exclusions),const DeepCollectionEquality().hash(_paymentPolicies),const DeepCollectionEquality().hash(_cancellationPolicies),const DeepCollectionEquality().hash(_bookingTerms),createdBy,createdAt]);

@override
String toString() {
  return 'QuotationDto(publicId: $publicId, leadId: $leadId, title: $title, quoteNo: $quoteNo, versionNumber: $versionNumber, pdfUrl: $pdfUrl, quotationStage: $quotationStage, templateStyle: $templateStyle, notes: $notes, nights: $nights, days: $days, rooms: $rooms, customer: $customer, totals: $totals, hotel: $hotel, vehicle: $vehicle, flight: $flight, sightseeing: $sightseeing, inclusions: $inclusions, exclusions: $exclusions, paymentPolicies: $paymentPolicies, cancellationPolicies: $cancellationPolicies, bookingTerms: $bookingTerms, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$QuotationDtoCopyWith<$Res> implements $QuotationDtoCopyWith<$Res> {
  factory _$QuotationDtoCopyWith(_QuotationDto value, $Res Function(_QuotationDto) _then) = __$QuotationDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, String? leadId, String? title,@JsonKey(readValue: _readQuoteNo) String? quoteNo, int? versionNumber, String? pdfUrl, String? quotationStage, String? templateStyle, String? notes, int? nights, int? days, int? rooms, QuotationCustomerDto? customer, QuotationTotalsDto? totals, QuotationHotelBlockDto? hotel, QuotationVehicleBlockDto? vehicle, QuotationFlightBlockDto? flight, QuotationSightseeingBlockDto? sightseeing, List<String> inclusions, List<String> exclusions, List<String> paymentPolicies, List<String> cancellationPolicies, List<String> bookingTerms, String? createdBy, String? createdAt
});


@override $QuotationCustomerDtoCopyWith<$Res>? get customer;@override $QuotationTotalsDtoCopyWith<$Res>? get totals;@override $QuotationHotelBlockDtoCopyWith<$Res>? get hotel;@override $QuotationVehicleBlockDtoCopyWith<$Res>? get vehicle;@override $QuotationFlightBlockDtoCopyWith<$Res>? get flight;@override $QuotationSightseeingBlockDtoCopyWith<$Res>? get sightseeing;

}
/// @nodoc
class __$QuotationDtoCopyWithImpl<$Res>
    implements _$QuotationDtoCopyWith<$Res> {
  __$QuotationDtoCopyWithImpl(this._self, this._then);

  final _QuotationDto _self;
  final $Res Function(_QuotationDto) _then;

/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? leadId = freezed,Object? title = freezed,Object? quoteNo = freezed,Object? versionNumber = freezed,Object? pdfUrl = freezed,Object? quotationStage = freezed,Object? templateStyle = freezed,Object? notes = freezed,Object? nights = freezed,Object? days = freezed,Object? rooms = freezed,Object? customer = freezed,Object? totals = freezed,Object? hotel = freezed,Object? vehicle = freezed,Object? flight = freezed,Object? sightseeing = freezed,Object? inclusions = null,Object? exclusions = null,Object? paymentPolicies = null,Object? cancellationPolicies = null,Object? bookingTerms = null,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(_QuotationDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,leadId: freezed == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,quoteNo: freezed == quoteNo ? _self.quoteNo : quoteNo // ignore: cast_nullable_to_non_nullable
as String?,versionNumber: freezed == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int?,pdfUrl: freezed == pdfUrl ? _self.pdfUrl : pdfUrl // ignore: cast_nullable_to_non_nullable
as String?,quotationStage: freezed == quotationStage ? _self.quotationStage : quotationStage // ignore: cast_nullable_to_non_nullable
as String?,templateStyle: freezed == templateStyle ? _self.templateStyle : templateStyle // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,nights: freezed == nights ? _self.nights : nights // ignore: cast_nullable_to_non_nullable
as int?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as QuotationCustomerDto?,totals: freezed == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as QuotationTotalsDto?,hotel: freezed == hotel ? _self.hotel : hotel // ignore: cast_nullable_to_non_nullable
as QuotationHotelBlockDto?,vehicle: freezed == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as QuotationVehicleBlockDto?,flight: freezed == flight ? _self.flight : flight // ignore: cast_nullable_to_non_nullable
as QuotationFlightBlockDto?,sightseeing: freezed == sightseeing ? _self.sightseeing : sightseeing // ignore: cast_nullable_to_non_nullable
as QuotationSightseeingBlockDto?,inclusions: null == inclusions ? _self._inclusions : inclusions // ignore: cast_nullable_to_non_nullable
as List<String>,exclusions: null == exclusions ? _self._exclusions : exclusions // ignore: cast_nullable_to_non_nullable
as List<String>,paymentPolicies: null == paymentPolicies ? _self._paymentPolicies : paymentPolicies // ignore: cast_nullable_to_non_nullable
as List<String>,cancellationPolicies: null == cancellationPolicies ? _self._cancellationPolicies : cancellationPolicies // ignore: cast_nullable_to_non_nullable
as List<String>,bookingTerms: null == bookingTerms ? _self._bookingTerms : bookingTerms // ignore: cast_nullable_to_non_nullable
as List<String>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationCustomerDtoCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $QuotationCustomerDtoCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationTotalsDtoCopyWith<$Res>? get totals {
    if (_self.totals == null) {
    return null;
  }

  return $QuotationTotalsDtoCopyWith<$Res>(_self.totals!, (value) {
    return _then(_self.copyWith(totals: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationHotelBlockDtoCopyWith<$Res>? get hotel {
    if (_self.hotel == null) {
    return null;
  }

  return $QuotationHotelBlockDtoCopyWith<$Res>(_self.hotel!, (value) {
    return _then(_self.copyWith(hotel: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationVehicleBlockDtoCopyWith<$Res>? get vehicle {
    if (_self.vehicle == null) {
    return null;
  }

  return $QuotationVehicleBlockDtoCopyWith<$Res>(_self.vehicle!, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationFlightBlockDtoCopyWith<$Res>? get flight {
    if (_self.flight == null) {
    return null;
  }

  return $QuotationFlightBlockDtoCopyWith<$Res>(_self.flight!, (value) {
    return _then(_self.copyWith(flight: value));
  });
}/// Create a copy of QuotationDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuotationSightseeingBlockDtoCopyWith<$Res>? get sightseeing {
    if (_self.sightseeing == null) {
    return null;
  }

  return $QuotationSightseeingBlockDtoCopyWith<$Res>(_self.sightseeing!, (value) {
    return _then(_self.copyWith(sightseeing: value));
  });
}
}


/// @nodoc
mixin _$QuotationCustomerDto {

 String? get name; String? get phone; String? get email; String? get destination; String? get travelDate; int? get adults; int? get children; int? get infants;
/// Create a copy of QuotationCustomerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationCustomerDtoCopyWith<QuotationCustomerDto> get copyWith => _$QuotationCustomerDtoCopyWithImpl<QuotationCustomerDto>(this as QuotationCustomerDto, _$identity);

  /// Serializes this QuotationCustomerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationCustomerDto&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.infants, infants) || other.infants == infants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,email,destination,travelDate,adults,children,infants);

@override
String toString() {
  return 'QuotationCustomerDto(name: $name, phone: $phone, email: $email, destination: $destination, travelDate: $travelDate, adults: $adults, children: $children, infants: $infants)';
}


}

/// @nodoc
abstract mixin class $QuotationCustomerDtoCopyWith<$Res>  {
  factory $QuotationCustomerDtoCopyWith(QuotationCustomerDto value, $Res Function(QuotationCustomerDto) _then) = _$QuotationCustomerDtoCopyWithImpl;
@useResult
$Res call({
 String? name, String? phone, String? email, String? destination, String? travelDate, int? adults, int? children, int? infants
});




}
/// @nodoc
class _$QuotationCustomerDtoCopyWithImpl<$Res>
    implements $QuotationCustomerDtoCopyWith<$Res> {
  _$QuotationCustomerDtoCopyWithImpl(this._self, this._then);

  final QuotationCustomerDto _self;
  final $Res Function(QuotationCustomerDto) _then;

/// Create a copy of QuotationCustomerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? phone = freezed,Object? email = freezed,Object? destination = freezed,Object? travelDate = freezed,Object? adults = freezed,Object? children = freezed,Object? infants = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,adults: freezed == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int?,children: freezed == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int?,infants: freezed == infants ? _self.infants : infants // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationCustomerDto].
extension QuotationCustomerDtoPatterns on QuotationCustomerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationCustomerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationCustomerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationCustomerDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationCustomerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationCustomerDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationCustomerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? phone,  String? email,  String? destination,  String? travelDate,  int? adults,  int? children,  int? infants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationCustomerDto() when $default != null:
return $default(_that.name,_that.phone,_that.email,_that.destination,_that.travelDate,_that.adults,_that.children,_that.infants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? phone,  String? email,  String? destination,  String? travelDate,  int? adults,  int? children,  int? infants)  $default,) {final _that = this;
switch (_that) {
case _QuotationCustomerDto():
return $default(_that.name,_that.phone,_that.email,_that.destination,_that.travelDate,_that.adults,_that.children,_that.infants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? phone,  String? email,  String? destination,  String? travelDate,  int? adults,  int? children,  int? infants)?  $default,) {final _that = this;
switch (_that) {
case _QuotationCustomerDto() when $default != null:
return $default(_that.name,_that.phone,_that.email,_that.destination,_that.travelDate,_that.adults,_that.children,_that.infants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationCustomerDto implements QuotationCustomerDto {
  const _QuotationCustomerDto({this.name, this.phone, this.email, this.destination, this.travelDate, this.adults, this.children, this.infants});
  factory _QuotationCustomerDto.fromJson(Map<String, dynamic> json) => _$QuotationCustomerDtoFromJson(json);

@override final  String? name;
@override final  String? phone;
@override final  String? email;
@override final  String? destination;
@override final  String? travelDate;
@override final  int? adults;
@override final  int? children;
@override final  int? infants;

/// Create a copy of QuotationCustomerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationCustomerDtoCopyWith<_QuotationCustomerDto> get copyWith => __$QuotationCustomerDtoCopyWithImpl<_QuotationCustomerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationCustomerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationCustomerDto&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.adults, adults) || other.adults == adults)&&(identical(other.children, children) || other.children == children)&&(identical(other.infants, infants) || other.infants == infants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,phone,email,destination,travelDate,adults,children,infants);

@override
String toString() {
  return 'QuotationCustomerDto(name: $name, phone: $phone, email: $email, destination: $destination, travelDate: $travelDate, adults: $adults, children: $children, infants: $infants)';
}


}

/// @nodoc
abstract mixin class _$QuotationCustomerDtoCopyWith<$Res> implements $QuotationCustomerDtoCopyWith<$Res> {
  factory _$QuotationCustomerDtoCopyWith(_QuotationCustomerDto value, $Res Function(_QuotationCustomerDto) _then) = __$QuotationCustomerDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? phone, String? email, String? destination, String? travelDate, int? adults, int? children, int? infants
});




}
/// @nodoc
class __$QuotationCustomerDtoCopyWithImpl<$Res>
    implements _$QuotationCustomerDtoCopyWith<$Res> {
  __$QuotationCustomerDtoCopyWithImpl(this._self, this._then);

  final _QuotationCustomerDto _self;
  final $Res Function(_QuotationCustomerDto) _then;

/// Create a copy of QuotationCustomerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? phone = freezed,Object? email = freezed,Object? destination = freezed,Object? travelDate = freezed,Object? adults = freezed,Object? children = freezed,Object? infants = freezed,}) {
  return _then(_QuotationCustomerDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,adults: freezed == adults ? _self.adults : adults // ignore: cast_nullable_to_non_nullable
as int?,children: freezed == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as int?,infants: freezed == infants ? _self.infants : infants // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QuotationTotalsDto {

 num? get subtotal; String? get discountType; num? get discount; num? get discountAmount; num? get markup; num? get taxPercent; num? get taxAmount; num? get grandTotal; num? get addonsTotal; num? get perAdult;
/// Create a copy of QuotationTotalsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationTotalsDtoCopyWith<QuotationTotalsDto> get copyWith => _$QuotationTotalsDtoCopyWithImpl<QuotationTotalsDto>(this as QuotationTotalsDto, _$identity);

  /// Serializes this QuotationTotalsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationTotalsDto&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.markup, markup) || other.markup == markup)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.addonsTotal, addonsTotal) || other.addonsTotal == addonsTotal)&&(identical(other.perAdult, perAdult) || other.perAdult == perAdult));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subtotal,discountType,discount,discountAmount,markup,taxPercent,taxAmount,grandTotal,addonsTotal,perAdult);

@override
String toString() {
  return 'QuotationTotalsDto(subtotal: $subtotal, discountType: $discountType, discount: $discount, discountAmount: $discountAmount, markup: $markup, taxPercent: $taxPercent, taxAmount: $taxAmount, grandTotal: $grandTotal, addonsTotal: $addonsTotal, perAdult: $perAdult)';
}


}

/// @nodoc
abstract mixin class $QuotationTotalsDtoCopyWith<$Res>  {
  factory $QuotationTotalsDtoCopyWith(QuotationTotalsDto value, $Res Function(QuotationTotalsDto) _then) = _$QuotationTotalsDtoCopyWithImpl;
@useResult
$Res call({
 num? subtotal, String? discountType, num? discount, num? discountAmount, num? markup, num? taxPercent, num? taxAmount, num? grandTotal, num? addonsTotal, num? perAdult
});




}
/// @nodoc
class _$QuotationTotalsDtoCopyWithImpl<$Res>
    implements $QuotationTotalsDtoCopyWith<$Res> {
  _$QuotationTotalsDtoCopyWithImpl(this._self, this._then);

  final QuotationTotalsDto _self;
  final $Res Function(QuotationTotalsDto) _then;

/// Create a copy of QuotationTotalsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subtotal = freezed,Object? discountType = freezed,Object? discount = freezed,Object? discountAmount = freezed,Object? markup = freezed,Object? taxPercent = freezed,Object? taxAmount = freezed,Object? grandTotal = freezed,Object? addonsTotal = freezed,Object? perAdult = freezed,}) {
  return _then(_self.copyWith(
subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as num?,markup: freezed == markup ? _self.markup : markup // ignore: cast_nullable_to_non_nullable
as num?,taxPercent: freezed == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as num?,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as num?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as num?,addonsTotal: freezed == addonsTotal ? _self.addonsTotal : addonsTotal // ignore: cast_nullable_to_non_nullable
as num?,perAdult: freezed == perAdult ? _self.perAdult : perAdult // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationTotalsDto].
extension QuotationTotalsDtoPatterns on QuotationTotalsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationTotalsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationTotalsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationTotalsDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationTotalsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationTotalsDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationTotalsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? subtotal,  String? discountType,  num? discount,  num? discountAmount,  num? markup,  num? taxPercent,  num? taxAmount,  num? grandTotal,  num? addonsTotal,  num? perAdult)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationTotalsDto() when $default != null:
return $default(_that.subtotal,_that.discountType,_that.discount,_that.discountAmount,_that.markup,_that.taxPercent,_that.taxAmount,_that.grandTotal,_that.addonsTotal,_that.perAdult);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? subtotal,  String? discountType,  num? discount,  num? discountAmount,  num? markup,  num? taxPercent,  num? taxAmount,  num? grandTotal,  num? addonsTotal,  num? perAdult)  $default,) {final _that = this;
switch (_that) {
case _QuotationTotalsDto():
return $default(_that.subtotal,_that.discountType,_that.discount,_that.discountAmount,_that.markup,_that.taxPercent,_that.taxAmount,_that.grandTotal,_that.addonsTotal,_that.perAdult);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? subtotal,  String? discountType,  num? discount,  num? discountAmount,  num? markup,  num? taxPercent,  num? taxAmount,  num? grandTotal,  num? addonsTotal,  num? perAdult)?  $default,) {final _that = this;
switch (_that) {
case _QuotationTotalsDto() when $default != null:
return $default(_that.subtotal,_that.discountType,_that.discount,_that.discountAmount,_that.markup,_that.taxPercent,_that.taxAmount,_that.grandTotal,_that.addonsTotal,_that.perAdult);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationTotalsDto implements QuotationTotalsDto {
  const _QuotationTotalsDto({this.subtotal, this.discountType, this.discount, this.discountAmount, this.markup, this.taxPercent, this.taxAmount, this.grandTotal, this.addonsTotal, this.perAdult});
  factory _QuotationTotalsDto.fromJson(Map<String, dynamic> json) => _$QuotationTotalsDtoFromJson(json);

@override final  num? subtotal;
@override final  String? discountType;
@override final  num? discount;
@override final  num? discountAmount;
@override final  num? markup;
@override final  num? taxPercent;
@override final  num? taxAmount;
@override final  num? grandTotal;
@override final  num? addonsTotal;
@override final  num? perAdult;

/// Create a copy of QuotationTotalsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationTotalsDtoCopyWith<_QuotationTotalsDto> get copyWith => __$QuotationTotalsDtoCopyWithImpl<_QuotationTotalsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationTotalsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationTotalsDto&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.markup, markup) || other.markup == markup)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.grandTotal, grandTotal) || other.grandTotal == grandTotal)&&(identical(other.addonsTotal, addonsTotal) || other.addonsTotal == addonsTotal)&&(identical(other.perAdult, perAdult) || other.perAdult == perAdult));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subtotal,discountType,discount,discountAmount,markup,taxPercent,taxAmount,grandTotal,addonsTotal,perAdult);

@override
String toString() {
  return 'QuotationTotalsDto(subtotal: $subtotal, discountType: $discountType, discount: $discount, discountAmount: $discountAmount, markup: $markup, taxPercent: $taxPercent, taxAmount: $taxAmount, grandTotal: $grandTotal, addonsTotal: $addonsTotal, perAdult: $perAdult)';
}


}

/// @nodoc
abstract mixin class _$QuotationTotalsDtoCopyWith<$Res> implements $QuotationTotalsDtoCopyWith<$Res> {
  factory _$QuotationTotalsDtoCopyWith(_QuotationTotalsDto value, $Res Function(_QuotationTotalsDto) _then) = __$QuotationTotalsDtoCopyWithImpl;
@override @useResult
$Res call({
 num? subtotal, String? discountType, num? discount, num? discountAmount, num? markup, num? taxPercent, num? taxAmount, num? grandTotal, num? addonsTotal, num? perAdult
});




}
/// @nodoc
class __$QuotationTotalsDtoCopyWithImpl<$Res>
    implements _$QuotationTotalsDtoCopyWith<$Res> {
  __$QuotationTotalsDtoCopyWithImpl(this._self, this._then);

  final _QuotationTotalsDto _self;
  final $Res Function(_QuotationTotalsDto) _then;

/// Create a copy of QuotationTotalsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subtotal = freezed,Object? discountType = freezed,Object? discount = freezed,Object? discountAmount = freezed,Object? markup = freezed,Object? taxPercent = freezed,Object? taxAmount = freezed,Object? grandTotal = freezed,Object? addonsTotal = freezed,Object? perAdult = freezed,}) {
  return _then(_QuotationTotalsDto(
subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as num?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String?,discount: freezed == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as num?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as num?,markup: freezed == markup ? _self.markup : markup // ignore: cast_nullable_to_non_nullable
as num?,taxPercent: freezed == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as num?,taxAmount: freezed == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as num?,grandTotal: freezed == grandTotal ? _self.grandTotal : grandTotal // ignore: cast_nullable_to_non_nullable
as num?,addonsTotal: freezed == addonsTotal ? _self.addonsTotal : addonsTotal // ignore: cast_nullable_to_non_nullable
as num?,perAdult: freezed == perAdult ? _self.perAdult : perAdult // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$QuotationHotelBlockDto {

 bool? get included; String? get title; num? get amount; String? get notes; List<QuotationHotelDto> get hotels;
/// Create a copy of QuotationHotelBlockDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationHotelBlockDtoCopyWith<QuotationHotelBlockDto> get copyWith => _$QuotationHotelBlockDtoCopyWithImpl<QuotationHotelBlockDto>(this as QuotationHotelBlockDto, _$identity);

  /// Serializes this QuotationHotelBlockDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationHotelBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other.hotels, hotels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,notes,const DeepCollectionEquality().hash(hotels));

@override
String toString() {
  return 'QuotationHotelBlockDto(included: $included, title: $title, amount: $amount, notes: $notes, hotels: $hotels)';
}


}

/// @nodoc
abstract mixin class $QuotationHotelBlockDtoCopyWith<$Res>  {
  factory $QuotationHotelBlockDtoCopyWith(QuotationHotelBlockDto value, $Res Function(QuotationHotelBlockDto) _then) = _$QuotationHotelBlockDtoCopyWithImpl;
@useResult
$Res call({
 bool? included, String? title, num? amount, String? notes, List<QuotationHotelDto> hotels
});




}
/// @nodoc
class _$QuotationHotelBlockDtoCopyWithImpl<$Res>
    implements $QuotationHotelBlockDtoCopyWith<$Res> {
  _$QuotationHotelBlockDtoCopyWithImpl(this._self, this._then);

  final QuotationHotelBlockDto _self;
  final $Res Function(QuotationHotelBlockDto) _then;

/// Create a copy of QuotationHotelBlockDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? notes = freezed,Object? hotels = null,}) {
  return _then(_self.copyWith(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,hotels: null == hotels ? _self.hotels : hotels // ignore: cast_nullable_to_non_nullable
as List<QuotationHotelDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationHotelBlockDto].
extension QuotationHotelBlockDtoPatterns on QuotationHotelBlockDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationHotelBlockDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationHotelBlockDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationHotelBlockDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationHotelBlockDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationHotelBlockDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationHotelBlockDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  String? notes,  List<QuotationHotelDto> hotels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationHotelBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.notes,_that.hotels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  String? notes,  List<QuotationHotelDto> hotels)  $default,) {final _that = this;
switch (_that) {
case _QuotationHotelBlockDto():
return $default(_that.included,_that.title,_that.amount,_that.notes,_that.hotels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? included,  String? title,  num? amount,  String? notes,  List<QuotationHotelDto> hotels)?  $default,) {final _that = this;
switch (_that) {
case _QuotationHotelBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.notes,_that.hotels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationHotelBlockDto implements QuotationHotelBlockDto {
  const _QuotationHotelBlockDto({this.included, this.title, this.amount, this.notes, final  List<QuotationHotelDto> hotels = const <QuotationHotelDto>[]}): _hotels = hotels;
  factory _QuotationHotelBlockDto.fromJson(Map<String, dynamic> json) => _$QuotationHotelBlockDtoFromJson(json);

@override final  bool? included;
@override final  String? title;
@override final  num? amount;
@override final  String? notes;
 final  List<QuotationHotelDto> _hotels;
@override@JsonKey() List<QuotationHotelDto> get hotels {
  if (_hotels is EqualUnmodifiableListView) return _hotels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hotels);
}


/// Create a copy of QuotationHotelBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationHotelBlockDtoCopyWith<_QuotationHotelBlockDto> get copyWith => __$QuotationHotelBlockDtoCopyWithImpl<_QuotationHotelBlockDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationHotelBlockDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationHotelBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.notes, notes) || other.notes == notes)&&const DeepCollectionEquality().equals(other._hotels, _hotels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,notes,const DeepCollectionEquality().hash(_hotels));

@override
String toString() {
  return 'QuotationHotelBlockDto(included: $included, title: $title, amount: $amount, notes: $notes, hotels: $hotels)';
}


}

/// @nodoc
abstract mixin class _$QuotationHotelBlockDtoCopyWith<$Res> implements $QuotationHotelBlockDtoCopyWith<$Res> {
  factory _$QuotationHotelBlockDtoCopyWith(_QuotationHotelBlockDto value, $Res Function(_QuotationHotelBlockDto) _then) = __$QuotationHotelBlockDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? included, String? title, num? amount, String? notes, List<QuotationHotelDto> hotels
});




}
/// @nodoc
class __$QuotationHotelBlockDtoCopyWithImpl<$Res>
    implements _$QuotationHotelBlockDtoCopyWith<$Res> {
  __$QuotationHotelBlockDtoCopyWithImpl(this._self, this._then);

  final _QuotationHotelBlockDto _self;
  final $Res Function(_QuotationHotelBlockDto) _then;

/// Create a copy of QuotationHotelBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? notes = freezed,Object? hotels = null,}) {
  return _then(_QuotationHotelBlockDto(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,hotels: null == hotels ? _self._hotels : hotels // ignore: cast_nullable_to_non_nullable
as List<QuotationHotelDto>,
  ));
}


}


/// @nodoc
mixin _$QuotationHotelDto {

 String? get name; String? get city; String? get checkIn; String? get checkOut; String? get roomType; String? get mealPlan; int? get stars; int? get rooms; num? get pricePerRoom;
/// Create a copy of QuotationHotelDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationHotelDtoCopyWith<QuotationHotelDto> get copyWith => _$QuotationHotelDtoCopyWithImpl<QuotationHotelDto>(this as QuotationHotelDto, _$identity);

  /// Serializes this QuotationHotelDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationHotelDto&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.mealPlan, mealPlan) || other.mealPlan == mealPlan)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.pricePerRoom, pricePerRoom) || other.pricePerRoom == pricePerRoom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,city,checkIn,checkOut,roomType,mealPlan,stars,rooms,pricePerRoom);

@override
String toString() {
  return 'QuotationHotelDto(name: $name, city: $city, checkIn: $checkIn, checkOut: $checkOut, roomType: $roomType, mealPlan: $mealPlan, stars: $stars, rooms: $rooms, pricePerRoom: $pricePerRoom)';
}


}

/// @nodoc
abstract mixin class $QuotationHotelDtoCopyWith<$Res>  {
  factory $QuotationHotelDtoCopyWith(QuotationHotelDto value, $Res Function(QuotationHotelDto) _then) = _$QuotationHotelDtoCopyWithImpl;
@useResult
$Res call({
 String? name, String? city, String? checkIn, String? checkOut, String? roomType, String? mealPlan, int? stars, int? rooms, num? pricePerRoom
});




}
/// @nodoc
class _$QuotationHotelDtoCopyWithImpl<$Res>
    implements $QuotationHotelDtoCopyWith<$Res> {
  _$QuotationHotelDtoCopyWithImpl(this._self, this._then);

  final QuotationHotelDto _self;
  final $Res Function(QuotationHotelDto) _then;

/// Create a copy of QuotationHotelDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? city = freezed,Object? checkIn = freezed,Object? checkOut = freezed,Object? roomType = freezed,Object? mealPlan = freezed,Object? stars = freezed,Object? rooms = freezed,Object? pricePerRoom = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String?,roomType: freezed == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String?,mealPlan: freezed == mealPlan ? _self.mealPlan : mealPlan // ignore: cast_nullable_to_non_nullable
as String?,stars: freezed == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,pricePerRoom: freezed == pricePerRoom ? _self.pricePerRoom : pricePerRoom // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationHotelDto].
extension QuotationHotelDtoPatterns on QuotationHotelDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationHotelDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationHotelDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationHotelDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationHotelDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationHotelDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationHotelDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  String? city,  String? checkIn,  String? checkOut,  String? roomType,  String? mealPlan,  int? stars,  int? rooms,  num? pricePerRoom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationHotelDto() when $default != null:
return $default(_that.name,_that.city,_that.checkIn,_that.checkOut,_that.roomType,_that.mealPlan,_that.stars,_that.rooms,_that.pricePerRoom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  String? city,  String? checkIn,  String? checkOut,  String? roomType,  String? mealPlan,  int? stars,  int? rooms,  num? pricePerRoom)  $default,) {final _that = this;
switch (_that) {
case _QuotationHotelDto():
return $default(_that.name,_that.city,_that.checkIn,_that.checkOut,_that.roomType,_that.mealPlan,_that.stars,_that.rooms,_that.pricePerRoom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  String? city,  String? checkIn,  String? checkOut,  String? roomType,  String? mealPlan,  int? stars,  int? rooms,  num? pricePerRoom)?  $default,) {final _that = this;
switch (_that) {
case _QuotationHotelDto() when $default != null:
return $default(_that.name,_that.city,_that.checkIn,_that.checkOut,_that.roomType,_that.mealPlan,_that.stars,_that.rooms,_that.pricePerRoom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationHotelDto implements QuotationHotelDto {
  const _QuotationHotelDto({this.name, this.city, this.checkIn, this.checkOut, this.roomType, this.mealPlan, this.stars, this.rooms, this.pricePerRoom});
  factory _QuotationHotelDto.fromJson(Map<String, dynamic> json) => _$QuotationHotelDtoFromJson(json);

@override final  String? name;
@override final  String? city;
@override final  String? checkIn;
@override final  String? checkOut;
@override final  String? roomType;
@override final  String? mealPlan;
@override final  int? stars;
@override final  int? rooms;
@override final  num? pricePerRoom;

/// Create a copy of QuotationHotelDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationHotelDtoCopyWith<_QuotationHotelDto> get copyWith => __$QuotationHotelDtoCopyWithImpl<_QuotationHotelDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationHotelDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationHotelDto&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.checkOut, checkOut) || other.checkOut == checkOut)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.mealPlan, mealPlan) || other.mealPlan == mealPlan)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&(identical(other.pricePerRoom, pricePerRoom) || other.pricePerRoom == pricePerRoom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,city,checkIn,checkOut,roomType,mealPlan,stars,rooms,pricePerRoom);

@override
String toString() {
  return 'QuotationHotelDto(name: $name, city: $city, checkIn: $checkIn, checkOut: $checkOut, roomType: $roomType, mealPlan: $mealPlan, stars: $stars, rooms: $rooms, pricePerRoom: $pricePerRoom)';
}


}

/// @nodoc
abstract mixin class _$QuotationHotelDtoCopyWith<$Res> implements $QuotationHotelDtoCopyWith<$Res> {
  factory _$QuotationHotelDtoCopyWith(_QuotationHotelDto value, $Res Function(_QuotationHotelDto) _then) = __$QuotationHotelDtoCopyWithImpl;
@override @useResult
$Res call({
 String? name, String? city, String? checkIn, String? checkOut, String? roomType, String? mealPlan, int? stars, int? rooms, num? pricePerRoom
});




}
/// @nodoc
class __$QuotationHotelDtoCopyWithImpl<$Res>
    implements _$QuotationHotelDtoCopyWith<$Res> {
  __$QuotationHotelDtoCopyWithImpl(this._self, this._then);

  final _QuotationHotelDto _self;
  final $Res Function(_QuotationHotelDto) _then;

/// Create a copy of QuotationHotelDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? city = freezed,Object? checkIn = freezed,Object? checkOut = freezed,Object? roomType = freezed,Object? mealPlan = freezed,Object? stars = freezed,Object? rooms = freezed,Object? pricePerRoom = freezed,}) {
  return _then(_QuotationHotelDto(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as String?,checkOut: freezed == checkOut ? _self.checkOut : checkOut // ignore: cast_nullable_to_non_nullable
as String?,roomType: freezed == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String?,mealPlan: freezed == mealPlan ? _self.mealPlan : mealPlan // ignore: cast_nullable_to_non_nullable
as String?,stars: freezed == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int?,rooms: freezed == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int?,pricePerRoom: freezed == pricePerRoom ? _self.pricePerRoom : pricePerRoom // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$QuotationVehicleBlockDto {

 bool? get included; String? get title; num? get amount; List<QuotationVehicleDto> get vehicles;
/// Create a copy of QuotationVehicleBlockDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationVehicleBlockDtoCopyWith<QuotationVehicleBlockDto> get copyWith => _$QuotationVehicleBlockDtoCopyWithImpl<QuotationVehicleBlockDto>(this as QuotationVehicleBlockDto, _$identity);

  /// Serializes this QuotationVehicleBlockDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationVehicleBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other.vehicles, vehicles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,const DeepCollectionEquality().hash(vehicles));

@override
String toString() {
  return 'QuotationVehicleBlockDto(included: $included, title: $title, amount: $amount, vehicles: $vehicles)';
}


}

/// @nodoc
abstract mixin class $QuotationVehicleBlockDtoCopyWith<$Res>  {
  factory $QuotationVehicleBlockDtoCopyWith(QuotationVehicleBlockDto value, $Res Function(QuotationVehicleBlockDto) _then) = _$QuotationVehicleBlockDtoCopyWithImpl;
@useResult
$Res call({
 bool? included, String? title, num? amount, List<QuotationVehicleDto> vehicles
});




}
/// @nodoc
class _$QuotationVehicleBlockDtoCopyWithImpl<$Res>
    implements $QuotationVehicleBlockDtoCopyWith<$Res> {
  _$QuotationVehicleBlockDtoCopyWithImpl(this._self, this._then);

  final QuotationVehicleBlockDto _self;
  final $Res Function(QuotationVehicleBlockDto) _then;

/// Create a copy of QuotationVehicleBlockDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? vehicles = null,}) {
  return _then(_self.copyWith(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,vehicles: null == vehicles ? _self.vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<QuotationVehicleDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationVehicleBlockDto].
extension QuotationVehicleBlockDtoPatterns on QuotationVehicleBlockDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationVehicleBlockDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationVehicleBlockDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationVehicleBlockDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationVehicleBlockDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationVehicleBlockDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationVehicleBlockDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  List<QuotationVehicleDto> vehicles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationVehicleBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.vehicles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  List<QuotationVehicleDto> vehicles)  $default,) {final _that = this;
switch (_that) {
case _QuotationVehicleBlockDto():
return $default(_that.included,_that.title,_that.amount,_that.vehicles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? included,  String? title,  num? amount,  List<QuotationVehicleDto> vehicles)?  $default,) {final _that = this;
switch (_that) {
case _QuotationVehicleBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.vehicles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationVehicleBlockDto implements QuotationVehicleBlockDto {
  const _QuotationVehicleBlockDto({this.included, this.title, this.amount, final  List<QuotationVehicleDto> vehicles = const <QuotationVehicleDto>[]}): _vehicles = vehicles;
  factory _QuotationVehicleBlockDto.fromJson(Map<String, dynamic> json) => _$QuotationVehicleBlockDtoFromJson(json);

@override final  bool? included;
@override final  String? title;
@override final  num? amount;
 final  List<QuotationVehicleDto> _vehicles;
@override@JsonKey() List<QuotationVehicleDto> get vehicles {
  if (_vehicles is EqualUnmodifiableListView) return _vehicles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vehicles);
}


/// Create a copy of QuotationVehicleBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationVehicleBlockDtoCopyWith<_QuotationVehicleBlockDto> get copyWith => __$QuotationVehicleBlockDtoCopyWithImpl<_QuotationVehicleBlockDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationVehicleBlockDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationVehicleBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other._vehicles, _vehicles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,const DeepCollectionEquality().hash(_vehicles));

@override
String toString() {
  return 'QuotationVehicleBlockDto(included: $included, title: $title, amount: $amount, vehicles: $vehicles)';
}


}

/// @nodoc
abstract mixin class _$QuotationVehicleBlockDtoCopyWith<$Res> implements $QuotationVehicleBlockDtoCopyWith<$Res> {
  factory _$QuotationVehicleBlockDtoCopyWith(_QuotationVehicleBlockDto value, $Res Function(_QuotationVehicleBlockDto) _then) = __$QuotationVehicleBlockDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? included, String? title, num? amount, List<QuotationVehicleDto> vehicles
});




}
/// @nodoc
class __$QuotationVehicleBlockDtoCopyWithImpl<$Res>
    implements _$QuotationVehicleBlockDtoCopyWith<$Res> {
  __$QuotationVehicleBlockDtoCopyWithImpl(this._self, this._then);

  final _QuotationVehicleBlockDto _self;
  final $Res Function(_QuotationVehicleBlockDto) _then;

/// Create a copy of QuotationVehicleBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? vehicles = null,}) {
  return _then(_QuotationVehicleBlockDto(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,vehicles: null == vehicles ? _self._vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<QuotationVehicleDto>,
  ));
}


}


/// @nodoc
mixin _$QuotationVehicleDto {

 String? get type; String? get model; String? get pickup; String? get drop; String? get startDate; String? get endDate; int? get qty; num? get pricePerVehicle;
/// Create a copy of QuotationVehicleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationVehicleDtoCopyWith<QuotationVehicleDto> get copyWith => _$QuotationVehicleDtoCopyWithImpl<QuotationVehicleDto>(this as QuotationVehicleDto, _$identity);

  /// Serializes this QuotationVehicleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationVehicleDto&&(identical(other.type, type) || other.type == type)&&(identical(other.model, model) || other.model == model)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.drop, drop) || other.drop == drop)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.pricePerVehicle, pricePerVehicle) || other.pricePerVehicle == pricePerVehicle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,model,pickup,drop,startDate,endDate,qty,pricePerVehicle);

@override
String toString() {
  return 'QuotationVehicleDto(type: $type, model: $model, pickup: $pickup, drop: $drop, startDate: $startDate, endDate: $endDate, qty: $qty, pricePerVehicle: $pricePerVehicle)';
}


}

/// @nodoc
abstract mixin class $QuotationVehicleDtoCopyWith<$Res>  {
  factory $QuotationVehicleDtoCopyWith(QuotationVehicleDto value, $Res Function(QuotationVehicleDto) _then) = _$QuotationVehicleDtoCopyWithImpl;
@useResult
$Res call({
 String? type, String? model, String? pickup, String? drop, String? startDate, String? endDate, int? qty, num? pricePerVehicle
});




}
/// @nodoc
class _$QuotationVehicleDtoCopyWithImpl<$Res>
    implements $QuotationVehicleDtoCopyWith<$Res> {
  _$QuotationVehicleDtoCopyWithImpl(this._self, this._then);

  final QuotationVehicleDto _self;
  final $Res Function(QuotationVehicleDto) _then;

/// Create a copy of QuotationVehicleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? model = freezed,Object? pickup = freezed,Object? drop = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? qty = freezed,Object? pricePerVehicle = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as String?,drop: freezed == drop ? _self.drop : drop // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,qty: freezed == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int?,pricePerVehicle: freezed == pricePerVehicle ? _self.pricePerVehicle : pricePerVehicle // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationVehicleDto].
extension QuotationVehicleDtoPatterns on QuotationVehicleDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationVehicleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationVehicleDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationVehicleDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationVehicleDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationVehicleDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationVehicleDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? type,  String? model,  String? pickup,  String? drop,  String? startDate,  String? endDate,  int? qty,  num? pricePerVehicle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationVehicleDto() when $default != null:
return $default(_that.type,_that.model,_that.pickup,_that.drop,_that.startDate,_that.endDate,_that.qty,_that.pricePerVehicle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? type,  String? model,  String? pickup,  String? drop,  String? startDate,  String? endDate,  int? qty,  num? pricePerVehicle)  $default,) {final _that = this;
switch (_that) {
case _QuotationVehicleDto():
return $default(_that.type,_that.model,_that.pickup,_that.drop,_that.startDate,_that.endDate,_that.qty,_that.pricePerVehicle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? type,  String? model,  String? pickup,  String? drop,  String? startDate,  String? endDate,  int? qty,  num? pricePerVehicle)?  $default,) {final _that = this;
switch (_that) {
case _QuotationVehicleDto() when $default != null:
return $default(_that.type,_that.model,_that.pickup,_that.drop,_that.startDate,_that.endDate,_that.qty,_that.pricePerVehicle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationVehicleDto implements QuotationVehicleDto {
  const _QuotationVehicleDto({this.type, this.model, this.pickup, this.drop, this.startDate, this.endDate, this.qty, this.pricePerVehicle});
  factory _QuotationVehicleDto.fromJson(Map<String, dynamic> json) => _$QuotationVehicleDtoFromJson(json);

@override final  String? type;
@override final  String? model;
@override final  String? pickup;
@override final  String? drop;
@override final  String? startDate;
@override final  String? endDate;
@override final  int? qty;
@override final  num? pricePerVehicle;

/// Create a copy of QuotationVehicleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationVehicleDtoCopyWith<_QuotationVehicleDto> get copyWith => __$QuotationVehicleDtoCopyWithImpl<_QuotationVehicleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationVehicleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationVehicleDto&&(identical(other.type, type) || other.type == type)&&(identical(other.model, model) || other.model == model)&&(identical(other.pickup, pickup) || other.pickup == pickup)&&(identical(other.drop, drop) || other.drop == drop)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.pricePerVehicle, pricePerVehicle) || other.pricePerVehicle == pricePerVehicle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,model,pickup,drop,startDate,endDate,qty,pricePerVehicle);

@override
String toString() {
  return 'QuotationVehicleDto(type: $type, model: $model, pickup: $pickup, drop: $drop, startDate: $startDate, endDate: $endDate, qty: $qty, pricePerVehicle: $pricePerVehicle)';
}


}

/// @nodoc
abstract mixin class _$QuotationVehicleDtoCopyWith<$Res> implements $QuotationVehicleDtoCopyWith<$Res> {
  factory _$QuotationVehicleDtoCopyWith(_QuotationVehicleDto value, $Res Function(_QuotationVehicleDto) _then) = __$QuotationVehicleDtoCopyWithImpl;
@override @useResult
$Res call({
 String? type, String? model, String? pickup, String? drop, String? startDate, String? endDate, int? qty, num? pricePerVehicle
});




}
/// @nodoc
class __$QuotationVehicleDtoCopyWithImpl<$Res>
    implements _$QuotationVehicleDtoCopyWith<$Res> {
  __$QuotationVehicleDtoCopyWithImpl(this._self, this._then);

  final _QuotationVehicleDto _self;
  final $Res Function(_QuotationVehicleDto) _then;

/// Create a copy of QuotationVehicleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? model = freezed,Object? pickup = freezed,Object? drop = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? qty = freezed,Object? pricePerVehicle = freezed,}) {
  return _then(_QuotationVehicleDto(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,pickup: freezed == pickup ? _self.pickup : pickup // ignore: cast_nullable_to_non_nullable
as String?,drop: freezed == drop ? _self.drop : drop // ignore: cast_nullable_to_non_nullable
as String?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String?,qty: freezed == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int?,pricePerVehicle: freezed == pricePerVehicle ? _self.pricePerVehicle : pricePerVehicle // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$QuotationFlightBlockDto {

 bool? get included; String? get title; num? get amount; String? get journey; List<QuotationFlightSegmentDto> get segments;
/// Create a copy of QuotationFlightBlockDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationFlightBlockDtoCopyWith<QuotationFlightBlockDto> get copyWith => _$QuotationFlightBlockDtoCopyWithImpl<QuotationFlightBlockDto>(this as QuotationFlightBlockDto, _$identity);

  /// Serializes this QuotationFlightBlockDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationFlightBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.journey, journey) || other.journey == journey)&&const DeepCollectionEquality().equals(other.segments, segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,journey,const DeepCollectionEquality().hash(segments));

@override
String toString() {
  return 'QuotationFlightBlockDto(included: $included, title: $title, amount: $amount, journey: $journey, segments: $segments)';
}


}

/// @nodoc
abstract mixin class $QuotationFlightBlockDtoCopyWith<$Res>  {
  factory $QuotationFlightBlockDtoCopyWith(QuotationFlightBlockDto value, $Res Function(QuotationFlightBlockDto) _then) = _$QuotationFlightBlockDtoCopyWithImpl;
@useResult
$Res call({
 bool? included, String? title, num? amount, String? journey, List<QuotationFlightSegmentDto> segments
});




}
/// @nodoc
class _$QuotationFlightBlockDtoCopyWithImpl<$Res>
    implements $QuotationFlightBlockDtoCopyWith<$Res> {
  _$QuotationFlightBlockDtoCopyWithImpl(this._self, this._then);

  final QuotationFlightBlockDto _self;
  final $Res Function(QuotationFlightBlockDto) _then;

/// Create a copy of QuotationFlightBlockDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? journey = freezed,Object? segments = null,}) {
  return _then(_self.copyWith(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as String?,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<QuotationFlightSegmentDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationFlightBlockDto].
extension QuotationFlightBlockDtoPatterns on QuotationFlightBlockDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationFlightBlockDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationFlightBlockDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationFlightBlockDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationFlightBlockDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationFlightBlockDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationFlightBlockDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  String? journey,  List<QuotationFlightSegmentDto> segments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationFlightBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.journey,_that.segments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  String? journey,  List<QuotationFlightSegmentDto> segments)  $default,) {final _that = this;
switch (_that) {
case _QuotationFlightBlockDto():
return $default(_that.included,_that.title,_that.amount,_that.journey,_that.segments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? included,  String? title,  num? amount,  String? journey,  List<QuotationFlightSegmentDto> segments)?  $default,) {final _that = this;
switch (_that) {
case _QuotationFlightBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.journey,_that.segments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationFlightBlockDto implements QuotationFlightBlockDto {
  const _QuotationFlightBlockDto({this.included, this.title, this.amount, this.journey, final  List<QuotationFlightSegmentDto> segments = const <QuotationFlightSegmentDto>[]}): _segments = segments;
  factory _QuotationFlightBlockDto.fromJson(Map<String, dynamic> json) => _$QuotationFlightBlockDtoFromJson(json);

@override final  bool? included;
@override final  String? title;
@override final  num? amount;
@override final  String? journey;
 final  List<QuotationFlightSegmentDto> _segments;
@override@JsonKey() List<QuotationFlightSegmentDto> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}


/// Create a copy of QuotationFlightBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationFlightBlockDtoCopyWith<_QuotationFlightBlockDto> get copyWith => __$QuotationFlightBlockDtoCopyWithImpl<_QuotationFlightBlockDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationFlightBlockDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationFlightBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.journey, journey) || other.journey == journey)&&const DeepCollectionEquality().equals(other._segments, _segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,journey,const DeepCollectionEquality().hash(_segments));

@override
String toString() {
  return 'QuotationFlightBlockDto(included: $included, title: $title, amount: $amount, journey: $journey, segments: $segments)';
}


}

/// @nodoc
abstract mixin class _$QuotationFlightBlockDtoCopyWith<$Res> implements $QuotationFlightBlockDtoCopyWith<$Res> {
  factory _$QuotationFlightBlockDtoCopyWith(_QuotationFlightBlockDto value, $Res Function(_QuotationFlightBlockDto) _then) = __$QuotationFlightBlockDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? included, String? title, num? amount, String? journey, List<QuotationFlightSegmentDto> segments
});




}
/// @nodoc
class __$QuotationFlightBlockDtoCopyWithImpl<$Res>
    implements _$QuotationFlightBlockDtoCopyWith<$Res> {
  __$QuotationFlightBlockDtoCopyWithImpl(this._self, this._then);

  final _QuotationFlightBlockDto _self;
  final $Res Function(_QuotationFlightBlockDto) _then;

/// Create a copy of QuotationFlightBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? journey = freezed,Object? segments = null,}) {
  return _then(_QuotationFlightBlockDto(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,journey: freezed == journey ? _self.journey : journey // ignore: cast_nullable_to_non_nullable
as String?,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<QuotationFlightSegmentDto>,
  ));
}


}


/// @nodoc
mixin _$QuotationFlightSegmentDto {

 String? get airline; String? get flightNo;/// `class` is a Dart keyword, so the wire name is mapped explicitly.
@JsonKey(name: 'class') String? get cabinClass; String? get from; String? get to; String? get depDate; String? get depTime; String? get arrDate; String? get arrTime;
/// Create a copy of QuotationFlightSegmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationFlightSegmentDtoCopyWith<QuotationFlightSegmentDto> get copyWith => _$QuotationFlightSegmentDtoCopyWithImpl<QuotationFlightSegmentDto>(this as QuotationFlightSegmentDto, _$identity);

  /// Serializes this QuotationFlightSegmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationFlightSegmentDto&&(identical(other.airline, airline) || other.airline == airline)&&(identical(other.flightNo, flightNo) || other.flightNo == flightNo)&&(identical(other.cabinClass, cabinClass) || other.cabinClass == cabinClass)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.depDate, depDate) || other.depDate == depDate)&&(identical(other.depTime, depTime) || other.depTime == depTime)&&(identical(other.arrDate, arrDate) || other.arrDate == arrDate)&&(identical(other.arrTime, arrTime) || other.arrTime == arrTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,airline,flightNo,cabinClass,from,to,depDate,depTime,arrDate,arrTime);

@override
String toString() {
  return 'QuotationFlightSegmentDto(airline: $airline, flightNo: $flightNo, cabinClass: $cabinClass, from: $from, to: $to, depDate: $depDate, depTime: $depTime, arrDate: $arrDate, arrTime: $arrTime)';
}


}

/// @nodoc
abstract mixin class $QuotationFlightSegmentDtoCopyWith<$Res>  {
  factory $QuotationFlightSegmentDtoCopyWith(QuotationFlightSegmentDto value, $Res Function(QuotationFlightSegmentDto) _then) = _$QuotationFlightSegmentDtoCopyWithImpl;
@useResult
$Res call({
 String? airline, String? flightNo,@JsonKey(name: 'class') String? cabinClass, String? from, String? to, String? depDate, String? depTime, String? arrDate, String? arrTime
});




}
/// @nodoc
class _$QuotationFlightSegmentDtoCopyWithImpl<$Res>
    implements $QuotationFlightSegmentDtoCopyWith<$Res> {
  _$QuotationFlightSegmentDtoCopyWithImpl(this._self, this._then);

  final QuotationFlightSegmentDto _self;
  final $Res Function(QuotationFlightSegmentDto) _then;

/// Create a copy of QuotationFlightSegmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? airline = freezed,Object? flightNo = freezed,Object? cabinClass = freezed,Object? from = freezed,Object? to = freezed,Object? depDate = freezed,Object? depTime = freezed,Object? arrDate = freezed,Object? arrTime = freezed,}) {
  return _then(_self.copyWith(
airline: freezed == airline ? _self.airline : airline // ignore: cast_nullable_to_non_nullable
as String?,flightNo: freezed == flightNo ? _self.flightNo : flightNo // ignore: cast_nullable_to_non_nullable
as String?,cabinClass: freezed == cabinClass ? _self.cabinClass : cabinClass // ignore: cast_nullable_to_non_nullable
as String?,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String?,depDate: freezed == depDate ? _self.depDate : depDate // ignore: cast_nullable_to_non_nullable
as String?,depTime: freezed == depTime ? _self.depTime : depTime // ignore: cast_nullable_to_non_nullable
as String?,arrDate: freezed == arrDate ? _self.arrDate : arrDate // ignore: cast_nullable_to_non_nullable
as String?,arrTime: freezed == arrTime ? _self.arrTime : arrTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationFlightSegmentDto].
extension QuotationFlightSegmentDtoPatterns on QuotationFlightSegmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationFlightSegmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationFlightSegmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationFlightSegmentDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationFlightSegmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationFlightSegmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationFlightSegmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? airline,  String? flightNo, @JsonKey(name: 'class')  String? cabinClass,  String? from,  String? to,  String? depDate,  String? depTime,  String? arrDate,  String? arrTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationFlightSegmentDto() when $default != null:
return $default(_that.airline,_that.flightNo,_that.cabinClass,_that.from,_that.to,_that.depDate,_that.depTime,_that.arrDate,_that.arrTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? airline,  String? flightNo, @JsonKey(name: 'class')  String? cabinClass,  String? from,  String? to,  String? depDate,  String? depTime,  String? arrDate,  String? arrTime)  $default,) {final _that = this;
switch (_that) {
case _QuotationFlightSegmentDto():
return $default(_that.airline,_that.flightNo,_that.cabinClass,_that.from,_that.to,_that.depDate,_that.depTime,_that.arrDate,_that.arrTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? airline,  String? flightNo, @JsonKey(name: 'class')  String? cabinClass,  String? from,  String? to,  String? depDate,  String? depTime,  String? arrDate,  String? arrTime)?  $default,) {final _that = this;
switch (_that) {
case _QuotationFlightSegmentDto() when $default != null:
return $default(_that.airline,_that.flightNo,_that.cabinClass,_that.from,_that.to,_that.depDate,_that.depTime,_that.arrDate,_that.arrTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationFlightSegmentDto implements QuotationFlightSegmentDto {
  const _QuotationFlightSegmentDto({this.airline, this.flightNo, @JsonKey(name: 'class') this.cabinClass, this.from, this.to, this.depDate, this.depTime, this.arrDate, this.arrTime});
  factory _QuotationFlightSegmentDto.fromJson(Map<String, dynamic> json) => _$QuotationFlightSegmentDtoFromJson(json);

@override final  String? airline;
@override final  String? flightNo;
/// `class` is a Dart keyword, so the wire name is mapped explicitly.
@override@JsonKey(name: 'class') final  String? cabinClass;
@override final  String? from;
@override final  String? to;
@override final  String? depDate;
@override final  String? depTime;
@override final  String? arrDate;
@override final  String? arrTime;

/// Create a copy of QuotationFlightSegmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationFlightSegmentDtoCopyWith<_QuotationFlightSegmentDto> get copyWith => __$QuotationFlightSegmentDtoCopyWithImpl<_QuotationFlightSegmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationFlightSegmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationFlightSegmentDto&&(identical(other.airline, airline) || other.airline == airline)&&(identical(other.flightNo, flightNo) || other.flightNo == flightNo)&&(identical(other.cabinClass, cabinClass) || other.cabinClass == cabinClass)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.depDate, depDate) || other.depDate == depDate)&&(identical(other.depTime, depTime) || other.depTime == depTime)&&(identical(other.arrDate, arrDate) || other.arrDate == arrDate)&&(identical(other.arrTime, arrTime) || other.arrTime == arrTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,airline,flightNo,cabinClass,from,to,depDate,depTime,arrDate,arrTime);

@override
String toString() {
  return 'QuotationFlightSegmentDto(airline: $airline, flightNo: $flightNo, cabinClass: $cabinClass, from: $from, to: $to, depDate: $depDate, depTime: $depTime, arrDate: $arrDate, arrTime: $arrTime)';
}


}

/// @nodoc
abstract mixin class _$QuotationFlightSegmentDtoCopyWith<$Res> implements $QuotationFlightSegmentDtoCopyWith<$Res> {
  factory _$QuotationFlightSegmentDtoCopyWith(_QuotationFlightSegmentDto value, $Res Function(_QuotationFlightSegmentDto) _then) = __$QuotationFlightSegmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String? airline, String? flightNo,@JsonKey(name: 'class') String? cabinClass, String? from, String? to, String? depDate, String? depTime, String? arrDate, String? arrTime
});




}
/// @nodoc
class __$QuotationFlightSegmentDtoCopyWithImpl<$Res>
    implements _$QuotationFlightSegmentDtoCopyWith<$Res> {
  __$QuotationFlightSegmentDtoCopyWithImpl(this._self, this._then);

  final _QuotationFlightSegmentDto _self;
  final $Res Function(_QuotationFlightSegmentDto) _then;

/// Create a copy of QuotationFlightSegmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? airline = freezed,Object? flightNo = freezed,Object? cabinClass = freezed,Object? from = freezed,Object? to = freezed,Object? depDate = freezed,Object? depTime = freezed,Object? arrDate = freezed,Object? arrTime = freezed,}) {
  return _then(_QuotationFlightSegmentDto(
airline: freezed == airline ? _self.airline : airline // ignore: cast_nullable_to_non_nullable
as String?,flightNo: freezed == flightNo ? _self.flightNo : flightNo // ignore: cast_nullable_to_non_nullable
as String?,cabinClass: freezed == cabinClass ? _self.cabinClass : cabinClass // ignore: cast_nullable_to_non_nullable
as String?,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String?,depDate: freezed == depDate ? _self.depDate : depDate // ignore: cast_nullable_to_non_nullable
as String?,depTime: freezed == depTime ? _self.depTime : depTime // ignore: cast_nullable_to_non_nullable
as String?,arrDate: freezed == arrDate ? _self.arrDate : arrDate // ignore: cast_nullable_to_non_nullable
as String?,arrTime: freezed == arrTime ? _self.arrTime : arrTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$QuotationSightseeingBlockDto {

 bool? get included; String? get title; num? get amount; List<QuotationSightseeingDayDto> get days;
/// Create a copy of QuotationSightseeingBlockDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationSightseeingBlockDtoCopyWith<QuotationSightseeingBlockDto> get copyWith => _$QuotationSightseeingBlockDtoCopyWithImpl<QuotationSightseeingBlockDto>(this as QuotationSightseeingBlockDto, _$identity);

  /// Serializes this QuotationSightseeingBlockDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationSightseeingBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other.days, days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,const DeepCollectionEquality().hash(days));

@override
String toString() {
  return 'QuotationSightseeingBlockDto(included: $included, title: $title, amount: $amount, days: $days)';
}


}

/// @nodoc
abstract mixin class $QuotationSightseeingBlockDtoCopyWith<$Res>  {
  factory $QuotationSightseeingBlockDtoCopyWith(QuotationSightseeingBlockDto value, $Res Function(QuotationSightseeingBlockDto) _then) = _$QuotationSightseeingBlockDtoCopyWithImpl;
@useResult
$Res call({
 bool? included, String? title, num? amount, List<QuotationSightseeingDayDto> days
});




}
/// @nodoc
class _$QuotationSightseeingBlockDtoCopyWithImpl<$Res>
    implements $QuotationSightseeingBlockDtoCopyWith<$Res> {
  _$QuotationSightseeingBlockDtoCopyWithImpl(this._self, this._then);

  final QuotationSightseeingBlockDto _self;
  final $Res Function(QuotationSightseeingBlockDto) _then;

/// Create a copy of QuotationSightseeingBlockDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? days = null,}) {
  return _then(_self.copyWith(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<QuotationSightseeingDayDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationSightseeingBlockDto].
extension QuotationSightseeingBlockDtoPatterns on QuotationSightseeingBlockDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationSightseeingBlockDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationSightseeingBlockDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationSightseeingBlockDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationSightseeingBlockDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationSightseeingBlockDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationSightseeingBlockDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  List<QuotationSightseeingDayDto> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationSightseeingBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? included,  String? title,  num? amount,  List<QuotationSightseeingDayDto> days)  $default,) {final _that = this;
switch (_that) {
case _QuotationSightseeingBlockDto():
return $default(_that.included,_that.title,_that.amount,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? included,  String? title,  num? amount,  List<QuotationSightseeingDayDto> days)?  $default,) {final _that = this;
switch (_that) {
case _QuotationSightseeingBlockDto() when $default != null:
return $default(_that.included,_that.title,_that.amount,_that.days);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationSightseeingBlockDto implements QuotationSightseeingBlockDto {
  const _QuotationSightseeingBlockDto({this.included, this.title, this.amount, final  List<QuotationSightseeingDayDto> days = const <QuotationSightseeingDayDto>[]}): _days = days;
  factory _QuotationSightseeingBlockDto.fromJson(Map<String, dynamic> json) => _$QuotationSightseeingBlockDtoFromJson(json);

@override final  bool? included;
@override final  String? title;
@override final  num? amount;
 final  List<QuotationSightseeingDayDto> _days;
@override@JsonKey() List<QuotationSightseeingDayDto> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of QuotationSightseeingBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationSightseeingBlockDtoCopyWith<_QuotationSightseeingBlockDto> get copyWith => __$QuotationSightseeingBlockDtoCopyWithImpl<_QuotationSightseeingBlockDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationSightseeingBlockDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationSightseeingBlockDto&&(identical(other.included, included) || other.included == included)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&const DeepCollectionEquality().equals(other._days, _days));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,included,title,amount,const DeepCollectionEquality().hash(_days));

@override
String toString() {
  return 'QuotationSightseeingBlockDto(included: $included, title: $title, amount: $amount, days: $days)';
}


}

/// @nodoc
abstract mixin class _$QuotationSightseeingBlockDtoCopyWith<$Res> implements $QuotationSightseeingBlockDtoCopyWith<$Res> {
  factory _$QuotationSightseeingBlockDtoCopyWith(_QuotationSightseeingBlockDto value, $Res Function(_QuotationSightseeingBlockDto) _then) = __$QuotationSightseeingBlockDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? included, String? title, num? amount, List<QuotationSightseeingDayDto> days
});




}
/// @nodoc
class __$QuotationSightseeingBlockDtoCopyWithImpl<$Res>
    implements _$QuotationSightseeingBlockDtoCopyWith<$Res> {
  __$QuotationSightseeingBlockDtoCopyWithImpl(this._self, this._then);

  final _QuotationSightseeingBlockDto _self;
  final $Res Function(_QuotationSightseeingBlockDto) _then;

/// Create a copy of QuotationSightseeingBlockDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? included = freezed,Object? title = freezed,Object? amount = freezed,Object? days = null,}) {
  return _then(_QuotationSightseeingBlockDto(
included: freezed == included ? _self.included : included // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as num?,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<QuotationSightseeingDayDto>,
  ));
}


}


/// @nodoc
mixin _$QuotationSightseeingDayDto {

 int? get day; String? get date; int? get pax; num? get pricePerPax; List<QuotationActivityDto> get activities;
/// Create a copy of QuotationSightseeingDayDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationSightseeingDayDtoCopyWith<QuotationSightseeingDayDto> get copyWith => _$QuotationSightseeingDayDtoCopyWithImpl<QuotationSightseeingDayDto>(this as QuotationSightseeingDayDto, _$identity);

  /// Serializes this QuotationSightseeingDayDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationSightseeingDayDto&&(identical(other.day, day) || other.day == day)&&(identical(other.date, date) || other.date == date)&&(identical(other.pax, pax) || other.pax == pax)&&(identical(other.pricePerPax, pricePerPax) || other.pricePerPax == pricePerPax)&&const DeepCollectionEquality().equals(other.activities, activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,date,pax,pricePerPax,const DeepCollectionEquality().hash(activities));

@override
String toString() {
  return 'QuotationSightseeingDayDto(day: $day, date: $date, pax: $pax, pricePerPax: $pricePerPax, activities: $activities)';
}


}

/// @nodoc
abstract mixin class $QuotationSightseeingDayDtoCopyWith<$Res>  {
  factory $QuotationSightseeingDayDtoCopyWith(QuotationSightseeingDayDto value, $Res Function(QuotationSightseeingDayDto) _then) = _$QuotationSightseeingDayDtoCopyWithImpl;
@useResult
$Res call({
 int? day, String? date, int? pax, num? pricePerPax, List<QuotationActivityDto> activities
});




}
/// @nodoc
class _$QuotationSightseeingDayDtoCopyWithImpl<$Res>
    implements $QuotationSightseeingDayDtoCopyWith<$Res> {
  _$QuotationSightseeingDayDtoCopyWithImpl(this._self, this._then);

  final QuotationSightseeingDayDto _self;
  final $Res Function(QuotationSightseeingDayDto) _then;

/// Create a copy of QuotationSightseeingDayDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = freezed,Object? date = freezed,Object? pax = freezed,Object? pricePerPax = freezed,Object? activities = null,}) {
  return _then(_self.copyWith(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,pax: freezed == pax ? _self.pax : pax // ignore: cast_nullable_to_non_nullable
as int?,pricePerPax: freezed == pricePerPax ? _self.pricePerPax : pricePerPax // ignore: cast_nullable_to_non_nullable
as num?,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<QuotationActivityDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationSightseeingDayDto].
extension QuotationSightseeingDayDtoPatterns on QuotationSightseeingDayDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationSightseeingDayDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationSightseeingDayDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationSightseeingDayDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationSightseeingDayDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationSightseeingDayDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationSightseeingDayDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? day,  String? date,  int? pax,  num? pricePerPax,  List<QuotationActivityDto> activities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationSightseeingDayDto() when $default != null:
return $default(_that.day,_that.date,_that.pax,_that.pricePerPax,_that.activities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? day,  String? date,  int? pax,  num? pricePerPax,  List<QuotationActivityDto> activities)  $default,) {final _that = this;
switch (_that) {
case _QuotationSightseeingDayDto():
return $default(_that.day,_that.date,_that.pax,_that.pricePerPax,_that.activities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? day,  String? date,  int? pax,  num? pricePerPax,  List<QuotationActivityDto> activities)?  $default,) {final _that = this;
switch (_that) {
case _QuotationSightseeingDayDto() when $default != null:
return $default(_that.day,_that.date,_that.pax,_that.pricePerPax,_that.activities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationSightseeingDayDto implements QuotationSightseeingDayDto {
  const _QuotationSightseeingDayDto({this.day, this.date, this.pax, this.pricePerPax, final  List<QuotationActivityDto> activities = const <QuotationActivityDto>[]}): _activities = activities;
  factory _QuotationSightseeingDayDto.fromJson(Map<String, dynamic> json) => _$QuotationSightseeingDayDtoFromJson(json);

@override final  int? day;
@override final  String? date;
@override final  int? pax;
@override final  num? pricePerPax;
 final  List<QuotationActivityDto> _activities;
@override@JsonKey() List<QuotationActivityDto> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}


/// Create a copy of QuotationSightseeingDayDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationSightseeingDayDtoCopyWith<_QuotationSightseeingDayDto> get copyWith => __$QuotationSightseeingDayDtoCopyWithImpl<_QuotationSightseeingDayDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationSightseeingDayDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationSightseeingDayDto&&(identical(other.day, day) || other.day == day)&&(identical(other.date, date) || other.date == date)&&(identical(other.pax, pax) || other.pax == pax)&&(identical(other.pricePerPax, pricePerPax) || other.pricePerPax == pricePerPax)&&const DeepCollectionEquality().equals(other._activities, _activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,date,pax,pricePerPax,const DeepCollectionEquality().hash(_activities));

@override
String toString() {
  return 'QuotationSightseeingDayDto(day: $day, date: $date, pax: $pax, pricePerPax: $pricePerPax, activities: $activities)';
}


}

/// @nodoc
abstract mixin class _$QuotationSightseeingDayDtoCopyWith<$Res> implements $QuotationSightseeingDayDtoCopyWith<$Res> {
  factory _$QuotationSightseeingDayDtoCopyWith(_QuotationSightseeingDayDto value, $Res Function(_QuotationSightseeingDayDto) _then) = __$QuotationSightseeingDayDtoCopyWithImpl;
@override @useResult
$Res call({
 int? day, String? date, int? pax, num? pricePerPax, List<QuotationActivityDto> activities
});




}
/// @nodoc
class __$QuotationSightseeingDayDtoCopyWithImpl<$Res>
    implements _$QuotationSightseeingDayDtoCopyWith<$Res> {
  __$QuotationSightseeingDayDtoCopyWithImpl(this._self, this._then);

  final _QuotationSightseeingDayDto _self;
  final $Res Function(_QuotationSightseeingDayDto) _then;

/// Create a copy of QuotationSightseeingDayDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = freezed,Object? date = freezed,Object? pax = freezed,Object? pricePerPax = freezed,Object? activities = null,}) {
  return _then(_QuotationSightseeingDayDto(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,pax: freezed == pax ? _self.pax : pax // ignore: cast_nullable_to_non_nullable
as int?,pricePerPax: freezed == pricePerPax ? _self.pricePerPax : pricePerPax // ignore: cast_nullable_to_non_nullable
as num?,activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<QuotationActivityDto>,
  ));
}


}


/// @nodoc
mixin _$QuotationActivityDto {

 String? get attraction; String? get startTime; String? get description; String? get transfer;
/// Create a copy of QuotationActivityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuotationActivityDtoCopyWith<QuotationActivityDto> get copyWith => _$QuotationActivityDtoCopyWithImpl<QuotationActivityDto>(this as QuotationActivityDto, _$identity);

  /// Serializes this QuotationActivityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuotationActivityDto&&(identical(other.attraction, attraction) || other.attraction == attraction)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.transfer, transfer) || other.transfer == transfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attraction,startTime,description,transfer);

@override
String toString() {
  return 'QuotationActivityDto(attraction: $attraction, startTime: $startTime, description: $description, transfer: $transfer)';
}


}

/// @nodoc
abstract mixin class $QuotationActivityDtoCopyWith<$Res>  {
  factory $QuotationActivityDtoCopyWith(QuotationActivityDto value, $Res Function(QuotationActivityDto) _then) = _$QuotationActivityDtoCopyWithImpl;
@useResult
$Res call({
 String? attraction, String? startTime, String? description, String? transfer
});




}
/// @nodoc
class _$QuotationActivityDtoCopyWithImpl<$Res>
    implements $QuotationActivityDtoCopyWith<$Res> {
  _$QuotationActivityDtoCopyWithImpl(this._self, this._then);

  final QuotationActivityDto _self;
  final $Res Function(QuotationActivityDto) _then;

/// Create a copy of QuotationActivityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attraction = freezed,Object? startTime = freezed,Object? description = freezed,Object? transfer = freezed,}) {
  return _then(_self.copyWith(
attraction: freezed == attraction ? _self.attraction : attraction // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transfer: freezed == transfer ? _self.transfer : transfer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuotationActivityDto].
extension QuotationActivityDtoPatterns on QuotationActivityDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuotationActivityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuotationActivityDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuotationActivityDto value)  $default,){
final _that = this;
switch (_that) {
case _QuotationActivityDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuotationActivityDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuotationActivityDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? attraction,  String? startTime,  String? description,  String? transfer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuotationActivityDto() when $default != null:
return $default(_that.attraction,_that.startTime,_that.description,_that.transfer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? attraction,  String? startTime,  String? description,  String? transfer)  $default,) {final _that = this;
switch (_that) {
case _QuotationActivityDto():
return $default(_that.attraction,_that.startTime,_that.description,_that.transfer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? attraction,  String? startTime,  String? description,  String? transfer)?  $default,) {final _that = this;
switch (_that) {
case _QuotationActivityDto() when $default != null:
return $default(_that.attraction,_that.startTime,_that.description,_that.transfer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuotationActivityDto implements QuotationActivityDto {
  const _QuotationActivityDto({this.attraction, this.startTime, this.description, this.transfer});
  factory _QuotationActivityDto.fromJson(Map<String, dynamic> json) => _$QuotationActivityDtoFromJson(json);

@override final  String? attraction;
@override final  String? startTime;
@override final  String? description;
@override final  String? transfer;

/// Create a copy of QuotationActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuotationActivityDtoCopyWith<_QuotationActivityDto> get copyWith => __$QuotationActivityDtoCopyWithImpl<_QuotationActivityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuotationActivityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuotationActivityDto&&(identical(other.attraction, attraction) || other.attraction == attraction)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.transfer, transfer) || other.transfer == transfer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attraction,startTime,description,transfer);

@override
String toString() {
  return 'QuotationActivityDto(attraction: $attraction, startTime: $startTime, description: $description, transfer: $transfer)';
}


}

/// @nodoc
abstract mixin class _$QuotationActivityDtoCopyWith<$Res> implements $QuotationActivityDtoCopyWith<$Res> {
  factory _$QuotationActivityDtoCopyWith(_QuotationActivityDto value, $Res Function(_QuotationActivityDto) _then) = __$QuotationActivityDtoCopyWithImpl;
@override @useResult
$Res call({
 String? attraction, String? startTime, String? description, String? transfer
});




}
/// @nodoc
class __$QuotationActivityDtoCopyWithImpl<$Res>
    implements _$QuotationActivityDtoCopyWith<$Res> {
  __$QuotationActivityDtoCopyWithImpl(this._self, this._then);

  final _QuotationActivityDto _self;
  final $Res Function(_QuotationActivityDto) _then;

/// Create a copy of QuotationActivityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attraction = freezed,Object? startTime = freezed,Object? description = freezed,Object? transfer = freezed,}) {
  return _then(_QuotationActivityDto(
attraction: freezed == attraction ? _self.attraction : attraction // ignore: cast_nullable_to_non_nullable
as String?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,transfer: freezed == transfer ? _self.transfer : transfer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
