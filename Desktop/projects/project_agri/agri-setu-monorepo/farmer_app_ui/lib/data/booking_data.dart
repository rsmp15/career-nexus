import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// EQUIPMENT MODEL
// ════════════════════════════════════════════════════════════════════════════
class Equipment {
  final String id;
  final String name;
  final String category;
  final String categoryLabel;
  final String imageUrl;
  final double pricePerHour;
  final double rating;
  final int reviews;
  final bool isAvailable;
  final String ownerId;
  final String ownerName;
  final String ownerAvatar;
  final double distance;
  final String description;
  final List<String> features;
  final String fuelType;
  final String condition;

  Equipment({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.imageUrl,
    required this.pricePerHour,
    required this.rating,
    required this.reviews,
    required this.isAvailable,
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatar,
    required this.distance,
    required this.description,
    required this.features,
    this.fuelType = 'Diesel',
    this.condition = 'Excellent',
  });
}

// ════════════════════════════════════════════════════════════════════════════
// CATEGORY MODEL
// ════════════════════════════════════════════════════════════════════════════
class Category {
  final String id;
  final String name;
  final IconData icon;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.count,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// BOOKING MODEL
// ════════════════════════════════════════════════════════════════════════════
class Booking {
  final String id;
  final Equipment equipment;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // pending, confirmed, active, completed
  final double totalPrice;

  Booking({
    required this.id,
    required this.equipment,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.totalPrice,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// MOCK DATA
// ════════════════════════════════════════════════════════════════════════════
class MockData {
  static final List<Category> categories = [
    Category(id: 'all', name: 'All', icon: Icons.grid_view_rounded, count: 24),
    Category(
      id: 'tractor',
      name: 'Tractors',
      icon: Icons.agriculture,
      count: 8,
    ),
    Category(id: 'harvester', name: 'Harvesters', icon: Icons.grass, count: 5),
    Category(
      id: 'cultivator',
      name: 'Cultivators',
      icon: Icons.terrain,
      count: 4,
    ),
    Category(id: 'sprayer', name: 'Sprayers', icon: Icons.water_drop, count: 4),
    Category(
      id: 'trailer',
      name: 'Trailers',
      icon: Icons.local_shipping,
      count: 3,
    ),
  ];

  static final List<Equipment> equipment = [
    Equipment(
      id: 'eq1',
      name: 'John Deere Tractor',
      category: 'tractor',
      categoryLabel: 'Tractor',
      imageUrl:
          'https://images.unsplash.com/photo-1530267981375-f0de937f5f13?w=800',
      pricePerHour: 450,
      rating: 4.9,
      reviews: 128,
      isAvailable: true,
      ownerId: 'o1',
      ownerName: 'Rajesh Kumar',
      ownerAvatar: 'https://i.pravatar.cc/150?img=11',
      distance: 1.2,
      description:
          'Powerful 45HP tractor perfect for medium to large farms. Well-maintained with low running hours.',
      features: ['45 HP Engine', '4WD', 'Power Steering', 'AC Cabin'],
    ),
    Equipment(
      id: 'eq2',
      name: 'Combine Harvester Pro',
      category: 'harvester',
      categoryLabel: 'Harvester',
      imageUrl:
          'https://images.unsplash.com/photo-1562859500-d3a179f3e2d6?w=800',
      pricePerHour: 1200,
      rating: 4.8,
      reviews: 86,
      isAvailable: true,
      ownerId: 'o2',
      ownerName: 'Vikram Singh',
      ownerAvatar: 'https://i.pravatar.cc/150?img=12',
      distance: 2.5,
      description:
          'Advanced combine harvester with GPS tracking and yield monitoring.',
      features: [
        'GPS Tracking',
        'Yield Monitor',
        'Auto-Level',
        '20ft Cutting Width',
      ],
    ),
    Equipment(
      id: 'eq3',
      name: 'Rotavator Heavy Duty',
      category: 'cultivator',
      categoryLabel: 'Cultivator',
      imageUrl:
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800',
      pricePerHour: 280,
      rating: 4.7,
      reviews: 54,
      isAvailable: false,
      ownerId: 'o3',
      ownerName: 'Amit Patel',
      ownerAvatar: 'https://i.pravatar.cc/150?img=13',
      distance: 0.8,
      description:
          'Heavy duty rotavator for deep soil preparation. Suitable for all soil types.',
      features: ['48 Blades', 'Heavy Duty', 'Adjustable Depth', 'Fits 35HP+'],
    ),
    Equipment(
      id: 'eq4',
      name: 'Boom Sprayer 800L',
      category: 'sprayer',
      categoryLabel: 'Sprayer',
      imageUrl:
          'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?w=800',
      pricePerHour: 180,
      rating: 4.6,
      reviews: 42,
      isAvailable: true,
      ownerId: 'o1',
      ownerName: 'Rajesh Kumar',
      ownerAvatar: 'https://i.pravatar.cc/150?img=11',
      distance: 1.2,
      description:
          'High capacity boom sprayer with 12m spray width. Perfect for large fields.',
      features: [
        '800L Tank',
        '12m Boom Width',
        'Electric Pump',
        'Adjustable Nozzles',
      ],
    ),
    Equipment(
      id: 'eq5',
      name: 'Farm Trailer 5 Ton',
      category: 'trailer',
      categoryLabel: 'Trailer',
      imageUrl:
          'https://images.unsplash.com/photo-1593113646773-028c64a8f1b8?w=800',
      pricePerHour: 150,
      rating: 4.5,
      reviews: 38,
      isAvailable: true,
      ownerId: 'o2',
      ownerName: 'Vikram Singh',
      ownerAvatar: 'https://i.pravatar.cc/150?img=12',
      distance: 2.5,
      description:
          'Hydraulic tipping trailer with 5-ton capacity. Steel body construction.',
      features: ['5 Ton Capacity', 'Hydraulic Tip', 'Steel Body', 'Air Brakes'],
    ),
    Equipment(
      id: 'eq6',
      name: 'Mahindra 575 DI',
      category: 'tractor',
      categoryLabel: 'Tractor',
      imageUrl:
          'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?w=800',
      pricePerHour: 380,
      rating: 4.8,
      reviews: 156,
      isAvailable: true,
      ownerId: 'o3',
      ownerName: 'Amit Patel',
      ownerAvatar: 'https://i.pravatar.cc/150?img=13',
      distance: 0.8,
      description:
          'Popular 45HP tractor known for reliability and fuel efficiency.',
      features: ['45 HP', '8 Speed', 'Oil Immersed Brakes', 'Dual Clutch'],
    ),
  ];

  static final List<Booking> activeBookings = [
    Booking(
      id: 'b1',
      equipment: equipment[0],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(hours: 4)),
      status: 'active',
      totalPrice: 1800,
    ),
    Booking(
      id: 'b2',
      equipment: equipment[3],
      startDate: DateTime.now().add(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 1, hours: 6)),
      status: 'confirmed',
      totalPrice: 1080,
    ),
  ];
}
