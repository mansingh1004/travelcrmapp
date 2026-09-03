// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookingDto {

 String? get publicId; String? get bookingCode; String? get customerId; String? get customerNameSnapshot; String? get destinationSnapshot; String? get sourceLeadPublicId; String? get sourceQuotationPublicId; String? get assignedUserId; String? get assignedUserName; String? get bookingDate; String? get travelDate; bool? get overseasTourPackage; num? get customerAmount; num? get vendorCost; String? get vendorPublicId; String? get vendorName; num? get gst; num? get tcs; num? get totalPayable; num? get paidAmount; num? get pendingAmount; num? get refundedAmount; num? get netProfit; String? get status; String? get paymentStatus; List<String> get services;@JsonKey(readValue: readTripSummary) String? get tripSnapshot; String? get createdAt;
/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingDtoCopyWith<BookingDto> get copyWith => _$BookingDtoCopyWithImpl<BookingDto>(this as BookingDto, _$identity);

  /// Serializes this BookingDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerNameSnapshot, customerNameSnapshot) || other.customerNameSnapshot == customerNameSnapshot)&&(identical(other.destinationSnapshot, destinationSnapshot) || other.destinationSnapshot == destinationSnapshot)&&(identical(other.sourceLeadPublicId, sourceLeadPublicId) || other.sourceLeadPublicId == sourceLeadPublicId)&&(identical(other.sourceQuotationPublicId, sourceQuotationPublicId) || other.sourceQuotationPublicId == sourceQuotationPublicId)&&(identical(other.assignedUserId, assignedUserId) || other.assignedUserId == assignedUserId)&&(identical(other.assignedUserName, assignedUserName) || other.assignedUserName == assignedUserName)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.overseasTourPackage, overseasTourPackage) || other.overseasTourPackage == overseasTourPackage)&&(identical(other.customerAmount, customerAmount) || other.customerAmount == customerAmount)&&(identical(other.vendorCost, vendorCost) || other.vendorCost == vendorCost)&&(identical(other.vendorPublicId, vendorPublicId) || other.vendorPublicId == vendorPublicId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.gst, gst) || other.gst == gst)&&(identical(other.tcs, tcs) || other.tcs == tcs)&&(identical(other.totalPayable, totalPayable) || other.totalPayable == totalPayable)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.pendingAmount, pendingAmount) || other.pendingAmount == pendingAmount)&&(identical(other.refundedAmount, refundedAmount) || other.refundedAmount == refundedAmount)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.tripSnapshot, tripSnapshot) || other.tripSnapshot == tripSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,publicId,bookingCode,customerId,customerNameSnapshot,destinationSnapshot,sourceLeadPublicId,sourceQuotationPublicId,assignedUserId,assignedUserName,bookingDate,travelDate,overseasTourPackage,customerAmount,vendorCost,vendorPublicId,vendorName,gst,tcs,totalPayable,paidAmount,pendingAmount,refundedAmount,netProfit,status,paymentStatus,const DeepCollectionEquality().hash(services),tripSnapshot,createdAt]);

