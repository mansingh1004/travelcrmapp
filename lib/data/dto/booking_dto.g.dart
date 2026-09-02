// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingDto _$BookingDtoFromJson(Map<String, dynamic> json) => _BookingDto(
  publicId: json['publicId'] as String?,
  bookingCode: json['bookingCode'] as String?,
  customerId: json['customerId'] as String?,
  customerNameSnapshot: json['customerNameSnapshot'] as String?,
  destinationSnapshot: json['destinationSnapshot'] as String?,
  sourceLeadPublicId: json['sourceLeadPublicId'] as String?,
  sourceQuotationPublicId: json['sourceQuotationPublicId'] as String?,
  assignedUserId: json['assignedUserId'] as String?,
  assignedUserName: json['assignedUserName'] as String?,
  bookingDate: json['bookingDate'] as String?,
  travelDate: json['travelDate'] as String?,
  overseasTourPackage: json['overseasTourPackage'] as bool?,
  customerAmount: json['customerAmount'] as num?,
  vendorCost: json['vendorCost'] as num?,
  vendorPublicId: json['vendorPublicId'] as String?,
  vendorName: json['vendorName'] as String?,
  gst: json['gst'] as num?,
  tcs: json['tcs'] as num?,
  totalPayable: json['totalPayable'] as num?,
  paidAmount: json['paidAmount'] as num?,
  pendingAmount: json['pendingAmount'] as num?,
  refundedAmount: json['refundedAmount'] as num?,
  netProfit: json['netProfit'] as num?,
  status: json['status'] as String?,
  paymentStatus: json['paymentStatus'] as String?,
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  tripSnapshot: json['tripSnapshot'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$BookingDtoToJson(_BookingDto instance) =>
    <String, dynamic>{
      'publicId': instance.publicId,
      'bookingCode': instance.bookingCode,
      'customerId': instance.customerId,
      'customerNameSnapshot': instance.customerNameSnapshot,
      'destinationSnapshot': instance.destinationSnapshot,
      'sourceLeadPublicId': instance.sourceLeadPublicId,
      'sourceQuotationPublicId': instance.sourceQuotationPublicId,
      'assignedUserId': instance.assignedUserId,
      'assignedUserName': instance.assignedUserName,
      'bookingDate': instance.bookingDate,
      'travelDate': instance.travelDate,
      'overseasTourPackage': instance.overseasTourPackage,
      'customerAmount': instance.customerAmount,
      'vendorCost': instance.vendorCost,
      'vendorPublicId': instance.vendorPublicId,
      'vendorName': instance.vendorName,
      'gst': instance.gst,
      'tcs': instance.tcs,
      'totalPayable': instance.totalPayable,
      'paidAmount': instance.paidAmount,
      'pendingAmount': instance.pendingAmount,
      'refundedAmount': instance.refundedAmount,
      'netProfit': instance.netProfit,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'services': instance.services,
      'tripSnapshot': instance.tripSnapshot,
      'createdAt': instance.createdAt,
    };

_BookingStatsDto _$BookingStatsDtoFromJson(Map<String, dynamic> json) =>
    _BookingStatsDto(
      totalBookings: (json['totalBookings'] as num?)?.toInt(),
      confirmedBookings: (json['confirmedBookings'] as num?)?.toInt(),
      pendingBookings: (json['pendingBookings'] as num?)?.toInt(),
      cancelledBookings: (json['cancelledBookings'] as num?)?.toInt(),
      completedBookings: (json['completedBookings'] as num?)?.toInt(),
      refundedBookings: (json['refundedBookings'] as num?)?.toInt(),
      totalRevenue: json['totalRevenue'] as num?,
      totalCollected: json['totalCollected'] as num?,
      totalPending: json['totalPending'] as num?,
      totalRefundAmount: json['totalRefundAmount'] as num?,
      netProfit: json['netProfit'] as num?,
      totalVendorCost: json['totalVendorCost'] as num?,
    );

Map<String, dynamic> _$BookingStatsDtoToJson(_BookingStatsDto instance) =>
    <String, dynamic>{
      'totalBookings': instance.totalBookings,
      'confirmedBookings': instance.confirmedBookings,
      'pendingBookings': instance.pendingBookings,
      'cancelledBookings': instance.cancelledBookings,
      'completedBookings': instance.completedBookings,
      'refundedBookings': instance.refundedBookings,
      'totalRevenue': instance.totalRevenue,
      'totalCollected': instance.totalCollected,
      'totalPending': instance.totalPending,
      'totalRefundAmount': instance.totalRefundAmount,
      'netProfit': instance.netProfit,
      'totalVendorCost': instance.totalVendorCost,
    };

_BookingServiceDto _$BookingServiceDtoFromJson(Map<String, dynamic> json) =>
    _BookingServiceDto(
      publicId: json['publicId'] as String?,
      serviceType: json['serviceType'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      vendorName: json['vendorName'] as String?,
      confirmationNumber: json['confirmationNumber'] as String?,
      serviceDate: json['serviceDate'] as String?,
      cost: json['cost'] as num?,
    );

Map<String, dynamic> _$BookingServiceDtoToJson(_BookingServiceDto instance) =>
    <String, dynamic>{
      'publicId': instance.publicId,
      'serviceType': instance.serviceType,
      'title': instance.title,
      'status': instance.status,
      'vendorName': instance.vendorName,
      'confirmationNumber': instance.confirmationNumber,
      'serviceDate': instance.serviceDate,
      'cost': instance.cost,
    };
