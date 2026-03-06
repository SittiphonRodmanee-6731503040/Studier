import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../context/user_provider.dart';
import '../../utils/constants.dart';

/// CreateTutorProfileScreen — matches the BecomeTutorpage/code.html reference.
/// Fields: Full Name, Profession, Education, Expertise tags, Hourly Fee.
/// Shows a live "Preview on Discovery" card at the bottom.
/// Prevents duplicate registration if user already has tutor status.
class CreateTutorProfileScreen extends StatefulWidget {
  const CreateTutorProfileScreen({super.key});

  @override
  State<CreateTutorProfileScreen> createState() =>
      _CreateTutorProfileScreenState();
}

class _CreateTutorProfileScreenState extends State<CreateTutorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _professionCtrl = TextEditingController();
  final _educationCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _lineCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final List<String> _tags = [];
  bool _justRegistered = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with user info when available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = UserProvider.of(context);
      final user = auth.currentUser;
      if (user != null) {
        _nameCtrl.text = user.name;
        if (user.education != null) _educationCtrl.text = user.education!;
        if (user.profession != null) _professionCtrl.text = user.profession!;
        if (user.phoneNumber != null) _phoneCtrl.text = user.phoneNumber!;
        if (user.lineId != null) _lineCtrl.text = user.lineId!;
        if (user.instagramHandle != null) {
          _instagramCtrl.text = user.instagramHandle!;
        }
      }
    });
  }

  void _addTag() {
    final raw = _tagCtrl.text.trim().replaceAll('#', '');
    if (raw.isNotEmpty && !_tags.contains(raw)) {
      setState(() {
        _tags.add(raw);
        _tagCtrl.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one expertise tag')),
      );
      return;
    }

    // Validate at least one contact method
    final line = _lineCtrl.text.trim();
    final ig = _instagramCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (line.isEmpty && ig.isEmpty && phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please provide at least one contact method '
            '(LINE, Instagram, or Phone)',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final auth = UserProvider.of(context);

    // Prevent duplicate tutor registration
    if (auth.currentUser != null && auth.currentUser!.isTutor) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are already registered as a tutor!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final rate = int.tryParse(_rateCtrl.text.trim()) ?? 0;

    _justRegistered = true;
    final success = await auth.registerAsTutor(
      profession: _professionCtrl.text.trim(),
      education: _educationCtrl.text.trim(),
      bio:
          '${_professionCtrl.text.trim()} with ${_educationCtrl.text.trim()}. '
          'Teaching: ${_tags.join(", ")}.',
      hourlyRate: rate.toDouble(),
      subjectTags: List.from(_tags),
      lineId: line.isNotEmpty ? line : null,
      instagramHandle: ig.isNotEmpty ? ig : null,
      phoneNumber: phone.isNotEmpty ? phone : null,
    );

    if (success) {
      // Show success dialog, then navigate to home
      if (!mounted) return;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primary, size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Tutor Profile Created!',
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          content: const Text(
            'You are now registered as a tutor. '
            'Students can find you and book sessions!',
            style: TextStyle(color: AppColors.gray300, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                'Go to Home',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Routes.main, (route) => false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _professionCtrl.dispose();
    _educationCtrl.dispose();
    _tagCtrl.dispose();
    _rateCtrl.dispose();
    _lineCtrl.dispose();
    _instagramCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is already a tutor — show a blocking screen
    final auth = UserProvider.of(context);
    if (auth.currentUser != null &&
        auth.currentUser!.isTutor &&
        !_justRegistered) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.white,
          title: const Text('Become a Tutor'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'You\'re already a tutor!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your tutor profile is active and visible to students.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.gray400),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.backgroundDark,
                  ),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Become a Tutor'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Professional Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tell students about your background and expertise.',
                      style: TextStyle(fontSize: 14, color: AppColors.gray400),
                    ),
                    const SizedBox(height: 24),

                    // Full Name
                    _label('Full Name'),
                    _field(_nameCtrl, 'Enter your full name'),
                    const SizedBox(height: 16),

                    // Profession / Current Role
                    _label('Profession / Current Role'),
                    _field(_professionCtrl, 'e.g. Senior Software Engineer'),
                    const SizedBox(height: 16),

                    // Education
                    _label('Education'),
                    _field(_educationCtrl, 'University, Degree'),
                    const SizedBox(height: 16),

                    // Expertise / Interests (tags)
                    _label('Expertise / Interests'),
                    if (_tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '#$tag',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => _removeTag(tag),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: _fieldRaw(
                            _tagCtrl,
                            'Add skill (e.g. Programming)',
                            onSubmitted: (_) => _addTag(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _addTag,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: AppColors.backgroundDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Subject chips (quick-select)
                    _label('Or pick from common subjects'),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kSubjects.map((s) {
                        final selected = _tags.contains(s);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                _tags.remove(s);
                              } else {
                                _tags.add(s);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              s,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColors.backgroundDark
                                    : AppColors.gray300,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Hourly Fee
                    _label('Hourly Fee (Rate)'),
                    _fieldRaw(
                      _rateCtrl,
                      '0',
                      keyboard: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      prefix: const Text(
                        '฿ ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray400,
                        ),
                      ),
                      suffix: const Text(
                        'per hour',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray400,
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Rate is required';
                        final parsed = int.tryParse(v);
                        if (parsed == null) {
                          return 'Please enter a whole number (no decimals)';
                        }
                        if (parsed <= 0) {
                          return 'Rate must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Contact Information ──
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Provide at least one way for students to reach you.',
                      style: TextStyle(fontSize: 14, color: AppColors.gray400),
                    ),
                    const SizedBox(height: 16),

                    _label('LINE ID'),
                    _fieldRaw(
                      _lineCtrl,
                      'e.g. mylineid',
                      prefix: const Icon(
                        Icons.chat_bubble_outline,
                        size: 18,
                        color: AppColors.gray400,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _label('Instagram'),
                    _fieldRaw(
                      _instagramCtrl,
                      'e.g. my_instagram',
                      prefix: const Text(
                        '@ ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _label('Phone Number'),
                    _fieldRaw(
                      _phoneCtrl,
                      'e.g. +66812345678',
                      keyboard: TextInputType.phone,
                      prefix: const Icon(
                        Icons.phone_outlined,
                        size: 18,
                        color: AppColors.gray400,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Preview card ──
                    _buildPreview(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // ── Fixed bottom button ──
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withValues(alpha: 0.8),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Create Tutor Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 4,
                    shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Preview card (matches HTML reference) ──
  Widget _buildPreview() {
    final name = _nameCtrl.text.trim().isEmpty
        ? 'Your Name'
        : _nameCtrl.text.trim();
    final role = _professionCtrl.text.trim().isEmpty
        ? 'Your Role'
        : _professionCtrl.text.trim();
    final edu = _educationCtrl.text.trim().isEmpty
        ? 'University'
        : _educationCtrl.text.trim();
    final rate = int.tryParse(_rateCtrl.text.trim()) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PREVIEW ON DISCOVERY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: AppColors.gray400.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              // Avatar placeholder
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.account_circle,
                  size: 32,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Text(
                          '฿$rate/hr',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$role · $edu',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gray400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Draft Mode',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Helper builders ──

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.gray300,
      ),
    ),
  );

  Widget _field(TextEditingController ctrl, String hint) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: AppColors.white),
      decoration: _dec(hint),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      onChanged: (_) => setState(() {}), // refresh preview
    );
  }

  Widget _fieldRaw(
    TextEditingController ctrl,
    String hint, {
    TextInputType? keyboard,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefix,
    Widget? suffix,
    String? Function(String?)? validator,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: AppColors.white),
      onFieldSubmitted: onSubmitted,
      validator: validator,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.gray400.withValues(alpha: 0.6)),
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16, right: 4),
                child: prefix,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffix != null
            ? Padding(padding: const EdgeInsets.only(right: 16), child: suffix)
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: AppColors.surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: AppColors.gray400.withValues(alpha: 0.6)),
    filled: true,
    fillColor: AppColors.surfaceDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
  );
}
