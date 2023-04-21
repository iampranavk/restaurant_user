import 'package:flutter/material.dart';
import 'package:restaurant_user/ui/screens/homescreen_sections/cart_screen.dart';
import 'package:restaurant_user/ui/screens/login_screen.dart';
import 'package:restaurant_user/ui/screens/suggestion_screen.dart';
import 'package:restaurant_user/ui/widget/add_suggestion_dialog.dart';
import 'package:restaurant_user/ui/widget/change_password_dialog.dart';
import 'package:restaurant_user/ui/widget/custom_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SettingsCard(
                  icon: Icons.reviews_outlined,
                  label: 'Suggestions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuggestionsScreen(),
                      ),
                    );
                  },
                ),
                SettingsCard(
                  icon: Icons.shopping_bag_outlined,
                  label: 'My Cart',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(),
                      ),
                    );
                  },
                ),
                SettingsCard(
                  icon: Icons.lock_open,
                  label: 'Change Password',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (builder) => const ChangePasswordDialog(),
                    );
                  },
                ),
                SettingsCard(
                  icon: Icons.logout,
                  label: isLoading ? 'Logging out...' : 'Logout',
                  onTap: isLoading
                      ? () {}
                      : () async {
                          isLoading = true;
                          setState(() {});

                          await Supabase.instance.client.auth.signOut();

                          isLoading = false;
                          setState(() {});

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => true,
                          );
                        },
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onTap;

  const SettingsCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.green[800],
              size: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