@override
String toString() {
  return 'BookingDto(publicId: $publicId, bookingCode: $bookingCode, customerId: $customerId, customerNameSnapshot: $customerNameSnapshot, destinationSnapshot: $destinationSnapshot, sourceLeadPublicId: $sourceLeadPublicId, sourceQuotationPublicId: $sourceQuotationPublicId, assignedUserId: $assignedUserId, assignedUserName: $assignedUserName, bookingDate: $bookingDate, travelDate: $travelDate, overseasTourPackage: $overseasTourPackage, customerAmount: $customerAmount, vendorCost: $vendorCost, vendorPublicId: $vendorPublicId, vendorName: $vendorName, gst: $gst, tcs: $tcs, totalPayable: $totalPayable, paidAmount: $paidAmount, pendingAmount: $pendingAmount, refundedAmount: $refundedAmount, netProfit: $netProfit, status: $status, paymentStatus: $paymentStatus, services: $services, tripSnapshot: $tripSnapshot, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BookingDtoCopyWith<$Res>  {
  factory $BookingDtoCopyWith(BookingDto value, $Res Function(BookingDto) _then) = _$BookingDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, String? bookingCode, String? customerId, String? customerNameSnapshot, String? destinationSnapshot, String? sourceLeadPublicId, String? sourceQuotationPublicId, String? assignedUserId, String? assignedUserName, String? bookingDate, String? travelDate, bool? overseasTourPackage, num? customerAmount, num? vendorCost, String? vendorPublicId, String? vendorName, num? gst, num? tcs, num? totalPayable, num? paidAmount, num? pendingAmount, num? refundedAmount, num? netProfit, String? status, String? paymentStatus, List<String> services,@JsonKey(readValue: readTripSummary) String? tripSnapshot, String? createdAt
});




}
/// @nodoc
class _$BookingDtoCopyWithImpl<$Res>
    implements $BookingDtoCopyWith<$Res> {
  _$BookingDtoCopyWithImpl(this._self, this._then);

  final BookingDto _self;
  final $Res Function(BookingDto) _then;

/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? bookingCode = freezed,Object? customerId = freezed,Object? customerNameSnapshot = freezed,Object? destinationSnapshot = freezed,Object? sourceLeadPublicId = freezed,Object? sourceQuotationPublicId = freezed,Object? assignedUserId = freezed,Object? assignedUserName = freezed,Object? bookingDate = freezed,Object? travelDate = freezed,Object? overseasTourPackage = freezed,Object? customerAmount = freezed,Object? vendorCost = freezed,Object? vendorPublicId = freezed,Object? vendorName = freezed,Object? gst = freezed,Object? tcs = freezed,Object? totalPayable = freezed,Object? paidAmount = freezed,Object? pendingAmount = freezed,Object? refundedAmount = freezed,Object? netProfit = freezed,Object? status = freezed,Object? paymentStatus = freezed,Object? services = null,Object? tripSnapshot = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: freezed == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerNameSnapshot: freezed == customerNameSnapshot ? _self.customerNameSnapshot : customerNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,destinationSnapshot: freezed == destinationSnapshot ? _self.destinationSnapshot : destinationSnapshot // ignore: cast_nullable_to_non_nullable
as String?,sourceLeadPublicId: freezed == sourceLeadPublicId ? _self.sourceLeadPublicId : sourceLeadPublicId // ignore: cast_nullable_to_non_nullable
as String?,sourceQuotationPublicId: freezed == sourceQuotationPublicId ? _self.sourceQuotationPublicId : sourceQuotationPublicId // ignore: cast_nullable_to_non_nullable
as String?,assignedUserId: freezed == assignedUserId ? _self.assignedUserId : assignedUserId // ignore: cast_nullable_to_non_nullable
as String?,assignedUserName: freezed == assignedUserName ? _self.assignedUserName : assignedUserName // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: freezed == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,overseasTourPackage: freezed == overseasTourPackage ? _self.overseasTourPackage : overseasTourPackage // ignore: cast_nullable_to_non_nullable
as bool?,customerAmount: freezed == customerAmount ? _self.customerAmount : customerAmount // ignore: cast_nullable_to_non_nullable
as num?,vendorCost: freezed == vendorCost ? _self.vendorCost : vendorCost // ignore: cast_nullable_to_non_nullable
as num?,vendorPublicId: freezed == vendorPublicId ? _self.vendorPublicId : vendorPublicId // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,gst: freezed == gst ? _self.gst : gst // ignore: cast_nullable_to_non_nullable
as num?,tcs: freezed == tcs ? _self.tcs : tcs // ignore: cast_nullable_to_non_nullable
as num?,totalPayable: freezed == totalPayable ? _self.totalPayable : totalPayable // ignore: cast_nullable_to_non_nullable
as num?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as num?,pendingAmount: freezed == pendingAmount ? _self.pendingAmount : pendingAmount // ignore: cast_nullable_to_non_nullable
as num?,refundedAmount: freezed == refundedAmount ? _self.refundedAmount : refundedAmount // ignore: cast_nullable_to_non_nullable
as num?,netProfit: freezed == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as num?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,tripSnapshot: freezed == tripSnapshot ? _self.tripSnapshot : tripSnapshot // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingDto].
extension BookingDtoPatterns on BookingDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingDto value)  $default,){
final _that = this;
switch (_that) {
case _BookingDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  String? bookingCode,  String? customerId,  String? customerNameSnapshot,  String? destinationSnapshot,  String? sourceLeadPublicId,  String? sourceQuotationPublicId,  String? assignedUserId,  String? assignedUserName,  String? bookingDate,  String? travelDate,  bool? overseasTourPackage,  num? customerAmount,  num? vendorCost,  String? vendorPublicId,  String? vendorName,  num? gst,  num? tcs,  num? totalPayable,  num? paidAmount,  num? pendingAmount,  num? refundedAmount,  num? netProfit,  String? status,  String? paymentStatus,  List<String> services, @JsonKey(readValue: readTripSummary)  String? tripSnapshot,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
return $default(_that.publicId,_that.bookingCode,_that.customerId,_that.customerNameSnapshot,_that.destinationSnapshot,_that.sourceLeadPublicId,_that.sourceQuotationPublicId,_that.assignedUserId,_that.assignedUserName,_that.bookingDate,_that.travelDate,_that.overseasTourPackage,_that.customerAmount,_that.vendorCost,_that.vendorPublicId,_that.vendorName,_that.gst,_that.tcs,_that.totalPayable,_that.paidAmount,_that.pendingAmount,_that.refundedAmount,_that.netProfit,_that.status,_that.paymentStatus,_that.services,_that.tripSnapshot,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  String? bookingCode,  String? customerId,  String? customerNameSnapshot,  String? destinationSnapshot,  String? sourceLeadPublicId,  String? sourceQuotationPublicId,  String? assignedUserId,  String? assignedUserName,  String? bookingDate,  String? travelDate,  bool? overseasTourPackage,  num? customerAmount,  num? vendorCost,  String? vendorPublicId,  String? vendorName,  num? gst,  num? tcs,  num? totalPayable,  num? paidAmount,  num? pendingAmount,  num? refundedAmount,  num? netProfit,  String? status,  String? paymentStatus,  List<String> services, @JsonKey(readValue: readTripSummary)  String? tripSnapshot,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BookingDto():
return $default(_that.publicId,_that.bookingCode,_that.customerId,_that.customerNameSnapshot,_that.destinationSnapshot,_that.sourceLeadPublicId,_that.sourceQuotationPublicId,_that.assignedUserId,_that.assignedUserName,_that.bookingDate,_that.travelDate,_that.overseasTourPackage,_that.customerAmount,_that.vendorCost,_that.vendorPublicId,_that.vendorName,_that.gst,_that.tcs,_that.totalPayable,_that.paidAmount,_that.pendingAmount,_that.refundedAmount,_that.netProfit,_that.status,_that.paymentStatus,_that.services,_that.tripSnapshot,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  String? bookingCode,  String? customerId,  String? customerNameSnapshot,  String? destinationSnapshot,  String? sourceLeadPublicId,  String? sourceQuotationPublicId,  String? assignedUserId,  String? assignedUserName,  String? bookingDate,  String? travelDate,  bool? overseasTourPackage,  num? customerAmount,  num? vendorCost,  String? vendorPublicId,  String? vendorName,  num? gst,  num? tcs,  num? totalPayable,  num? paidAmount,  num? pendingAmount,  num? refundedAmount,  num? netProfit,  String? status,  String? paymentStatus,  List<String> services, @JsonKey(readValue: readTripSummary)  String? tripSnapshot,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BookingDto() when $default != null:
return $default(_that.publicId,_that.bookingCode,_that.customerId,_that.customerNameSnapshot,_that.destinationSnapshot,_that.sourceLeadPublicId,_that.sourceQuotationPublicId,_that.assignedUserId,_that.assignedUserName,_that.bookingDate,_that.travelDate,_that.overseasTourPackage,_that.customerAmount,_that.vendorCost,_that.vendorPublicId,_that.vendorName,_that.gst,_that.tcs,_that.totalPayable,_that.paidAmount,_that.pendingAmount,_that.refundedAmount,_that.netProfit,_that.status,_that.paymentStatus,_that.services,_that.tripSnapshot,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingDto implements BookingDto {
  const _BookingDto({this.publicId, this.bookingCode, this.customerId, this.customerNameSnapshot, this.destinationSnapshot, this.sourceLeadPublicId, this.sourceQuotationPublicId, this.assignedUserId, this.assignedUserName, this.bookingDate, this.travelDate, this.overseasTourPackage, this.customerAmount, this.vendorCost, this.vendorPublicId, this.vendorName, this.gst, this.tcs, this.totalPayable, this.paidAmount, this.pendingAmount, this.refundedAmount, this.netProfit, this.status, this.paymentStatus, final  List<String> services = const <String>[], @JsonKey(readValue: readTripSummary) this.tripSnapshot, this.createdAt}): _services = services;
  factory _BookingDto.fromJson(Map<String, dynamic> json) => _$BookingDtoFromJson(json);

@override final  String? publicId;
@override final  String? bookingCode;
@override final  String? customerId;
@override final  String? customerNameSnapshot;
@override final  String? destinationSnapshot;
@override final  String? sourceLeadPublicId;
@override final  String? sourceQuotationPublicId;
@override final  String? assignedUserId;
@override final  String? assignedUserName;
@override final  String? bookingDate;
@override final  String? travelDate;
@override final  bool? overseasTourPackage;
@override final  num? customerAmount;
@override final  num? vendorCost;
@override final  String? vendorPublicId;
@override final  String? vendorName;
@override final  num? gst;
@override final  num? tcs;
@override final  num? totalPayable;
@override final  num? paidAmount;
@override final  num? pendingAmount;
@override final  num? refundedAmount;
@override final  num? netProfit;
@override final  String? status;
@override final  String? paymentStatus;
 final  List<String> _services;
@override@JsonKey() List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override@JsonKey(readValue: readTripSummary) final  String? tripSnapshot;
@override final  String? createdAt;

/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingDtoCopyWith<_BookingDto> get copyWith => __$BookingDtoCopyWithImpl<_BookingDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.bookingCode, bookingCode) || other.bookingCode == bookingCode)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.customerNameSnapshot, customerNameSnapshot) || other.customerNameSnapshot == customerNameSnapshot)&&(identical(other.destinationSnapshot, destinationSnapshot) || other.destinationSnapshot == destinationSnapshot)&&(identical(other.sourceLeadPublicId, sourceLeadPublicId) || other.sourceLeadPublicId == sourceLeadPublicId)&&(identical(other.sourceQuotationPublicId, sourceQuotationPublicId) || other.sourceQuotationPublicId == sourceQuotationPublicId)&&(identical(other.assignedUserId, assignedUserId) || other.assignedUserId == assignedUserId)&&(identical(other.assignedUserName, assignedUserName) || other.assignedUserName == assignedUserName)&&(identical(other.bookingDate, bookingDate) || other.bookingDate == bookingDate)&&(identical(other.travelDate, travelDate) || other.travelDate == travelDate)&&(identical(other.overseasTourPackage, overseasTourPackage) || other.overseasTourPackage == overseasTourPackage)&&(identical(other.customerAmount, customerAmount) || other.customerAmount == customerAmount)&&(identical(other.vendorCost, vendorCost) || other.vendorCost == vendorCost)&&(identical(other.vendorPublicId, vendorPublicId) || other.vendorPublicId == vendorPublicId)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.gst, gst) || other.gst == gst)&&(identical(other.tcs, tcs) || other.tcs == tcs)&&(identical(other.totalPayable, totalPayable) || other.totalPayable == totalPayable)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.pendingAmount, pendingAmount) || other.pendingAmount == pendingAmount)&&(identical(other.refundedAmount, refundedAmount) || other.refundedAmount == refundedAmount)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.tripSnapshot, tripSnapshot) || other.tripSnapshot == tripSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,publicId,bookingCode,customerId,customerNameSnapshot,destinationSnapshot,sourceLeadPublicId,sourceQuotationPublicId,assignedUserId,assignedUserName,bookingDate,travelDate,overseasTourPackage,customerAmount,vendorCost,vendorPublicId,vendorName,gst,tcs,totalPayable,paidAmount,pendingAmount,refundedAmount,netProfit,status,paymentStatus,const DeepCollectionEquality().hash(_services),tripSnapshot,createdAt]);

