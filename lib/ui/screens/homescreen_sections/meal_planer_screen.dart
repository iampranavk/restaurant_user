import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_user/ui/widget/counter.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  double _value = 100;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Meal Planner',
              style: GoogleFonts.mavenPro(
                textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Plan your meal with ease',
              style: GoogleFonts.mavenPro(
                textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            const Divider(
              height: 30,
            ),
            Text(
              'Number of people',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Counter(
              onChange: (count) {},
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Budget',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 5,
            ),
            Slider(
              thumbColor: Colors.green,
              activeColor: Colors.green[900],
              min: 100,
              max: 1000,
              value: _value,
              onChanged: (value) {
                _value = value;
                setState(() {});
              },
              label: _value.toString(),
              divisions: 10,
              inactiveColor: Colors.green[50],
            ),
          ],
        ),
      ),
    );
  }
}
