import 'package:flutter/widgets.dart';
import 'package:meals_app/models/meal.dart';

class MealItemTrait extends StatelessWidget {
  const MealItemTrait({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Color.fromARGB(255, 255, 255, 255)),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
