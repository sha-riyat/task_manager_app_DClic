import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../viewmodels/profile_view_model.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../../auth/domain/entities/user.dart';

/// Screen that allows the user to edit their personal information and change
/// their password. A segmented control implemented via [TabBar] provides two
/// tabs: one for general info and one for security settings. The forms are
/// pre‑filled with the current user details and saving triggers updates via
/// the view models.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for form fields
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  // Toggles for obscuring password fields
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  // Index of the selected tab: 0 for General, 1 for Security
  int _selectedTab = 0;

  /// Builds the general information form used in the profile screen.
  Widget _buildGeneralForm(BuildContext context, User user, AuthViewModel authVm, ProfileViewModel profileVm) {
    return Column(
      children: [
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: 'Prénom',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            labelText: 'Nom',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: profileVm.isUpdating
                ? null
                : () async {
                    final updated = user.copyWith(
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      email: _emailController.text.trim(),
                    );
                    final success = await profileVm.updateProfile(updated);
                    if (success) {
                      // propagate changes to auth view model
                      await authVm.updateProfile(
                        firstName: updated.firstName,
                        lastName: updated.lastName,
                        email: updated.email,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil mis à jour')),);
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(profileVm.error ?? 'Erreur')),);
                      }
                    }
                  },
            child: const Text('Sauvegarder'),
          ),
        ),
        if (profileVm.isUpdating)
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  /// Builds the security form used in the profile screen.
  Widget _buildSecurityForm(BuildContext context, User user, AuthViewModel authVm, ProfileViewModel profileVm) {
    return Column(
      children: [
        TextField(
          controller: _oldPasswordController,
          obscureText: _obscureOld,
          decoration: InputDecoration(
            labelText: 'Ancien mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureOld ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureOld = !_obscureOld;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _newPasswordController,
          obscureText: _obscureNew,
          decoration: InputDecoration(
            labelText: 'Nouveau mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureNew = !_obscureNew;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            labelText: 'Confirmer le mot de passe',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: profileVm.isUpdating
                ? null
                : () async {
                    final oldPwd = _oldPasswordController.text;
                    final newPwd = _newPasswordController.text;
                    final confirmPwd = _confirmPasswordController.text;
                    if (newPwd.isEmpty || confirmPwd.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veuillez renseigner le nouveau mot de passe')),);
                      return;
                    }
                    if (newPwd != confirmPwd) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),);
                      return;
                    }
                    // Check if the old password matches current one
                    if (oldPwd != authVm.user?.password) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ancien mot de passe incorrect')),);
                      return;
                    }
                    final success = await profileVm.changePassword(user.id!, newPwd);
                    if (success) {
                      await authVm.changePassword(newPwd);
                      _oldPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mot de passe mis à jour')),);
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(profileVm.error ?? 'Erreur')),);
                      }
                    }
                  },
            child: const Text('Sauvegarder'),
          ),
        ),
        if (profileVm.isUpdating)
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final profileVm = context.watch<ProfileViewModel>();
    final user = authVm.user;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Utilisateur non connecté')));
    }
    // Pre‑fill controllers with current user info once when the screen builds.
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Segmented control replicating the login/inscription style
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? AppColors.card : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Général',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTab = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? AppColors.card : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Sécurité',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Conditional forms
          if (_selectedTab == 0)
            _buildGeneralForm(context, user, authVm, profileVm)
          else
            _buildSecurityForm(context, user, authVm, profileVm),
        ],
      ),
    );
  }
}