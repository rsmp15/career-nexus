import 'package:flutter/material.dart';

class MockData {
  static final List<Map<String, dynamic>> categories = [
    {'id': 'all', 'name': 'All'},
    {'id': 'tractor', 'name': 'Tractor'},
    {'id': 'harvester', 'name': 'Harvester'},
    {'id': 'plough', 'name': 'Plough'},
    {'id': 'sprayer', 'name': 'Sprayer'},
    {'id': 'seeder', 'name': 'Seeder'},
  ];

  static final List<Map<String, dynamic>> shops = [
    {
      'id': 1,
      'name': 'Kumar Farm Equipment',
      'distance': 1.2,
      'rating': 4.8,
      'reviews': 156,
      'phone': '+91 98765 43210',
      'lat': 28.6139,
      'lng': 77.209,
      'equipment': [
        {
          'id': 101,
          'name': 'Heavy Duty Tractor',
          'category': 'tractor',
          'price': 450,
          'image':
              'https://images.unsplash.com/photo-1702563437324-eaeb112bef9c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmFjdG9yJTIwZmFybSUyMGVxdWlwbWVudHxlbnwxfHx8fDE3NzA0NjAxNjh8MA&ixlib=rb-4.1.0&q=80&w=1080',
          'available': true,
        },
        {
          'id': 102,
          'name': 'Modern Plowing Machine',
          'category': 'plough',
          'price': 320,
          'image':
              'https://images.unsplash.com/photo-1760947960930-e2701e352eed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwbG93aW5nJTIwbWFjaGluZSUyMHRyYWN0b3J8ZW58MXx8fHwxNzcwNTIwNTc0fDA&ixlib=rb-4.1.0&q=80&w=1080',
          'available': true,
        },
      ],
    },
    {
      'id': 2,
      'name': 'Singh Agricultural Hub',
      'distance': 2.5,
      'rating': 4.6,
      'reviews': 98,
      'phone': '+91 98765 43211',
      'lat': 28.6149,
      'lng': 77.21,
      'equipment': [
        {
          'id': 201,
          'name': 'Combine Harvester',
          'category': 'harvester',
          'price': 850,
          'image':
              'https://images.unsplash.com/photo-1689150396762-65ed008390cf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoYXJ2ZXN0ZXIlMjBhZ3JpY3VsdHVyYWwlMjBtYWNoaW5lcnl8ZW58MXx8fHwxNzcwNTIwNTczfDA&ixlib=rb-4.1.0&q=80&w=1080',
          'available': true,
        },
      ],
    },
    {
      'id': 3,
      'name': "Patel Equipment Rentals",
      'distance': 0.8,
      'rating': 4.9,
      'reviews': 234,
      'phone': "+91 98765 43212",
      'lat': 28.6129,
      'lng': 77.208,
      'equipment': [
        {
          'id': 301,
          'name': "Seeding Equipment",
          'category': "seeder",
          'price': 280,
          'image':
              "https://images.unsplash.com/photo-1764277434161-23d72931335f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzZWVkaW5nJTIwZXF1aXBtZW50JTIwYWdyaWN1bHR1cmV8ZW58MXx8fHwxNzcwNTIwNTc1fDA&ixlib=rb-4.1.0&q=80&w=1080",
          'available': true,
        },
        {
          'id': 302,
          'name': "Premium Tractor XL",
          'category': "tractor",
          'price': 520,
          'image':
              "https://images.unsplash.com/photo-1702563437324-eaeb112bef9c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmFjdG9yJTIwZmFybSUyMGVxdWlwbWVudHxlbnwxfHx8fDE3NzA0NjAxNjh8MA&ixlib=rb-4.1.0&q=80&w=1080",
          'available': false,
        },
      ],
    },
  ];

  static final List<Map<String, dynamic>> promotions = [
    {
      'id': 1,
      'image':
          'https://images.unsplash.com/photo-1715368062208-1568574dbb7a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxncmVlbiUyMGZhcm0lMjBmaWVsZCUyMGJhbm5lcnxlbnwxfHx8fDE3NzA1MjA1Nzh8MA&ixlib=rb-4.1.0&q=80&w=1080',
      'title': 'Summer Special Offer',
    },
    {
      'id': 2,
      'image':
          'https://images.unsplash.com/photo-1763867641182-9ff4cfbcc389?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBhZ3JpY3VsdHVyZSUyMHByb21vdGlvbnxlbnwxfHx8fDE3NzA1MjA1Nzh8MA&ixlib=rb-4.1.0&q=80&w=1080',
      'title': 'New Equipment Available',
    },
  ];

  static final List<Map<String, dynamic>> featuredDeals = [
    {
      'id': 1,
      'name': 'Premium Tractor Package',
      'price': 380,
      'discount': '20% OFF',
      'distance': 1.5,
      'image':
          'https://images.unsplash.com/photo-1702563437324-eaeb112bef9c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmFjdG9yJTIwZmFybSUyMGVxdWlwbWVudHxlbnwxfHx8fDE3NzA0NjAxNjh8MA&ixlib=rb-4.1.0&q=80&w=1080',
    },
    {
      'id': 2,
      'name': 'Harvesting Combo Deal',
      'price': 750,
      'discount': '15% OFF',
      'distance': 2.3,
      'image':
          'https://images.unsplash.com/photo-1689150396762-65ed008390cf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoYXJ2ZXN0ZXIlMjBhZ3JpY3VsdHVyYWwlMjBtYWNoaW5lcnl8ZW58MXx8fHwxNzcwNTIwNTczfDA&ixlib=rb-4.1.0&q=80&w=1080',
    },
  ];

  static final List<Map<String, dynamic>> services = [
    {'id': 1, 'name': 'Government Scheme', 'icon': Icons.description},
    {'id': 2, 'name': 'Support', 'icon': Icons.help_outline},
    {'id': 3, 'name': 'Core Advisory', 'icon': Icons.work_outline},
  ];

  static final List<Map<String, dynamic>> socialPosts = [
    {
      'id': 1,
      'userName': 'Rajesh Kumar',
      'userAvatar': 'https://i.pravatar.cc/150?img=12',
      'timeAgo': '2h ago',
      'content':
          'Just finished harvesting with the new combine harvester! Productivity increased by 40%. Highly recommend!',
      'image':
          'https://images.unsplash.com/photo-1689150396762-65ed008390cf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoYXJ2ZXN0ZXIlMjBhZ3JpY3VsdHVyYWwlMjBtYWNoaW5lcnl8ZW58MXx8fHwxNzcwNTIwNTczfDA&ixlib=rb-4.1.0&q=80&w=1080',
      'likes': 234,
      'comments': 45,
    },
    {
      'id': 2,
      'userName': 'Priya Sharma',
      'userAvatar': 'https://i.pravatar.cc/150?img=5',
      'timeAgo': '5h ago',
      'content':
          'Great experience renting equipment from FarmRent. Quick delivery and excellent condition!',
      'likes': 189,
      'comments': 32,
    },
  ];
}
