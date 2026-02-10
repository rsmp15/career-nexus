// ════════════════════════════════════════════════════════════════════════════
// USER MODEL
// ════════════════════════════════════════════════════════════════════════════
class SocialUser {
  final String id;
  final String name;
  final String username;
  final String avatar;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final bool isFollowing;

  SocialUser({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    this.isFollowing = false,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// POST MODEL
// ════════════════════════════════════════════════════════════════════════════
class Post {
  final String id;
  final SocialUser author;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isSaved;
  final List<String>? tags;

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isLiked = false,
    this.isSaved = false,
    this.tags,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}w';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// STORY MODEL
// ════════════════════════════════════════════════════════════════════════════
class Story {
  final String id;
  final SocialUser user;
  final String? imageUrl;
  final bool isViewed;
  final DateTime createdAt;

  Story({
    required this.id,
    required this.user,
    this.imageUrl,
    this.isViewed = false,
    required this.createdAt,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// NOTIFICATION MODEL
// ════════════════════════════════════════════════════════════════════════════
class SocialNotification {
  final String id;
  final String type; // like, comment, follow, mention
  final SocialUser fromUser;
  final String? postId;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  SocialNotification({
    required this.id,
    required this.type,
    required this.fromUser,
    this.postId,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });
}

// ════════════════════════════════════════════════════════════════════════════
// MOCK DATA
// ════════════════════════════════════════════════════════════════════════════
class SocialMockData {
  static final SocialUser currentUser = SocialUser(
    id: 'u0',
    name: 'Ramesh Kumar',
    username: 'ramesh_farmer',
    avatar: 'https://i.pravatar.cc/150?img=8',
    bio: 'Organic farmer from Punjab 🌾 | 15+ years experience',
    followers: 1256,
    following: 342,
    posts: 48,
  );

  static final List<SocialUser> users = [
    SocialUser(
      id: 'u1',
      name: 'Priya Sharma',
      username: 'priya_greenfields',
      avatar: 'https://i.pravatar.cc/150?img=5',
      bio: 'Modern farming techniques | Tech enthusiast',
      followers: 2841,
      following: 584,
      posts: 92,
    ),
    SocialUser(
      id: 'u2',
      name: 'Suresh Yadav',
      username: 'suresh_agri',
      avatar: 'https://i.pravatar.cc/150?img=12',
      bio: 'Dairy & Crop farming | Helping farmers grow',
      followers: 5623,
      following: 231,
      posts: 156,
    ),
    SocialUser(
      id: 'u3',
      name: 'Lakshmi Devi',
      username: 'lakshmi_organic',
      avatar: 'https://i.pravatar.cc/150?img=9',
      bio: '100% organic | Farm to table 🌱',
      followers: 3892,
      following: 445,
      posts: 78,
    ),
    SocialUser(
      id: 'u4',
      name: 'Arjun Reddy',
      username: 'arjun_farms',
      avatar: 'https://i.pravatar.cc/150?img=15',
      bio: 'Precision agriculture | Smart farming solutions',
      followers: 8451,
      following: 189,
      posts: 234,
    ),
  ];

  static final List<Story> stories = [
    Story(id: 's0', user: currentUser, createdAt: DateTime.now()),
    ...users.map(
      (u) => Story(
        id: 's${u.id}',
        user: u,
        createdAt: DateTime.now().subtract(
          Duration(hours: users.indexOf(u) + 1),
        ),
        isViewed: users.indexOf(u) > 1,
      ),
    ),
  ];

  static final List<Post> posts = [
    Post(
      id: 'p1',
      author: users[0],
      content:
          'Just harvested our first batch of organic wheat! The yield is 20% higher than last year 🌾✨ #OrganicFarming #WheatHarvest',
      imageUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 342,
      comments: 45,
      shares: 12,
      tags: ['OrganicFarming', 'WheatHarvest'],
    ),
    Post(
      id: 'p2',
      author: users[1],
      content:
          'New irrigation system installed! Saving 40% water compared to traditional methods. Smart farming is the future 💧🚀',
      imageUrl:
          'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 567,
      comments: 89,
      shares: 34,
      tags: ['SmartFarming', 'Irrigation'],
    ),
    Post(
      id: 'p3',
      author: users[2],
      content:
          'Morning at the farm 🌅 Nothing beats the peace of watching sunrise over the fields. Grateful for this life.',
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 892,
      comments: 56,
      shares: 23,
    ),
    Post(
      id: 'p4',
      author: users[3],
      content:
          'Pro tip: Rotate your crops every season to maintain soil fertility. This simple practice has doubled my yield over 3 years! 📈',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      likes: 1245,
      comments: 234,
      shares: 156,
      tags: ['FarmingTips', 'CropRotation'],
    ),
    Post(
      id: 'p5',
      author: users[0],
      content:
          'Testing the new drone for crop monitoring. Technology making farming easier every day! 🚁',
      imageUrl:
          'https://images.unsplash.com/photo-1508614589041-895b88991e3e?w=800',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 456,
      comments: 67,
      shares: 28,
      tags: ['AgriTech', 'Drones'],
    ),
  ];

  static final List<SocialNotification> notifications = [
    SocialNotification(
      id: 'n1',
      type: 'like',
      fromUser: users[0],
      postId: 'p1',
      message: 'liked your post',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    SocialNotification(
      id: 'n2',
      type: 'follow',
      fromUser: users[1],
      message: 'started following you',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SocialNotification(
      id: 'n3',
      type: 'comment',
      fromUser: users[2],
      postId: 'p2',
      message: 'commented on your post',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
}
