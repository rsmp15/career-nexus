import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'machine.g.dart';

@JsonSerializable()
class Machine extends Equatable {
  final int id;
  final String name;
  final String description;
  @JsonKey(name: 'price_per_hour')
  final String pricePerHour; // Decimal comes as string often, or double
  @JsonKey(name: 'owner_name')
  final String? ownerName;
  @JsonKey(defaultValue: 'other')
  final String category;
  final String? image;
  final Map<String, dynamic>? location; // GeoJSON
  @JsonKey(name: 'is_active', defaultValue: true)
  final bool isActive;

  const Machine({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerHour,
    this.ownerName,
    this.category = 'other',
    this.image,
    this.location,
    this.isActive = true,
  });

  factory Machine.fromJson(Map<String, dynamic> json) =>
      _$MachineFromJson(json);
  Map<String, dynamic> toJson() => _$MachineToJson(this);

  Machine copyWith({
    int? id,
    String? name,
    String? description,
    String? pricePerHour,
    String? ownerName,
    String? category,
    String? image,
    Map<String, dynamic>? location,
    bool? isActive,
  }) {
    return Machine(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      ownerName: ownerName ?? this.ownerName,
      category: category ?? this.category,
      image: image ?? this.image,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    pricePerHour,
    ownerName,
    category,
    image,
    location,
    isActive,
  ];
}
