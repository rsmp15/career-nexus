import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'machine.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking extends Equatable {
  final int id;
  final int farmer;
  @JsonKey(name: 'farmer_name')
  final String? farmerName;
  final int machine;
  @JsonKey(name: 'machine_details')
  final Machine? machineDetails;
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @JsonKey(name: 'end_time')
  final DateTime endTime;
  final int? duration;
  @JsonKey(name: 'total_price')
  final double? totalPrice;
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  final String status;

  const Booking({
    required this.id,
    required this.farmer,
    this.farmerName,
    required this.machine,
    this.machineDetails,
    required this.startTime,
    required this.endTime,
    this.duration,
    this.totalPrice,
    this.paymentStatus,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);

  @override
  List<Object?> get props => [
    id,
    farmer,
    machine,
    startTime,
    endTime,
    duration,
    totalPrice,
    paymentStatus,
    status,
  ];
}
