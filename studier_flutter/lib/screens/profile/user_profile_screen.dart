import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../context/user_provider.dart';
import '../../models/tutor_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';

/// UserProfileScreen — matches the attached userprofile/code.html reference.
/// Shows avatar (editable), stats, "Become a Tutor" card, and recent tutors.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = UserProvider.of(context);
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Not logged in',
                style: TextStyle(color: AppColors.white, fontSize: 18),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.login),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // room for nav bar
          child: Column(
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: AppColors.gray300),
                      tooltip: 'Logout',
                      onPressed: () async {
                        await auth.logout();
                        if (!context.mounted) return;
                        Navigator.pushReplacementNamed(context, Routes.login);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Avatar ──
              _AvatarSection(user: user, auth: auth),

              const SizedBox(height: 16),

              // ── Name / University / Major ──
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, size: 16, color: AppColors.gray400),
                  const SizedBox(width: 6),
                  Text(
                    user.university.isEmpty ? 'No university' : user.university,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                user.major.isEmpty ? '' : user.major,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // ── Stats row ──
              _StatsRow(user: user),

              const SizedBox(height: 24),

              // ── Edit profile button ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _showEditProfileSheet(context, auth),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Become a Tutor card ──
              _BecomeTutorCard(user: user),

              const SizedBox(height: 28),

              // ── Recent Tutors Contacted ──
              _RecentTutorsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Edit profile bottom sheet ──
  void _showEditProfileSheet(BuildContext context, AuthService auth) {
    final user = auth.currentUser!;
    final nameCtrl = TextEditingController(text: user.name);
    final uniCtrl = TextEditingController(text: user.university);
    final majorCtrl = TextEditingController(text: user.major);
    final phoneCtrl = TextEditingController(text: user.phoneNumber ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.gray500,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _editField('Full Name', nameCtrl),
                _editField('University', uniCtrl),
                _editField('Major', majorCtrl),
                _editField('Phone', phoneCtrl, keyboard: TextInputType.phone),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      await auth.updateProfile(
                        name: nameCtrl.text.trim(),
                        university: uniCtrl.text.trim(),
                        major: majorCtrl.text.trim(),
                        phoneNumber: phoneCtrl.text.trim(),
                      );
                      if (!context.mounted) return;
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.backgroundDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _editField(
    String label,
    TextEditingController ctrl, {
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.gray400),
          filled: true,
          fillColor: AppColors.backgroundDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

/// Circular avatar with edit button + real image picker.
class _AvatarSection extends StatefulWidget {
  final AppUser user;
  final AuthService auth;

  const _AvatarSection({required this.user, required this.auth});

  @override
  State<_AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<_AvatarSection> {
  Uint8List?
  _pickedBytes; // holds the picked image in memory (works on web + native)

  /// Build the correct image provider.
  ImageProvider _avatarImage() {
    // If user just picked a new photo this session, show it from memory.
    if (_pickedBytes != null) return MemoryImage(_pickedBytes!);

    final url = widget.user.avatarUrl;
    if (url.isEmpty) {
      return const AssetImage('assets/images/placeholder.png');
    }
    // Local asset path
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return AssetImage(url);
    }
    // Everything else (network URLs, blob: URLs on web) goes through NetworkImage.
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 64,
            backgroundColor: AppColors.gray200,
            backgroundImage: _avatarImage(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _changeAvatar,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundDark, width: 3),
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: AppColors.backgroundDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Open the device gallery / camera to pick a real photo.
  Future<void> _changeAvatar() async {
    final picker = ImagePicker();

    // On web, camera is usually not available — default to gallery.
    ImageSource? source;
    if (kIsWeb) {
      source = ImageSource.gallery;
    } else {
      source = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: AppColors.surfaceDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Change Profile Picture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Choose from Gallery',
                      style: TextStyle(color: AppColors.white),
                    ),
                    onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt,
                      color: AppColors.primary,
                    ),
                    title: const Text(
                      'Take a Photo',
                      style: TextStyle(color: AppColors.white),
                    ),
                    onTap: () => Navigator.pop(ctx, ImageSource.camera),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    if (source == null) return; // user cancelled

    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (image != null && mounted) {
      // Read bytes so it works on both web and native.
      final bytes = await image.readAsBytes();
      setState(() => _pickedBytes = bytes);

      // Also persist the path (useful on native; on web this is a blob URL).
      await widget.auth.updateProfile(avatarUrl: image.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

/// Statistics row: Sessions · Rating · Tutors.
class _StatsRow extends StatelessWidget {
  final AppUser user;
  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _stat('${user.totalSessions}', 'Sessions'),
          _stat(
            user.averageRating > 0 ? '${user.averageRating}' : '-',
            'Rating',
          ),
          _stat(user.isTutor ? '${user.totalReviews}' : '5', 'Tutors'),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.gray400),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Become a Tutor" card with visual.
class _BecomeTutorCard extends StatelessWidget {
  final AppUser user;
  const _BecomeTutorCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.05),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.isTutor ? 'Tutor Mode Active' : 'Become a Tutor',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.isTutor
                        ? 'Your profile is visible to students.'
                        : 'Create your digital business card and start earning.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray300,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (user.isTutor)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.backgroundDark,
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, Routes.createTutorProfile),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Recent tutors contacted — loads first 3 tutors from AuthService.
class _RecentTutorsSection extends StatefulWidget {
  @override
  State<_RecentTutorsSection> createState() => _RecentTutorsSectionState();
}

class _RecentTutorsSectionState extends State<_RecentTutorsSection> {
  List<Tutor> _recentTutors = [];
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) _loadTutors();
  }

  Future<void> _loadTutors() async {
    final auth = UserProvider.of(context);
    final all = await auth.fetchAllTutors();
    if (mounted) {
      setState(() {
        _recentTutors = all.take(3).toList();
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Tutors Contacted',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.tutorList,
                  arguments: 'All',
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._recentTutors.map((t) => _RecentTutorTile(tutor: t)),
        ],
      ),
    );
  }
}

class _RecentTutorTile extends StatelessWidget {
  final Tutor tutor;
  const _RecentTutorTile({required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.tutorProfile,
          arguments: tutor.id,
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.gray200,
                backgroundImage: tutor.avatarUrl.startsWith('http')
                    ? NetworkImage(tutor.avatarUrl)
                    : AssetImage(tutor.avatarUrl) as ImageProvider,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutor.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tutor.subjectTags.take(2).join(' · ')} · ${tutor.major}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Last session: ${_lastSession()}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gray400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _lastSession() {
    final options = ['2 days ago', '1 week ago', '3 weeks ago'];
    return options[tutor.id.hashCode % options.length];
  }
}
