// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'machine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Machine _$MachineFromJson(Map<String, dynamic> json) => Machine(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  pricePerHour: json['price_per_hour'] as String,
  ownerName: json['owner_name'] as String?,
  category: json['category'] as String? ?? 'other',
  image: json['image'] as String?,
  location: json['location'] as Map<String, dynamic>?,
  isActive: json['is_active'] as bool? ?? true,
);

Map<String, dynamic> _$MachineToJson(Machine instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price_per_hour': instance.pricePerHour,
  'owner_name': instance.ownerName,
  'category': instance.category,
  'image': instance.image,
  'location': instance.location,
  'is_active': instance.isActive,
};
