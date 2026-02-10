import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/design_system.dart';
import '../../core/app_mode.dart';
import '../../data/booking_data.dart';
import 'package:provider/provider.dart';
import 'equipment_screen.dart';
import 'equipment_detail_screen.dart';

class BookingHomeScreen extends StatefulWidget {
  const BookingHomeScreen({super.key});

  @override
  State<BookingHomeScreen> createState() => _BookingHomeScreenState();
}

class _BookingHomeScreenState extends State<BookingHomeScreen> {
  int _currentNavIndex = 0;
  final PageController _carouselController = PageController();
  int _currentCarouselPage = 0;

  // Sample ads data
  final List<Map<String, dynamic>> _ads = [
    {
      'title': 'Monsoon Special',
      'subtitle': 'Get 20% off on all tractors',
      'color': AppDesign.booking,
      'icon': Icons.local_offer,
    },
    {
      'title': 'New Equipment',
      'subtitle': 'Latest harvesters available now',
      'color': AppDesign.social,
      'icon': Icons.new_releases,
    },
    {
      'title': 'Govt. Subsidy',
      'subtitle': 'Apply for PM-KISAN benefits',
      'color': AppDesign.warning,
      'icon': Icons.account_balance,
    },
  ];

  // Previously booked equipment
  final List<Equipment> _previouslyBooked = MockData.equipment.take(4).toList();

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void initState() {
    super.initState();
    // Auto-scroll carousel
    Future.delayed(const Duration(seconds: 3), _autoScrollCarousel);
  }

