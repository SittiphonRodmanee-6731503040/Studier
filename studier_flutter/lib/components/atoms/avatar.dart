import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Atom: Circular avatar with optional online badge.
class Avatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool showOnlineBadge;

  const Avatar({
    super.key,
    required this.imageUrl,
    this.radius = 40,
    this.showOnlineBadge = false,
  });

  /// Returns the right [ImageProvider] for network URLs vs local assets.
  /// SECURITY: Only HTTPS URLs are allowed for network images
  ImageProvider _resolveImage() {
    if (imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    }
    // SECURITY: Reject insecure HTTP URLs - treat as asset or show default
    if (imageUrl.startsWith('http://')) {
      // Log warning in debug mode, return placeholder
      debugPrint('SECURITY WARNING: HTTP URL rejected for avatar: $imageUrl');
      return const AssetImage('assets/images/default_avatar.png');
    }
    return AssetImage(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.gray200,
          backgroundImage: _resolveImage(),
        ),
        if (showOnlineBadge)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: radius * 0.35,
              height: radius * 0.35,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surfaceDark, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
