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
  ImageProvider? _resolveImage() {
    if (imageUrl.trim().isEmpty) {
      return null;
    }
    if (imageUrl.startsWith('https://') || imageUrl.startsWith('blob:')) {
      return NetworkImage(imageUrl);
    }
    // SECURITY: Reject insecure HTTP URLs - treat as asset or show default
    if (imageUrl.startsWith('http://')) {
      // Log warning in debug mode, return placeholder
      debugPrint('SECURITY WARNING: HTTP URL rejected for avatar: $imageUrl');
      return null;
    }
    return AssetImage(imageUrl);
  }

  Widget _fallbackAvatar() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B4A38), Color(0xFF0A3224)],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.school,
          size: radius * 0.72,
          color: AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = _resolveImage();

    return Stack(
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.backgroundDark, width: 2),
          ),
          child: ClipOval(
            child: image == null
                ? _fallbackAvatar()
                : Image(
                    image: image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _fallbackAvatar(),
                  ),
          ),
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