  void _autoScrollCarousel() {
    if (!mounted) return;
    final nextPage = (_currentCarouselPage + 1) % _ads.length;
    _carouselController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(seconds: 4), _autoScrollCarousel);
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: AppDesign.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _currentNavIndex == 0
                  ? _buildHomeContent()
                  : _buildPlaceholderContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceL,
        vertical: AppDesign.spaceM,
      ),
      child: Row(
        children: [
          // Profile avatar
          GestureDetector(
            onTap: () => setState(() => _currentNavIndex = 4),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppDesign.booking, width: 2),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?img=8'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDesign.spaceM),

          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: AppDesign.caption.copyWith(color: AppDesign.textMuted),
                ),
                const Text(
                  'Ramesh',
                  style: TextStyle(
                    color: AppDesign.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Switch to Social Mode
          _buildModeSwitch(),

          const SizedBox(width: AppDesign.spaceS),

          // Notifications
          _buildIconButton(
            Icons.notifications_outlined,
            onTap: () {},
            badge: true,
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitch() {
    return GestureDetector(
      onTap: () {
        Provider.of<AppMode>(context, listen: false).toggleMode();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppDesign.social.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppDesign.social.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt_rounded, size: 18, color: AppDesign.social),
            const SizedBox(width: 6),
            Text(
              'Social',
              style: AppDesign.labelMedium.copyWith(
                color: AppDesign.social,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
    IconData icon, {
    required VoidCallback onTap,
    bool badge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppDesign.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppDesign.divider),
            ),
            child: Icon(icon, color: AppDesign.textSecondary, size: 22),
          ),
          if (badge)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppDesign.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppDesign.card, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDesign.spaceM),

          // Ad Carousel
          _buildAdCarousel(),

          const SizedBox(height: AppDesign.spaceXL),

          // Main Categories: Equipment, Shops, Govt Schemes
          _buildMainCategories(),

          const SizedBox(height: AppDesign.spaceXL),

          // Previously Booked Vehicles
          _buildPreviouslyBookedSection(),
        ],
      ),
    );
  }

  Widget _buildAdCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) =>
                setState(() => _currentCarouselPage = index),
            itemCount: _ads.length,
            itemBuilder: (context, index) {
              final ad = _ads[index];
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppDesign.spaceL,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (ad['color'] as Color),
                      (ad['color'] as Color).withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (ad['color'] as Color).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        ad['icon'] as IconData,
                        size: 120,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(AppDesign.spaceL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ad['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ad['subtitle'] as String,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Learn More',
                              style: TextStyle(
                                color: ad['color'] as Color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppDesign.spaceM),
        // Carousel indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_ads.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentCarouselPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentCarouselPage == index
                    ? AppDesign.booking
                    : AppDesign.divider,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMainCategories() {
    final categories = [
      {
        'icon': Icons.agriculture,
        'label': 'Equipment',
        'color': AppDesign.booking,
        'description': 'Rent tractors & more',
      },
      {
        'icon': Icons.storefront,
        'label': 'Shops',
        'color': AppDesign.social,
        'description': 'Find nearby stores',
      },
      {
        'icon': Icons.account_balance,
        'label': 'Govt Schemes',
        'color': AppDesign.warning,
        'description': 'Subsidies & benefits',
      },
      {
        'icon': Icons.support_agent,
        'label': 'Support',
        'color': AppDesign.success,
        'description': 'Get help & guidance',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(
              color: AppDesign.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDesign.spaceM),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppDesign.spaceM,
            mainAxisSpacing: AppDesign.spaceM,
            childAspectRatio: 1.4,
            children: categories.map((cat) {
              return GestureDetector(
                onTap: () {
                  if (cat['label'] == 'Equipment') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EquipmentScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(AppDesign.spaceM),
                  decoration: BoxDecoration(
                    color: AppDesign.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppDesign.divider),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (cat['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          cat['icon'] as IconData,
                          color: cat['color'] as Color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cat['label'] as String,
                        style: const TextStyle(
                          color: AppDesign.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        cat['description'] as String,
                        style: const TextStyle(
                          color: AppDesign.textMuted,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviouslyBookedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Previously Booked',
                style: TextStyle(
                  color: AppDesign.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _currentNavIndex = 2),
                child: Text(
                  'View All',
                  style: AppDesign.labelLarge.copyWith(
                    color: AppDesign.booking,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDesign.spaceM),

        if (_previouslyBooked.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
            child: Container(
              padding: const EdgeInsets.all(AppDesign.spaceXL),
              decoration: BoxDecoration(
                color: AppDesign.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppDesign.divider),
              ),
              child: Column(
                children: [
                  Icon(Icons.history, size: 48, color: AppDesign.textMuted),
                  const SizedBox(height: 12),
                  const Text(
                    'No previous bookings',
                    style: TextStyle(
                      color: AppDesign.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EquipmentScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppDesign.bookingAccentGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...(_previouslyBooked.map((eq) => _buildPreviouslyBookedCard(eq))),
      ],
    );
  }

  Widget _buildPreviouslyBookedCard(Equipment eq) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EquipmentDetailScreen(equipment: eq)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDesign.spaceL,
          vertical: AppDesign.spaceS,
        ),
        padding: const EdgeInsets.all(AppDesign.spaceM),
        decoration: BoxDecoration(
          color: AppDesign.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppDesign.divider),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                eq.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: AppDesign.cardLight,
                  child: const Icon(
                    Icons.agriculture,
                    color: AppDesign.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDesign.spaceM),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eq.name,
                    style: const TextStyle(
                      color: AppDesign.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 14,
                        color: AppDesign.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(eq.ownerName, style: AppDesign.caption),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppDesign.bookingAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${eq.rating}',
                        style: AppDesign.caption.copyWith(
                          color: AppDesign.bookingAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('• ${eq.categoryLabel}', style: AppDesign.caption),
                    ],
                  ),
                ],
              ),
            ),

            // Book Again button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppDesign.bookingAccentGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Book Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderContent() {
    final titles = ['Home', 'Explore', 'Bookings', 'Messages', 'Profile'];
    final icons = [
      Icons.home,
      Icons.explore,
      Icons.calendar_today,
      Icons.chat_bubble,
      Icons.person,
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppDesign.booking.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icons[_currentNavIndex],
              size: 40,
              color: AppDesign.booking,
            ),
          ),
          const SizedBox(height: 16),
          Text(titles[_currentNavIndex], style: AppDesign.headlineMedium),
          const SizedBox(height: 8),
          Text('Coming soon', style: AppDesign.caption),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {
        'icon': Icons.home_rounded,
        'activeIcon': Icons.home_rounded,
        'label': 'Home',
      },
      {
        'icon': Icons.explore_outlined,
        'activeIcon': Icons.explore,
        'label': 'Explore',
      },
      {
        'icon': Icons.calendar_today_outlined,
        'activeIcon': Icons.calendar_today,
        'label': 'Bookings',
      },
      {
        'icon': Icons.chat_bubble_outline,
        'activeIcon': Icons.chat_bubble,
        'label': 'Chat',
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Profile',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppDesign.surface,
        border: Border(top: BorderSide(color: AppDesign.divider)),
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isActive = _currentNavIndex == index;
              final item = items[index];

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _currentNavIndex = index),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppDesign.booking.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          isActive
                              ? item['activeIcon'] as IconData
                              : item['icon'] as IconData,
                          color: isActive
                              ? AppDesign.booking
                              : AppDesign.textMuted,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: isActive
                              ? AppDesign.booking
                              : AppDesign.textMuted,
                          fontSize: 11,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
