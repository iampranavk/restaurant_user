import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_user/ui/screens/homescreen_sections/cart_screen.dart';
import 'package:restaurant_user/ui/screens/homescreen_sections/favourites_screen.dart';
import 'package:restaurant_user/ui/screens/homescreen_sections/food_screen.dart';
import 'package:restaurant_user/ui/screens/homescreen_sections/meal_planer_screen.dart';
import 'package:restaurant_user/ui/screens/homescreen_sections/orders_screen.dart';
import 'package:restaurant_user/ui/screens/homescreen_sections/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Restaurant',
          style: GoogleFonts.oswald(
            textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.green[800],
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FavouritesScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.favorite,
                color: Colors.green[900]!,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            FoodScreen(),
            MealPlannerScreen(),
            OrdersScreen(),
            SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.green[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavBarItem(
                  isSelected: _controller.index == 0,
                  icon: Icons.home_filled,
                  onTap: () {
                    _controller.animateTo(0);
                    setState(() {});
                  },
                  label: 'Home',
                ),
                NavBarItem(
                  isSelected: _controller.index == 1,
                  icon: Icons.restaurant_menu,
                  onTap: () {
                    _controller.animateTo(1);
                    setState(() {});
                  },
                  label: 'Meal Planner',
                ),
                NavBarItem(
                  isSelected: _controller.index == 2,
                  icon: Icons.category,
                  onTap: () {
                    _controller.animateTo(2);
                    setState(() {});
                  },
                  label: 'Order',
                ),
                NavBarItem(
                  isSelected: _controller.index == 3,
                  icon: Icons.settings,
                  onTap: () {
                    _controller.animateTo(3);
                    setState(() {});
                  },
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function() onTap;
  final String label;
  const NavBarItem({
    super.key,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? Colors.green[800] : Colors.black38,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: isSelected ? Colors.green[800] : Colors.black38,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
