import 'package:flutter/material.dart';

import '../models/category.dart';
import '../theme/app_colors.dart';

/// Illustrated category tile for the "what's your issue?" entry screen
/// (design.md §5). Tappable and immediately scannable.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  final ServiceCategory category;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.signalCoral : AppColors.mintWash;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.signalCoral : AppColors.mist,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 8),
              Text(
                category.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.charcoal,
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
