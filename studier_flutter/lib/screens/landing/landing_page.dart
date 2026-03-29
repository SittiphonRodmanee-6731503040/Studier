import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const Color _bg = Color(0xFF08120A);
  static const Color _ink = Color(0xFFF1F3F4);
  static const Color _muted = Color(0xFF94A3B8);
  static const Color _primary = Color(0xFF00FF88);
  static const Color _primaryDim = Color(0xFF00CC6D);
  static const Color _primarySoft = Color(0x1913EC5B);
  static const Color _surfaceLow = Color(0xFF0A160C);
  static const Color _surfaceCard = Color(0xFF112214);
  static const Color _tertiarySoft = Color(0xFF0C1A0E);
  static const Color _tertiaryInk = Color(0xFF00FF88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(context),
              _buildHero(context),
              _buildFeatures(),
              _buildHowItWorks(),
              _buildPreview(),
              _buildCta(context),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final showMenu = width >= 980;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: _surfaceCard.withValues(alpha: 0.84),
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text(
              'Studier',
              style: TextStyle(
                color: _ink,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
            const Spacer(),
            if (showMenu) ...[
              _topLink('About'),
              _topLink('Features'),
              _topLink('Pricing'),
              _topLink('Blog'),
              _topLink('Contact'),
              const SizedBox(width: 16),
            ],
            _gradientPillButton(
              label: 'SIGN UP',
              onTap: () => Navigator.pushNamed(context, Routes.register),
              horizontal: 16,
              vertical: 10,
              fontSize: 11,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        label,
        style: const TextStyle(
          color: _muted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final twoCol = width >= 980;
    final titleSize = twoCol ? 52.0 : 42.0;

    final leftContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Your Academic Match. Master Any Subject.',
          style: TextStyle(
            color: _ink,
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.6,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Studier connects you with senior peers and expert tutors who actually know your class curriculum.',
          style: TextStyle(color: _muted, fontSize: 17, height: 1.5),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ctaButton(
              label: 'Find A Tutor',
              dark: true,
              onTap: () => Navigator.pushNamed(context, Routes.register),
            ),
            _ctaButton(
              label: 'Become A Tutor',
              dark: false,
              onTap: () => Navigator.pushNamed(context, Routes.register),
            ),
          ],
        ),
      ],
    );

    final rightContent = Container(
      constraints: const BoxConstraints(minHeight: 420),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F2817), Color(0xFF0A160C)],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Transform.rotate(
              angle: 0.11,
              child: Container(
                width: 220,
                height: 430,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9B69E),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F1216),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D1B0F),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.all(12),
                            children: const [
                              _MiniTutorRow(
                                name: 'Sarah J.',
                                status: 'Chemistry',
                              ),
                              _MiniTutorRow(name: 'David C.', status: 'Math'),
                              _MiniTutorRow(
                                name: 'Elena R.',
                                status: 'Physics',
                              ),
                              _MiniTutorRow(
                                name: 'Ploy W.',
                                status: 'General Math',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Container(
              width: 138,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _surfaceCard.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: _primary, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Match Found',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Top-rated Math tutor available now.',
                    style: TextStyle(color: _muted, fontSize: 10, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _surfaceCard,
          borderRadius: BorderRadius.circular(40),
        ),
        child: twoCol
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: leftContent),
                  const SizedBox(width: 26),
                  Expanded(child: rightContent),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leftContent,
                  const SizedBox(height: 26),
                  rightContent,
                ],
              ),
      ),
    );
  }

  Widget _ctaButton({
    required String label,
    required bool dark,
    required VoidCallback onTap,
  }) {
    if (dark) {
      return _gradientPillButton(
        label: label.toUpperCase(),
        onTap: onTap,
        horizontal: 24,
        vertical: 14,
        fontSize: 12,
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: _ink,
        backgroundColor: const Color(0xFF1A2E1D),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.9,
        ),
      ),
    );
  }

  Widget _gradientPillButton({
    required String label,
    required VoidCallback onTap,
    required double horizontal,
    required double vertical,
    required double fontSize,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primary, _primaryDim],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontal,
              vertical: vertical,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFF001A0D),
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.9,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    const features = [
      (
        'Tutor Profile Advertising',
        'Tutors can present expertise, subjects, pricing, and availability to attract new students.',
        Icons.campaign,
      ),
      (
        'Student Tutor Discovery',
        'Students can browse and filter tutors by subject, budget, and rating in one place.',
        Icons.person_search,
      ),
      (
        'Subject-Based Matching',
        'Connect students with tutors based on requested subjects and learning goals.',
        Icons.hub,
      ),
      (
        'Transparent Tutor Cards',
        'Clear profiles with bios, tags, and rates help students compare tutors quickly.',
        Icons.view_agenda,
      ),
      (
        'Reviews and Trust Signals',
        'Ratings and review counts help students choose tutors with confidence.',
        Icons.verified_user,
      ),
      (
        'Direct Contact Flow',
        'Students can reach tutors directly to discuss schedule, class needs, and session details.',
        Icons.forum,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 74, 20, 0),
      child: Column(
        children: [
          const Text(
            'Built as a Tutoring Marketplace',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _ink,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Core features focused on helping tutors get discovered and helping students find the right tutor.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= 1120
                  ? 3
                  : width >= 700
                  ? 2
                  : 1;
              final itemWidth = (width - (columns - 1) * 18) / columns;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  for (final f in features)
                    SizedBox(
                      width: itemWidth,
                      child: _FeatureCard(title: f.$1, text: f.$2, icon: f.$3),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 74, 0, 0),
      color: _surfaceLow,
      padding: const EdgeInsets.fromLTRB(20, 64, 20, 64),
      child: Column(
        children: [
          const Text(
            'Your Path to Mastery',
            style: TextStyle(
              color: _ink,
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Three simple steps to transition from overwhelmed to organized.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 16),
          ),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final oneCol = width < 860;

              if (oneCol) {
                final cardWidth = width.clamp(280.0, 360.0);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: const _StepCard(
                          index: 1,
                          title: 'Sign Up',
                          text:
                              'Create your account and set your basic student profile.',
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: cardWidth,
                        child: const _StepCard(
                          index: 2,
                          title: 'Browse for Tutor',
                          text:
                              'Explore tutor profiles by subject, rate, and fit for your learning needs.',
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: cardWidth,
                        child: const _StepCard(
                          index: 3,
                          title: 'Reach Contact',
                          text:
                              'Contact your selected tutor directly and arrange session details.',
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _StepCard(
                      index: 1,
                      title: 'Sign Up',
                      text:
                          'Create your account and set your basic student profile.',
                    ),
                  ),
                  SizedBox(width: 16, height: 16),
                  Expanded(
                    child: _StepCard(
                      index: 2,
                      title: 'Browse for Tutor',
                      text:
                          'Explore tutor profiles by subject, rate, and fit for your learning needs.',
                    ),
                  ),
                  SizedBox(width: 16, height: 16),
                  Expanded(
                    child: _StepCard(
                      index: 3,
                      title: 'Reach Contact',
                      text:
                          'Contact your selected tutor directly and arrange session details.',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 74, 20, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expert Help is Just a Tap Away.',
                style: TextStyle(
                  color: _ink,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 24),
              _TinyFeature(
                icon: Icons.person_search,
                title: 'Find Your Tutor',
                text:
                    'Filter by subject, rating, and price plus exact course relevance.',
              ),
              SizedBox(height: 14),
              _TinyFeature(
                icon: Icons.verified_user,
                title: 'Tutor Profile Verification',
                text:
                    'Review track records and student feedback before each booking.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 74, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(26, 36, 26, 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF153222), Color(0xFF0B1D12)],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Ready to Ace Your Exams?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Join the academic sanctuary today and start studying with intent.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 16),
            ),
            const SizedBox(height: 22),
            _lightButton(
              label: 'Get Started',
              onTap: () => Navigator.pushNamed(context, Routes.register),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lightButton({required String label, required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: const Color(0xFF001A0D),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        elevation: 0,
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 74, 0, 0),
      padding: const EdgeInsets.fromLTRB(20, 46, 20, 46),
      decoration: const BoxDecoration(color: Color(0xFF0A160C)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 860;
          if (wide) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _FooterBlock(
                    title: 'Studier',
                    lines: [
                      'Elevating the academic experience through intelligent connection and focus-driven tools.',
                    ],
                  ),
                ),
                Expanded(
                  child: _FooterBlock(
                    title: 'Product',
                    lines: [
                      'Features',
                      'Tutor Network',
                      'Study Tools',
                      'Pricing',
                    ],
                  ),
                ),
                Expanded(
                  child: _FooterBlock(
                    title: 'Support',
                    lines: [
                      'Help Center',
                      'Privacy Policy',
                      'Terms of Service',
                      'Contact',
                    ],
                  ),
                ),
                Expanded(
                  child: _FooterBlock(
                    title: 'Connect',
                    lines: ['Share', 'Chat', 'Email'],
                  ),
                ),
              ],
            );
          }

          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _FooterBlock(
                title: 'Studier',
                lines: [
                  'Elevating the academic experience through intelligent connection and focus-driven tools.',
                ],
              ),
              SizedBox(height: 20),
              _FooterBlock(
                title: 'Product',
                lines: ['Features', 'Tutor Network', 'Study Tools', 'Pricing'],
              ),
              SizedBox(height: 20),
              _FooterBlock(
                title: 'Support',
                lines: [
                  'Help Center',
                  'Privacy Policy',
                  'Terms of Service',
                  'Contact',
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniTutorRow extends StatelessWidget {
  final String name;
  final String status;

  const _MiniTutorRow({required this.name, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E1D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF2A3F31),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 16, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: LandingPage._ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    color: LandingPage._muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;

  const _FeatureCard({
    required this.title,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: LandingPage._surfaceCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: LandingPage._primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: LandingPage._primary),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: LandingPage._ink,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: LandingPage._muted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int index;
  final String title;
  final String text;

  const _StepCard({
    required this.index,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: LandingPage._surfaceCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 220,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A2E1D), Color(0xFF112214)],
              ),
            ),
            child: const Icon(
              Icons.menu_book,
              size: 42,
              color: LandingPage._primary,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: LandingPage._primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: const TextStyle(
                color: Color(0xFF001A0D),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: LandingPage._ink,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: LandingPage._muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _TinyFeature({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: LandingPage._tertiarySoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: LandingPage._tertiaryInk),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: LandingPage._ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  color: LandingPage._muted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhonePoster extends StatelessWidget {
  final Color color;

  const _PhonePoster({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Center(
        child: Container(
          width: 148,
          height: 250,
          decoration: BoxDecoration(
            color: const Color(0xFF08120A),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Container(
              width: 130,
              height: 222,
              decoration: BoxDecoration(
                color: LandingPage._surfaceCard,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.school,
                size: 48,
                color: LandingPage._primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterBlock extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _FooterBlock({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: LandingPage._ink,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                line,
                style: const TextStyle(
                  color: LandingPage._muted,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
