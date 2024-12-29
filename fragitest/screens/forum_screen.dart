import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './create_post_screen.dart';
import '../utils/global_state.dart';
import '../widgets/header_1_line_no_back.dart';
import '../widgets/bottom_nav_bar.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  Stream<QuerySnapshot> _fetchPosts() {
    return FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<bool> _isPostLikedByCurrentUser(String postId) async {
    final userId = GlobalState().currentUserId;

    if (userId == null) {
      return false; // No user is logged in
    }

    final likedPostDoc = await FirebaseFirestore.instance
        .collection('Liked_Posts')
        .doc('${userId}_$postId')
        .get();

    return likedPostDoc.exists; // Check if the document exists
  }

  void _handleSwipeLeft(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null &&
            details.primaryVelocity! < -100) {
          // Detect left swipe
          _handleSwipeLeft(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2EBD9),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                const Header1LineNoBack(
                  title: 'FORUM',
                  underlineWidth: 180,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _fetchPosts(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      var posts = snapshot.data!.docs;

                      if (posts.isEmpty) {
                        return const Center(
                          child: Text(
                            'No posts available yet.',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index];
                          return FutureBuilder<bool>(
                            future: _isPostLikedByCurrentUser(post.id),
                            builder: (context, likedSnapshot) {
                              if (!likedSnapshot.hasData) {
                                return const SizedBox(
                                  height: 100,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              bool isLiked = likedSnapshot.data ?? false;
                              return PostCard(
                                username: post['user_id'],
                                imageUrl: post['image_url'],
                                caption: post['caption'],
                                likesCount: post['likes_count'],
                                postId: post.id,
                                isLiked: isLiked,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Image.asset('assets/images/plus_icon.png',
                    width: 25, height: 25),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreatePostScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const NavigationButtons(),
      ),
    );
  }
}

class PostCard extends StatefulWidget {
  final String username;
  final String imageUrl;
  final String caption;
  final int likesCount;
  final String postId;
  final bool isLiked;

  const PostCard({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.caption,
    required this.likesCount,
    required this.postId,
    required this.isLiked,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late bool isLiked;
  late int currentLikes;

  bool _showHeart = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isLiked;
    currentLikes = widget.likesCount;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> likePost() async {
    if (isLiked) {
      // If already liked, do nothing on double-tap
      return;
    }

    final userId = GlobalState().currentUserId;

    if (userId == null) {
      if (kDebugMode) {
        print('Error: User ID is null');
      }
      return;
    }

    final likedPostId = '${userId}_${widget.postId}';
    final postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);
    final likedPostRef =
        FirebaseFirestore.instance.collection('Liked_Posts').doc(likedPostId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) return;

      int likes = postSnapshot['likes_count'] ?? 0;

      transaction.update(postRef, {'likes_count': likes + 1});
      transaction.set(likedPostRef, {
        'user_id': userId,
        'post_id': widget.postId,
      });
    }).then((_) {
      setState(() {
        isLiked = true;
        currentLikes += 1;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('Error liking post: $error');
      }
    });
  }

  Future<void> toggleLikeButton() async {
    final userId = GlobalState().currentUserId;

    if (userId == null) {
      if (kDebugMode) {
        print('Error: User ID is null');
      }
      return;
    }

    final likedPostId = '${userId}_${widget.postId}';
    final postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);
    final likedPostRef =
        FirebaseFirestore.instance.collection('Liked_Posts').doc(likedPostId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final postSnapshot = await transaction.get(postRef);

      if (!postSnapshot.exists) return;

      int likes = postSnapshot['likes_count'] ?? 0;

      if (isLiked) {
        transaction.update(postRef, {'likes_count': likes - 1});
        transaction.delete(likedPostRef);
      } else {
        transaction.update(postRef, {'likes_count': likes + 1});
        transaction.set(likedPostRef, {
          'user_id': userId,
          'post_id': widget.postId,
        });
      }
    }).then((_) {
      setState(() {
        isLiked = !isLiked;
        currentLikes += isLiked ? 1 : -1;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('Error toggling like: $error');
      }
    });
  }

  void _triggerHeartAnimation() {
    setState(() {
      _showHeart = true;
    });
    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        setState(() {
          _showHeart = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: const Color(0xFFF2EBD9),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/images/account_icon.png',
                    width: 30, height: 30),
                const SizedBox(width: 8),
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Finlandica',
                    fontSize: 18,
                    color: Color(0xFF003366),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            GestureDetector(
              onDoubleTap: () {
                likePost();
                _triggerHeartAnimation();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 250),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            'Image not found',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_showHeart)
                    ScaleTransition(
                      scale: Tween(begin: 0.5, end: 1.5).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.elasticOut,
                        ),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white.withOpacity(0.8),
                        size: 80,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/pillar_icon.png',
                        width: 20, height: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.caption,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Finlandica',
                        fontSize: 16,
                        color: Color(0xFF003366),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '$currentLikes',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD88D7F),
                        fontFamily: 'Finlandica',
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Image.asset(
                        isLiked
                            ? 'assets/images/like_icon.png'
                            : 'assets/images/like_icon_outline.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: toggleLikeButton,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
