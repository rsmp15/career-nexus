import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/design_system.dart';
import '../../core/app_mode.dart';
import '../../data/social_data.dart';

class SocialHomeScreen extends StatefulWidget {
  const SocialHomeScreen({super.key});

  @override
  State<SocialHomeScreen> createState() => _SocialHomeScreenState();
}

class _SocialHomeScreenState extends State<SocialHomeScreen> {
  int _currentNavIndex = 0;
  final Map<String, bool> _likedPosts = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesign.background,
      body: SafeArea(
        child: Column(
          children: [
            // ════════════════════════════════════════════════════════════════
            // TOP BAR
            // ════════════════════════════════════════════════════════════════
            _buildTopBar(),

            // ════════════════════════════════════════════════════════════════
            // CONTENT
            // ════════════════════════════════════════════════════════════════
            Expanded(
              child: _currentNavIndex == 0
                  ? _buildFeedContent()
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
          // Logo & Title
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppDesign.socialAccentGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.people_alt, color: Colors.white, size: 22),
          ),
          const SizedBox(width: AppDesign.spaceM),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FarmConnect',
                  style: TextStyle(
                    color: AppDesign.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Farmer Community',
                  style: TextStyle(color: AppDesign.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),

          // Switch to Booking Mode
          GestureDetector(
            onTap: () {
              Provider.of<AppMode>(context, listen: false).toggleMode();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppDesign.booking.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppDesign.booking.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.agriculture,
                    size: 18,
                    color: AppDesign.booking,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Booking',
                    style: AppDesign.labelMedium.copyWith(
                      color: AppDesign.booking,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppDesign.spaceS),

          _buildIconButton(Icons.notifications_outlined, badge: true),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {bool badge = false}) {
    return Stack(
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
                color: AppDesign.socialAccent,
                shape: BoxShape.circle,
                border: Border.all(color: AppDesign.card, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFeedContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDesign.spaceM),

          // Stories
          _buildStoriesSection(),

          const SizedBox(height: AppDesign.spaceL),

          // Create Post
          _buildCreatePostCard(),

          const SizedBox(height: AppDesign.spaceM),

          // Posts
          ...SocialMockData.posts.map((post) => _buildPostCard(post)),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
        itemCount: SocialMockData.stories.length,
        itemBuilder: (context, index) {
          final story = SocialMockData.stories[index];
          final isYou = index == 0;

          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: story.isViewed
                            ? null
                            : AppDesign.socialAccentGradient,
                        border: story.isViewed
                            ? Border.all(color: AppDesign.divider, width: 2)
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppDesign.background,
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(story.user.avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    if (isYou)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            gradient: AppDesign.socialAccentGradient,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppDesign.background,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isYou ? 'You' : story.user.name.split(' ').first,
                  style: AppDesign.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCreatePostCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
      padding: const EdgeInsets.all(AppDesign.spaceM),
      decoration: BoxDecoration(
        color: AppDesign.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppDesign.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppDesign.social, width: 2),
              image: DecorationImage(
                image: NetworkImage(SocialMockData.currentUser.avatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppDesign.spaceM),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppDesign.cardLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                "What's happening on your farm?",
                style: TextStyle(color: AppDesign.textMuted, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: AppDesign.spaceS),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppDesign.social.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image, color: AppDesign.social, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    final isLiked = _likedPosts[post.id] ?? post.isLiked;
    final likeCount = isLiked != post.isLiked
        ? (isLiked ? post.likes + 1 : post.likes - 1)
        : post.likes;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDesign.spaceL,
        vertical: AppDesign.spaceS,
      ),
      decoration: BoxDecoration(
        color: AppDesign.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppDesign.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppDesign.spaceM),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(post.author.avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: AppDesign.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.name,
                        style: const TextStyle(
                          color: AppDesign.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text('${post.timeAgo} ago', style: AppDesign.caption),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: AppDesign.textMuted),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceM),
            child: Text(
              post.content,
              style: const TextStyle(
                color: AppDesign.textPrimary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),

          // Image
          if (post.imageUrl != null) ...[
            const SizedBox(height: AppDesign.spaceM),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ],

          const SizedBox(height: AppDesign.spaceM),

          // Actions
          Padding(
            padding: const EdgeInsets.only(
              left: AppDesign.spaceM,
              right: AppDesign.spaceM,
              bottom: AppDesign.spaceM,
            ),
            child: Row(
              children: [
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: _formatCount(likeCount),
                  isActive: isLiked,
                  activeColor: AppDesign.socialAccent,
                  onTap: () => setState(() => _likedPosts[post.id] = !isLiked),
                ),
                const SizedBox(width: AppDesign.spaceL),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments}',
                  onTap: () {},
                ),
                const SizedBox(width: AppDesign.spaceL),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {},
                ),
                const Spacer(),
                Icon(
                  Icons.bookmark_border,
                  color: AppDesign.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    Color? activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isActive
                ? (activeColor ?? AppDesign.social)
                : AppDesign.textMuted,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? (activeColor ?? AppDesign.social)
                  : AppDesign.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  Widget _buildPlaceholderContent() {
    final titles = ['Feed', 'Explore', 'Create', 'Messages', 'Profile'];
    final icons = [
      Icons.home,
      Icons.explore,
      Icons.add_circle,
      Icons.chat,
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
              color: AppDesign.social.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icons[_currentNavIndex],
              size: 40,
              color: AppDesign.social,
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
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Feed'},
      {
        'icon': Icons.explore_outlined,
        'activeIcon': Icons.explore,
        'label': 'Explore',
      },
      {
        'icon': Icons.add_circle_outline,
        'activeIcon': Icons.add_circle,
        'label': 'Create',
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
                              ? AppDesign.social.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          isActive
                              ? item['activeIcon'] as IconData
                              : item['icon'] as IconData,
                          color: isActive
                              ? AppDesign.social
                              : AppDesign.textMuted,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: isActive
                              ? AppDesign.social
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
