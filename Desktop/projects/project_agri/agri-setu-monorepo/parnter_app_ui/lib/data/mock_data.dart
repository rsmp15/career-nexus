class MockDataRepository {
  static final List<Map<String, dynamic>> equipmentList = [
    {
      'id': '1',
      'name': 'John Deere 5050D',
      'type': 'Tractor',
      'image':
          'https://images.unsplash.com/photo-1595246140625-573b715d11dc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'status': 'Available',
      'pricePerDay': 2500,
      'totalBookings': 12,
      'rating': 4.8,
    },
    {
      'id': '2',
      'name': 'Kubota Harvester',
      'type': 'Harvester',
      'image':
          'https://images.unsplash.com/photo-1530267981375-f0de93fe1e91?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'status': 'Booked',
      'pricePerDay': 5000,
      'totalBookings': 8,
      'rating': 4.9,
    },
    {
      'id': '3',
      'name': 'DJI Agras T20',
      'type': 'Drone',
      'image':
          'https://images.unsplash.com/photo-1506947411487-a56738267384?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      'status': 'Maintenance',
      'pricePerDay': 3000,
      'totalBookings': 5,
      'rating': 4.5,
    },
    {
      'id': '4',
      'name': 'Rotavator 6ft',
      'type': 'Implement',
      'image':
          'https://rukminim2.flixcart.com/image/850/1000/xif0q/plant-sapling/0/l/n/no-annual-yes-rotavator-machine-1-multiflora-orig-imagu426ayf6xzzs.jpeg',
      'status': 'Available',
      'pricePerDay': 800,
      'totalBookings': 25,
      'rating': 4.7,
    },
  ];

  // Alias for userEquipment
  static List<Map<String, dynamic>> get userEquipment => equipmentList;

  static final List<Map<String, dynamic>> bookings = [
    {
      'id': 'B001',
      'farmerName': 'Ramesh Kumar',
      'equipment': 'John Deere 5050D',
      'startDate': DateTime.now().add(const Duration(days: 1)),
      'endDate': DateTime.now().add(const Duration(days: 3)),
      'status': 'Pending',
      'amount': 5000,
      'duration': 2,
    },
    {
      'id': 'B002',
      'farmerName': 'Suresh Singh',
      'equipment': 'Kubota Harvester',
      'startDate': DateTime.now().subtract(const Duration(days: 2)),
      'endDate': DateTime.now(),
      'status': 'Active',
      'amount': 10000,
      'duration': 2,
    },
    {
      'id': 'B003',
      'farmerName': 'Anita Devi',
      'equipment': 'Rotavator 6ft',
      'startDate': DateTime.now().add(const Duration(days: 5)),
      'endDate': DateTime.now().add(const Duration(days: 6)),
      'status': 'Confirmed',
      'amount': 800,
      'duration': 1,
    },
  ];

  static final List<Map<String, dynamic>> earningsHistory = [
    {'day': 'Mon', 'amount': 2500},
    {'day': 'Tue', 'amount': 5000},
    {'day': 'Wed', 'amount': 3000},
    {'day': 'Thu', 'amount': 7500},
    {'day': 'Fri', 'amount': 4000},
    {'day': 'Sat', 'amount': 6000},
    {'day': 'Sun', 'amount': 8000},
  ];
}
