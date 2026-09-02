// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerDto {

/// Public UUID.
 String? get id;/// Human code, e.g. `CUS10001`.
 String? get customerId; String? get name; String? get phone; String? get email; String? get alternatePhone; String? get type; String? get commPref; String? get tier; String? get status; String? get city; String? get state; String? get address; String? get pincode; String? get country; String? get gstin; String? get legalName; String? get birthday; String? get anniversary; String? get passportNo; String? get passportExpiry; String? get nationality; String? get panNo; String? get notes; int? get bookings; num? get spent; String? get lastBooking; String? get createdAt;
/// Create a copy of CustomerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerDtoCopyWith<CustomerDto> get copyWith => _$CustomerDtoCopyWithImpl<CustomerDto>(this as CustomerDto, _$identity);

  /// Serializes this CustomerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerDto&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.alternatePhone, alternatePhone) || other.alternatePhone == alternatePhone)&&(identical(other.type, type) || other.type == type)&&(identical(other.commPref, commPref) || other.commPref == commPref)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.address, address) || other.address == address)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.country, country) || other.country == country)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.anniversary, anniversary) || other.anniversary == anniversary)&&(identical(other.passportNo, passportNo) || other.passportNo == passportNo)&&(identical(other.passportExpiry, passportExpiry) || other.passportExpiry == passportExpiry)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.panNo, panNo) || other.panNo == panNo)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.bookings, bookings) || other.bookings == bookings)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.lastBooking, lastBooking) || other.lastBooking == lastBooking)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,name,phone,email,alternatePhone,type,commPref,tier,status,city,state,address,pincode,country,gstin,legalName,birthday,anniversary,passportNo,passportExpiry,nationality,panNo,notes,bookings,spent,lastBooking,createdAt]);