@override
String toString() {
  return 'BookingDto(publicId: $publicId, bookingCode: $bookingCode, customerId: $customerId, customerNameSnapshot: $customerNameSnapshot, destinationSnapshot: $destinationSnapshot, sourceLeadPublicId: $sourceLeadPublicId, sourceQuotationPublicId: $sourceQuotationPublicId, assignedUserId: $assignedUserId, assignedUserName: $assignedUserName, bookingDate: $bookingDate, travelDate: $travelDate, overseasTourPackage: $overseasTourPackage, customerAmount: $customerAmount, vendorCost: $vendorCost, vendorPublicId: $vendorPublicId, vendorName: $vendorName, gst: $gst, tcs: $tcs, totalPayable: $totalPayable, paidAmount: $paidAmount, pendingAmount: $pendingAmount, refundedAmount: $refundedAmount, netProfit: $netProfit, status: $status, paymentStatus: $paymentStatus, services: $services, tripSnapshot: $tripSnapshot, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookingDtoCopyWith<$Res> implements $BookingDtoCopyWith<$Res> {
  factory _$BookingDtoCopyWith(_BookingDto value, $Res Function(_BookingDto) _then) = __$BookingDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, String? bookingCode, String? customerId, String? customerNameSnapshot, String? destinationSnapshot, String? sourceLeadPublicId, String? sourceQuotationPublicId, String? assignedUserId, String? assignedUserName, String? bookingDate, String? travelDate, bool? overseasTourPackage, num? customerAmount, num? vendorCost, String? vendorPublicId, String? vendorName, num? gst, num? tcs, num? totalPayable, num? paidAmount, num? pendingAmount, num? refundedAmount, num? netProfit, String? status, String? paymentStatus, List<String> services,@JsonKey(readValue: readTripSummary) String? tripSnapshot, String? createdAt
});




}
/// @nodoc
class __$BookingDtoCopyWithImpl<$Res>
    implements _$BookingDtoCopyWith<$Res> {
  __$BookingDtoCopyWithImpl(this._self, this._then);

  final _BookingDto _self;
  final $Res Function(_BookingDto) _then;

/// Create a copy of BookingDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? bookingCode = freezed,Object? customerId = freezed,Object? customerNameSnapshot = freezed,Object? destinationSnapshot = freezed,Object? sourceLeadPublicId = freezed,Object? sourceQuotationPublicId = freezed,Object? assignedUserId = freezed,Object? assignedUserName = freezed,Object? bookingDate = freezed,Object? travelDate = freezed,Object? overseasTourPackage = freezed,Object? customerAmount = freezed,Object? vendorCost = freezed,Object? vendorPublicId = freezed,Object? vendorName = freezed,Object? gst = freezed,Object? tcs = freezed,Object? totalPayable = freezed,Object? paidAmount = freezed,Object? pendingAmount = freezed,Object? refundedAmount = freezed,Object? netProfit = freezed,Object? status = freezed,Object? paymentStatus = freezed,Object? services = null,Object? tripSnapshot = freezed,Object? createdAt = freezed,}) {
  return _then(_BookingDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,bookingCode: freezed == bookingCode ? _self.bookingCode : bookingCode // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,customerNameSnapshot: freezed == customerNameSnapshot ? _self.customerNameSnapshot : customerNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,destinationSnapshot: freezed == destinationSnapshot ? _self.destinationSnapshot : destinationSnapshot // ignore: cast_nullable_to_non_nullable
as String?,sourceLeadPublicId: freezed == sourceLeadPublicId ? _self.sourceLeadPublicId : sourceLeadPublicId // ignore: cast_nullable_to_non_nullable
as String?,sourceQuotationPublicId: freezed == sourceQuotationPublicId ? _self.sourceQuotationPublicId : sourceQuotationPublicId // ignore: cast_nullable_to_non_nullable
as String?,assignedUserId: freezed == assignedUserId ? _self.assignedUserId : assignedUserId // ignore: cast_nullable_to_non_nullable
as String?,assignedUserName: freezed == assignedUserName ? _self.assignedUserName : assignedUserName // ignore: cast_nullable_to_non_nullable
as String?,bookingDate: freezed == bookingDate ? _self.bookingDate : bookingDate // ignore: cast_nullable_to_non_nullable
as String?,travelDate: freezed == travelDate ? _self.travelDate : travelDate // ignore: cast_nullable_to_non_nullable
as String?,overseasTourPackage: freezed == overseasTourPackage ? _self.overseasTourPackage : overseasTourPackage // ignore: cast_nullable_to_non_nullable
as bool?,customerAmount: freezed == customerAmount ? _self.customerAmount : customerAmount // ignore: cast_nullable_to_non_nullable
as num?,vendorCost: freezed == vendorCost ? _self.vendorCost : vendorCost // ignore: cast_nullable_to_non_nullable
as num?,vendorPublicId: freezed == vendorPublicId ? _self.vendorPublicId : vendorPublicId // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,gst: freezed == gst ? _self.gst : gst // ignore: cast_nullable_to_non_nullable
as num?,tcs: freezed == tcs ? _self.tcs : tcs // ignore: cast_nullable_to_non_nullable
as num?,totalPayable: freezed == totalPayable ? _self.totalPayable : totalPayable // ignore: cast_nullable_to_non_nullable
as num?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as num?,pendingAmount: freezed == pendingAmount ? _self.pendingAmount : pendingAmount // ignore: cast_nullable_to_non_nullable
as num?,refundedAmount: freezed == refundedAmount ? _self.refundedAmount : refundedAmount // ignore: cast_nullable_to_non_nullable
as num?,netProfit: freezed == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as num?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,tripSnapshot: freezed == tripSnapshot ? _self.tripSnapshot : tripSnapshot // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BookingStatsDto {

 int? get totalBookings; int? get confirmedBookings; int? get pendingBookings; int? get cancelledBookings; int? get completedBookings; int? get refundedBookings; num? get totalRevenue; num? get totalCollected; num? get totalPending; num? get totalRefundAmount;// Only present with the profit-read permission.
 num? get netProfit; num? get totalVendorCost;
/// Create a copy of BookingStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingStatsDtoCopyWith<BookingStatsDto> get copyWith => _$BookingStatsDtoCopyWithImpl<BookingStatsDto>(this as BookingStatsDto, _$identity);

  /// Serializes this BookingStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingStatsDto&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.confirmedBookings, confirmedBookings) || other.confirmedBookings == confirmedBookings)&&(identical(other.pendingBookings, pendingBookings) || other.pendingBookings == pendingBookings)&&(identical(other.cancelledBookings, cancelledBookings) || other.cancelledBookings == cancelledBookings)&&(identical(other.completedBookings, completedBookings) || other.completedBookings == completedBookings)&&(identical(other.refundedBookings, refundedBookings) || other.refundedBookings == refundedBookings)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.totalPending, totalPending) || other.totalPending == totalPending)&&(identical(other.totalRefundAmount, totalRefundAmount) || other.totalRefundAmount == totalRefundAmount)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit)&&(identical(other.totalVendorCost, totalVendorCost) || other.totalVendorCost == totalVendorCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBookings,confirmedBookings,pendingBookings,cancelledBookings,completedBookings,refundedBookings,totalRevenue,totalCollected,totalPending,totalRefundAmount,netProfit,totalVendorCost);

@override
String toString() {
  return 'BookingStatsDto(totalBookings: $totalBookings, confirmedBookings: $confirmedBookings, pendingBookings: $pendingBookings, cancelledBookings: $cancelledBookings, completedBookings: $completedBookings, refundedBookings: $refundedBookings, totalRevenue: $totalRevenue, totalCollected: $totalCollected, totalPending: $totalPending, totalRefundAmount: $totalRefundAmount, netProfit: $netProfit, totalVendorCost: $totalVendorCost)';
}


}

/// @nodoc
abstract mixin class $BookingStatsDtoCopyWith<$Res>  {
  factory $BookingStatsDtoCopyWith(BookingStatsDto value, $Res Function(BookingStatsDto) _then) = _$BookingStatsDtoCopyWithImpl;
@useResult
$Res call({
 int? totalBookings, int? confirmedBookings, int? pendingBookings, int? cancelledBookings, int? completedBookings, int? refundedBookings, num? totalRevenue, num? totalCollected, num? totalPending, num? totalRefundAmount, num? netProfit, num? totalVendorCost
});




}
/// @nodoc
class _$BookingStatsDtoCopyWithImpl<$Res>
    implements $BookingStatsDtoCopyWith<$Res> {
  _$BookingStatsDtoCopyWithImpl(this._self, this._then);

  final BookingStatsDto _self;
  final $Res Function(BookingStatsDto) _then;

/// Create a copy of BookingStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBookings = freezed,Object? confirmedBookings = freezed,Object? pendingBookings = freezed,Object? cancelledBookings = freezed,Object? completedBookings = freezed,Object? refundedBookings = freezed,Object? totalRevenue = freezed,Object? totalCollected = freezed,Object? totalPending = freezed,Object? totalRefundAmount = freezed,Object? netProfit = freezed,Object? totalVendorCost = freezed,}) {
  return _then(_self.copyWith(
totalBookings: freezed == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int?,confirmedBookings: freezed == confirmedBookings ? _self.confirmedBookings : confirmedBookings // ignore: cast_nullable_to_non_nullable
as int?,pendingBookings: freezed == pendingBookings ? _self.pendingBookings : pendingBookings // ignore: cast_nullable_to_non_nullable
as int?,cancelledBookings: freezed == cancelledBookings ? _self.cancelledBookings : cancelledBookings // ignore: cast_nullable_to_non_nullable
as int?,completedBookings: freezed == completedBookings ? _self.completedBookings : completedBookings // ignore: cast_nullable_to_non_nullable
as int?,refundedBookings: freezed == refundedBookings ? _self.refundedBookings : refundedBookings // ignore: cast_nullable_to_non_nullable
as int?,totalRevenue: freezed == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as num?,totalCollected: freezed == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as num?,totalPending: freezed == totalPending ? _self.totalPending : totalPending // ignore: cast_nullable_to_non_nullable
as num?,totalRefundAmount: freezed == totalRefundAmount ? _self.totalRefundAmount : totalRefundAmount // ignore: cast_nullable_to_non_nullable
as num?,netProfit: freezed == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as num?,totalVendorCost: freezed == totalVendorCost ? _self.totalVendorCost : totalVendorCost // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingStatsDto].
extension BookingStatsDtoPatterns on BookingStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _BookingStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookingStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? totalBookings,  int? confirmedBookings,  int? pendingBookings,  int? cancelledBookings,  int? completedBookings,  int? refundedBookings,  num? totalRevenue,  num? totalCollected,  num? totalPending,  num? totalRefundAmount,  num? netProfit,  num? totalVendorCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingStatsDto() when $default != null:
return $default(_that.totalBookings,_that.confirmedBookings,_that.pendingBookings,_that.cancelledBookings,_that.completedBookings,_that.refundedBookings,_that.totalRevenue,_that.totalCollected,_that.totalPending,_that.totalRefundAmount,_that.netProfit,_that.totalVendorCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? totalBookings,  int? confirmedBookings,  int? pendingBookings,  int? cancelledBookings,  int? completedBookings,  int? refundedBookings,  num? totalRevenue,  num? totalCollected,  num? totalPending,  num? totalRefundAmount,  num? netProfit,  num? totalVendorCost)  $default,) {final _that = this;
switch (_that) {
case _BookingStatsDto():
return $default(_that.totalBookings,_that.confirmedBookings,_that.pendingBookings,_that.cancelledBookings,_that.completedBookings,_that.refundedBookings,_that.totalRevenue,_that.totalCollected,_that.totalPending,_that.totalRefundAmount,_that.netProfit,_that.totalVendorCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? totalBookings,  int? confirmedBookings,  int? pendingBookings,  int? cancelledBookings,  int? completedBookings,  int? refundedBookings,  num? totalRevenue,  num? totalCollected,  num? totalPending,  num? totalRefundAmount,  num? netProfit,  num? totalVendorCost)?  $default,) {final _that = this;
switch (_that) {
case _BookingStatsDto() when $default != null:
return $default(_that.totalBookings,_that.confirmedBookings,_that.pendingBookings,_that.cancelledBookings,_that.completedBookings,_that.refundedBookings,_that.totalRevenue,_that.totalCollected,_that.totalPending,_that.totalRefundAmount,_that.netProfit,_that.totalVendorCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingStatsDto implements BookingStatsDto {
  const _BookingStatsDto({this.totalBookings, this.confirmedBookings, this.pendingBookings, this.cancelledBookings, this.completedBookings, this.refundedBookings, this.totalRevenue, this.totalCollected, this.totalPending, this.totalRefundAmount, this.netProfit, this.totalVendorCost});
  factory _BookingStatsDto.fromJson(Map<String, dynamic> json) => _$BookingStatsDtoFromJson(json);

@override final  int? totalBookings;
@override final  int? confirmedBookings;
@override final  int? pendingBookings;
@override final  int? cancelledBookings;
@override final  int? completedBookings;
@override final  int? refundedBookings;
@override final  num? totalRevenue;
@override final  num? totalCollected;
@override final  num? totalPending;
@override final  num? totalRefundAmount;
// Only present with the profit-read permission.
@override final  num? netProfit;
@override final  num? totalVendorCost;

/// Create a copy of BookingStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingStatsDtoCopyWith<_BookingStatsDto> get copyWith => __$BookingStatsDtoCopyWithImpl<_BookingStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingStatsDto&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.confirmedBookings, confirmedBookings) || other.confirmedBookings == confirmedBookings)&&(identical(other.pendingBookings, pendingBookings) || other.pendingBookings == pendingBookings)&&(identical(other.cancelledBookings, cancelledBookings) || other.cancelledBookings == cancelledBookings)&&(identical(other.completedBookings, completedBookings) || other.completedBookings == completedBookings)&&(identical(other.refundedBookings, refundedBookings) || other.refundedBookings == refundedBookings)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.totalPending, totalPending) || other.totalPending == totalPending)&&(identical(other.totalRefundAmount, totalRefundAmount) || other.totalRefundAmount == totalRefundAmount)&&(identical(other.netProfit, netProfit) || other.netProfit == netProfit)&&(identical(other.totalVendorCost, totalVendorCost) || other.totalVendorCost == totalVendorCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBookings,confirmedBookings,pendingBookings,cancelledBookings,completedBookings,refundedBookings,totalRevenue,totalCollected,totalPending,totalRefundAmount,netProfit,totalVendorCost);

@override
String toString() {
  return 'BookingStatsDto(totalBookings: $totalBookings, confirmedBookings: $confirmedBookings, pendingBookings: $pendingBookings, cancelledBookings: $cancelledBookings, completedBookings: $completedBookings, refundedBookings: $refundedBookings, totalRevenue: $totalRevenue, totalCollected: $totalCollected, totalPending: $totalPending, totalRefundAmount: $totalRefundAmount, netProfit: $netProfit, totalVendorCost: $totalVendorCost)';
}


}

/// @nodoc
abstract mixin class _$BookingStatsDtoCopyWith<$Res> implements $BookingStatsDtoCopyWith<$Res> {
  factory _$BookingStatsDtoCopyWith(_BookingStatsDto value, $Res Function(_BookingStatsDto) _then) = __$BookingStatsDtoCopyWithImpl;
@override @useResult
$Res call({
 int? totalBookings, int? confirmedBookings, int? pendingBookings, int? cancelledBookings, int? completedBookings, int? refundedBookings, num? totalRevenue, num? totalCollected, num? totalPending, num? totalRefundAmount, num? netProfit, num? totalVendorCost
});




}
/// @nodoc
class __$BookingStatsDtoCopyWithImpl<$Res>
    implements _$BookingStatsDtoCopyWith<$Res> {
  __$BookingStatsDtoCopyWithImpl(this._self, this._then);

  final _BookingStatsDto _self;
  final $Res Function(_BookingStatsDto) _then;

/// Create a copy of BookingStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBookings = freezed,Object? confirmedBookings = freezed,Object? pendingBookings = freezed,Object? cancelledBookings = freezed,Object? completedBookings = freezed,Object? refundedBookings = freezed,Object? totalRevenue = freezed,Object? totalCollected = freezed,Object? totalPending = freezed,Object? totalRefundAmount = freezed,Object? netProfit = freezed,Object? totalVendorCost = freezed,}) {
  return _then(_BookingStatsDto(
totalBookings: freezed == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int?,confirmedBookings: freezed == confirmedBookings ? _self.confirmedBookings : confirmedBookings // ignore: cast_nullable_to_non_nullable
as int?,pendingBookings: freezed == pendingBookings ? _self.pendingBookings : pendingBookings // ignore: cast_nullable_to_non_nullable
as int?,cancelledBookings: freezed == cancelledBookings ? _self.cancelledBookings : cancelledBookings // ignore: cast_nullable_to_non_nullable
as int?,completedBookings: freezed == completedBookings ? _self.completedBookings : completedBookings // ignore: cast_nullable_to_non_nullable
as int?,refundedBookings: freezed == refundedBookings ? _self.refundedBookings : refundedBookings // ignore: cast_nullable_to_non_nullable
as int?,totalRevenue: freezed == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as num?,totalCollected: freezed == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as num?,totalPending: freezed == totalPending ? _self.totalPending : totalPending // ignore: cast_nullable_to_non_nullable
as num?,totalRefundAmount: freezed == totalRefundAmount ? _self.totalRefundAmount : totalRefundAmount // ignore: cast_nullable_to_non_nullable
as num?,netProfit: freezed == netProfit ? _self.netProfit : netProfit // ignore: cast_nullable_to_non_nullable
as num?,totalVendorCost: freezed == totalVendorCost ? _self.totalVendorCost : totalVendorCost // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$BookingServiceDto {

 String? get publicId; String? get serviceType; String? get title; String? get status; String? get vendorName; String? get confirmationNumber; String? get serviceDate; num? get cost;
/// Create a copy of BookingServiceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingServiceDtoCopyWith<BookingServiceDto> get copyWith => _$BookingServiceDtoCopyWithImpl<BookingServiceDto>(this as BookingServiceDto, _$identity);

  /// Serializes this BookingServiceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingServiceDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.confirmationNumber, confirmationNumber) || other.confirmationNumber == confirmationNumber)&&(identical(other.serviceDate, serviceDate) || other.serviceDate == serviceDate)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,serviceType,title,status,vendorName,confirmationNumber,serviceDate,cost);

@override
String toString() {
  return 'BookingServiceDto(publicId: $publicId, serviceType: $serviceType, title: $title, status: $status, vendorName: $vendorName, confirmationNumber: $confirmationNumber, serviceDate: $serviceDate, cost: $cost)';
}


}

/// @nodoc
abstract mixin class $BookingServiceDtoCopyWith<$Res>  {
  factory $BookingServiceDtoCopyWith(BookingServiceDto value, $Res Function(BookingServiceDto) _then) = _$BookingServiceDtoCopyWithImpl;
@useResult
$Res call({
 String? publicId, String? serviceType, String? title, String? status, String? vendorName, String? confirmationNumber, String? serviceDate, num? cost
});




}
/// @nodoc
class _$BookingServiceDtoCopyWithImpl<$Res>
    implements $BookingServiceDtoCopyWith<$Res> {
  _$BookingServiceDtoCopyWithImpl(this._self, this._then);

  final BookingServiceDto _self;
  final $Res Function(BookingServiceDto) _then;

/// Create a copy of BookingServiceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? publicId = freezed,Object? serviceType = freezed,Object? title = freezed,Object? status = freezed,Object? vendorName = freezed,Object? confirmationNumber = freezed,Object? serviceDate = freezed,Object? cost = freezed,}) {
  return _then(_self.copyWith(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,serviceType: freezed == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,confirmationNumber: freezed == confirmationNumber ? _self.confirmationNumber : confirmationNumber // ignore: cast_nullable_to_non_nullable
as String?,serviceDate: freezed == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingServiceDto].
extension BookingServiceDtoPatterns on BookingServiceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingServiceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingServiceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingServiceDto value)  $default,){
final _that = this;
switch (_that) {
case _BookingServiceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingServiceDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookingServiceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? publicId,  String? serviceType,  String? title,  String? status,  String? vendorName,  String? confirmationNumber,  String? serviceDate,  num? cost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingServiceDto() when $default != null:
return $default(_that.publicId,_that.serviceType,_that.title,_that.status,_that.vendorName,_that.confirmationNumber,_that.serviceDate,_that.cost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? publicId,  String? serviceType,  String? title,  String? status,  String? vendorName,  String? confirmationNumber,  String? serviceDate,  num? cost)  $default,) {final _that = this;
switch (_that) {
case _BookingServiceDto():
return $default(_that.publicId,_that.serviceType,_that.title,_that.status,_that.vendorName,_that.confirmationNumber,_that.serviceDate,_that.cost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? publicId,  String? serviceType,  String? title,  String? status,  String? vendorName,  String? confirmationNumber,  String? serviceDate,  num? cost)?  $default,) {final _that = this;
switch (_that) {
case _BookingServiceDto() when $default != null:
return $default(_that.publicId,_that.serviceType,_that.title,_that.status,_that.vendorName,_that.confirmationNumber,_that.serviceDate,_that.cost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookingServiceDto implements BookingServiceDto {
  const _BookingServiceDto({this.publicId, this.serviceType, this.title, this.status, this.vendorName, this.confirmationNumber, this.serviceDate, this.cost});
  factory _BookingServiceDto.fromJson(Map<String, dynamic> json) => _$BookingServiceDtoFromJson(json);

@override final  String? publicId;
@override final  String? serviceType;
@override final  String? title;
@override final  String? status;
@override final  String? vendorName;
@override final  String? confirmationNumber;
@override final  String? serviceDate;
@override final  num? cost;

/// Create a copy of BookingServiceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingServiceDtoCopyWith<_BookingServiceDto> get copyWith => __$BookingServiceDtoCopyWithImpl<_BookingServiceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingServiceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingServiceDto&&(identical(other.publicId, publicId) || other.publicId == publicId)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.title, title) || other.title == title)&&(identical(other.status, status) || other.status == status)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.confirmationNumber, confirmationNumber) || other.confirmationNumber == confirmationNumber)&&(identical(other.serviceDate, serviceDate) || other.serviceDate == serviceDate)&&(identical(other.cost, cost) || other.cost == cost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,publicId,serviceType,title,status,vendorName,confirmationNumber,serviceDate,cost);

@override
String toString() {
  return 'BookingServiceDto(publicId: $publicId, serviceType: $serviceType, title: $title, status: $status, vendorName: $vendorName, confirmationNumber: $confirmationNumber, serviceDate: $serviceDate, cost: $cost)';
}


}

/// @nodoc
abstract mixin class _$BookingServiceDtoCopyWith<$Res> implements $BookingServiceDtoCopyWith<$Res> {
  factory _$BookingServiceDtoCopyWith(_BookingServiceDto value, $Res Function(_BookingServiceDto) _then) = __$BookingServiceDtoCopyWithImpl;
@override @useResult
$Res call({
 String? publicId, String? serviceType, String? title, String? status, String? vendorName, String? confirmationNumber, String? serviceDate, num? cost
});




}
/// @nodoc
class __$BookingServiceDtoCopyWithImpl<$Res>
    implements _$BookingServiceDtoCopyWith<$Res> {
  __$BookingServiceDtoCopyWithImpl(this._self, this._then);

  final _BookingServiceDto _self;
  final $Res Function(_BookingServiceDto) _then;

/// Create a copy of BookingServiceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? publicId = freezed,Object? serviceType = freezed,Object? title = freezed,Object? status = freezed,Object? vendorName = freezed,Object? confirmationNumber = freezed,Object? serviceDate = freezed,Object? cost = freezed,}) {
  return _then(_BookingServiceDto(
publicId: freezed == publicId ? _self.publicId : publicId // ignore: cast_nullable_to_non_nullable
as String?,serviceType: freezed == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,confirmationNumber: freezed == confirmationNumber ? _self.confirmationNumber : confirmationNumber // ignore: cast_nullable_to_non_nullable
as String?,serviceDate: freezed == serviceDate ? _self.serviceDate : serviceDate // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
