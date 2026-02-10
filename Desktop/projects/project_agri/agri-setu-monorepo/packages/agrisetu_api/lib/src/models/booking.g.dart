// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  id: (json['id'] as num).toInt(),
  farmer: (json['farmer'] as num).toInt(),
  farmerName: json['farmer_name'] as String?,
  machine: (json['machine'] as num).toInt(),
  machineDetails: json['machine_details'] == null
      ? null
      : Machine.fromJson(json['machine_details'] as Map<String, dynamic>),
  startTime: DateTime.parse(json['start_time'] as String),
  endTime: DateTime.parse(json['end_time'] as String),
  duration: (json['duration'] as num?)?.toInt(),
  totalPrice: (json['total_price'] as num?)?.toDouble(),
  paymentStatus: json['payment_status'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'id': instance.id,
  'farmer': instance.farmer,
  'farmer_name': instance.farmerName,
  'machine': instance.machine,
  'machine_details': instance.machineDetails,
  'start_time': instance.startTime.toIso8601String(),
  'end_time': instance.endTime.toIso8601String(),
  'duration': instance.duration,
  'total_price': instance.totalPrice,
  'payment_status': instance.paymentStatus,
  'status': instance.status,
};