@override
String toString() {
  return 'CustomerDto(id: $id, customerId: $customerId, name: $name, phone: $phone, email: $email, alternatePhone: $alternatePhone, type: $type, commPref: $commPref, tier: $tier, status: $status, city: $city, state: $state, address: $address, pincode: $pincode, country: $country, gstin: $gstin, legalName: $legalName, birthday: $birthday, anniversary: $anniversary, passportNo: $passportNo, passportExpiry: $passportExpiry, nationality: $nationality, panNo: $panNo, notes: $notes, bookings: $bookings, spent: $spent, lastBooking: $lastBooking, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CustomerDtoCopyWith<$Res>  {
  factory $CustomerDtoCopyWith(CustomerDto value, $Res Function(CustomerDto) _then) = _$CustomerDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? customerId, String? name, String? phone, String? email, String? alternatePhone, String? type, String? commPref, String? tier, String? status, String? city, String? state, String? address, String? pincode, String? country, String? gstin, String? legalName, String? birthday, String? anniversary, String? passportNo, String? passportExpiry, String? nationality, String? panNo, String? notes, int? bookings, num? spent, String? lastBooking, String? createdAt
});




}
/// @nodoc
class _$CustomerDtoCopyWithImpl<$Res>
    implements $CustomerDtoCopyWith<$Res> {
  _$CustomerDtoCopyWithImpl(this._self, this._then);

  final CustomerDto _self;
  final $Res Function(CustomerDto) _then;

/// Create a copy of CustomerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerId = freezed,Object? name = freezed,Object? phone = freezed,Object? email = freezed,Object? alternatePhone = freezed,Object? type = freezed,Object? commPref = freezed,Object? tier = freezed,Object? status = freezed,Object? city = freezed,Object? state = freezed,Object? address = freezed,Object? pincode = freezed,Object? country = freezed,Object? gstin = freezed,Object? legalName = freezed,Object? birthday = freezed,Object? anniversary = freezed,Object? passportNo = freezed,Object? passportExpiry = freezed,Object? nationality = freezed,Object? panNo = freezed,Object? notes = freezed,Object? bookings = freezed,Object? spent = freezed,Object? lastBooking = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,alternatePhone: freezed == alternatePhone ? _self.alternatePhone : alternatePhone // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,commPref: freezed == commPref ? _self.commPref : commPref // ignore: cast_nullable_to_non_nullable
as String?,tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,anniversary: freezed == anniversary ? _self.anniversary : anniversary // ignore: cast_nullable_to_non_nullable
as String?,passportNo: freezed == passportNo ? _self.passportNo : passportNo // ignore: cast_nullable_to_non_nullable
as String?,passportExpiry: freezed == passportExpiry ? _self.passportExpiry : passportExpiry // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,panNo: freezed == panNo ? _self.panNo : panNo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bookings: freezed == bookings ? _self.bookings : bookings // ignore: cast_nullable_to_non_nullable
as int?,spent: freezed == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as num?,lastBooking: freezed == lastBooking ? _self.lastBooking : lastBooking // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerDto].
extension CustomerDtoPatterns on CustomerDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerDto value)  $default,){
final _that = this;
switch (_that) {
case _CustomerDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerDto value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? customerId,  String? name,  String? phone,  String? email,  String? alternatePhone,  String? type,  String? commPref,  String? tier,  String? status,  String? city,  String? state,  String? address,  String? pincode,  String? country,  String? gstin,  String? legalName,  String? birthday,  String? anniversary,  String? passportNo,  String? passportExpiry,  String? nationality,  String? panNo,  String? notes,  int? bookings,  num? spent,  String? lastBooking,  String? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerDto() when $default != null:
return $default(_that.id,_that.customerId,_that.name,_that.phone,_that.email,_that.alternatePhone,_that.type,_that.commPref,_that.tier,_that.status,_that.city,_that.state,_that.address,_that.pincode,_that.country,_that.gstin,_that.legalName,_that.birthday,_that.anniversary,_that.passportNo,_that.passportExpiry,_that.nationality,_that.panNo,_that.notes,_that.bookings,_that.spent,_that.lastBooking,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? customerId,  String? name,  String? phone,  String? email,  String? alternatePhone,  String? type,  String? commPref,  String? tier,  String? status,  String? city,  String? state,  String? address,  String? pincode,  String? country,  String? gstin,  String? legalName,  String? birthday,  String? anniversary,  String? passportNo,  String? passportExpiry,  String? nationality,  String? panNo,  String? notes,  int? bookings,  num? spent,  String? lastBooking,  String? createdAt)  $default,) {final _that = this;
switch (_that) {
case _CustomerDto():
return $default(_that.id,_that.customerId,_that.name,_that.phone,_that.email,_that.alternatePhone,_that.type,_that.commPref,_that.tier,_that.status,_that.city,_that.state,_that.address,_that.pincode,_that.country,_that.gstin,_that.legalName,_that.birthday,_that.anniversary,_that.passportNo,_that.passportExpiry,_that.nationality,_that.panNo,_that.notes,_that.bookings,_that.spent,_that.lastBooking,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? customerId,  String? name,  String? phone,  String? email,  String? alternatePhone,  String? type,  String? commPref,  String? tier,  String? status,  String? city,  String? state,  String? address,  String? pincode,  String? country,  String? gstin,  String? legalName,  String? birthday,  String? anniversary,  String? passportNo,  String? passportExpiry,  String? nationality,  String? panNo,  String? notes,  int? bookings,  num? spent,  String? lastBooking,  String? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomerDto() when $default != null:
return $default(_that.id,_that.customerId,_that.name,_that.phone,_that.email,_that.alternatePhone,_that.type,_that.commPref,_that.tier,_that.status,_that.city,_that.state,_that.address,_that.pincode,_that.country,_that.gstin,_that.legalName,_that.birthday,_that.anniversary,_that.passportNo,_that.passportExpiry,_that.nationality,_that.panNo,_that.notes,_that.bookings,_that.spent,_that.lastBooking,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerDto implements CustomerDto {
  const _CustomerDto({this.id, this.customerId, this.name, this.phone, this.email, this.alternatePhone, this.type, this.commPref, this.tier, this.status, this.city, this.state, this.address, this.pincode, this.country, this.gstin, this.legalName, this.birthday, this.anniversary, this.passportNo, this.passportExpiry, this.nationality, this.panNo, this.notes, this.bookings, this.spent, this.lastBooking, this.createdAt});
  factory _CustomerDto.fromJson(Map<String, dynamic> json) => _$CustomerDtoFromJson(json);

/// Public UUID.
@override final  String? id;
/// Human code, e.g. `CUS10001`.
@override final  String? customerId;
@override final  String? name;
@override final  String? phone;
@override final  String? email;
@override final  String? alternatePhone;
@override final  String? type;
@override final  String? commPref;
@override final  String? tier;
@override final  String? status;
@override final  String? city;
@override final  String? state;
@override final  String? address;
@override final  String? pincode;
@override final  String? country;
@override final  String? gstin;
@override final  String? legalName;
@override final  String? birthday;
@override final  String? anniversary;
@override final  String? passportNo;
@override final  String? passportExpiry;
@override final  String? nationality;
@override final  String? panNo;
@override final  String? notes;
@override final  int? bookings;
@override final  num? spent;
@override final  String? lastBooking;
@override final  String? createdAt;

/// Create a copy of CustomerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerDtoCopyWith<_CustomerDto> get copyWith => __$CustomerDtoCopyWithImpl<_CustomerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerDto&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.alternatePhone, alternatePhone) || other.alternatePhone == alternatePhone)&&(identical(other.type, type) || other.type == type)&&(identical(other.commPref, commPref) || other.commPref == commPref)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.address, address) || other.address == address)&&(identical(other.pincode, pincode) || other.pincode == pincode)&&(identical(other.country, country) || other.country == country)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.anniversary, anniversary) || other.anniversary == anniversary)&&(identical(other.passportNo, passportNo) || other.passportNo == passportNo)&&(identical(other.passportExpiry, passportExpiry) || other.passportExpiry == passportExpiry)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.panNo, panNo) || other.panNo == panNo)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.bookings, bookings) || other.bookings == bookings)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.lastBooking, lastBooking) || other.lastBooking == lastBooking)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,name,phone,email,alternatePhone,type,commPref,tier,status,city,state,address,pincode,country,gstin,legalName,birthday,anniversary,passportNo,passportExpiry,nationality,panNo,notes,bookings,spent,lastBooking,createdAt]);

@override
String toString() {
  return 'CustomerDto(id: $id, customerId: $customerId, name: $name, phone: $phone, email: $email, alternatePhone: $alternatePhone, type: $type, commPref: $commPref, tier: $tier, status: $status, city: $city, state: $state, address: $address, pincode: $pincode, country: $country, gstin: $gstin, legalName: $legalName, birthday: $birthday, anniversary: $anniversary, passportNo: $passportNo, passportExpiry: $passportExpiry, nationality: $nationality, panNo: $panNo, notes: $notes, bookings: $bookings, spent: $spent, lastBooking: $lastBooking, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerDtoCopyWith<$Res> implements $CustomerDtoCopyWith<$Res> {
  factory _$CustomerDtoCopyWith(_CustomerDto value, $Res Function(_CustomerDto) _then) = __$CustomerDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? customerId, String? name, String? phone, String? email, String? alternatePhone, String? type, String? commPref, String? tier, String? status, String? city, String? state, String? address, String? pincode, String? country, String? gstin, String? legalName, String? birthday, String? anniversary, String? passportNo, String? passportExpiry, String? nationality, String? panNo, String? notes, int? bookings, num? spent, String? lastBooking, String? createdAt
});




}
/// @nodoc
class __$CustomerDtoCopyWithImpl<$Res>
    implements _$CustomerDtoCopyWith<$Res> {
  __$CustomerDtoCopyWithImpl(this._self, this._then);

  final _CustomerDto _self;
  final $Res Function(_CustomerDto) _then;

/// Create a copy of CustomerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerId = freezed,Object? name = freezed,Object? phone = freezed,Object? email = freezed,Object? alternatePhone = freezed,Object? type = freezed,Object? commPref = freezed,Object? tier = freezed,Object? status = freezed,Object? city = freezed,Object? state = freezed,Object? address = freezed,Object? pincode = freezed,Object? country = freezed,Object? gstin = freezed,Object? legalName = freezed,Object? birthday = freezed,Object? anniversary = freezed,Object? passportNo = freezed,Object? passportExpiry = freezed,Object? nationality = freezed,Object? panNo = freezed,Object? notes = freezed,Object? bookings = freezed,Object? spent = freezed,Object? lastBooking = freezed,Object? createdAt = freezed,}) {
  return _then(_CustomerDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,alternatePhone: freezed == alternatePhone ? _self.alternatePhone : alternatePhone // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,commPref: freezed == commPref ? _self.commPref : commPref // ignore: cast_nullable_to_non_nullable
as String?,tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,pincode: freezed == pincode ? _self.pincode : pincode // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as String?,anniversary: freezed == anniversary ? _self.anniversary : anniversary // ignore: cast_nullable_to_non_nullable
as String?,passportNo: freezed == passportNo ? _self.passportNo : passportNo // ignore: cast_nullable_to_non_nullable
as String?,passportExpiry: freezed == passportExpiry ? _self.passportExpiry : passportExpiry // ignore: cast_nullable_to_non_nullable
as String?,nationality: freezed == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String?,panNo: freezed == panNo ? _self.panNo : panNo // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,bookings: freezed == bookings ? _self.bookings : bookings // ignore: cast_nullable_to_non_nullable
as int?,spent: freezed == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as num?,lastBooking: freezed == lastBooking ? _self.lastBooking : lastBooking // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CustomerSummaryDto {

 String? get id; String? get customerId; String? get name; String? get legalName; String? get phone; String? get alternatePhone; String? get email; String? get type; String? get tier; String? get status; String? get commPref; String? get city; String? get state; String? get country; String? get gstin; String? get ownerUserName; num? get totalBilled; num? get totalCollected; num? get outstanding; num? get totalRefunded; int? get activeBookingCount; int? get cancelledBookingCount; String? get lastBookingDate; String? get nextDueTravelDate; int? get leadCount; int? get quotationCount; int? get invoiceCount; int? get documentCount; int? get documentsExpiringSoon; String? get passportExpiry; bool? get hasPortalAccount;
/// Create a copy of CustomerSummaryDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerSummaryDtoCopyWith<CustomerSummaryDto> get copyWith => _$CustomerSummaryDtoCopyWithImpl<CustomerSummaryDto>(this as CustomerSummaryDto, _$identity);

  /// Serializes this CustomerSummaryDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerSummaryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.alternatePhone, alternatePhone) || other.alternatePhone == alternatePhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.commPref, commPref) || other.commPref == commPref)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.ownerUserName, ownerUserName) || other.ownerUserName == ownerUserName)&&(identical(other.totalBilled, totalBilled) || other.totalBilled == totalBilled)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.totalRefunded, totalRefunded) || other.totalRefunded == totalRefunded)&&(identical(other.activeBookingCount, activeBookingCount) || other.activeBookingCount == activeBookingCount)&&(identical(other.cancelledBookingCount, cancelledBookingCount) || other.cancelledBookingCount == cancelledBookingCount)&&(identical(other.lastBookingDate, lastBookingDate) || other.lastBookingDate == lastBookingDate)&&(identical(other.nextDueTravelDate, nextDueTravelDate) || other.nextDueTravelDate == nextDueTravelDate)&&(identical(other.leadCount, leadCount) || other.leadCount == leadCount)&&(identical(other.quotationCount, quotationCount) || other.quotationCount == quotationCount)&&(identical(other.invoiceCount, invoiceCount) || other.invoiceCount == invoiceCount)&&(identical(other.documentCount, documentCount) || other.documentCount == documentCount)&&(identical(other.documentsExpiringSoon, documentsExpiringSoon) || other.documentsExpiringSoon == documentsExpiringSoon)&&(identical(other.passportExpiry, passportExpiry) || other.passportExpiry == passportExpiry)&&(identical(other.hasPortalAccount, hasPortalAccount) || other.hasPortalAccount == hasPortalAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,name,legalName,phone,alternatePhone,email,type,tier,status,commPref,city,state,country,gstin,ownerUserName,totalBilled,totalCollected,outstanding,totalRefunded,activeBookingCount,cancelledBookingCount,lastBookingDate,nextDueTravelDate,leadCount,quotationCount,invoiceCount,documentCount,documentsExpiringSoon,passportExpiry,hasPortalAccount]);

@override
String toString() {
  return 'CustomerSummaryDto(id: $id, customerId: $customerId, name: $name, legalName: $legalName, phone: $phone, alternatePhone: $alternatePhone, email: $email, type: $type, tier: $tier, status: $status, commPref: $commPref, city: $city, state: $state, country: $country, gstin: $gstin, ownerUserName: $ownerUserName, totalBilled: $totalBilled, totalCollected: $totalCollected, outstanding: $outstanding, totalRefunded: $totalRefunded, activeBookingCount: $activeBookingCount, cancelledBookingCount: $cancelledBookingCount, lastBookingDate: $lastBookingDate, nextDueTravelDate: $nextDueTravelDate, leadCount: $leadCount, quotationCount: $quotationCount, invoiceCount: $invoiceCount, documentCount: $documentCount, documentsExpiringSoon: $documentsExpiringSoon, passportExpiry: $passportExpiry, hasPortalAccount: $hasPortalAccount)';
}


}

/// @nodoc
abstract mixin class $CustomerSummaryDtoCopyWith<$Res>  {
  factory $CustomerSummaryDtoCopyWith(CustomerSummaryDto value, $Res Function(CustomerSummaryDto) _then) = _$CustomerSummaryDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? customerId, String? name, String? legalName, String? phone, String? alternatePhone, String? email, String? type, String? tier, String? status, String? commPref, String? city, String? state, String? country, String? gstin, String? ownerUserName, num? totalBilled, num? totalCollected, num? outstanding, num? totalRefunded, int? activeBookingCount, int? cancelledBookingCount, String? lastBookingDate, String? nextDueTravelDate, int? leadCount, int? quotationCount, int? invoiceCount, int? documentCount, int? documentsExpiringSoon, String? passportExpiry, bool? hasPortalAccount
});




}
/// @nodoc
class _$CustomerSummaryDtoCopyWithImpl<$Res>
    implements $CustomerSummaryDtoCopyWith<$Res> {
  _$CustomerSummaryDtoCopyWithImpl(this._self, this._then);

  final CustomerSummaryDto _self;
  final $Res Function(CustomerSummaryDto) _then;

/// Create a copy of CustomerSummaryDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerId = freezed,Object? name = freezed,Object? legalName = freezed,Object? phone = freezed,Object? alternatePhone = freezed,Object? email = freezed,Object? type = freezed,Object? tier = freezed,Object? status = freezed,Object? commPref = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? gstin = freezed,Object? ownerUserName = freezed,Object? totalBilled = freezed,Object? totalCollected = freezed,Object? outstanding = freezed,Object? totalRefunded = freezed,Object? activeBookingCount = freezed,Object? cancelledBookingCount = freezed,Object? lastBookingDate = freezed,Object? nextDueTravelDate = freezed,Object? leadCount = freezed,Object? quotationCount = freezed,Object? invoiceCount = freezed,Object? documentCount = freezed,Object? documentsExpiringSoon = freezed,Object? passportExpiry = freezed,Object? hasPortalAccount = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,alternatePhone: freezed == alternatePhone ? _self.alternatePhone : alternatePhone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,commPref: freezed == commPref ? _self.commPref : commPref // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,ownerUserName: freezed == ownerUserName ? _self.ownerUserName : ownerUserName // ignore: cast_nullable_to_non_nullable
as String?,totalBilled: freezed == totalBilled ? _self.totalBilled : totalBilled // ignore: cast_nullable_to_non_nullable
as num?,totalCollected: freezed == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as num?,outstanding: freezed == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as num?,totalRefunded: freezed == totalRefunded ? _self.totalRefunded : totalRefunded // ignore: cast_nullable_to_non_nullable
as num?,activeBookingCount: freezed == activeBookingCount ? _self.activeBookingCount : activeBookingCount // ignore: cast_nullable_to_non_nullable
as int?,cancelledBookingCount: freezed == cancelledBookingCount ? _self.cancelledBookingCount : cancelledBookingCount // ignore: cast_nullable_to_non_nullable
as int?,lastBookingDate: freezed == lastBookingDate ? _self.lastBookingDate : lastBookingDate // ignore: cast_nullable_to_non_nullable
as String?,nextDueTravelDate: freezed == nextDueTravelDate ? _self.nextDueTravelDate : nextDueTravelDate // ignore: cast_nullable_to_non_nullable
as String?,leadCount: freezed == leadCount ? _self.leadCount : leadCount // ignore: cast_nullable_to_non_nullable
as int?,quotationCount: freezed == quotationCount ? _self.quotationCount : quotationCount // ignore: cast_nullable_to_non_nullable
as int?,invoiceCount: freezed == invoiceCount ? _self.invoiceCount : invoiceCount // ignore: cast_nullable_to_non_nullable
as int?,documentCount: freezed == documentCount ? _self.documentCount : documentCount // ignore: cast_nullable_to_non_nullable
as int?,documentsExpiringSoon: freezed == documentsExpiringSoon ? _self.documentsExpiringSoon : documentsExpiringSoon // ignore: cast_nullable_to_non_nullable
as int?,passportExpiry: freezed == passportExpiry ? _self.passportExpiry : passportExpiry // ignore: cast_nullable_to_non_nullable
as String?,hasPortalAccount: freezed == hasPortalAccount ? _self.hasPortalAccount : hasPortalAccount // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerSummaryDto].
extension CustomerSummaryDtoPatterns on CustomerSummaryDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerSummaryDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerSummaryDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerSummaryDto value)  $default,){
final _that = this;
switch (_that) {
case _CustomerSummaryDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerSummaryDto value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerSummaryDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? customerId,  String? name,  String? legalName,  String? phone,  String? alternatePhone,  String? email,  String? type,  String? tier,  String? status,  String? commPref,  String? city,  String? state,  String? country,  String? gstin,  String? ownerUserName,  num? totalBilled,  num? totalCollected,  num? outstanding,  num? totalRefunded,  int? activeBookingCount,  int? cancelledBookingCount,  String? lastBookingDate,  String? nextDueTravelDate,  int? leadCount,  int? quotationCount,  int? invoiceCount,  int? documentCount,  int? documentsExpiringSoon,  String? passportExpiry,  bool? hasPortalAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerSummaryDto() when $default != null:
return $default(_that.id,_that.customerId,_that.name,_that.legalName,_that.phone,_that.alternatePhone,_that.email,_that.type,_that.tier,_that.status,_that.commPref,_that.city,_that.state,_that.country,_that.gstin,_that.ownerUserName,_that.totalBilled,_that.totalCollected,_that.outstanding,_that.totalRefunded,_that.activeBookingCount,_that.cancelledBookingCount,_that.lastBookingDate,_that.nextDueTravelDate,_that.leadCount,_that.quotationCount,_that.invoiceCount,_that.documentCount,_that.documentsExpiringSoon,_that.passportExpiry,_that.hasPortalAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? customerId,  String? name,  String? legalName,  String? phone,  String? alternatePhone,  String? email,  String? type,  String? tier,  String? status,  String? commPref,  String? city,  String? state,  String? country,  String? gstin,  String? ownerUserName,  num? totalBilled,  num? totalCollected,  num? outstanding,  num? totalRefunded,  int? activeBookingCount,  int? cancelledBookingCount,  String? lastBookingDate,  String? nextDueTravelDate,  int? leadCount,  int? quotationCount,  int? invoiceCount,  int? documentCount,  int? documentsExpiringSoon,  String? passportExpiry,  bool? hasPortalAccount)  $default,) {final _that = this;
switch (_that) {
case _CustomerSummaryDto():
return $default(_that.id,_that.customerId,_that.name,_that.legalName,_that.phone,_that.alternatePhone,_that.email,_that.type,_that.tier,_that.status,_that.commPref,_that.city,_that.state,_that.country,_that.gstin,_that.ownerUserName,_that.totalBilled,_that.totalCollected,_that.outstanding,_that.totalRefunded,_that.activeBookingCount,_that.cancelledBookingCount,_that.lastBookingDate,_that.nextDueTravelDate,_that.leadCount,_that.quotationCount,_that.invoiceCount,_that.documentCount,_that.documentsExpiringSoon,_that.passportExpiry,_that.hasPortalAccount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? customerId,  String? name,  String? legalName,  String? phone,  String? alternatePhone,  String? email,  String? type,  String? tier,  String? status,  String? commPref,  String? city,  String? state,  String? country,  String? gstin,  String? ownerUserName,  num? totalBilled,  num? totalCollected,  num? outstanding,  num? totalRefunded,  int? activeBookingCount,  int? cancelledBookingCount,  String? lastBookingDate,  String? nextDueTravelDate,  int? leadCount,  int? quotationCount,  int? invoiceCount,  int? documentCount,  int? documentsExpiringSoon,  String? passportExpiry,  bool? hasPortalAccount)?  $default,) {final _that = this;
switch (_that) {
case _CustomerSummaryDto() when $default != null:
return $default(_that.id,_that.customerId,_that.name,_that.legalName,_that.phone,_that.alternatePhone,_that.email,_that.type,_that.tier,_that.status,_that.commPref,_that.city,_that.state,_that.country,_that.gstin,_that.ownerUserName,_that.totalBilled,_that.totalCollected,_that.outstanding,_that.totalRefunded,_that.activeBookingCount,_that.cancelledBookingCount,_that.lastBookingDate,_that.nextDueTravelDate,_that.leadCount,_that.quotationCount,_that.invoiceCount,_that.documentCount,_that.documentsExpiringSoon,_that.passportExpiry,_that.hasPortalAccount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerSummaryDto implements CustomerSummaryDto {
  const _CustomerSummaryDto({this.id, this.customerId, this.name, this.legalName, this.phone, this.alternatePhone, this.email, this.type, this.tier, this.status, this.commPref, this.city, this.state, this.country, this.gstin, this.ownerUserName, this.totalBilled, this.totalCollected, this.outstanding, this.totalRefunded, this.activeBookingCount, this.cancelledBookingCount, this.lastBookingDate, this.nextDueTravelDate, this.leadCount, this.quotationCount, this.invoiceCount, this.documentCount, this.documentsExpiringSoon, this.passportExpiry, this.hasPortalAccount});
  factory _CustomerSummaryDto.fromJson(Map<String, dynamic> json) => _$CustomerSummaryDtoFromJson(json);

@override final  String? id;
@override final  String? customerId;
@override final  String? name;
@override final  String? legalName;
@override final  String? phone;
@override final  String? alternatePhone;
@override final  String? email;
@override final  String? type;
@override final  String? tier;
@override final  String? status;
@override final  String? commPref;
@override final  String? city;
@override final  String? state;
@override final  String? country;
@override final  String? gstin;
@override final  String? ownerUserName;
@override final  num? totalBilled;
@override final  num? totalCollected;
@override final  num? outstanding;
@override final  num? totalRefunded;
@override final  int? activeBookingCount;
@override final  int? cancelledBookingCount;
@override final  String? lastBookingDate;
@override final  String? nextDueTravelDate;
@override final  int? leadCount;
@override final  int? quotationCount;
@override final  int? invoiceCount;
@override final  int? documentCount;
@override final  int? documentsExpiringSoon;
@override final  String? passportExpiry;
@override final  bool? hasPortalAccount;

/// Create a copy of CustomerSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerSummaryDtoCopyWith<_CustomerSummaryDto> get copyWith => __$CustomerSummaryDtoCopyWithImpl<_CustomerSummaryDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerSummaryDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerSummaryDto&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.alternatePhone, alternatePhone) || other.alternatePhone == alternatePhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.commPref, commPref) || other.commPref == commPref)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.ownerUserName, ownerUserName) || other.ownerUserName == ownerUserName)&&(identical(other.totalBilled, totalBilled) || other.totalBilled == totalBilled)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.outstanding, outstanding) || other.outstanding == outstanding)&&(identical(other.totalRefunded, totalRefunded) || other.totalRefunded == totalRefunded)&&(identical(other.activeBookingCount, activeBookingCount) || other.activeBookingCount == activeBookingCount)&&(identical(other.cancelledBookingCount, cancelledBookingCount) || other.cancelledBookingCount == cancelledBookingCount)&&(identical(other.lastBookingDate, lastBookingDate) || other.lastBookingDate == lastBookingDate)&&(identical(other.nextDueTravelDate, nextDueTravelDate) || other.nextDueTravelDate == nextDueTravelDate)&&(identical(other.leadCount, leadCount) || other.leadCount == leadCount)&&(identical(other.quotationCount, quotationCount) || other.quotationCount == quotationCount)&&(identical(other.invoiceCount, invoiceCount) || other.invoiceCount == invoiceCount)&&(identical(other.documentCount, documentCount) || other.documentCount == documentCount)&&(identical(other.documentsExpiringSoon, documentsExpiringSoon) || other.documentsExpiringSoon == documentsExpiringSoon)&&(identical(other.passportExpiry, passportExpiry) || other.passportExpiry == passportExpiry)&&(identical(other.hasPortalAccount, hasPortalAccount) || other.hasPortalAccount == hasPortalAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,name,legalName,phone,alternatePhone,email,type,tier,status,commPref,city,state,country,gstin,ownerUserName,totalBilled,totalCollected,outstanding,totalRefunded,activeBookingCount,cancelledBookingCount,lastBookingDate,nextDueTravelDate,leadCount,quotationCount,invoiceCount,documentCount,documentsExpiringSoon,passportExpiry,hasPortalAccount]);

@override
String toString() {
  return 'CustomerSummaryDto(id: $id, customerId: $customerId, name: $name, legalName: $legalName, phone: $phone, alternatePhone: $alternatePhone, email: $email, type: $type, tier: $tier, status: $status, commPref: $commPref, city: $city, state: $state, country: $country, gstin: $gstin, ownerUserName: $ownerUserName, totalBilled: $totalBilled, totalCollected: $totalCollected, outstanding: $outstanding, totalRefunded: $totalRefunded, activeBookingCount: $activeBookingCount, cancelledBookingCount: $cancelledBookingCount, lastBookingDate: $lastBookingDate, nextDueTravelDate: $nextDueTravelDate, leadCount: $leadCount, quotationCount: $quotationCount, invoiceCount: $invoiceCount, documentCount: $documentCount, documentsExpiringSoon: $documentsExpiringSoon, passportExpiry: $passportExpiry, hasPortalAccount: $hasPortalAccount)';
}


}

/// @nodoc
abstract mixin class _$CustomerSummaryDtoCopyWith<$Res> implements $CustomerSummaryDtoCopyWith<$Res> {
  factory _$CustomerSummaryDtoCopyWith(_CustomerSummaryDto value, $Res Function(_CustomerSummaryDto) _then) = __$CustomerSummaryDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? customerId, String? name, String? legalName, String? phone, String? alternatePhone, String? email, String? type, String? tier, String? status, String? commPref, String? city, String? state, String? country, String? gstin, String? ownerUserName, num? totalBilled, num? totalCollected, num? outstanding, num? totalRefunded, int? activeBookingCount, int? cancelledBookingCount, String? lastBookingDate, String? nextDueTravelDate, int? leadCount, int? quotationCount, int? invoiceCount, int? documentCount, int? documentsExpiringSoon, String? passportExpiry, bool? hasPortalAccount
});




}
/// @nodoc
class __$CustomerSummaryDtoCopyWithImpl<$Res>
    implements _$CustomerSummaryDtoCopyWith<$Res> {
  __$CustomerSummaryDtoCopyWithImpl(this._self, this._then);

  final _CustomerSummaryDto _self;
  final $Res Function(_CustomerSummaryDto) _then;

/// Create a copy of CustomerSummaryDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerId = freezed,Object? name = freezed,Object? legalName = freezed,Object? phone = freezed,Object? alternatePhone = freezed,Object? email = freezed,Object? type = freezed,Object? tier = freezed,Object? status = freezed,Object? commPref = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? gstin = freezed,Object? ownerUserName = freezed,Object? totalBilled = freezed,Object? totalCollected = freezed,Object? outstanding = freezed,Object? totalRefunded = freezed,Object? activeBookingCount = freezed,Object? cancelledBookingCount = freezed,Object? lastBookingDate = freezed,Object? nextDueTravelDate = freezed,Object? leadCount = freezed,Object? quotationCount = freezed,Object? invoiceCount = freezed,Object? documentCount = freezed,Object? documentsExpiringSoon = freezed,Object? passportExpiry = freezed,Object? hasPortalAccount = freezed,}) {
  return _then(_CustomerSummaryDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,legalName: freezed == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,alternatePhone: freezed == alternatePhone ? _self.alternatePhone : alternatePhone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,tier: freezed == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,commPref: freezed == commPref ? _self.commPref : commPref // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,ownerUserName: freezed == ownerUserName ? _self.ownerUserName : ownerUserName // ignore: cast_nullable_to_non_nullable
as String?,totalBilled: freezed == totalBilled ? _self.totalBilled : totalBilled // ignore: cast_nullable_to_non_nullable
as num?,totalCollected: freezed == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as num?,outstanding: freezed == outstanding ? _self.outstanding : outstanding // ignore: cast_nullable_to_non_nullable
as num?,totalRefunded: freezed == totalRefunded ? _self.totalRefunded : totalRefunded // ignore: cast_nullable_to_non_nullable
as num?,activeBookingCount: freezed == activeBookingCount ? _self.activeBookingCount : activeBookingCount // ignore: cast_nullable_to_non_nullable
as int?,cancelledBookingCount: freezed == cancelledBookingCount ? _self.cancelledBookingCount : cancelledBookingCount // ignore: cast_nullable_to_non_nullable
as int?,lastBookingDate: freezed == lastBookingDate ? _self.lastBookingDate : lastBookingDate // ignore: cast_nullable_to_non_nullable
as String?,nextDueTravelDate: freezed == nextDueTravelDate ? _self.nextDueTravelDate : nextDueTravelDate // ignore: cast_nullable_to_non_nullable
as String?,leadCount: freezed == leadCount ? _self.leadCount : leadCount // ignore: cast_nullable_to_non_nullable
as int?,quotationCount: freezed == quotationCount ? _self.quotationCount : quotationCount // ignore: cast_nullable_to_non_nullable
as int?,invoiceCount: freezed == invoiceCount ? _self.invoiceCount : invoiceCount // ignore: cast_nullable_to_non_nullable
as int?,documentCount: freezed == documentCount ? _self.documentCount : documentCount // ignore: cast_nullable_to_non_nullable
as int?,documentsExpiringSoon: freezed == documentsExpiringSoon ? _self.documentsExpiringSoon : documentsExpiringSoon // ignore: cast_nullable_to_non_nullable
as int?,passportExpiry: freezed == passportExpiry ? _self.passportExpiry : passportExpiry // ignore: cast_nullable_to_non_nullable
as String?,hasPortalAccount: freezed == hasPortalAccount ? _self.hasPortalAccount : hasPortalAccount // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$CustomerStatsDto {

 int? get total; int? get active; int? get inactive; int? get blocked; int? get vip; int? get corporate; int? get regular; num? get totalRevenue; int? get totalBookings; int? get repeatCustomers;
/// Create a copy of CustomerStatsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerStatsDtoCopyWith<CustomerStatsDto> get copyWith => _$CustomerStatsDtoCopyWithImpl<CustomerStatsDto>(this as CustomerStatsDto, _$identity);

  /// Serializes this CustomerStatsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerStatsDto&&(identical(other.total, total) || other.total == total)&&(identical(other.active, active) || other.active == active)&&(identical(other.inactive, inactive) || other.inactive == inactive)&&(identical(other.blocked, blocked) || other.blocked == blocked)&&(identical(other.vip, vip) || other.vip == vip)&&(identical(other.corporate, corporate) || other.corporate == corporate)&&(identical(other.regular, regular) || other.regular == regular)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.repeatCustomers, repeatCustomers) || other.repeatCustomers == repeatCustomers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,active,inactive,blocked,vip,corporate,regular,totalRevenue,totalBookings,repeatCustomers);

@override
String toString() {
  return 'CustomerStatsDto(total: $total, active: $active, inactive: $inactive, blocked: $blocked, vip: $vip, corporate: $corporate, regular: $regular, totalRevenue: $totalRevenue, totalBookings: $totalBookings, repeatCustomers: $repeatCustomers)';
}


}

/// @nodoc
abstract mixin class $CustomerStatsDtoCopyWith<$Res>  {
  factory $CustomerStatsDtoCopyWith(CustomerStatsDto value, $Res Function(CustomerStatsDto) _then) = _$CustomerStatsDtoCopyWithImpl;
@useResult
$Res call({
 int? total, int? active, int? inactive, int? blocked, int? vip, int? corporate, int? regular, num? totalRevenue, int? totalBookings, int? repeatCustomers
});




}
/// @nodoc
class _$CustomerStatsDtoCopyWithImpl<$Res>
    implements $CustomerStatsDtoCopyWith<$Res> {
  _$CustomerStatsDtoCopyWithImpl(this._self, this._then);

  final CustomerStatsDto _self;
  final $Res Function(CustomerStatsDto) _then;

/// Create a copy of CustomerStatsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = freezed,Object? active = freezed,Object? inactive = freezed,Object? blocked = freezed,Object? vip = freezed,Object? corporate = freezed,Object? regular = freezed,Object? totalRevenue = freezed,Object? totalBookings = freezed,Object? repeatCustomers = freezed,}) {
  return _then(_self.copyWith(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int?,inactive: freezed == inactive ? _self.inactive : inactive // ignore: cast_nullable_to_non_nullable
as int?,blocked: freezed == blocked ? _self.blocked : blocked // ignore: cast_nullable_to_non_nullable
as int?,vip: freezed == vip ? _self.vip : vip // ignore: cast_nullable_to_non_nullable
as int?,corporate: freezed == corporate ? _self.corporate : corporate // ignore: cast_nullable_to_non_nullable
as int?,regular: freezed == regular ? _self.regular : regular // ignore: cast_nullable_to_non_nullable
as int?,totalRevenue: freezed == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as num?,totalBookings: freezed == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int?,repeatCustomers: freezed == repeatCustomers ? _self.repeatCustomers : repeatCustomers // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerStatsDto].
extension CustomerStatsDtoPatterns on CustomerStatsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerStatsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerStatsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerStatsDto value)  $default,){
final _that = this;
switch (_that) {
case _CustomerStatsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerStatsDto value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerStatsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? total,  int? active,  int? inactive,  int? blocked,  int? vip,  int? corporate,  int? regular,  num? totalRevenue,  int? totalBookings,  int? repeatCustomers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerStatsDto() when $default != null:
return $default(_that.total,_that.active,_that.inactive,_that.blocked,_that.vip,_that.corporate,_that.regular,_that.totalRevenue,_that.totalBookings,_that.repeatCustomers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? total,  int? active,  int? inactive,  int? blocked,  int? vip,  int? corporate,  int? regular,  num? totalRevenue,  int? totalBookings,  int? repeatCustomers)  $default,) {final _that = this;
switch (_that) {
case _CustomerStatsDto():
return $default(_that.total,_that.active,_that.inactive,_that.blocked,_that.vip,_that.corporate,_that.regular,_that.totalRevenue,_that.totalBookings,_that.repeatCustomers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? total,  int? active,  int? inactive,  int? blocked,  int? vip,  int? corporate,  int? regular,  num? totalRevenue,  int? totalBookings,  int? repeatCustomers)?  $default,) {final _that = this;
switch (_that) {
case _CustomerStatsDto() when $default != null:
return $default(_that.total,_that.active,_that.inactive,_that.blocked,_that.vip,_that.corporate,_that.regular,_that.totalRevenue,_that.totalBookings,_that.repeatCustomers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerStatsDto implements CustomerStatsDto {
  const _CustomerStatsDto({this.total, this.active, this.inactive, this.blocked, this.vip, this.corporate, this.regular, this.totalRevenue, this.totalBookings, this.repeatCustomers});
  factory _CustomerStatsDto.fromJson(Map<String, dynamic> json) => _$CustomerStatsDtoFromJson(json);

@override final  int? total;
@override final  int? active;
@override final  int? inactive;
@override final  int? blocked;
@override final  int? vip;
@override final  int? corporate;
@override final  int? regular;
@override final  num? totalRevenue;
@override final  int? totalBookings;
@override final  int? repeatCustomers;

/// Create a copy of CustomerStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerStatsDtoCopyWith<_CustomerStatsDto> get copyWith => __$CustomerStatsDtoCopyWithImpl<_CustomerStatsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerStatsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerStatsDto&&(identical(other.total, total) || other.total == total)&&(identical(other.active, active) || other.active == active)&&(identical(other.inactive, inactive) || other.inactive == inactive)&&(identical(other.blocked, blocked) || other.blocked == blocked)&&(identical(other.vip, vip) || other.vip == vip)&&(identical(other.corporate, corporate) || other.corporate == corporate)&&(identical(other.regular, regular) || other.regular == regular)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalBookings, totalBookings) || other.totalBookings == totalBookings)&&(identical(other.repeatCustomers, repeatCustomers) || other.repeatCustomers == repeatCustomers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,active,inactive,blocked,vip,corporate,regular,totalRevenue,totalBookings,repeatCustomers);

@override
String toString() {
  return 'CustomerStatsDto(total: $total, active: $active, inactive: $inactive, blocked: $blocked, vip: $vip, corporate: $corporate, regular: $regular, totalRevenue: $totalRevenue, totalBookings: $totalBookings, repeatCustomers: $repeatCustomers)';
}


}

/// @nodoc
abstract mixin class _$CustomerStatsDtoCopyWith<$Res> implements $CustomerStatsDtoCopyWith<$Res> {
  factory _$CustomerStatsDtoCopyWith(_CustomerStatsDto value, $Res Function(_CustomerStatsDto) _then) = __$CustomerStatsDtoCopyWithImpl;
@override @useResult
$Res call({
 int? total, int? active, int? inactive, int? blocked, int? vip, int? corporate, int? regular, num? totalRevenue, int? totalBookings, int? repeatCustomers
});




}
/// @nodoc
class __$CustomerStatsDtoCopyWithImpl<$Res>
    implements _$CustomerStatsDtoCopyWith<$Res> {
  __$CustomerStatsDtoCopyWithImpl(this._self, this._then);

  final _CustomerStatsDto _self;
  final $Res Function(_CustomerStatsDto) _then;

/// Create a copy of CustomerStatsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = freezed,Object? active = freezed,Object? inactive = freezed,Object? blocked = freezed,Object? vip = freezed,Object? corporate = freezed,Object? regular = freezed,Object? totalRevenue = freezed,Object? totalBookings = freezed,Object? repeatCustomers = freezed,}) {
  return _then(_CustomerStatsDto(
total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as int?,inactive: freezed == inactive ? _self.inactive : inactive // ignore: cast_nullable_to_non_nullable
as int?,blocked: freezed == blocked ? _self.blocked : blocked // ignore: cast_nullable_to_non_nullable
as int?,vip: freezed == vip ? _self.vip : vip // ignore: cast_nullable_to_non_nullable
as int?,corporate: freezed == corporate ? _self.corporate : corporate // ignore: cast_nullable_to_non_nullable
as int?,regular: freezed == regular ? _self.regular : regular // ignore: cast_nullable_to_non_nullable
as int?,totalRevenue: freezed == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as num?,totalBookings: freezed == totalBookings ? _self.totalBookings : totalBookings // ignore: cast_nullable_to_non_nullable
as int?,repeatCustomers: freezed == repeatCustomers ? _self.repeatCustomers : repeatCustomers // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
